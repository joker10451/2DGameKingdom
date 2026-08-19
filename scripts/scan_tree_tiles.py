from PIL import Image

im = Image.open("temp_lpc/Terrain/trees_summer.png").convert("RGBA")

# Print which 32x32 tiles are filled
for ty in range(im.height // 32):
    row_str = ""
    for tx in range(im.width // 32):
        tile = im.crop((tx * 32, ty * 32, (tx + 1) * 32, (ty + 1) * 32))
        bbox = tile.getbbox()
        row_str += "#" if bbox else "."
    print(f"Row {ty:2d}: {row_str}")
