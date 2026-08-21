import os
import math
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# 48x48 Pixel-Art Campfire / Hearth
im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
draw = ImageDraw.Draw(im)

# 1. Circular stone hearth ring at base (y: 26 to 44)
stones = [
    (10, 32, 7), (16, 38, 8), (24, 40, 8), (32, 38, 8), (38, 32, 7),
    (36, 26, 7), (24, 24, 7), (12, 26, 7)
]
for sx, sy, sr in stones:
    draw.ellipse([sx - sr, sy - sr//2, sx + sr, sy + sr//2], fill=(70, 72, 78, 255), outline=(40, 42, 46, 255))
    draw.ellipse([sx - sr + 2, sy - sr//2 + 1, sx + sr - 2, sy + sr//2 - 1], fill=(105, 110, 118, 255))

# 2. Glowing ash & coal bed in center
draw.ellipse([14, 28, 34, 38], fill=(35, 20, 15, 255))
draw.ellipse([18, 30, 30, 36], fill=(180, 50, 15, 255)) # Hot coals
draw.ellipse([21, 31, 27, 34], fill=(255, 160, 30, 255)) # White-hot core

# 3. Crossed burning wood logs
# Log 1 (bottom-left to top-right)
draw.polygon([(14, 36), (17, 38), (34, 26), (31, 24)], fill=(90, 50, 20, 255), outline=(50, 28, 12, 255))
# Log 2 (bottom-right to top-left)
draw.polygon([(34, 36), (31, 38), (14, 26), (17, 24)], fill=(100, 58, 24, 255), outline=(50, 28, 12, 255))

# 4. Vibrant glowing fire flames (y: 10 to 32)
# Outer orange flame
draw.polygon([(24, 8), (32, 22), (28, 32), (20, 32), (16, 22)], fill=(245, 110, 15, 230))
# Mid yellow flame
draw.polygon([(24, 12), (30, 24), (26, 31), (22, 31), (18, 24)], fill=(255, 190, 25, 240))
# Inner bright core
draw.polygon([(24, 16), (28, 26), (24, 30), (20, 26)], fill=(255, 245, 150, 255))

im.save(f"{OUT_DIR}/campfire.png")
im.save(f"{OUT_DIR}/fireplace.png")
print("SUCCESS: Glowing pixel-art campfire & fireplace generated!")
