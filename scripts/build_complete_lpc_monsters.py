"""
Master LPC Skull & Monster Composite Generator
Generates full LPC composite spritesheets with complete, authentic 16-bit skulls and equipment for:
- skel (Skeleton Warrior)
- skel_archer (Skeleton Archer)
- boss (Boss Malgrim - Grand Lich)
"""

import os
from PIL import Image, ImageDraw, ImageEnhance

LPC_DIR = "godot/assets/lpc/raw"
OUT_DIR = "godot/assets/lpc/composite"
os.makedirs(OUT_DIR, exist_ok=True)

# 16-bit Master Bone Palette
BONE_HI   = (242, 238, 222, 255)
BONE_MID  = (205, 198, 180, 255)
BONE_SHD  = (145, 138, 122, 255)
BONE_DARK = (85, 78, 68, 255)
DARK_HOLE = (18, 12, 16, 255)
RED_EYE   = (255, 35, 45, 255)
RED_GLOW  = (255, 160, 160, 255)
PURP_EYE  = (225, 60, 255, 255)
PURP_GLOW = (255, 200, 255, 255)

HOOD_DARK = (45, 55, 45, 255)
HOOD_MID  = (70, 85, 70, 255)
HOOD_HI   = (100, 120, 100, 255)

def draw_skull_on_frame(d, x0, y0, r, state="idle", kind="skel"):
    # Center of head area: cx = x0 + 32, cy = y0 + 19
    cx = x0 + 32
    cy = y0 + 19

    eye_col = PURP_EYE if kind == "boss" else RED_EYE
    gleam_col = PURP_GLOW if kind == "boss" else RED_GLOW

    # 1. ARCHER HOOD (if archer)
    if kind == "archer":
        # Draw hood behind head
        d.polygon([(cx - 8, cy - 10), (cx, cy - 14), (cx + 8, cy - 10), (cx + 9, cy + 5), (cx - 9, cy + 5)], fill=HOOD_DARK)
        d.polygon([(cx - 7, cy - 9), (cx, cy - 13), (cx + 7, cy - 9), (cx + 8, cy + 3), (cx - 8, cy + 3)], fill=HOOD_MID)

    # 2. CRANIUM (Dome of the Skull, y: cy-9 to cy+2)
    # Cranium shadow/base
    d.polygon([(cx - 6, cy - 8), (cx + 6, cy - 8), (cx + 7, cy - 2), (cx + 6, cy + 3), (cx - 6, cy + 3), (cx - 7, cy - 2)], fill=BONE_DARK)
    d.polygon([(cx - 5, cy - 8), (cx + 5, cy - 8), (cx + 6, cy - 2), (cx + 5, cy + 2), (cx - 5, cy + 2), (cx - 6, cy - 2)], fill=BONE_MID)
    # Top highlight
    d.line([(cx - 4, cy - 8), (cx + 4, cy - 8)], fill=BONE_HI)
    d.line([(cx - 4, cy - 7), (cx + 4, cy - 7)], fill=BONE_HI)

    if r == 0: # BACK (Facing UP)
        # Back of skull: parietal and occipital bones + upper cervical spine
        d.rectangle([cx - 5, cy - 1, cx + 5, cy + 4], fill=BONE_MID)
        d.rectangle([cx - 4, cy + 4, cx + 4, cy + 6], fill=BONE_SHD)
        # Spine vertebrae connecting to neck
        d.line([(cx - 1, cy + 6), (cx - 1, cy + 12)], fill=BONE_HI)
        d.line([(cx + 1, cy + 6), (cx + 1, cy + 12)], fill=BONE_MID)

    elif r == 1: # LEFT PROFILE
        # Cranium profile
        d.rectangle([cx - 7, cy - 4, cx + 4, cy + 2], fill=BONE_MID)
        # Left cheekbone & maxilla
        d.rectangle([cx - 7, cy + 2, cx - 1, cy + 5], fill=BONE_MID)
        # Jaw & Teeth
        d.rectangle([cx - 6, cy + 5, cx - 2, cy + 8], fill=BONE_SHD)
        d.point([(cx - 6, cy + 6), (cx - 4, cy + 6)], fill=BONE_HI) # teeth
        # Left Eye Socket
        d.rectangle([cx - 6, cy - 2, cx - 3, cy + 1], fill=DARK_HOLE)
        d.point([(cx - 5, cy - 1)], fill=eye_col)
        d.point([(cx - 4, cy - 1)], fill=gleam_col)
        # Temporal hollow
        d.point([(cx + 1, cy - 1)], fill=BONE_SHD)

    elif r == 2: # FRONT (Facing Camera)
        # Full skull front face
        # Maxilla & Cheekbones
        d.rectangle([cx - 5, cy + 2, cx + 5, cy + 4], fill=BONE_MID)
        d.point([(cx - 5, cy + 2), (cx + 5, cy + 2)], fill=BONE_HI) # zygomatic arches
        
        # Upper & Lower Jaws + Teeth
        d.rectangle([cx - 4, cy + 5, cx + 4, cy + 8], fill=BONE_SHD)
        # Teeth rows (4 distinct white teeth)
        for tx in [-3, -1, 1, 3]:
            d.point([(cx + tx, cy + 6)], fill=BONE_HI)
            d.point([(cx + tx, cy + 7)], fill=BONE_MID)
        d.line([(cx - 3, cy + 8), (cx + 3, cy + 8)], fill=BONE_DARK) # chin outline

        # Large Dark Eye Sockets
        d.rectangle([cx - 5, cy - 2, cx - 2, cy + 1], fill=DARK_HOLE)
        d.rectangle([cx + 2, cy - 2, cx + 5, cy + 1], fill=DARK_HOLE)
        
        # Glowing Fiery Eye Souls
        d.point([(cx - 4, cy - 1), (cx + 3, cy - 1)], fill=eye_col)
        d.point([(cx - 3, cy - 1), (cx + 4, cy - 1)], fill=gleam_col)

        # Inverted Heart Nasal Cavity
        d.point([(cx, cy + 2)], fill=DARK_HOLE)
        d.point([(cx - 1, cy + 3), (cx + 1, cy + 3)], fill=DARK_HOLE)

    elif r == 3: # RIGHT PROFILE
        # Cranium profile
        d.rectangle([cx - 4, cy - 4, cx + 7, cy + 2], fill=BONE_MID)
        # Right cheekbone & maxilla
        d.rectangle([cx + 1, cy + 2, cx + 7, cy + 5], fill=BONE_MID)
        # Jaw & Teeth
        d.rectangle([cx + 2, cy + 5, cx + 6, cy + 8], fill=BONE_SHD)
        d.point([(cx + 4, cy + 6), (cx + 6, cy + 6)], fill=BONE_HI) # teeth
        # Right Eye Socket
        d.rectangle([cx + 3, cy - 2, cx + 6, cy + 1], fill=DARK_HOLE)
        d.point([(cx + 4, cy - 1)], fill=eye_col)
        d.point([(cx + 5, cy - 1)], fill=gleam_col)
        # Temporal hollow
        d.point([(cx - 1, cy - 1)], fill=BONE_SHD)

    # 3. BOSS CROWN & HORNS (if boss)
    if kind == "boss":
        # Horns
        d.line([(cx - 5, cy - 8), (cx - 12, cy - 16), (cx - 14, cy - 19)], fill=(45, 35, 55, 255), width=2)
        d.line([(cx - 5, cy - 8), (cx - 12, cy - 16), (cx - 14, cy - 19)], fill=(225, 185, 55, 255), width=1)
        d.line([(cx + 5, cy - 8), (cx + 12, cy - 16), (cx + 14, cy - 19)], fill=(45, 35, 55, 255), width=2)
        d.line([(cx + 5, cy - 8), (cx + 12, cy - 16), (cx + 14, cy - 19)], fill=(225, 185, 55, 255), width=1)
        # Obsidian Crown Band
        d.rectangle([cx - 6, cy - 10, cx + 6, cy - 7], fill=(30, 20, 40, 255))
        d.point([(cx, cy - 9)], fill=(255, 215, 60, 255)) # central gem

print("Building Master LPC Monster Spritesheets with real skulls...")

# 1. SKELETON WARRIOR
for state in ["idle", "walk", "slash", "hurt"]:
    p = os.path.join(LPC_DIR, f"skel_{state}.png")
    if not os.path.exists(p): continue
    im = Image.open(p).convert("RGBA")
    d = ImageDraw.Draw(im)
    w, h = im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            draw_skull_on_frame(d, x0, y0, r if state != "hurt" else 2, state, "skel")
    im.save(os.path.join(OUT_DIR, f"skel_{state}.png"))
    print(f"Generated skel_{state}.png")

# 2. SKELETON ARCHER
for state in ["idle", "walk", "slash", "hurt"]:
    p = os.path.join(LPC_DIR, f"skel_{state}.png")
    if not os.path.exists(p): continue
    im = Image.open(p).convert("RGBA")
    d = ImageDraw.Draw(im)
    w, h = im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            draw_skull_on_frame(d, x0, y0, r if state != "hurt" else 2, state, "archer")
    im.save(os.path.join(OUT_DIR, f"skel_archer_{state}.png"))
    print(f"Generated skel_archer_{state}.png")

# 3. BOSS MALGRIM
for state in ["idle", "walk", "slash", "hurt"]:
    p = os.path.join(LPC_DIR, f"skel_{state}.png")
    armor_p = os.path.join(LPC_DIR, f"torso_chainmail_male_{state}.png")
    if not os.path.exists(p): continue
    im = Image.open(p).convert("RGBA")
    if os.path.exists(armor_p):
        armor_im = Image.open(armor_p).convert("RGBA")
        enhancer = ImageEnhance.Brightness(armor_im)
        armor_dark = enhancer.enhance(0.35)
        im.alpha_composite(armor_dark)
    d = ImageDraw.Draw(im)
    w, h = im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            draw_skull_on_frame(d, x0, y0, r if state != "hurt" else 2, state, "boss")
    im.save(os.path.join(OUT_DIR, f"boss_{state}.png"))
    print(f"Generated boss_{state}.png")

print("SUCCESS: Master Monster sheets generated!")
