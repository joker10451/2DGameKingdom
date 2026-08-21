"""
Master Sleek Predatory Timber Wolf (Top-Down RPG 48x48)
Style: Castlevania / Chrono Trigger / Graveyard Keeper / Terraria
- Sleek, slender, dangerous prowling posture
- Clean pixel clusters with dark steel & slate fur shading
- Lowered stalking head with alert ears and glowing predatory eye
- Low-slung bushy tail and slender paws
"""

import os
from PIL import Image, ImageDraw

WORLD_DIR = "godot/assets/sprites/world"
os.makedirs(WORLD_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (15, 12, 18, 110)

def make_sleek_predator_wolf():
    im = Image.new("RGBA", (48, 48), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    # 4-tone Steel Slate Wolf Palette
    OUTLINE  = (22, 24, 30, 255)
    DEEP_SHD = (42, 46, 58, 255)
    MID_FUR  = (72, 80, 98, 255)
    HI_FUR   = (125, 138, 162, 255)
    SPEC_FUR = (185, 198, 218, 255)
    CHEST_W  = (175, 182, 195, 255)
    
    EYE_GOLD = (255, 210, 35, 255)
    FANG_W   = (250, 250, 255, 255)
    NOSE_B   = (15, 15, 20, 255)

    # 1. Ground Drop Shadow (Lowered sleek silhouette, y: 35 to 43)
    d.ellipse([7, 36, 41, 44], fill=C_SHADOW)

    # 2. Back Paws & Legs (Tucked in stalking stride)
    # Rear-left leg (shadow)
    d.polygon([(11, 28), (8, 38), (11, 38), (14, 30)], fill=DEEP_SHD)
    # Front-left leg (shadow)
    d.polygon([(26, 27), (24, 38), (27, 38), (29, 29)], fill=DEEP_SHD)
    
    # Rear-right leg (foreground)
    d.polygon([(16, 29), (13, 40), (17, 40), (20, 31)], fill=MID_FUR)
    d.polygon([(17, 30), (14, 39), (17, 39), (19, 32)], fill=HI_FUR)
    d.line([(13, 40), (17, 40)], fill=OUTLINE)
    
    # Front-right leg (foreground)
    d.polygon([(30, 28), (28, 40), (32, 40), (34, 30)], fill=MID_FUR)
    d.polygon([(31, 29), (29, 39), (32, 39), (33, 31)], fill=HI_FUR)
    d.line([(28, 40), (32, 40)], fill=OUTLINE)

    # 3. Bushy Trailing Tail (Low-slung behind haunches, y: 22 to 34)
    d.polygon([(10, 24), (2, 27), (1, 33), (4, 35), (8, 32), (12, 27)], fill=OUTLINE)
    d.polygon([(9, 25), (3, 28), (2, 32), (5, 34), (8, 31), (11, 27)], fill=DEEP_SHD)
    d.polygon([(8, 26), (4, 29), (3, 32), (6, 33), (7, 30)], fill=MID_FUR)
    d.point([(2, 32), (3, 33)], fill=CHEST_W) # tail tip

    # 4. Sleek Prowling Torso & Flank (y: 19 to 32)
    d.ellipse([8, 19, 35, 33], fill=OUTLINE)
    d.ellipse([9, 20, 34, 32], fill=DEEP_SHD)
    d.ellipse([10, 20, 33, 30], fill=MID_FUR)
    
    # Dark spine ridge
    d.line([(11, 20), (31, 19)], fill=OUTLINE, width=2)
    # Muscle flank highlight
    d.ellipse([12, 21, 30, 27], fill=HI_FUR)
    d.line([(15, 22), (27, 21)], fill=SPEC_FUR)

    # Underbelly / Flank fur
    d.ellipse([16, 26, 27, 31], fill=CHEST_W)

    # 5. Muscular Shoulders & Mane Ruff (y: 16 to 28)
    d.polygon([(23, 16), (36, 17), (38, 27), (28, 29), (22, 23)], fill=OUTLINE)
    d.polygon([(24, 17), (35, 18), (37, 26), (29, 28), (23, 23)], fill=DEEP_SHD)
    d.polygon([(26, 18), (34, 19), (36, 25), (30, 26)], fill=MID_FUR)
    d.polygon([(28, 19), (34, 21), (35, 24), (31, 24)], fill=HI_FUR)
    d.point([(32, 21), (33, 22)], fill=SPEC_FUR)
    # White chest mane ruff
    d.polygon([(30, 24), (36, 24), (33, 28)], fill=CHEST_W)

    # 6. Lowered Hunting Head & Snout (Facing down-right, center (37, 21))
    d.polygon([(31, 15), (41, 16), (44, 22), (38, 26), (31, 22)], fill=OUTLINE)
    d.polygon([(32, 16), (40, 17), (43, 21), (37, 25), (32, 21)], fill=DEEP_SHD)
    d.polygon([(33, 17), (39, 18), (42, 21), (37, 24)], fill=MID_FUR)
    d.polygon([(34, 18), (39, 18), (41, 20), (36, 21)], fill=HI_FUR)

    # Ears (Pushed back alertly in hunting pose)
    # Left Ear (back)
    d.polygon([(31, 15), (30, 9), (34, 13)], fill=OUTLINE)
    d.polygon([(31, 14), (31, 10), (33, 13)], fill=DEEP_SHD)
    # Right Ear (foreground)
    d.polygon([(35, 16), (36, 9), (39, 14)], fill=OUTLINE)
    d.polygon([(36, 15), (37, 10), (38, 14)], fill=MID_FUR)
    d.point([(37, 12)], fill=(175, 135, 145, 255)) # inner ear

    # Muzzle & Jaws (Tapered sleek predator snout)
    d.polygon([(38, 20), (45, 22), (43, 26), (37, 24)], fill=OUTLINE)
    d.polygon([(39, 21), (44, 22), (42, 25), (38, 24)], fill=MID_FUR)
    d.polygon([(40, 21), (44, 22), (42, 23)], fill=HI_FUR)
    
    # Black nose
    d.polygon([(44, 21), (46, 22), (44, 23)], fill=NOSE_B)
    d.point([(45, 22)], fill=(120, 130, 145, 255))

    # Snarl & Fangs
    d.line([(40, 24), (43, 23)], fill=(160, 30, 40, 255))
    d.point([(42, 23)], fill=FANG_W) # upper fang

    # Glowing Golden Eye Slit
    d.polygon([(37, 19), (40, 19), (38, 21)], fill=OUTLINE)
    d.point([(38, 19), (39, 19)], fill=EYE_GOLD)
    d.point([(39, 19)], fill=(255, 255, 200, 255)) # gleaming glint

    return im

print("Generating Master Sleek Predator Wolf...")

w = make_sleek_predator_wolf()
w.save(f"{WORLD_DIR}/animal_wolf.png")
w.save(f"{WORLD_DIR}/wolf.png")

print("SUCCESS: Sleek Timber Wolf created in godot/assets/sprites/world/!")
