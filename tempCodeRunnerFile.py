import numpy as np
# from PIL import Image
# import pandas as pd
# from IPython.display import display
# from scipy.signal import convolve2d
# import matplotlib.pyplot as plt

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
