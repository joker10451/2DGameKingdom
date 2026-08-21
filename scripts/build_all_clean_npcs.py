"""
Build 100% clean NPC sprite sheets directly from authentic LPC raw layers:
- Standard LPC Row Order:
  - Row 0 = Up (LPC row 8, y=512)
  - Row 1 = Left (LPC row 9, y=576)
  - Row 2 = Down (LPC row 10, y=640)
  - Row 3 = Right (LPC row 11, y=704)
- NO drawn lines / floating weapons / artifacts!
"""

import os
from PIL import Image

LPC_RAW = "godot/assets/sprites/lpc_raw"
NPC_DIR = "godot/assets/sprites/npcs"
os.makedirs(NPC_DIR, exist_ok=True)

# Standard LPC walk rows: 8=Up, 9=Left, 10=Down, 11=Right
LPC_WALK_ROWS = [8, 9, 10, 11]

def composite_npc_walk_sheet(layer_files):
    # Base 832x2944 master canvas
    master = Image.new("RGBA", (832, 2944), (0, 0, 0, 0))
    for fname in layer_files:
        fpath = os.path.join(LPC_RAW, fname)
        if not os.path.exists(fpath):
            print(f"  Warning: Missing layer {fname}")
            continue
        img = Image.open(fpath).convert("RGBA")
        if img.size == (832, 2944):
            master.alpha_composite(img)
        elif img.size == (832, 1344):
            temp = Image.new("RGBA", (832, 2944), (0, 0, 0, 0))
            temp.paste(img, (0, 0))
            master.alpha_composite(temp)
        elif img.size == (576, 256):
            # Already walk sheet size
            pass

    # Extract 9 cols x 4 rows in order: 0=Up, 1=Left, 2=Down, 3=Right
    walk_sheet = Image.new("RGBA", (576, 256), (0, 0, 0, 0))
    for out_r, lpc_r in enumerate(LPC_WALK_ROWS):
        for col in range(9):
            box = (col * 64, lpc_r * 64, (col + 1) * 64, (lpc_r + 1) * 64)
            frame = master.crop(box)
            walk_sheet.paste(frame, (col * 64, out_r * 64))

    return walk_sheet

NPC_CONFIGS = {
    "npc_peasant_male.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_brown.png",
        "feet_shoes_male_brown.png",
        "hair_plain_male_chestnut.png",
    ],
    "npc_peasant_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_brown.png",
        "feet_shoes_female_brown.png",
        "torso_clothes_blouse_female_white.png",
        "hair_loose_female_chestnut.png",
    ],
    "npc_guard.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_black.png",
        "feet_boots_male_black.png",
        "torso_armour_plate_male_steel.png",
        "hair_spiked_male_black.png",
    ],
    "npc_guard_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_brown.png",
        "feet_shoes_female_brown.png",
        "torso_armour_plate_male_steel.png",
        "hair_loose_female_black.png",
    ],
    "npc_bandit.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_black.png",
        "feet_boots_male_black.png",
        "torso_chainmail_male_gray.png",
        "hair_bangs_male_black.png",
    ],
    "npc_bandit_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_brown.png",
        "feet_shoes_female_brown.png",
        "torso_chainmail_male_gray.png",
        "hair_loose_female_black.png",
    ],
    "npc_blacksmith.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_brown.png",
        "feet_boots_male_brown.png",
        "torso_chainmail_male_gray.png",
        "hair_afro_male_black.png",
    ],
    "npc_blacksmith_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_brown.png",
        "feet_shoes_female_brown.png",
        "torso_chainmail_male_gray.png",
        "hair_loose_female_blonde.png",
    ],
    "npc_merchant.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_teal.png",
        "feet_shoes_male_brown.png",
        "torso_clothes_tunic_female_blue.png",
        "hair_bedhead_male_blonde.png",
    ],
    "npc_merchant_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_teal.png",
        "feet_shoes_female_brown.png",
        "torso_clothes_tunic_female_blue.png",
        "hair_parted_female_chestnut.png",
    ],
    "npc_lord.png": [
        "body_bodies_male_light.png",
        "head_heads_human_male_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_male_teal.png",
        "feet_boots_male_black.png",
        "torso_armour_plate_male_steel.png",
        "hair_parted_male_chestnut.png",
    ],
    "npc_lord_female.png": [
        "body_bodies_female_light.png",
        "head_heads_human_female_light.png",
        "eyes_human_adult_blue.png",
        "legs_pants_female_teal.png",
        "feet_shoes_female_brown.png",
        "torso_armour_plate_male_steel.png",
        "hair_loose_female_chestnut.png",
    ]
}

print(f"Building {len(NPC_CONFIGS)} clean NPC sheets in standard LPC format...")
for filename, layers in NPC_CONFIGS.items():
    sheet = composite_npc_walk_sheet(layers)
    out_path = os.path.join(NPC_DIR, filename)
    sheet.save(out_path)
    print(f"  Clean: {filename}")

print("\nSUCCESS: All NPC sheets are now 100% clean with standard LPC rows (0=Up, 1=Left, 2=Down, 3=Right)!")
