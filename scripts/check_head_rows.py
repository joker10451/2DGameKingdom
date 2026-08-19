from PIL import Image

im_head = Image.open('godot/assets/sprites/lpc_raw/head_heads_human_male_light.png')
print(f"Head sheet size: {im_head.size}")

num_rows = im_head.height // 64
print(f"Total rows in head sheet: {num_rows}")

for r in range(num_rows):
    row_crop = im_head.crop((0, r * 64, im_head.width, (r + 1) * 64))
    bbox = row_crop.getbbox()
    if bbox:
        print(f"Row {r:2d}: HAS PIXELS (bbox = {bbox})")
    else:
        print(f"Row {r:2d}: EMPTY!")
