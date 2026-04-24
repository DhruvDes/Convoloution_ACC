import numpy as np
from scipy.signal import convolve2d

# Create 16x16 matrix with 1,2,3,...255 then 0
values = list(range(1, 256)) + [0]  # 256 values to fill 16x16
img = np.array(values, dtype=np.uint8).reshape(16, 16)

kernel = np.array([[ 1, 0, 1],
                   [ 2, 0, 2],
                   [ 1, 0, 1]])

result = convolve2d(img, kernel, mode='valid')

# Clamp between 0 and 255
result_clamped = np.clip(result, 0, 255).astype(np.uint8)

# Hex formatting helper
def print_hex_matrix(mat, label):
    print(label)
    for row in mat:
        print("  ".join(f"0x{v:02X}" for v in row))

print_hex_matrix(img, "Input 16x16 matrix (hex):")
print(f"\nInput shape: {img.shape}")
print(f"Output shape: {result_clamped.shape}")
print(f"\nConvolved output (14x14, clamped 0-255, hex):")
print_hex_matrix(result_clamped, "")