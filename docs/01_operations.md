# 01 — IP Operations

## Role

`convAcc` is a streaming 2-D convolution accelerator for the Xilinx Zynq-7000 (PYNQ-Z2). It offloads 3×3 kernel convolutions on 8-bit grayscale images from the Arm Cortex-A9 PS, exchanging data with the PS over AXI4-Stream via AXI DMA. The IP runs at **125 MHz** on the xc7z020 and is stateless between frames, deterministic, and dimensioned so that the MAC datapath keeps pace with the AXI-Stream input rate (one output pixel per clock once the pipeline is primed).

## Mathematical Operation

For an input image `I` of size `H × W` and a 3×3 kernel `K`, the IP produces the valid-mode output `S` of size `(H − 2) × (W − 2)`:

$$S(i, j) = \sum_{m=0}^{2} \sum_{n=0}^{2} I(i+m,\, j+n) \cdot K(m, n)$$

Per output pixel this is **9 multiplications and 8 additions**. The result is then saturated to the 8-bit unsigned range before being packed into the AXI-Stream output.

## Data Types and Precision

| Quantity | Type | Width | Range |
|---|---|---|---|
| Input pixel `I(i,j)` | unsigned | 8 bits | `[0, 255]` |
| Kernel coefficient `K(m,n)` | signed (two's complement) | 9 bits | `[−256, +255]` |
| Product `p·k` | signed | 18 bits | — |
| Accumulator | signed | 22 bits | — |
| Output pixel `S(i,j)` | unsigned, saturated | 8 bits | `[0, 255]` |

Saturation is implemented in `mac_truncate.sv`: negative sums clamp to `0`, sums greater than `255` clamp to `255`, otherwise the lower 8 bits are emitted.

## Supported Image Sizes

The IP is parameterized but the synthesized line buffer constrains the practical working set:

- **Row width (`row_size`)**: 6-bit field → up to 63 pixels per row. Benchmarks used `W = 16` and `W = 60`.
- **Number of rows (`no_of_rows`)**: 10-bit field → up to 1023 rows per frame.
- **Minimum frame size**: 3 × 3 (one output pixel).
- **Line-buffer storage**: 4 lanes × 64 pixels × 8 bits = 2048 flip-flops (four rows of the frame are kept on-chip at any time to feed the sliding 3×3 window while the next row is being written).

Frames larger than the compile-time `row_size` require re-parameterization and re-synthesis; frames that fit this range are supported at runtime by writing the dimensions into the config registers at the start of each frame.

## Edge / Boundary Handling

The IP implements **valid-mode** convolution only — no padding. An `H × W` input produces an `(H − 2) × (W − 2)` output. The two leftmost and two rightmost columns of each row, and the top/bottom rows, are not emitted because a complete 3×3 window cannot be centred there. Software on the PS is responsible for any zero-padding, replicate-padding, or same-mode behaviour before streaming the frame in.

## Per-Frame Protocol

Each convolution is a self-contained transaction composed of four 32-bit AXI-Stream words of configuration followed by the pixel payload:

| Word | Contents |
|---|---|
| 0 | `{ reserved[15:0], no_of_rows[9:0], row_size[5:0] }` |
| 1 | `{ reserved[4:0], K(0,2)[8:0], K(0,1)[8:0], K(0,0)[8:0] }` |
| 2 | `{ reserved[4:0], K(1,2)[8:0], K(1,1)[8:0], K(1,0)[8:0] }` |
| 3 | `{ reserved[4:0], K(2,2)[8:0], K(2,1)[8:0], K(2,0)[8:0] }` |
| 4 .. N | Pixel stream, 4 pixels packed per 32-bit word, little-endian |

The final pixel word must assert `TLAST`. The IP asserts `TLAST` on the last output word for each frame. Because configuration travels on the same AXI-Stream channel as the pixels, the PS can change kernel or frame dimensions on a per-frame basis without stalling the pipeline with separate AXI-Lite transactions — this is what makes the 20,000-image-per-run benchmarks practical.

## Interaction with the Processing System

The PS is responsible for:

1. Allocating contiguous DMA buffers (PYNQ `allocate()` with `pynq.Overlay`).
2. Packing the config header and pixel payload into the send buffer.
3. Issuing MM2S (memory-to-stream) and S2MM (stream-to-memory) DMA transfers.
4. Waiting on both DMA channels.
5. Unpacking the result buffer back to an `(H − 2) × (W − 2)` image.

The accelerator itself holds no state between frames: a `Cleanup → Idle → Operational → preCleanup → Cleanup` FSM in `convAcc.sv` returns the pipeline to a known state after every `TLAST`, so back-to-back frames with different dimensions and different kernels work without software-side reset.
