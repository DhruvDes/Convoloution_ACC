import numpy as np

def s9(x):
    if not (-256 <= x <= 255):
        raise ValueError(f"{x} out of signed 9-bit range")
    return x & 0x1FF


def pack_kernel_words(kernel_3x3):
    k = np.array(kernel_3x3).reshape(-1).tolist()

    if len(k) != 9:
        raise ValueError("Need exactly 9 kernel values")

    t1 = s9(k[0]) | (s9(k[1]) << 9) | (s9(k[2]) << 18)
    t2 = s9(k[3]) | (s9(k[4]) << 9) | (s9(k[5]) << 18)
    t3 = s9(k[6]) | (s9(k[7]) << 9) | (s9(k[8]) << 18)

    return np.array([t1, t2, t3], dtype=np.uint32)


def pack_image_words(img_u8):
    flat = np.array(img_u8, dtype=np.uint8).reshape(-1)

    nwords = (len(flat) + 3) // 4
    words = np.zeros(nwords, dtype=np.uint32)

    for i in range(nwords):
        b0 = int(flat[4*i])     if 4*i < len(flat) else 0
        b1 = int(flat[4*i + 1]) if 4*i + 1 < len(flat) else 0
        b2 = int(flat[4*i + 2]) if 4*i + 2 < len(flat) else 0
        b3 = int(flat[4*i + 3]) if 4*i + 3 < len(flat) else 0

        words[i] = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)

    return words


def build_input_stream(kernel_3x3, img_u8):
    cfg_words = pack_kernel_words(kernel_3x3)
    img_words = pack_image_words(img_u8)

    return np.concatenate((cfg_words, img_words)).astype(np.uint32)
