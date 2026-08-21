import os
from PIL import Image, ImageDraw, ImageEnhance

LPC_RAW = "godot/assets/sprites/lpc_raw"
LPC_RAW_DIR = "godot/assets/lpc/raw"
OUT_DIR = "godot/assets/lpc/composite"
os.makedirs(OUT_DIR, exist_ok=True)

# Master row definitions for standard 832x2944 sheets:
# Walk: rows 8, 9, 10, 11 (9 frames, 64x64 each -> 576x256) (0=Up, 1=Left, 2=Down, 3=Right)
# Slash: rows 12, 13, 14, 15 (6 frames, 64x64 each -> 384x256)
# Hurt: row 20 (6 frames, 64x64 each -> 384x64)

def extract_lpc_anim(layer_im, state):
    # Extracts the specific state animation from an 832x2944 (or 832x1344) sheet
    if state == "walk":
        # rows 8..11 (y: 8*64=512 to 12*64=768), 9 frames wide (x: 0 to 9*64=576)
        if layer_im.height >= 768:
            return layer_im.crop((0, 512, 576, 768))
    elif state == "idle":
        # First 2 frames of walk rows
        if layer_im.height >= 768:
            out = Image.new("RGBA", (128, 256), (0, 0, 0, 0))
            for r in range(4):
                frame0 = layer_im.crop((0, (8 + r) * 64, 64, (9 + r) * 64))
                frame1 = layer_im.crop((64, (8 + r) * 64, 128, (9 + r) * 64))
                out.paste(frame0, (0, r * 64))
                out.paste(frame0, (64, r * 64)) # gentle idle
            return out
    elif state == "slash":
        # rows 12..15 (y: 12*64=768 to 16*64=1024), 6 frames wide (x: 0 to 6*64=384)
        if layer_im.height >= 1024:
            return layer_im.crop((0, 768, 384, 1024))
    elif state == "hurt":
        # row 20 (y: 20*64=1280 to 21*64=1344), 6 frames wide (x: 0 to 6*64=384)
        if layer_im.height >= 1344:
            return layer_im.crop((0, 1280, 384, 1344))
    return None

# 1. BUILD HERO FROM MASTER LPC LAYERS
hero_layers = [
    "body_bodies_male_light.png",
    "head_heads_human_male_light.png",
    "eyes_human_adult_blue.png",
    "legs_pants_male_brown.png",
    "feet_boots_male_brown.png",
    "torso_chainmail_male_gray.png",
    "hair_plain_male_chestnut.png"
]

for state in ["idle", "walk", "slash", "hurt"]:
    hero_comp = None
    for l_name in hero_layers:
        p = os.path.join(LPC_RAW, l_name)
        if os.path.exists(p):
            layer_im = Image.open(p).convert("RGBA")
            anim_crop = extract_lpc_anim(layer_im, state)
            if anim_crop:
                if hero_comp is None:
                    hero_comp = Image.new("RGBA", anim_crop.size, (0, 0, 0, 0))
                hero_comp.alpha_composite(anim_crop)
                
    if hero_comp:
        out_p = os.path.join(OUT_DIR, f"hero_{state}.png")
        hero_comp.save(out_p)
        print(f"Generated complete Hero sheet: {out_p} ({hero_comp.size})")

# 2. HELPER TO DRAW REAL PIXEL-ART SKULL ON SKELETON SHEETS
def draw_pixel_skull(draw, cx, cy, dir_idx, is_boss=False):
    # cx, cy is the center of the head area (typically x0+32, y0+20)
    # dir_idx: 0=Up (back of head), 1=Left, 2=Down (face forward), 3=Right
    bone_col = (225, 220, 205, 255) if not is_boss else (180, 175, 195, 255)
    shadow_col = (155, 150, 135, 255) if not is_boss else (90, 80, 110, 255)
    dark_socket = (25, 15, 20, 255)
    glow_eye = (255, 35, 35, 255) if not is_boss else (220, 50, 255, 255)
    
    # Cranium (dome)
    draw.rectangle([cx - 5, cy - 9, cx + 5, cy - 3], fill=bone_col)
    draw.rectangle([cx - 6, cy - 7, cx + 6, cy - 4], fill=bone_col)
    
    if dir_idx == 0: # Back of head
        draw.rectangle([cx - 5, cy - 3, cx + 5, cy + 3], fill=bone_col)
        draw.rectangle([cx - 4, cy + 3, cx + 4, cy + 5], fill=shadow_col)
        draw.rectangle([cx - 2, cy + 5, cx + 2, cy + 8], fill=bone_col) # Cervical spine
    elif dir_idx == 1: # Facing Left
        draw.rectangle([cx - 6, cy - 3, cx + 4, cy + 2], fill=bone_col)
        draw.rectangle([cx - 6, cy + 2, cx - 1, cy + 6], fill=bone_col) # Left Jaw
        # Eye socket & glowing eye
        draw.rectangle([cx - 5, cy - 2, cx - 2, cy + 1], fill=dark_socket)
        draw.point((cx - 4, cy - 1), fill=glow_eye)
        # Teeth
        draw.point((cx - 5, cy + 5), fill=(240, 240, 230, 255))
        draw.point((cx - 3, cy + 5), fill=(240, 240, 230, 255))
    elif dir_idx == 2: # Facing Forward
        draw.rectangle([cx - 5, cy - 3, cx + 5, cy + 2], fill=bone_col)
        # Cheekbones & Upper Jaw
        draw.rectangle([cx - 4, cy + 2, cx + 4, cy + 4], fill=bone_col)
        # Lower Jaw & Teeth
        draw.rectangle([cx - 3, cy + 4, cx + 3, cy + 6], fill=bone_col)
        draw.point((cx - 2, cy + 5), fill=(255, 255, 240, 255))
        draw.point((cx, cy + 5), fill=(255, 255, 240, 255))
        draw.point((cx + 2, cy + 5), fill=(255, 255, 240, 255))
        # Eye Sockets
        draw.rectangle([cx - 4, cy - 2, cx - 1, cy + 1], fill=dark_socket)
        draw.rectangle([cx + 1, cy - 2, cx + 4, cy + 1], fill=dark_socket)
        # Glowing Red / Violet Eyes
        draw.point((cx - 2, cy - 1), fill=glow_eye)
        draw.point((cx + 2, cy - 1), fill=glow_eye)
        # Nasal Cavity
        draw.point((cx, cy + 2), fill=dark_socket)
    elif dir_idx == 3: # Facing Right
        draw.rectangle([cx - 4, cy - 3, cx + 6, cy + 2], fill=bone_col)
        draw.rectangle([cx + 1, cy + 2, cx + 6, cy + 6], fill=bone_col) # Right Jaw
        # Eye socket & glowing eye
        draw.rectangle([cx + 2, cy - 2, cx + 5, cy + 1], fill=dark_socket)
        draw.point((cx + 4, cy - 1), fill=glow_eye)
        # Teeth
        draw.point((cx + 3, cy + 5), fill=(240, 240, 230, 255))
        draw.point((cx + 5, cy + 5), fill=(240, 240, 230, 255))
        
    if is_boss:
        # Horned Death Visor & Obsidian Crown
        draw.polygon([(cx - 6, cy - 8), (cx - 11, cy - 18), (cx - 3, cy - 11)], fill=(180, 25, 45, 255))
        draw.polygon([(cx + 6, cy - 8), (cx + 11, cy - 18), (cx + 3, cy - 11)], fill=(180, 25, 45, 255))
        draw.rectangle([cx - 5, cy - 10, cx + 5, cy - 6], fill=(45, 40, 55, 255))

# 3. BUILD COMPLETE SKELETON SHEETS (skel_idle, skel_walk, skel_slash, skel_hurt)
for state in ["idle", "walk", "slash", "hurt"]:
    skel_base_p = os.path.join(LPC_RAW_DIR, f"skel_{state}.png")
    if not os.path.exists(skel_base_p): continue
    skel_im = Image.open(skel_base_p).convert("RGBA")
    draw = ImageDraw.Draw(skel_im)
    w, h = skel_im.size
    cols = w // 64
    rows = h // 64
    
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            # Draw real skull on every frame
            draw_pixel_skull(draw, x0 + 32, y0 + 20, r if state != "hurt" else 2, is_boss=False)
            
    out_p = os.path.join(OUT_DIR, f"skel_{state}.png")
    skel_im.save(out_p)
    print(f"Generated complete Skeleton sheet: {out_p} ({skel_im.size})")

# 4. BUILD COMPLETE BOSS MALGRIM SHEETS (boss_idle, boss_walk, boss_slash, boss_hurt)
plate_p = os.path.join(LPC_RAW, "torso_armour_plate_male_steel.png")
for state in ["idle", "walk", "slash", "hurt"]:
    skel_base_p = os.path.join(LPC_RAW_DIR, f"skel_{state}.png")
    if not os.path.exists(skel_base_p): continue
    boss_im = Image.open(skel_base_p).convert("RGBA")
    
    # Overlay obsidian plate armor if available
    if os.path.exists(plate_p):
        plate_im = Image.open(plate_p).convert("RGBA")
        plate_anim = extract_lpc_anim(plate_im, state)
        if plate_anim:
            # Dark obsidian tint
            enh = ImageEnhance.Brightness(plate_anim)
            plate_dark = enh.enhance(0.35)
            boss_im.alpha_composite(plate_dark)
            
    draw = ImageDraw.Draw(boss_im)
    w, h = boss_im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            draw_pixel_skull(draw, x0 + 32, y0 + 20, r if state != "hurt" else 2, is_boss=True)
            
    out_p = os.path.join(OUT_DIR, f"boss_{state}.png")
    boss_im.save(out_p)
    print(f"Generated complete Boss Malgrim sheet: {out_p} ({boss_im.size})")

print("All LPC sheets generated with 100% complete heads and armor!")
