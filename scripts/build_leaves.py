"""
Wind Leaf Pixel-Art Generator
- leaf_spring.png (10x10) - fresh emerald green oak/maple leaf
- leaf_autumn.png (10x10) - golden orange autumn leaf
"""

import os
from PIL import Image, ImageDraw

WORLD_DIR = "godot/assets/sprites/world"
os.makedirs(WORLD_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)

def make_leaf(season="spring"):
    im = Image.new("RGBA", (10, 10), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    if season == "spring":
        c_hi   = (145, 235, 75, 255)
        c_mid  = (85, 195, 45, 255)
        c_dark = (45, 135, 25, 255)
        c_stem = (35, 95, 20, 255)
    else: # autumn
        c_hi   = (255, 200, 50, 255)
        c_mid  = (235, 125, 30, 255)
        c_dark = (185, 65, 20, 255)
        c_stem = (120, 45, 15, 255)

    # Leaf shape (Maple / Oak lobe)
    d.polygon([(1, 1), (5, 0), (9, 2), (8, 6), (5, 9), (2, 7)], fill=c_dark)
    d.polygon([(2, 2), (5, 1), (8, 3), (7, 6), (5, 8), (3, 6)], fill=c_mid)
    d.polygon([(3, 3), (5, 2), (7, 4), (6, 5)], fill=c_hi)
    # Stem
    d.line([(5, 8), (7, 10)], fill=c_stem)
    d.line([(5, 2), (5, 7)], fill=c_stem)

    return im

make_leaf("spring").save(f"{WORLD_DIR}/leaf_spring.png")
make_leaf("autumn").save(f"{WORLD_DIR}/leaf_autumn.png")
print("Generated leaf_spring.png and leaf_autumn.png!")
