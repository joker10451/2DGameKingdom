"""
Medieval Fantasy UI Master Asset Pack Generator
Generates handcrafted 9-slice panels, buttons, ornate status bars, icons, and frames
Style: Stardew Valley / Graveyard Keeper / Kingdom Two Crowns / Baldur's Gate
"""

import os
from PIL import Image, ImageDraw, ImageFilter

UI_DIR = "godot/assets/ui"
os.makedirs(UI_DIR, exist_ok=True)

# Colors
C_TRANSPARENT = (0, 0, 0, 0)
C_DARK_BG = (20, 16, 15, 240)
C_PARCHMENT_LIGHT = (238, 226, 198, 255)
C_PARCHMENT_MID   = (218, 202, 170, 255)
C_PARCHMENT_DARK  = (185, 165, 130, 255)
C_PARCHMENT_EDGE  = (140, 115, 80, 255)

C_WOOD_HI    = (195, 135, 75, 255)
C_WOOD_MID   = (135, 82, 42, 255)
C_WOOD_DARK  = (80, 45, 20, 255)
C_WOOD_SHD   = (45, 24, 10, 255)

C_GOLD_HI    = (255, 240, 130, 255)
C_GOLD_MID   = (225, 185, 45, 255)
C_GOLD_DARK  = (145, 105, 20, 255)
C_GOLD_SHD   = (85, 55, 10, 255)

C_IRON_HI    = (200, 210, 225, 255)
C_IRON_MID   = (115, 125, 140, 255)
C_IRON_DARK  = (65, 72, 85, 255)
C_IRON_SHD   = (32, 36, 45, 255)

# ================= 1. 9-SLICE PANELS (48x48) =================

def make_panel_parchment():
    im = Image.new("RGBA", (48, 48), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Dark shadow border
    d.rectangle([0, 0, 47, 47], fill=C_WOOD_SHD)
    # Outer wood frame
    d.rectangle([1, 1, 46, 46], fill=C_WOOD_DARK)
    d.rectangle([2, 2, 45, 45], fill=C_WOOD_MID)
    # Inner gold filigree line
    d.rectangle([4, 4, 43, 43], outline=C_GOLD_MID)
    # Corner gold studs
    for cx in [4, 43]:
        for cy in [4, 43]:
            d.rectangle([cx-1, cy-1, cx+1, cy+1], fill=C_GOLD_HI)
            d.point([(cx, cy)], fill=C_GOLD_SHD)
    # Parchment fill
    d.rectangle([5, 5, 42, 42], fill=C_PARCHMENT_MID)
    d.rectangle([6, 6, 41, 41], fill=C_PARCHMENT_LIGHT)
    # Parchment subtle edge aging
    d.line([(5, 5), (42, 5)], fill=C_PARCHMENT_EDGE)
    d.line([(5, 5), (5, 42)], fill=C_PARCHMENT_EDGE)
    d.line([(42, 5), (42, 42)], fill=C_PARCHMENT_DARK)
    d.line([(5, 42), (42, 42)], fill=C_PARCHMENT_DARK)
    return im

def make_panel_dark_stone():
    im = Image.new("RGBA", (48, 48), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Black bevel border
    d.rectangle([0, 0, 47, 47], fill=(12, 10, 14, 255))
    # Outer carved stone
    d.rectangle([1, 1, 46, 46], fill=C_IRON_DARK)
    d.line([(1, 1), (46, 1)], fill=C_IRON_HI)
    d.line([(1, 1), (1, 46)], fill=C_IRON_HI)
    d.line([(46, 1), (46, 46)], fill=C_IRON_SHD)
    d.line([(1, 46), (46, 46)], fill=C_IRON_SHD)
    # Inner gold border
    d.rectangle([3, 3, 44, 44], outline=C_GOLD_DARK)
    # Brass rivets
    for cx in [3, 44]:
        for cy in [3, 44]:
            d.point([(cx, cy)], fill=C_GOLD_HI)
    # Dark velvet interior
    d.rectangle([4, 4, 43, 43], fill=(22, 18, 20, 245))
    d.rectangle([5, 5, 42, 42], fill=(28, 24, 26, 245))
    return im

def make_panel_gold_frame():
    im = Image.new("RGBA", (48, 48), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.rectangle([0, 0, 47, 47], fill=C_GOLD_SHD)
    d.rectangle([1, 1, 46, 46], fill=C_GOLD_DARK)
    d.rectangle([2, 2, 45, 45], fill=C_GOLD_MID)
    d.line([(2, 2), (45, 2)], fill=C_GOLD_HI)
    d.line([(2, 2), (2, 45)], fill=C_GOLD_HI)
    d.rectangle([4, 4, 43, 43], fill=(30, 24, 20, 250))
    d.rectangle([5, 5, 42, 42], fill=(38, 30, 25, 250))
    return im

# ================= 2. BUTTONS (64x28) =================

def make_button(state="normal"):
    im = Image.new("RGBA", (64, 28), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    
    if state == "normal":
        d.rectangle([0, 0, 63, 27], fill=C_WOOD_SHD)
        d.rectangle([1, 1, 62, 26], fill=C_WOOD_DARK)
        d.rectangle([2, 2, 61, 25], fill=C_WOOD_MID)
        # Top/left highlight
        d.line([(2, 2), (61, 2)], fill=C_WOOD_HI)
        d.line([(2, 2), (2, 25)], fill=C_WOOD_HI)
        # Gold border line
        d.rectangle([3, 3, 60, 24], outline=C_GOLD_DARK)
        # Corner studs
        d.point([(3, 3), (60, 3), (3, 24), (60, 24)], fill=C_GOLD_HI)
    elif state == "hover":
        d.rectangle([0, 0, 63, 27], fill=C_GOLD_SHD)
        d.rectangle([1, 1, 62, 26], fill=C_GOLD_DARK)
        d.rectangle([2, 2, 61, 25], fill=C_WOOD_HI)
        d.line([(2, 2), (61, 2)], fill=(255, 220, 160, 255))
        d.rectangle([3, 3, 60, 24], outline=C_GOLD_HI)
        d.point([(3, 3), (60, 3), (3, 24), (60, 24)], fill=(255, 255, 220, 255))
    elif state == "pressed":
        d.rectangle([0, 0, 63, 27], fill=C_WOOD_SHD)
        d.rectangle([1, 1, 62, 26], fill=C_WOOD_SHD)
        d.rectangle([2, 2, 61, 25], fill=C_WOOD_DARK)
        d.line([(2, 25), (61, 25)], fill=C_WOOD_MID)
        d.rectangle([4, 4, 59, 23], outline=C_GOLD_SHD)
    elif state == "disabled":
        d.rectangle([0, 0, 63, 27], fill=(30, 30, 35, 255))
        d.rectangle([1, 1, 62, 26], fill=(50, 50, 55, 255))
        d.rectangle([2, 2, 61, 25], fill=(65, 65, 70, 255))
    return im

# ================= 3. ORNATE STATUS BARS =================

def make_bar_frame(w=160, h=16):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Heavy outer metallic frame
    d.rectangle([0, 0, w-1, h-1], fill=C_IRON_SHD)
    d.rectangle([1, 1, w-2, h-2], fill=C_IRON_DARK)
    d.rectangle([2, 2, w-3, h-3], fill=C_IRON_MID)
    d.line([(2, 2), (w-3, 2)], fill=C_IRON_HI)
    d.line([(2, 2), (2, h-3)], fill=C_IRON_HI)
    # Sunken inner channel
    d.rectangle([3, 3, w-4, h-4], fill=(14, 12, 16, 255))
    d.rectangle([4, 4, w-5, h-5], fill=(22, 18, 24, 255))
    # Corner gold accents
    for x in [1, w-2]:
        for y in [1, h-2]:
            d.point([(x, y)], fill=C_GOLD_HI)
    return im

def make_bar_fill(w=152, h=8, fill_type="hp"):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    
    if fill_type == "hp":
        c_hi  = (255, 140, 150, 255)
        c_mid = (225, 35, 50, 255)
        c_low = (145, 15, 25, 255)
        c_shd = (85, 8, 15, 255)
    elif fill_type == "stamina":
        c_hi  = (160, 255, 150, 255)
        c_mid = (40, 205, 75, 255)
        c_low = (18, 135, 45, 255)
        c_shd = (10, 75, 25, 255)
    elif fill_type == "hunger":
        c_hi  = (255, 245, 140, 255)
        c_mid = (235, 175, 30, 255)
        c_low = (165, 105, 15, 255)
        c_shd = (95, 55, 8, 255)
    else: # Mana / magic
        c_hi  = (160, 220, 255, 255)
        c_mid = (45, 135, 245, 255)
        c_low = (20, 75, 175, 255)
        c_shd = (10, 35, 105, 255)
        
    for y in range(h):
        if y == 0: col = c_hi
        elif y < h // 2: col = c_mid
        elif y < h - 1: col = c_low
        else: col = c_shd
        d.line([(0, y), (w-1, y)], fill=col)
        
    # Segment divider ticks
    for x in range(24, w, 24):
        d.line([(x, 0), (x, h-1)], fill=C_IRON_SHD)
        d.point([(x+1, 0)], fill=c_hi)
        
    return im

# ================= 4. MEDIEVAL ICONS (22x22) =================

def make_icon_heart():
    im = Image.new("RGBA", (22, 22), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Gold rim
    d.polygon([(11, 20), (1, 10), (1, 5), (6, 1), (11, 5), (16, 1), (21, 5), (21, 10)], fill=C_GOLD_DARK)
    d.polygon([(11, 18), (3, 10), (3, 6), (7, 3), (11, 6), (15, 3), (19, 6), (19, 10)], fill=(180, 20, 30, 255))
    d.polygon([(11, 16), (5, 9), (5, 7), (8, 4), (11, 7), (14, 4), (17, 7), (17, 9)], fill=(235, 45, 60, 255))
    # Specular shine
    d.point([(6, 6), (7, 5), (7, 6)], fill=(255, 200, 210, 255))
    return im

def make_icon_stamina():
    im = Image.new("RGBA", (22, 22), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Winged Lightning / Emerald Leaf
    d.polygon([(13, 1), (5, 11), (10, 11), (8, 21), (18, 9), (12, 9)], fill=C_GOLD_DARK)
    d.polygon([(12, 3), (7, 10), (11, 10), (9, 18), (16, 10), (12, 10)], fill=(35, 200, 70, 255))
    d.point([(12, 5), (11, 6)], fill=(210, 255, 200, 255))
    return im

def make_icon_bread():
    im = Image.new("RGBA", (22, 22), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    # Bread loaf
    d.ellipse([2, 5, 20, 18], fill=C_WOOD_DARK)
    d.ellipse([3, 6, 19, 17], fill=(225, 155, 55, 255))
    d.ellipse([5, 7, 17, 13], fill=(245, 205, 110, 255))
    # Crust cuts
    d.line([(7, 8), (9, 12)], fill=C_WOOD_DARK)
    d.line([(11, 8), (13, 12)], fill=C_WOOD_DARK)
    d.line([(15, 8), (17, 12)], fill=C_WOOD_DARK)
    return im

def make_icon_coin():
    im = Image.new("RGBA", (22, 22), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([1, 1, 20, 20], fill=C_GOLD_SHD)
    d.ellipse([2, 2, 19, 19], fill=C_GOLD_DARK)
    d.ellipse([3, 3, 18, 18], fill=C_GOLD_MID)
    d.ellipse([5, 5, 16, 16], fill=C_GOLD_HI)
    # Crown stamp
    d.polygon([(7, 14), (8, 9), (11, 11), (14, 9), (15, 14)], fill=C_GOLD_DARK)
    # Shine
    d.point([(5, 5), (6, 4)], fill=(255, 255, 220, 255))
    return im

# ================= 5. ITEM SLOTS & DIVIDERS =================

def make_slot_frame(size=44, selected=False):
    im = Image.new("RGBA", (size, size), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    rim_hi = C_GOLD_HI if selected else C_IRON_HI
    rim_mid = C_GOLD_MID if selected else C_IRON_MID
    rim_dark = C_GOLD_DARK if selected else C_IRON_DARK
    rim_shd = C_GOLD_SHD if selected else C_IRON_SHD

    d.rectangle([0, 0, size-1, size-1], fill=rim_shd)
    d.rectangle([1, 1, size-2, size-2], fill=rim_dark)
    d.rectangle([2, 2, size-3, size-3], fill=rim_mid)
    d.line([(2, 2), (size-3, 2)], fill=rim_hi)
    d.line([(2, 2), (2, size-3)], fill=rim_hi)
    # Sunken velvet well
    d.rectangle([3, 3, size-4, size-4], fill=(12, 10, 14, 255))
    d.rectangle([4, 4, size-5, size-5], fill=(22, 18, 20, 255))
    d.rectangle([5, 5, size-6, size-6], fill=(30, 25, 28, 255))
    return im

def make_divider_ornate(w=256, h=8):
    im = Image.new("RGBA", (w, h), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx = w // 2
    cy = h // 2
    # Filigree line tapering to edges
    for x in range(w):
        dist_from_c = abs(x - cx) / float(cx)
        alpha = int(255 * (1.0 - dist_from_c))
        if alpha > 0:
            d.point([(x, cy)], fill=(C_GOLD_MID[0], C_GOLD_MID[1], C_GOLD_MID[2], alpha))
            if dist_from_c < 0.6:
                d.point([(x, cy-1)], fill=(C_GOLD_HI[0], C_GOLD_HI[1], C_GOLD_HI[2], alpha))
                d.point([(x, cy+1)], fill=(C_GOLD_SHD[0], C_GOLD_SHD[1], C_GOLD_SHD[2], alpha))
    # Center diamond jewel
    d.polygon([(cx, 1), (cx-5, cy), (cx, h-2), (cx+5, cy)], fill=C_GOLD_DARK)
    d.polygon([(cx, 2), (cx-3, cy), (cx, h-3), (cx+3, cy)], fill=(220, 40, 50, 255)) # Ruby
    d.point([(cx, cy)], fill=(255, 200, 210, 255))
    return im

# Save all assets
print("Generating Medieval UI Master Asset Pack...")

make_panel_parchment().save(f"{UI_DIR}/panel_parchment.png")
make_panel_dark_stone().save(f"{UI_DIR}/panel_dark_stone.png")
make_panel_gold_frame().save(f"{UI_DIR}/panel_gold_frame.png")

make_button("normal").save(f"{UI_DIR}/btn_wood_normal.png")
make_button("hover").save(f"{UI_DIR}/btn_wood_hover.png")
make_button("pressed").save(f"{UI_DIR}/btn_wood_pressed.png")
make_button("disabled").save(f"{UI_DIR}/btn_wood_disabled.png")

make_bar_frame(160, 16).save(f"{UI_DIR}/bar_frame.png")
make_bar_fill(152, 8, "hp").save(f"{UI_DIR}/bar_hp_fill.png")
make_bar_fill(152, 8, "stamina").save(f"{UI_DIR}/bar_stamina_fill.png")
make_bar_fill(152, 8, "hunger").save(f"{UI_DIR}/bar_hunger_fill.png")

make_icon_heart().save(f"{UI_DIR}/icon_heart.png")
make_icon_stamina().save(f"{UI_DIR}/icon_stamina.png")
make_icon_bread().save(f"{UI_DIR}/icon_bread.png")
make_icon_coin().save(f"{UI_DIR}/icon_coin.png")

make_slot_frame(44, False).save(f"{UI_DIR}/slot_frame.png")
make_slot_frame(44, True).save(f"{UI_DIR}/slot_frame_selected.png")
make_divider_ornate(256, 8).save(f"{UI_DIR}/divider_ornate.png")

print("SUCCESS: All medieval UI assets created in godot/assets/ui/!")
