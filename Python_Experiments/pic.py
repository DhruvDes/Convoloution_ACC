import numpy as np
from PIL import Image
import pandas as pd
from IPython.display import display
from scipy.signal import convolve2d
import matplotlib.pyplot as plt

# 1. Open the image and convert to Grayscale
img = Image.open('8.png').convert('L')
width, height = img.size

# 2. Convert to NumPy Array (int32 for math safety)
matrix = np.array(img, dtype=np.int32) 

display(pd.DataFrame(matrix))
# 3. Define your Vertical Edge Detection Kernel
# This highlights transitions from light-to-dark or dark-to-light horizontally
kernel = np.array([[ -10, 0, 10],
                   [ -10, 0, 10],
                   [ -10, 0, 10]]) # Note: Standard Sobel usually uses 1, 2, 1

# 4. Perform Convolution
edge_matrix = convolve2d(matrix, kernel, mode='same', boundary='fill')

# Absolute value to catch both "Black-to-White" and "White-to-Black" edges
edge_matrix_abs = np.absolute(edge_matrix)
# display(pd.DataFrame(edge_matrix_abs))
edge_matrix_view = edge_matrix_abs.clip(0, 255).astype(np.uint8)

# # 5. PLOTTING
# plt.figure(figsize=(10, 5))

# plt.subplot(1, 2, 1)
# plt.imshow(matrix, cmap='gray')
# plt.title("Original '8'")
# plt.axis('off')

# plt.subplot(1, 2, 2)
# plt.imshow(edge_matrix_view, cmap='gray')
# plt.title("Vertical Edges Only")
# plt.axis('off')

# plt.tight_layout()
# plt.show()

# 6. Display a slice of the vertical edge matrix
# print("--- VERTICAL EDGE VALUES (SLICE) ---")
# display(pd.DataFrame(edge_matrix_view).iloc[height//4:height//4+15, width//4:width//4+15])