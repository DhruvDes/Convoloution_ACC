from PIL import Image
img = Image.open('dog.jpg')
width, height = img.size
print(f"Matrix size: {height} x {width}")