from PIL import Image

im = Image.open("temp_lpc/Terrain/trees_summer.png")
print("trees_summer size:", im.size)

# In standard LPC 32px tile grid:
# A large tree is typically 3x4 tiles (96x128) or 4x5 tiles (128x160)
# Let's save a slice grid of trees_summer.png with tile boundaries
grid_img = im.copy()
from PIL import ImageDraw
draw = ImageDraw.Draw(grid_img)
for x in range(0, im.width, 32):
    draw.line([(x, 0), (x, im.height)], fill=(255, 0, 0, 128))
for y in range(0, im.height, 32):
    draw.line([(0, y), (im.width, y)], fill=(255, 0, 0, 128))

grid_img.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/trees_grid_debug.png")
print("Saved trees_grid_debug.png")
