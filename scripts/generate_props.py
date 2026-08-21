import os
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# -------------------------------------------------------------
# 1. ALCHEMY LAB (48x48 Pixel-Art Table with Alembic & Elixirs)
# -------------------------------------------------------------
im_alc = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_alc = ImageDraw.Draw(im_alc)

# Table Legs and wooden structure
d_alc.rectangle([6, 22, 10, 44], fill=(70, 42, 22, 255), outline=(40, 24, 12, 255))
d_alc.rectangle([38, 22, 42, 44], fill=(70, 42, 22, 255), outline=(40, 24, 12, 255))
d_alc.rectangle([6, 40, 42, 42], fill=(50, 30, 15, 255)) # Crossbeam

# Main wooden tabletop with beveled edge
d_alc.rectangle([4, 20, 44, 30], fill=(110, 68, 36, 255), outline=(55, 32, 16, 255))
d_alc.rectangle([5, 21, 43, 23], fill=(145, 92, 50, 255)) # Highlight top lip

# Mortar & Pestle on left
d_alc.ellipse([8, 16, 16, 22], fill=(90, 92, 98, 255), outline=(50, 52, 56, 255))
d_alc.polygon([(11, 14), (13, 13), (17, 19), (15, 20)], fill=(130, 80, 40, 255)) # Pestle stick

# Brass Alembic / Retort in Center
d_alc.ellipse([20, 12, 30, 22], fill=(210, 160, 40, 255), outline=(130, 95, 20, 255)) # Brass boiler
d_alc.polygon([(24, 6), (26, 6), (28, 12), (22, 12)], fill=(230, 180, 55, 255)) # Neck
d_alc.polygon([(26, 6), (36, 12), (35, 14), (25, 8)], fill=(200, 150, 35, 255)) # Condenser pipe

# Glowing Glass Flask / Beaker on right
d_alc.ellipse([34, 14, 42, 22], fill=(40, 190, 230, 220), outline=(20, 110, 140, 255))
d_alc.rectangle([37, 9, 39, 14], fill=(160, 230, 255, 180), outline=(20, 110, 140, 255))
d_alc.ellipse([36, 16, 40, 20], fill=(120, 240, 255, 240)) # Magic liquid core

# Open Ancient Spellbook / Scroll
d_alc.polygon([(17, 23), (25, 23), (27, 28), (15, 28)], fill=(235, 225, 185, 255), outline=(100, 70, 40, 255))
d_alc.line([(21, 23), (21, 28)], fill=(130, 100, 60, 255))

im_alc.save(f"{OUT_DIR}/alchemy_lab.png")
print("Saved alchemy_lab.png")


# -------------------------------------------------------------
# 2. CAMPFIRE & FIREPLACE (48x48 Warm Stone Hearth & Flame)
# -------------------------------------------------------------
im_camp = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_camp = ImageDraw.Draw(im_camp)

# Base stone ring
stones = [
    (10, 34, 6), (16, 39, 7), (24, 41, 7), (32, 39, 7), (38, 34, 6),
    (36, 28, 6), (24, 26, 6), (12, 28, 6)
]
for sx, sy, sr in stones:
    d_camp.ellipse([sx - sr, sy - sr//2, sx + sr, sy + sr//2], fill=(75, 78, 85, 255), outline=(42, 44, 48, 255))
    d_camp.ellipse([sx - sr + 2, sy - sr//2 + 1, sx + sr - 2, sy + sr//2 - 1], fill=(110, 115, 122, 255))

# Dark ash bed & red-hot coals
d_camp.ellipse([14, 28, 34, 38], fill=(30, 18, 14, 255))
d_camp.ellipse([18, 30, 30, 36], fill=(190, 55, 15, 255))
d_camp.ellipse([21, 31, 27, 34], fill=(255, 170, 35, 255))

# Crossed wooden logs
d_camp.polygon([(14, 36), (17, 38), (34, 26), (31, 24)], fill=(95, 52, 22, 255), outline=(52, 28, 12, 255))
d_camp.polygon([(34, 36), (31, 38), (14, 26), (17, 24)], fill=(105, 60, 26, 255), outline=(52, 28, 12, 255))

# Glowing multi-layered fire flame
d_camp.polygon([(24, 8), (33, 21), (29, 32), (19, 32), (15, 21)], fill=(245, 105, 12, 240))
d_camp.polygon([(24, 12), (30, 23), (27, 31), (21, 31), (18, 23)], fill=(255, 195, 25, 250))
d_camp.polygon([(24, 16), (28, 25), (24, 30), (20, 25)], fill=(255, 250, 160, 255))

im_camp.save(f"{OUT_DIR}/campfire.png")
im_camp.save(f"{OUT_DIR}/fireplace.png")
print("Saved campfire.png and fireplace.png")
