from pathlib import Path

import numpy as np
from PIL import Image
from scipy.signal import convolve2d


# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------
IMAGE_FOLDER = "images"
DTYPE = np.int32

KERNEL = np.array([
    [1, 0, -1],
    [1, 0, -1],
    [1, 0, -1]
], dtype=DTYPE)

TEST_WIDTHS = range(4, 61, 4)
TEST_HEIGHTS = range(4, 61)

VALID_EXTENSIONS = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff"}


# ------------------------------------------------------------
# Image loading
# ------------------------------------------------------------
def load_grayscale_image(path: Path) -> np.ndarray:
    image = Image.open(path).convert("L")
    return np.array(image, dtype=DTYPE)


# ------------------------------------------------------------
# Reference model
# ------------------------------------------------------------
def reference_model(image_2d: np.ndarray, kernel_2d: np.ndarray) -> np.ndarray:
    return convolve2d(image_2d, kernel_2d, mode="valid")


# ------------------------------------------------------------
# Device under test
# Replace this later with your hardware/software function
# ------------------------------------------------------------
def device_under_test(image_2d: np.ndarray, kernel_2d: np.ndarray) -> np.ndarray:
    return convolve2d(image_2d, kernel_2d, mode="valid")


# ------------------------------------------------------------
# Output comparison
# ------------------------------------------------------------
def compare_outputs(expected: np.ndarray, actual: np.ndarray, test_name: str) -> None:
    if expected.shape != actual.shape:
        print(
            f"FAIL: {test_name} shape mismatch "
            f"expected={expected.shape} actual={actual.shape}"
        )
        return

    if not np.array_equal(expected, actual):
        mismatch_locations = np.argwhere(expected != actual)
        row, col = mismatch_locations[0]
        print(
            f"FAIL: {test_name} first mismatch at ({row}, {col}) "
            f"expected={expected[row, col]} actual={actual[row, col]}"
        )


# ------------------------------------------------------------
# Main test runner
# ------------------------------------------------------------
def run_tests(image_folder: str, kernel: np.ndarray) -> None:
    folder = Path(image_folder)

    if not folder.exists() or not folder.is_dir():
        print(f"FAIL: image folder does not exist: {folder}")
        return

    image_files = sorted(
        path for path in folder.iterdir()
        if path.suffix.lower() in VALID_EXTENSIONS
    )

    if not image_files:
        print(f"FAIL: no image files found in folder: {folder}")
        return

    kernel_height, kernel_width = kernel.shape

    for image_path in image_files:
        full_image = load_grayscale_image(image_path)
        image_height, image_width = full_image.shape

        for height in TEST_HEIGHTS:
            if height < kernel_height or height > image_height:
                continue

            for width in TEST_WIDTHS:
                if width < kernel_width or width > image_width:
                    continue

                test_image = full_image[:height, :width]

                expected_output = reference_model(test_image, kernel)
                actual_output = device_under_test(test_image, kernel)

                test_name = f"{image_path.name} size={height}x{width}"
                compare_outputs(expected_output, actual_output, test_name)


if __name__ == "__main__":
    run_tests(IMAGE_FOLDER, KERNEL)