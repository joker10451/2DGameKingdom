import os
import math
from PIL import Image

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

def cl(v, lo=0, hi=255):
    return max(lo, min(hi, int(v)))

# 1. WOLF (48x48) - Sleek grey timberwolf
def make_wolf():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # Body ellipse: cx: 24, cy: 26, rx: 14, ry: 9
    for y in range(48):
        for x in range(48):
            dx = (x - 24) / 14.0
            dy = (y - 26) / 9.0
            if dx*dx + dy*dy <= 1.0:
                base = 110 - dy * 30 + ((x * 7 + y * 11) % 9)
                im.putpixel((x, y), (cl(base * 0.95), cl(base * 0.98), cl(base * 1.05), 255))
    # Head: cx: 14, cy: 21, r: 6
    for y in range(48):
        for x in range(48):
            if (x - 14)**2 + (y - 21)**2 <= 36:
                im.putpixel((x, y), (120, 125, 135, 255))
    # Muzzle / Snout: (8..13, 21..24)
    for y in range(21, 25):
        for x in range(8, 14):
            im.putpixel((x, y), (105, 110, 120, 255))
    im.putpixel((7, 22), (30, 30, 35, 255)) # Black nose
    im.putpixel((12, 19), (240, 220, 40, 255)) # Amber eye
    # Pointed wolf ears
    for px, py in [(13, 14), (14, 13), (14, 14), (17, 14), (17, 15)]:
        im.putpixel((px, py), (90, 95, 105, 255))
    # 4 Legs
    for lx in [14, 18, 28, 32]:
        for y in range(32, 42):
            for x in range(lx, lx + 3):
                im.putpixel((x, y), (90, 95, 105, 255))
    # Bushy tail (34..42, 22..28)
    for px, py in [(35, 23), (36, 24), (37, 24), (38, 25), (39, 25), (40, 26), (41, 26)]:
        for dy in [0, 1]:
            im.putpixel((px, py + dy), (115, 120, 130, 255))
    return im

# 2. BOAR (48x48) - Rugged brown wild boar with white tusks
def make_boar():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # Stout stocky body
    for y in range(48):
        for x in range(48):
            dx = (x - 24) / 15.0
            dy = (y - 27) / 11.0
            if dx*dx + dy*dy <= 1.0:
                base = 90 - dy * 25 + ((x * 5 + y * 7) % 11)
                im.putpixel((x, y), (cl(base * 1.1), cl(base * 0.7), cl(base * 0.45), 255))
    # Big head & snout
    for y in range(20, 34):
        for x in range(9, 20):
            if (x - 17)**2 + (y - 26)**2 <= 49:
                im.putpixel((x, y), (95, 60, 38, 255))
    # Snout
    for y in range(25, 31):
        for x in range(6, 12):
            im.putpixel((x, y), (115, 75, 50, 255))
    im.putpixel((5, 27), (60, 35, 25, 255)) # Snout disc
    # White tusk
    for tx, ty in [(8, 28), (7, 27), (6, 26)]:
        im.putpixel((tx, ty), (245, 245, 230, 255))
    # Small eye & ears
    im.putpixel((14, 23), (25, 20, 18, 255))
    im.putpixel((17, 18), (80, 50, 30, 255))
    # 4 Short legs
    for lx in [13, 18, 28, 33]:
        for y in range(35, 43):
            for x in range(lx, lx + 4):
                im.putpixel((x, y), (70, 42, 25, 255))
    return im

# 3. DEER / STAG (48x48) - Graceful fawn/stag with antlers
def make_deer():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # Slender body
    for y in range(48):
        for x in range(48):
            dx = (x - 25) / 13.0
            dy = (y - 28) / 8.0
            if dx*dx + dy*dy <= 1.0:
                im.putpixel((x, y), (185, 120, 68, 255))
    # Slender neck & head
    for y in range(16, 29):
        for x in range(14, 19):
            im.putpixel((x, y), (195, 128, 72, 255))
    # Head
    for y in range(14, 21):
        for x in range(9, 16):
            im.putpixel((x, y), (205, 135, 78, 255))
    im.putpixel((8, 17), (40, 30, 25, 255)) # Nose
    im.putpixel((12, 16), (25, 20, 18, 255)) # Eye
    # Antlers
    antler_pts = [(14, 12), (14, 10), (13, 8), (12, 6), (15, 7), (16, 5), (17, 9)]
    for ax, ay in antler_pts:
        im.putpixel((ax, ay), (140, 110, 85, 255))
    # Long thin legs
    for lx in [14, 18, 28, 32]:
        for y in range(34, 45):
            for x in range(lx, lx + 2):
                im.putpixel((x, y), (160, 100, 55, 255))
    return im

# 4. BEAR (48x48) - Massive brown bear
def make_bear():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # Huge body
    for y in range(48):
        for x in range(48):
            dx = (x - 24) / 16.0
            dy = (y - 27) / 12.0
            if dx*dx + dy*dy <= 1.0:
                base = 80 - dy * 20 + ((x * 3 + y * 7) % 9)
                im.putpixel((x, y), (cl(base * 1.1), cl(base * 0.65), cl(base * 0.35), 255))
    # Head
    for y in range(18, 30):
        for x in range(8, 18):
            if (x - 14)**2 + (y - 24)**2 <= 36:
                im.putpixel((x, y), (90, 55, 30, 255))
    im.putpixel((7, 24), (30, 25, 20, 255)) # Nose
    im.putpixel((11, 21), (25, 20, 18, 255)) # Eye
    # Round ears
    im.putpixel((13, 17), (80, 48, 25, 255))
    im.putpixel((16, 17), (80, 48, 25, 255))
    # Thick heavy paws
    for lx in [11, 17, 27, 33]:
        for y in range(36, 45):
            for x in range(lx, lx + 5):
                im.putpixel((x, y), (70, 42, 22, 255))
    return im

wolf = make_wolf()
wolf.save(f"{OUT_DIR}/wildlife_wolf.png")
wolf.save(f"{OUT_DIR}/wolf.png")

boar = make_boar()
boar.save(f"{OUT_DIR}/wildlife_boar.png")
boar.save(f"{OUT_DIR}/boar.png")

deer = make_deer()
deer.save(f"{OUT_DIR}/wildlife_deer.png")
deer.save(f"{OUT_DIR}/deer.png")

bear = make_bear()
bear.save(f"{OUT_DIR}/wildlife_bear.png")
bear.save(f"{OUT_DIR}/bear.png")

print("SUCCESS: Wildlife sprites (wolf, boar, deer, bear) generated!")
