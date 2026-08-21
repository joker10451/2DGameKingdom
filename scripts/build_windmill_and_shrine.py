"""
Medieval Windmill & Ancient Rune Shrine Pixel-Art Generator
- windmill_tower.png (64x96)
- windmill_sails.png (96x96)
- ancient_shrine.png (64x80)
- shrine_rune_glow.png (64x80)
Style: Stardew Valley / Graveyard Keeper / Heroes III
"""

import os
from PIL import Image, ImageDraw

WORLD_DIR = "godot/assets/sprites/world"
os.makedirs(WORLD_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (14, 12, 18, 120)

# Stone palette
ST_HI    = (215, 210, 200, 255)
ST_MID   = (175, 170, 160, 255)
ST_DARK  = (125, 120, 110, 255)
ST_MORT  = (85, 80, 75, 255)
MOSS_C   = (90, 135, 65, 255)

# Wood palette
W_HI   = (175, 120, 65, 255)
W_MID  = (135, 85, 40, 255)
W_DARK = (90, 50, 25, 255)
W_DEEP = (55, 30, 15, 255)

# Sail canvas
SAIL_HI  = (248, 245, 235, 255)
SAIL_MID = (225, 218, 200, 255)
SAIL_SHD = (185, 175, 155, 255)
ROPE_C   = (145, 115, 75, 255)

# Rune Magic Glow
RUNE_CYAN = (60, 235, 255, 255)
RUNE_HI   = (210, 250, 255, 255)
RUNE_DEEP = (20, 130, 200, 255)

def make_windmill_tower(w=64, h=96):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx = w // 2 # 32

    # 1. Foundation Drop Shadow
    d.ellipse([cx - 28, h - 14, cx + 28, h - 2], fill=C_SHADOW)

    # 2. Conical Stone Tower Body (y: 28 to 88)
    # Tapered from top radius 16 to bottom radius 24
    for y in range(28, 88):
        t = (y - 28) / 60.0
        rw = int(16 + t * 9) # 16 at top, 25 at bottom
        
        # Base stone shading with cylindrical light (light from top-left)
        for x in range(cx - rw, cx + rw + 1):
            nx = (x - cx) / float(rw) # -1.0 to 1.0
            if nx < -0.3:
                col = ST_HI
            elif nx < 0.3:
                col = ST_MID
            elif nx < 0.7:
                col = ST_DARK
            else:
                col = ST_MORT
            # Bottom moss
            if y > 76 and (x + y * 3) % 7 < 3:
                col = MOSS_C
            d.point([(x, y)], fill=col)

    # Brick mortar lines & stones texture
    for row in range(30, 86, 7):
        t = (row - 28) / 60.0
        rw = int(16 + t * 9)
        d.line([(cx - rw, row), (cx + rw, row)], fill=ST_MORT)
        # Vertical stone seams
        shift = 0 if (row // 7) % 2 == 0 else 5
        for sx in range(cx - rw + 3 + shift, cx + rw - 2, 10):
            d.line([(sx, row), (sx, min(88, row + 7))], fill=ST_MORT)

    # 3. Wooden Door at bottom (y: 66 to 88)
    d.rectangle([cx - 7, 66, cx + 7, 88], fill=W_DARK)
    d.rectangle([cx - 6, 67, cx + 6, 87], fill=W_MID)
    # Timber planks
    d.line([(cx - 2, 67), (cx - 2, 87)], fill=W_DEEP)
    d.line([(cx + 2, 67), (cx + 2, 87)], fill=W_DEEP)
    # Iron hinges & latch
    d.rectangle([cx - 6, 71, cx - 3, 73], fill=(45, 45, 50, 255))
    d.rectangle([cx - 6, 81, cx - 3, 83], fill=(45, 45, 50, 255))
    d.point([(cx + 4, 77)], fill=(235, 195, 50, 255)) # brass knob

    # 4. Arched Windows
    for wy in [40, 56]:
        d.rectangle([cx - 4, wy, cx + 4, wy + 7], fill=W_DEEP)
        d.rectangle([cx - 3, wy + 1, cx + 3, wy + 6], fill=(25, 20, 25, 255))
        d.line([(cx, wy + 1), (cx, wy + 6)], fill=W_HI) # cross frame
        d.line([(cx - 3, wy + 3), (cx + 3, wy + 3)], fill=W_HI)
        # Timber sill
        d.line([(cx - 5, wy + 8), (cx + 5, wy + 8)], fill=W_MID)

    # 5. Timber Shingle Roof (Conical top, y: 4 to 28)
    d.polygon([(cx, 3), (cx - 20, 28), (cx + 20, 28)], fill=W_DARK)
    d.polygon([(cx, 4), (cx - 18, 27), (cx + 18, 27)], fill=W_MID)
    # Shingle rows
    for ry in range(8, 28, 4):
        rw = int(3 + (ry - 4) * 0.75)
        d.line([(cx - rw, ry), (cx + rw, ry)], fill=W_DEEP)
        d.line([(cx - rw + 1, ry - 1), (cx + rw - 1, ry - 1)], fill=W_HI)
    # Weather vane on top
    d.line([(cx, 0), (cx, 4)], fill=(75, 75, 80, 255))
    d.point([(cx + 1, 1), (cx + 2, 1), (cx - 1, 1)], fill=(235, 195, 50, 255))

    # 6. Iron Cog Pivot Hub for the Rotor (cx, 28)
    d.ellipse([cx - 5, 23, cx + 5, 33], fill=(45, 45, 50, 255))
    d.ellipse([cx - 4, 24, cx + 4, 32], fill=(85, 85, 95, 255))
    d.point([(cx, 28)], fill=(255, 215, 50, 255))

    return im

def make_windmill_sails(size=96):
    im = Image.new("RGBA", (size, size), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx, cy = size // 2, size // 2 # (48, 48)

    # 4 rotating sails pointing North, South, East, West
    # Each sail has a wooden timber spar + white canvas sail with lattice
    for angle_idx, (dx, dy, px, py) in enumerate([
        (0, -1, 1, 0),   # North: spar goes up, canvas on right
        (1, 0, 0, 1),    # East: spar goes right, canvas on bottom
        (0, 1, -1, 0),   # South: spar goes down, canvas on left
        (-1, 0, 0, -1),  # West: spar goes left, canvas on top
    ]):
        # Main wooden spar (length 40px)
        sx = cx + dx * 8
        sy = cy + dy * 8
        ex = cx + dx * 44
        ey = cy + dy * 44
        d.line([(cx, cy), (ex, ey)], fill=W_DARK, width=3)
        d.line([(cx, cy), (ex, ey)], fill=W_HI, width=1)

        # Cross timber ribs along the spar
        for step in range(12, 42, 6):
            rx = cx + dx * step
            ry = cy + dy * step
            crx = rx + px * 10
            cry = ry + py * 10
            d.line([(rx, ry), (crx, cry)], fill=W_DARK, width=2)
            d.line([(rx, ry), (crx, cry)], fill=W_HI, width=1)

        # Canvas sail cloth stretched between ribs
        # Quad corners: (cx+dx*12, cy+dy*12) -> (cx+dx*42, cy+dy*42) -> (cx+dx*42+px*10, cy+dy*42+py*10) -> (cx+dx*12+px*9, cy+dy*12+py*9)
        p1 = (cx + dx * 12 + px * 1, cy + dy * 12 + py * 1)
        p2 = (cx + dx * 42 + px * 1, cy + dy * 42 + py * 1)
        p3 = (cx + dx * 42 + px * 9, cy + dy * 42 + py * 9)
        p4 = (cx + dx * 12 + px * 8, cy + dy * 12 + py * 8)
        
        d.polygon([p1, p2, p3, p4], fill=SAIL_SHD)
        
        # Inset highlight
        ip1 = (cx + dx * 13 + px * 2, cy + dy * 13 + py * 2)
        ip2 = (cx + dx * 41 + px * 2, cy + dy * 41 + py * 2)
        ip3 = (cx + dx * 41 + px * 8, cy + dy * 41 + py * 8)
        ip4 = (cx + dx * 13 + px * 7, cy + dy * 13 + py * 7)
        d.polygon([ip1, ip2, ip3, ip4], fill=SAIL_MID)

        # Rope ties
        d.line([p1, p4], fill=ROPE_C)
        d.line([p2, p3], fill=ROPE_C)

    # Center iron hub cap
    d.ellipse([cx - 7, cy - 7, cx + 7, cy + 7], fill=(35, 35, 40, 255))
    d.ellipse([cx - 5, cy - 5, cx + 5, cy + 5], fill=(75, 75, 85, 255))
    d.ellipse([cx - 3, cy - 3, cx + 3, cy + 3], fill=(160, 160, 175, 255))
    d.point([(cx, cy)], fill=(255, 225, 80, 255))

    return im

def make_ancient_shrine(w=64, h=80):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx = w // 2 # 32

    # Drop shadow
    d.ellipse([cx - 26, h - 14, cx + 26, h - 2], fill=C_SHADOW)

    # 1. Stone Altar Step Base (y: 64 to 76)
    d.polygon([(cx - 24, 76), (cx + 24, 76), (cx + 20, 64), (cx - 20, 64)], fill=ST_DARK)
    d.polygon([(cx - 22, 74), (cx + 22, 74), (cx + 18, 65), (cx - 18, 65)], fill=ST_MID)
    # Moss on altar
    for mx in range(cx - 20, cx + 20, 4):
        if (mx * 7) % 11 < 6:
            d.point([(mx, 65), (mx + 1, 66)], fill=MOSS_C)

    # 2. Megalithic Stone Pillars (Left pillar: cx-18 to cx-8, Right pillar: cx+8 to cx+18)
    for px_center in [cx - 13, cx + 13]:
        d.polygon([(px_center - 5, 64), (px_center + 5, 64), (px_center + 4, 20), (px_center - 4, 20)], fill=ST_DARK)
        d.polygon([(px_center - 4, 63), (px_center + 4, 63), (px_center + 3, 21), (px_center - 3, 21)], fill=ST_MID)
        d.line([(px_center - 3, 22), (px_center - 4, 62)], fill=ST_HI)

    # 3. Top Capstone Lintel (y: 12 to 24)
    d.polygon([(cx - 22, 23), (cx + 22, 23), (cx + 20, 12), (cx - 20, 12)], fill=ST_DARK)
    d.polygon([(cx - 20, 21), (cx + 20, 21), (cx + 18, 14), (cx - 18, 14)], fill=ST_MID)
    d.line([(cx - 19, 14), (cx + 19, 14)], fill=ST_HI)

    # 4. Central Floating Rune Obelisk (y: 24 to 58)
    d.polygon([(cx, 22), (cx - 8, 38), (cx - 6, 56), (cx, 60), (cx + 6, 56), (cx + 8, 38)], fill=(40, 45, 55, 255))
    d.polygon([(cx, 24), (cx - 6, 38), (cx - 5, 54), (cx, 58), (cx + 5, 54), (cx + 6, 38)], fill=(65, 75, 90, 255))
    d.line([(cx, 24), (cx, 58)], fill=(110, 125, 150, 255))

    # 5. Glowing Mystical Runes Carved in the Obelisk
    # Ancient rune symbols (Rune 1: top, Rune 2: center, Rune 3: bottom)
    d.line([(cx, 28), (cx, 36)], fill=RUNE_CYAN, width=2)
    d.line([(cx - 3, 30), (cx + 3, 34)], fill=RUNE_CYAN, width=2)
    d.point([(cx, 32)], fill=RUNE_HI)

    # Rune 2 (Diamond nexus)
    d.polygon([(cx, 39), (cx - 4, 44), (cx, 49), (cx + 4, 44)], outline=RUNE_CYAN, fill=(30, 80, 120, 255))
    d.point([(cx, 44)], fill=RUNE_HI)

    # Rune 3 (Trident / Fork)
    d.line([(cx, 51), (cx, 56)], fill=RUNE_CYAN, width=2)
    d.line([(cx - 3, 52), (cx, 54)], fill=RUNE_CYAN)
    d.line([(cx + 3, 52), (cx, 54)], fill=RUNE_CYAN)

    # 6. Altar Sacred Chalice with glowing mana flame
    d.rectangle([cx - 3, 62, cx + 3, 65], fill=(225, 185, 45, 255))
    d.point([(cx, 60)], fill=RUNE_HI)
    d.point([(cx, 59)], fill=RUNE_CYAN)

    return im

print("Generating Windmill & Rune Shrine assets...")

make_windmill_tower().save(f"{WORLD_DIR}/windmill_tower.png")
make_windmill_sails().save(f"{WORLD_DIR}/windmill_sails.png")
make_ancient_shrine().save(f"{WORLD_DIR}/ancient_shrine.png")

print("SUCCESS: Windmill & Ancient Shrine assets created in godot/assets/sprites/world/!")
