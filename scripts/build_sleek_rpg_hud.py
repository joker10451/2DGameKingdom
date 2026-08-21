"""
Exquisite Medieval Fantasy RPG HUD Generator (Symmetrical 180x14 Edition)
"""

import os
from PIL import Image, ImageDraw

UI_DIR = "godot/assets/ui"
os.makedirs(UI_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (12, 10, 14, 180)

G_SPEC  = (255, 255, 210, 255)
G_HI    = (255, 230, 130, 255)
G_MID   = (215, 170, 45, 255)
G_DARK  = (140, 95, 20, 255)
G_SHD   = (65, 40, 10, 255)

IRON_BG = (16, 14, 18, 255)

def make_hud_crest(size=44):
    im = Image.new("RGBA", (size, size), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx, cy = size // 2, size // 2
    r = size // 2 - 3

    d.ellipse([cx - r + 1, cy - r + 2, cx + r + 1, cy + r + 2], fill=C_SHADOW)
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=G_SHD)
    d.ellipse([cx - r + 1, cy - r + 1, cx + r - 1, cy + r - 1], fill=G_DARK)
    d.ellipse([cx - r + 2, cy - r + 2, cx + r - 2, cy + r - 2], fill=G_MID)
    d.ellipse([cx - r + 3, cy - r + 3, cx + r - 3, cy + r - 3], fill=G_HI)
    d.ellipse([cx - r + 5, cy - r + 5, cx + r - 5, cy + r - 5], fill=IRON_BG)
    
    # Shield & Sword
    d.polygon([(cx, cy - 9), (cx - 7, cy - 2), (cx - 5, cy + 7), (cx, cy + 10), (cx + 5, cy + 7), (cx + 7, cy - 2)], fill=G_MID)
    d.polygon([(cx, cy - 7), (cx - 5, cy - 1), (cx - 3, cy + 5), (cx, cy + 8), (cx + 3, cy + 5), (cx + 5, cy - 1)], fill=G_HI)
    d.polygon([(cx, cy + 3), (cx - 3, cy - 1), (cx, cy - 3), (cx + 3, cy - 1)], fill=(225, 30, 45, 255))
    d.point([(cx, cy - 1)], fill=G_SPEC)
    return im

def make_bar_frame(w=180, h=14):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.rectangle([1, 1, w - 1, h - 1], fill=C_SHADOW)
    d.rectangle([0, 0, w - 2, h - 2], fill=G_SHD)
    d.rectangle([1, 1, w - 3, h - 3], fill=G_DARK)
    d.line([(1, 1), (w - 3, 1)], fill=G_HI)
    d.line([(1, 1), (1, h - 3)], fill=G_HI)
    d.line([(w - 3, 1), (w - 3, h - 3)], fill=G_SHD)
    d.line([(1, h - 3), (w - 3, h - 3)], fill=G_SHD)
    d.rectangle([2, 2, w - 4, h - 4], fill=IRON_BG)
    d.point([(1, 1), (w - 3, 1), (1, h - 3), (w - 3, h - 3)], fill=G_SPEC)
    return im

def make_bar_fill(w=176, h=10, fill_type="hp"):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    if fill_type == "hp":
        c_glow = (255, 210, 220, 255)
        c_hi   = (245, 55, 75, 255)
        c_mid  = (205, 20, 40, 255)
        c_dark = (135, 10, 25, 255)
        c_deep = (75, 5, 15, 255)
    elif fill_type == "stamina":
        c_glow = (210, 255, 220, 255)
        c_hi   = (65, 240, 110, 255)
        c_mid  = (30, 185, 65, 255)
        c_dark = (15, 120, 40, 255)
        c_deep = (8, 65, 20, 255)
    elif fill_type == "hunger":
        c_glow = (255, 250, 200, 255)
        c_hi   = (250, 200, 50, 255)
        c_mid  = (215, 150, 25, 255)
        c_dark = (145, 95, 15, 255)
        c_deep = (75, 45, 8, 255)

    for y in range(h):
        if y == 0: col = c_glow
        elif y == 1: col = c_hi
        elif y < h - 2: col = c_mid
        elif y < h - 1: col = c_dark
        else: col = c_deep
        d.line([(0, y), (w - 1, y)], fill=col)

    # Top highlight
    for x in range(w):
        orig = im.getpixel((x, 0))
        d.point([(x, 0)], fill=(min(255, orig[0] + 30), min(255, orig[1] + 30), min(255, orig[2] + 30), 255))

    return im

make_hud_crest(44).save(f"{UI_DIR}/hud_crest.png")

for t in ["hp", "stamina", "hunger"]:
    make_bar_frame(180, 14).save(f"{UI_DIR}/hud_bar_{t}_frame.png")
    make_bar_fill(174, 10, t).save(f"{UI_DIR}/hud_bar_{t}_fill.png")

print("Generated clean 180x14 bars!")
