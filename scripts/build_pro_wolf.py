"""
Professional 3/4 Top-Down RPG Wolf Generator (48x48)
Matches the LPC / Stardew / Diablo 3/4 isometric perspective and palette.
Features:
- 3/4 top-down angled posture (head facing down-right)
- Rich multi-tone timber wolf fur (highlights, midtones, dark spine, soft belly)
- Thick neck ruff / mane
- Snarling muzzle with black nose, white fangs, and piercing golden eyes
- Natural anatomy with shoulder blades, muscular hindquarters, and bushy tail
"""

import os
from PIL import Image, ImageDraw

WORLD_DIR = "godot/assets/sprites/world"
os.makedirs(WORLD_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (16, 12, 20, 110)

def make_pro_wolf():
    # 48x48 Top-Down 3/4 RPG Wolf
    im = Image.new("RGBA", (48, 48), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    # 16-bit Timber Wolf Palette
    fur_spec  = (230, 235, 240, 255) # Silver highlight
    fur_hi    = (190, 195, 205, 255)
    fur_mid   = (140, 145, 155, 255)
    fur_shd   = (90, 95, 105, 255)
    fur_dark  = (55, 60, 70, 255)
    fur_deep  = (32, 35, 42, 255)   # Charcoal spine
    belly_c   = (215, 218, 225, 255)
    
    eye_gold  = (255, 215, 40, 255)
    eye_gleam = (255, 255, 210, 255)
    mouth_red = (185, 35, 45, 255)
    fang_w    = (250, 250, 250, 255)
    nose_blk  = (20, 20, 24, 255)

    # 1. Soft Ground Drop Shadow (3/4 perspective oval)
    d.ellipse([8, 32, 40, 43], fill=C_SHADOW)

    # 2. Paws & Legs (Positioned naturally on ground)
    # Back-left leg (shadow)
    d.polygon([(14, 26), (11, 38), (14, 38), (17, 28)], fill=fur_dark)
    # Front-left leg (shadow)
    d.polygon([(27, 26), (25, 38), (28, 38), (30, 28)], fill=fur_dark)
    # Back-right leg (foreground)
    d.polygon([(18, 28), (16, 40), (20, 40), (23, 29)], fill=fur_mid)
    d.polygon([(19, 29), (17, 39), (20, 39), (22, 30)], fill=fur_hi)
    # Front-right leg (foreground)
    d.polygon([(32, 28), (30, 40), (34, 40), (36, 29)], fill=fur_mid)
    d.polygon([(33, 29), (31, 39), (34, 39), (35, 30)], fill=fur_hi)
    
    # Dark claws on all 4 paws
    for px, py in [(12, 38), (26, 38), (17, 40), (31, 40)]:
        d.point([(px, py), (px+1, py)], fill=nose_blk)

    # 3. Bushy Tail (Sweeping down and left behind hindquarters)
    d.polygon([(12, 19), (4, 23), (2, 30), (5, 34), (9, 31), (13, 23)], fill=fur_dark)
    d.polygon([(11, 20), (5, 24), (3, 29), (6, 33), (8, 30), (12, 23)], fill=fur_mid)
    d.polygon([(9, 23), (5, 27), (5, 30), (7, 31)], fill=fur_hi)
    d.point([(3, 30), (4, 31), (5, 32)], fill=belly_c) # white tail tip

    # 4. Muscular Torso & Flank (3/4 Angled Body, y: 14 to 32)
    # Dark base silhouette
    d.ellipse([10, 15, 36, 32], fill=fur_dark)
    d.ellipse([11, 14, 35, 31], fill=fur_mid)
    
    # Dark Charcoal Spine & Ridge Fur
    d.polygon([(12, 15), (28, 14), (30, 18), (14, 20)], fill=fur_deep)
    d.line([(13, 16), (28, 15)], fill=(20, 22, 28, 255), width=2)
    
    # Silver & Grey Rib Highlights
    d.ellipse([13, 16, 32, 28], fill=fur_hi)
    for fx, fy in [(16, 20), (20, 19), (24, 21), (28, 20)]:
        d.point([(fx, fy), (fx+1, fy)], fill=fur_spec)

    # Soft White/Cream Belly & Flank Fur
    d.ellipse([18, 24, 30, 31], fill=belly_c)
    d.polygon([(20, 23), (28, 23), (27, 29), (19, 29)], fill=belly_c)

    # 5. Thick Neck Ruff & Mane (Fluffy tufts around shoulders, y: 12 to 26)
    d.polygon([(24, 12), (38, 15), (41, 25), (32, 27), (25, 23)], fill=fur_dark)
    d.polygon([(25, 13), (37, 16), (40, 24), (33, 26), (26, 22)], fill=fur_mid)
    # Mane spikes & fluff
    d.polygon([(28, 14), (36, 18), (38, 24), (31, 24)], fill=fur_hi)
    d.polygon([(32, 19), (38, 23), (34, 26)], fill=fur_spec)
    # White throat patch
    d.polygon([(31, 22), (37, 23), (35, 27)], fill=belly_c)

    # 6. Head & Snarling Snout (3/4 Angled down-right, center (36, 17))
    d.ellipse([30, 9, 44, 23], fill=fur_dark)
    d.ellipse([31, 10, 43, 22], fill=fur_mid)
    d.polygon([(32, 11), (39, 11), (41, 16), (34, 17)], fill=fur_hi)

    # Pointed Alert Ears (Ears cocked slightly forward in 3/4)
    # Left Ear (behind)
    d.polygon([(31, 10), (31, 3), (35, 7)], fill=fur_deep)
    d.polygon([(32, 9), (32, 4), (34, 7)], fill=fur_dark)
    # Right Ear (foreground)
    d.polygon([(36, 11), (38, 3), (42, 8)], fill=fur_dark)
    d.polygon([(37, 10), (38, 4), (41, 8)], fill=fur_mid)
    d.polygon([(38, 7), (39, 5), (40, 8)], fill=(185, 140, 150, 255)) # pinkish inner ear

    # Muzzle & Snarl (Pointing down-right)
    d.polygon([(36, 15), (45, 18), (43, 24), (36, 21)], fill=fur_mid)
    d.polygon([(37, 16), (44, 19), (42, 23), (37, 20)], fill=fur_hi)
    
    # Black Wet Nose
    d.polygon([(43, 17), (46, 19), (44, 20)], fill=nose_blk)
    d.point([(44, 18)], fill=(100, 105, 120, 255)) # nose highlight

    # Open Snarling Mouth & White Fangs
    d.polygon([(40, 21), (44, 21), (42, 24), (39, 23)], fill=mouth_red)
    # Upper fangs
    d.point([(41, 21), (43, 21)], fill=fang_w)
    # Lower fangs
    d.point([(42, 23)], fill=fang_w)
    # Snarl nose wrinkle
    d.line([(40, 16), (42, 17)], fill=fur_deep)

    # Glowing Amber Eye with White Gleam
    d.polygon([(37, 14), (41, 14), (39, 16)], fill=(30, 25, 20, 255))
    d.point([(38, 14), (39, 14)], fill=eye_gold)
    d.point([(39, 14)], fill=eye_gleam)

    return im

print("Generating 3/4 Pro Timber Wolf...")

wolf_im = make_pro_wolf()
wolf_im.save(f"{WORLD_DIR}/animal_wolf.png")
wolf_im.save(f"{WORLD_DIR}/wolf.png")

print("SUCCESS: Pro 3/4 Timber Wolf saved in godot/assets/sprites/world/!")
