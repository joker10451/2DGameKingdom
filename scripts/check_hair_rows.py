from PIL import Image

im_hair = Image.open('godot/assets/sprites/lpc_raw/hair_bedhead_male_blonde.png')
print(f"Hair sheet size: {im_hair.size}")

num_rows = im_hair.height // 64
print(f"Total rows in hair sheet: {num_rows}")

for r in range(num_rows):
    row_crop = im_hair.crop((0, r * 64, im_hair.width, (r + 1) * 64))
    bbox = row_crop.getbbox()
    if bbox:
        print(f"Row {r:2d}: HAS PIXELS (bbox = {bbox})")
    else:
        print(f"Row {r:2d}: EMPTY!")
