import numpy as np

def manual_convolution(matrix, kernel):
    # Get dimensions
    m_h, m_w = matrix.shape
    k_h, k_w = kernel.shape
    
    # Calculate output dimensions (valid convolution)
    out_h = m_h - k_h + 1
    out_w = m_w - k_w + 1
    
    # Initialize output matrix with zeros
    output = np.zeros((out_h, out_w))
    
    # Perform the convolution
    for i in range(out_h):
        for j in range(out_w):
            # Extract the 'window' or 'patch' from the matrix
            region = matrix[i : i + k_h, j : j + k_w]
            
            # Multiply element-wise and sum (the dot product)
            output[i, j] = np.sum(region * kernel)
            
    return output

# 1. Create an 8x8 input matrix (e.g., random integers 0-10)
input_matrix = np.random.randint(0, 10, (8, 8))

# 2. Create a 3x3 kernel (e.g., an edge detection filter or averaging filter)
# Let's use an averaging filter:
kernel = np.array([
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1]
])

# 3. Run the function
result = manual_convolution(input_matrix, kernel)

print("Input Matrix (8x8):")
print(input_matrix)
print("Size of Input Matrix:", input_matrix.shape)
print("\nResulting Matrix (6x6):")
print(np.round(result, 2))#get the size of this resulting matrix
print("Size of Resulting Matrix:", result.shape)