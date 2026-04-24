import numpy as np
import pandas as pd
from scipy.signal import convolve2d
 
# ── 1. Generate random 64x64 input matrix ────────────────────────────────────
np.random.seed(42)
matrix = np.random.rand(64, 64)
 
# ── 2. Define a kernel (3x3 edge detection kernel) ───────────────────────────
kernel = np.array([
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0]
], dtype=float)
 
# ── 3. Perform 2D convolution — 'valid' mode = NO padding ────────────────────
output = convolve2d(matrix, kernel, mode='valid')
 
# ── 4. Print shapes and stats ─────────────────────────────────────────────────
print("=" * 50)
print("2D Convolution — No Padding (valid mode)")
print("=" * 50)
print(f"Input  matrix shape : {matrix.shape}")
print(f"Kernel shape        : {kernel.shape}")
print(f"Output matrix shape : {output.shape}")
print(f"Input  — min: {matrix.min():.4f}, max: {matrix.max():.4f}, mean: {matrix.mean():.4f}")
print(f"Output — min: {output.min():.4f}, max: {output.max():.4f}, mean: {output.mean():.4f}")
print("=" * 50)
 
# ── 5. Print using pandas ─────────────────────────────────────────────────────
pd.set_option('display.float_format', '{:.4f}'.format)
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.set_option('display.width', None)
 
print("\nINPUT MATRIX:")
print(pd.DataFrame(matrix))
 
print("\nKERNEL:")
print(pd.DataFrame(kernel))
 
print("\nOUTPUT MATRIX:")
print(pd.DataFrame(output))