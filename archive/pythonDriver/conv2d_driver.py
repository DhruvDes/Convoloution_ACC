"""
conv2d_driver.py
────────────────────────────────────────────────────────────────────────────
Driver for the 2D convolution accelerator overlay.

Wraps the DMA protocol in a reusable class. Protocol is identical to the
working reference flow:

    Send stream layout:
        [4 config words] -> [pixel words, 4 px/word uint8 packed] -> TLAST

    Config word layout (32-bit):
        cfg[0] bits[5:0]   = row_width   (image width,  1..63)
        cfg[0] bits[15:6]  = num_rows    (image height, 1..1023)
        cfg[1] bits[26:0]  = kernel row 0 (three 9-bit signed values)
        cfg[2] bits[26:0]  = kernel row 1
        cfg[3] bits[26:0]  = kernel row 2

    Recv stream:
        (W-2) * (H-2) output pixels, 4 px/word uint8 packed, clipped 0..255
"""

import numpy as np
from pynq import Overlay, allocate


# ─────────────────────────────────────────────────────────────────────────────
# Config packing helpers
# ─────────────────────────────────────────────────────────────────────────────
def to_signed9(v: int) -> int:
    """Clamp to [-256, 255] and return 9-bit two's-complement encoding."""
    v = max(-256, min(255, int(v)))
    return v & 0x1FF


def pack_kernel_words(kernel) -> list:
    """
    Precompute cfg[1..3] from a 3x3 kernel. These only depend on kernel values,
    not image size, so they can be computed once and reused.
    """
    k = np.asarray(kernel)
    assert k.shape == (3, 3), f"kernel must be 3x3, got {k.shape}"

    def pack_row(r):
        k0 = to_signed9(k[r][0])
        k1 = to_signed9(k[r][1])
        k2 = to_signed9(k[r][2])
        return k0 | (k1 << 9) | (k2 << 18)

    return [pack_row(0), pack_row(1), pack_row(2)]


def build_config_words(row_width: int, num_rows: int, kernel_words: list) -> list:
    """Build the 4 config words. kernel_words is precomputed from pack_kernel_words."""
    assert 0 < row_width <= 60,   f"row_width {row_width} out of range [1, 60]"
    assert 0 < num_rows  <= 1020, f"num_rows {num_rows} out of range [1, 1020]"
    cfg0 = (row_width & 0x3F) | ((num_rows & 0x3FF) << 6)
    return [cfg0] + kernel_words


def pack_pixels(image: np.ndarray) -> np.ndarray:
    """
    Flatten image to bytes (row-major) and view as uint32 words
    (little-endian, 4 pixels per word). Pads to multiple of 4 if needed.
    """
    flat = image.flatten().astype(np.uint8)
    remainder = len(flat) % 4
    if remainder:
        flat = np.concatenate([flat, np.zeros(4 - remainder, dtype=np.uint8)])
    # Use ascontiguousarray to guarantee contiguous before viewing as uint32
    return np.ascontiguousarray(flat).view(np.uint32)


# ─────────────────────────────────────────────────────────────────────────────
# Driver class
# ─────────────────────────────────────────────────────────────────────────────
class Conv2DDriver:
    """
    Driver for the 2D convolution accelerator.

    Usage:
        drv = Conv2DDriver("conv100m.bit", kernel)          # kernel fixed at init
        out = drv.convolve(image)

    Or change kernel per call:
        drv = Conv2DDriver("conv100m.bit")                  # no kernel at init
        out = drv.convolve(image, kernel=sobel_x)
        out = drv.convolve(image, kernel=sobel_y)

    Or update the default kernel between batches:
        drv.set_kernel(blur)
        for img in batch: drv.convolve(img)

    The driver pre-allocates buffers sized for MAX_IMG_W x MAX_IMG_H and
    reuses them across calls.
    """

    # Hardware limits for this accelerator build.
    #
    # MAX_IMG_W = 60:
    #   - row_width field is 6 bits (cfg[0][5:0]), so hardware upper bound is 63.
    #   - Driver also requires width % 4 == 0 (pixel packing).
    #   - 60 is the largest multiple-of-4 value that fits.
    #
    # MAX_IMG_H = 1020:
    #   - num_rows field is 10 bits (cfg[0][15:6]), supporting up to 1023.
    #   - convAcc's rowsdoneCount is 10 bits to match, so full height range works.
    #   - Using 1020 as a conservative multiple-of-4 cap.
    MAX_IMG_W = 60
    MAX_IMG_H = 1020

    def __init__(
        self,
        bitstream_path: str,
        kernel=None,
        max_w: int = 60,
        max_h: int = 1020,
        dma_name: str = "axi_dma",
    ):
        assert max_w <= self.MAX_IMG_W, f"max_w {max_w} exceeds hardware limit {self.MAX_IMG_W}"
        assert max_h <= self.MAX_IMG_H, f"max_h {max_h} exceeds hardware limit {self.MAX_IMG_H}"

        self.overlay = Overlay(bitstream_path)
        self.dma = getattr(self.overlay, dma_name)

        # Kernel is optional — can be supplied per-call to convolve() instead
        if kernel is not None:
            self.kernel = np.asarray(kernel, dtype=np.int32)
            self.kernel_words = pack_kernel_words(self.kernel)
        else:
            self.kernel = None
            self.kernel_words = None

        self.max_w = max_w
        self.max_h = max_h

        # Worst-case sizes
        max_pixels      = max_w * max_h
        max_pixel_words = (max_pixels + 3) // 4
        max_in_words    = 4 + max_pixel_words                 # 4 config + pixels
        max_out_pixels  = (max_w - 2) * (max_h - 2)
        max_out_words   = (max_out_pixels + 3) // 4 + 8       # +8 margin

        self._send_buf = allocate(shape=(max_in_words,),  dtype=np.uint32)
        self._recv_buf = allocate(shape=(max_out_words,), dtype=np.uint32)

        # Reset DMA channels once
        self.dma.sendchannel.stop()
        self.dma.recvchannel.stop()
        self.dma.sendchannel.start()
        self.dma.recvchannel.start()

        self._closed = False

    # ────────────────────────────────────────────────────────────────────────
    # Kernel management
    # ────────────────────────────────────────────────────────────────────────
    def set_kernel(self, kernel):
        """Update the default kernel used for subsequent convolve() calls."""
        self.kernel = np.asarray(kernel, dtype=np.int32)
        self.kernel_words = pack_kernel_words(self.kernel)

    # ────────────────────────────────────────────────────────────────────────
    # Core transfer
    # ────────────────────────────────────────────────────────────────────────
    def convolve(self, image: np.ndarray, kernel=None) -> np.ndarray:
        """
        Run convolution on a single image. Returns uint8 (H-2, W-2) output,
        clipped to [0, 255] by the hardware.

        If `kernel` is provided, it overrides the driver's default kernel for
        just this call (without modifying the default).
        """
        assert self._closed is False, "Driver has been closed"
        assert image.ndim == 2, f"image must be 2D, got shape {image.shape}"

        # Pick which kernel to use
        if kernel is not None:
            kernel_words = pack_kernel_words(kernel)
        else:
            assert self.kernel_words is not None, (
                "No kernel available — pass `kernel=` to convolve(), "
                "call set_kernel(), or pass `kernel=` at construction."
            )
            kernel_words = self.kernel_words

        h, w = image.shape
        assert 3 <= w <= self.max_w, f"width {w} out of range [3, {self.max_w}]"
        assert 3 <= h <= self.max_h, f"height {h} out of range [3, {self.max_h}]"

        out_h = h - 2
        out_w = w - 2
        n_out_pixels = out_h * out_w
        n_out_words  = (n_out_pixels + 3) // 4

        # ── Pack pixels ──
        pixel_words = pack_pixels(image)
        n_words_in  = 4 + len(pixel_words)

        # ── Fill send buffer ──
        cfg = build_config_words(w, h, kernel_words)
        self._send_buf[0:4]          = cfg
        self._send_buf[4:n_words_in] = pixel_words

        # ── Transfer  (only transfer the active slice, not the whole buffer) ──
        # This is CRITICAL: passing the full pre-allocated buffer would send
        # stale data past the image and hang the FPGA on subsequent transfers.
        send_slice = self._send_buf[:n_words_in]
        recv_slice = self._recv_buf[:n_out_words]

        self.dma.recvchannel.transfer(recv_slice)
        self.dma.sendchannel.transfer(send_slice)
        self.dma.sendchannel.wait()
        self.dma.recvchannel.wait()

        # ── Unpack result ──
        # Convert uint32 words back to uint8 pixels via bytes (matches the
        # known-good reference flow using struct.pack('<I', ...)).
        raw = recv_slice.tobytes()
        output_pixels = np.frombuffer(raw[:n_out_pixels], dtype=np.uint8)
        return output_pixels.reshape(out_h, out_w).copy()

    # ────────────────────────────────────────────────────────────────────────
    # Lifecycle
    # ────────────────────────────────────────────────────────────────────────
    def close(self):
        """Free DMA buffers. Safe to call multiple times."""
        if self._closed:
            return
        try:
            self._send_buf.freebuffer()
            self._recv_buf.freebuffer()
        except Exception:
            pass
        self._closed = True

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    def __del__(self):
        self.close()