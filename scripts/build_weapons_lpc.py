"""
Build CLEAN LPC composite sheets (without programmatic painted weapons):
- Pure, authentic LPC layers: Body + Head + Eyes + Hair + Chainmail + Pants + Boots.
- Generates clean idle, walk, slash, hurt sheets for Hero and Skeletons.
"""

import os
import shutil
from PIL import Image

LPC_RAW = "godot/assets/sprites/lpc_raw"
LPC_RAW_DIR = "godot/assets/lpc/raw"
OUT_DIR = "godot/assets/lpc/composite"
os.makedirs(OUT_DIR, exist_ok=True)

def extract_master_anim(im, state):
    if state == "walk":
        return im.crop((0, 512, 576, 768)) # 9 cols x 4 rows
    elif state == "idle":
        out = Image.new("RGBA", (128, 256), (0, 0, 0, 0))
        for r in range(4):
            f0 = im.crop((0, (8 + r) * 64, 64, (9 + r) * 64))
            out.paste(f0, (0, r * 64))
            out.paste(f0, (64, r * 64))
        return out
    elif state == "slash":
        return im.crop((0, 768, 384, 1024)) # 6 cols x 4 rows
    elif state == "hurt":
        return im.crop((0, 1280, 384, 1344)) # 6 cols x 1 row
    return None

# Clean Hero Composite
hero_layers = [
    "body_bodies_male_light.png",
    "head_heads_human_male_light.png",
    "eyes_human_adult_blue.png",
    "legs_pants_male_brown.png",
    "feet_boots_male_brown.png",
    "torso_chainmail_male_gray.png",
    "hair_plain_male_chestnut.png",
]

for state in ["idle", "walk", "slash", "hurt"]:
    comp = None
    for layer_name in hero_layers:
        lp = os.path.join(LPC_RAW, layer_name)
        if not os.path.exists(lp):
            continue
        l_img = Image.open(lp).convert("RGBA")
        anim = extract_master_anim(l_img, state)
        if anim:
            if comp is None:
                comp = Image.new("RGBA", anim.size, (0, 0, 0, 0))
            comp.alpha_composite(anim)
    if comp:
        comp.save(os.path.join(OUT_DIR, f"hero_{state}.png"))
        print(f"  Clean hero_{state}.png built")

# Copy clean hero_walk to player_walk_cycle.png
shutil.copyfile(os.path.join(OUT_DIR, "hero_walk.png"), "godot/assets/sprites/player_walk_cycle.png")
print("  Copied clean hero_walk.png -> godot/assets/sprites/player_walk_cycle.png")

# Also copy raw skeleton sheets directly (clean, artist-made skeletons)
for state in ["idle", "walk", "slash", "hurt"]:
    raw_p = os.path.join(LPC_RAW_DIR, f"skel_{state}.png")
    if os.path.exists(raw_p):
        shutil.copyfile(raw_p, os.path.join(OUT_DIR, f"skel_{state}.png"))
        shutil.copyfile(raw_p, os.path.join(OUT_DIR, f"skel_archer_{state}.png"))
        shutil.copyfile(raw_p, os.path.join(OUT_DIR, f"boss_{state}.png"))
        print(f"  Restored clean skel_{state}.png")

print("\nALL CLEAN SPRITES RESTORED!")
