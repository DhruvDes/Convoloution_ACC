import numpy as np
from PIL import Image
import pandas as pd
from IPython.display import display
from scipy.signal import convolve2d
import matplotlib.pyplot as plt

# # 1. Open image in RGB (Color)
# img = Image.open('dog.jpg').convert('RGB')
# width, height = img.size
# matrix_rgb = np.array(img, dtype=np.int32)

# # 2. Define your Kernel (Increased gain to +/- 10 as per your reference)
# kernel = np.array([[ -10, 0, 10],
#                    [ -10, 0, 10],
#                    [ -10, 0, 10]])

# # 3. Process and Print for each Channel
# channels = ['RED', 'GREEN', 'BLUE']

# for i, name in enumerate(channels):
#     # Extract the specific color channel (2D matrix)
#     channel_matrix = matrix_rgb[:, :, i]
    
#     # Perform Convolution on this channel
#     edge_matrix = convolve2d(channel_matrix, kernel, mode='same', boundary='fill')
#     edge_matrix_view = np.absolute(edge_matrix).clip(0, 255).astype(np.uint8)
    
#     print(f"\n{'='*30}")
#     print(f" CHANNEL: {name}")
#     print(f"{'='*30}")
    
#     # Display the raw color values for this channel
#     print(f"Raw {name} Values (Slice):")
#     display(pd.DataFrame(channel_matrix).iloc[height//4:height//4+10, width//4:width//4+10])
    
#     # Display the edge detection values for this channel
#     print(f"Convoluted {name} Edges (Slice):")
#     display(pd.DataFrame(edge_matrix_view).iloc[height//4:height//4+10, width//4:width//4+10])

# # 4. Final Visualization
# fig, axes = plt.subplots(1, 2, figsize=(12, 5))
# axes[0].imshow(matrix_rgb.astype(np.uint8))
# axes[0].set_title("Original Color '8'")
# axes[1].imshow(img.convert('L'), cmap='gray') # Showing grayscale for contrast
# axes[1].set_title("For Reference (Grayscale)")
# plt.show()



# import numpy as np
# from PIL import Image
# import pandas as pd
# from scipy.signal import convolve2d

# # 1. Open the dog image and get dimensions
# img = Image.open('dog.jpg').convert('RGB')
# width, height = img.size
# matrix_rgb = np.array(img, dtype=np.int32)

# # 2. Use your specific Vertical Edge Kernel
# kernel = np.array([[ -10, 0, 10],
#                    [ -10, 0, 10],
#                    [ -10, 0, 10]])

# # 3. Extract Red Channel and Convolve
# red_channel = matrix_rgb[:, :, 0]
# edge_matrix = convolve2d(red_channel, kernel, mode='same', boundary='fill')
# edge_matrix_view = np.absolute(edge_matrix).clip(0, 255).astype(np.uint8)

# # 4. Display a slice where there is an edge (e.g., near the dog's ear/face)
# # I'll pick a slice near the center for observation
# start_h, start_w = height//2, width//2

# print(f"--- Raw RED Values (10x10 Slice from center) ---")
# display(pd.DataFrame(red_channel).iloc[start_h:start_h+10, start_w:start_w+10])

# print(f"\n--- Convoluted EDGE Values (10x10 Slice from center) ---")
# display(pd.DataFrame(edge_matrix_view).iloc[start_h:start_h+10, start_w:start_w+10])


import numpy as np
from PIL import Image

# Load the image
img = Image.open('dog.jpg').convert('RGB')
matrix_rgb = np.array(img)

# Set numpy to not truncate any data
np.set_printoptions(threshold=np.inf, linewidth=np.inf)

# Create and write to the file
with open('dog_matrices.txt', 'w') as f:
    f.write("--- RED CHANNEL MATRIX ---\n")
    f.write(np.array2string(matrix_rgb[:, :, 0], max_line_width=np.inf, separator=', '))
    
    f.write("\n\n--- GREEN CHANNEL MATRIX ---\n")
    f.write(np.array2string(matrix_rgb[:, :, 1], max_line_width=np.inf, separator=', '))
    
    f.write("\n\n--- BLUE CHANNEL MATRIX ---\n")
    f.write(np.array2string(matrix_rgb[:, :, 2], max_line_width=np.inf, separator=', '))

print("The file 'dog_matrices.txt' has been successfully generated.")