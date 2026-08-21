"""
Fauna Master Pixel-Art Sprite Generator
Generates handcrafted, authentic pixel-art animals for FaunaVisualLayer:
- Chicken (Курица) (2-frame: Idle & Peck/Walk)
- Cow (Корова)
- Sheep (Овечка)
- Deer (Олень)
- Dog (Пес)
Style: Stardew Valley / Graveyard Keeper / Harvest Moon
"""

import os
from PIL import Image, ImageDraw

FAUNA_DIR = "godot/assets/sprites/world"
os.makedirs(FAUNA_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (15, 12, 18, 110)

def make_chicken_frames():
    # 2-frame spritesheet (48x24 -> two 24x24 frames: Frame 0 = Stand/Walk, Frame 1 = Pecking/Step)
    im = Image.new("RGBA", (48, 24), C_TRANSPARENT)
    
    # Palette
    feather_hi   = (255, 255, 250, 255)
    feather_mid  = (238, 230, 218, 255)
    feather_shd  = (195, 182, 165, 255)
    feather_dark = (145, 130, 115, 255)
    
    comb_hi   = (245, 60, 60, 255)
    comb_dark = (180, 25, 25, 255)
    
    beak_c = (255, 185, 30, 255)
    beak_d = (205, 135, 15, 255)
    leg_c  = (245, 155, 25, 255)
    eye_c  = (20, 15, 15, 255)
    
    # --- Frame 0: Standing / Walking ---
    d0 = ImageDraw.Draw(im)
    ox = 0
    # Shadow
    d0.ellipse([ox + 4, 19, ox + 18, 23], fill=C_SHADOW)
    # Legs
    d0.line([(ox + 9, 16), (ox + 9, 21)], fill=leg_c)
    d0.line([(ox + 13, 16), (ox + 13, 21)], fill=leg_c)
    d0.point([(ox + 10, 21), (ox + 14, 21)], fill=leg_c)
    # Body (Plump round chicken)
    d0.ellipse([ox + 5, 8, ox + 18, 18], fill=feather_shd)
    d0.ellipse([ox + 6, 9, ox + 17, 17], fill=feather_mid)
    d0.ellipse([ox + 7, 9, ox + 15, 15], fill=feather_hi)
    # Tail feathers (Left)
    d0.polygon([(ox + 5, 11), (ox + 2, 7), (ox + 3, 13)], fill=feather_shd)
    d0.polygon([(ox + 4, 9), (ox + 1, 5), (ox + 3, 11)], fill=feather_hi)
    # Wing
    d0.ellipse([ox + 8, 12, ox + 14, 16], fill=feather_shd)
    d0.line([(ox + 9, 14), (ox + 13, 14)], fill=feather_mid)
    # Head & Neck (Right)
    d0.ellipse([ox + 12, 4, ox + 19, 12], fill=feather_mid)
    d0.ellipse([ox + 13, 5, ox + 18, 11], fill=feather_hi)
    # Eye
    d0.point([(ox + 16, 7)], fill=eye_c)
    d0.point([(ox + 16, 6)], fill=(255, 255, 255, 255)) # gleam
    # Beak
    d0.polygon([(ox + 18, 7), (ox + 22, 9), (ox + 18, 10)], fill=beak_c)
    d0.line([(ox + 18, 10), (ox + 20, 10)], fill=beak_d)
    # Comb (Top) & Wattle (Bottom)
    d0.polygon([(ox + 14, 4), (ox + 15, 1), (ox + 17, 2), (ox + 18, 5)], fill=comb_hi)
    d0.point([(ox + 16, 1)], fill=comb_dark)
    d0.polygon([(ox + 17, 10), (ox + 19, 12), (ox + 17, 12)], fill=comb_hi)

    # --- Frame 1: Pecking Ground / Stepping ---
    ox = 24
    d1 = ImageDraw.Draw(im)
    # Shadow
    d1.ellipse([ox + 4, 19, ox + 18, 23], fill=C_SHADOW)
    # Stepping legs
    d1.line([(ox + 8, 16), (ox + 7, 21)], fill=leg_c)
    d1.line([(ox + 13, 16), (ox + 14, 20)], fill=leg_c)
    d1.point([(ox + 8, 21), (ox + 15, 20)], fill=leg_c)
    # Body tilted slightly forward
    d1.ellipse([ox + 4, 9, ox + 17, 18], fill=feather_shd)
    d1.ellipse([ox + 5, 10, ox + 16, 17], fill=feather_mid)
    d1.ellipse([ox + 6, 10, ox + 14, 15], fill=feather_hi)
    # Raised Tail feathers
    d1.polygon([(ox + 4, 10), (ox + 1, 4), (ox + 3, 12)], fill=feather_shd)
    d1.polygon([(ox + 3, 8), (ox + 0, 3), (ox + 2, 10)], fill=feather_hi)
    # Wing
    d1.ellipse([ox + 7, 12, ox + 13, 16], fill=feather_shd)
    # Lowered Head (Pecking ground)
    d1.ellipse([ox + 13, 8, ox + 19, 15], fill=feather_mid)
    d1.ellipse([ox + 14, 9, ox + 18, 14], fill=feather_hi)
    # Eye
    d1.point([(ox + 17, 10)], fill=eye_c)
    # Beak touching ground
    d1.polygon([(ox + 18, 12), (ox + 22, 16), (ox + 17, 14)], fill=beak_c)
    # Comb
    d1.polygon([(ox + 14, 8), (ox + 15, 5), (ox + 17, 7)], fill=comb_hi)
    d1.polygon([(ox + 17, 13), (ox + 19, 15), (ox + 17, 15)], fill=comb_hi)

    return im

def make_cow():
    im = Image.new("RGBA", (36, 28), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    
    white_hi  = (245, 245, 240, 255)
    white_mid = (215, 215, 210, 255)
    white_shd = (165, 165, 160, 255)
    black_c   = (35, 32, 38, 255)
    pink_c    = (245, 185, 195, 255)
    pink_d    = (210, 140, 155, 255)
    horn_c    = (235, 215, 165, 255)
    hoof_c    = (50, 45, 45, 255)

    # Shadow
    d.ellipse([4, 21, 32, 27], fill=C_SHADOW)
    # Legs (4 legs)
    for lx in [6, 11, 23, 28]:
        d.rectangle([lx, 15, lx+2, 23], fill=white_shd)
        d.rectangle([lx, 22, lx+2, 24], fill=hoof_c)
    # Back legs shadow
    d.rectangle([6, 15, 8, 22], fill=black_c)
    d.rectangle([23, 15, 25, 22], fill=white_shd)

    # Body
    d.rectangle([4, 7, 28, 18], fill=white_shd)
    d.rectangle([5, 6, 27, 17], fill=white_mid)
    d.rectangle([6, 6, 26, 15], fill=white_hi)
    # Black Holstein Spots
    d.ellipse([7, 7, 14, 15], fill=black_c)
    d.ellipse([18, 9, 26, 16], fill=black_c)
    d.polygon([(9, 6), (16, 6), (13, 11)], fill=black_c)
    # Tail
    d.line([(4, 9), (2, 17)], fill=white_shd)
    d.point([(2, 17), (2, 18), (1, 18)], fill=black_c) # tuft

    # Head (Right)
    d.rectangle([25, 4, 34, 15], fill=white_mid)
    d.rectangle([26, 5, 33, 14], fill=white_hi)
    d.ellipse([27, 4, 32, 9], fill=black_c) # head patch
    # Horns
    d.point([(26, 3), (25, 2), (31, 3), (32, 2)], fill=horn_c)
    # Ears
    d.polygon([(24, 6), (22, 8), (25, 8)], fill=pink_d)
    d.polygon([(33, 6), (35, 8), (32, 8)], fill=pink_d)
    # Eye
    d.point([(30, 7)], fill=(20, 20, 20, 255))
    d.point([(30, 6)], fill=(255, 255, 255, 255))
    # Muzzle (Pink snout)
    d.rectangle([30, 10, 35, 15], fill=pink_c)
    d.point([(32, 12), (34, 12)], fill=pink_d) # nostrils
    return im

def make_sheep():
    im = Image.new("RGBA", (30, 24), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    
    wool_hi  = (255, 255, 250, 255)
    wool_mid = (235, 230, 220, 255)
    wool_shd = (185, 178, 165, 255)
    face_c   = (45, 40, 42, 255)
    face_hi  = (75, 68, 70, 255)

    # Shadow
    d.ellipse([3, 18, 27, 23], fill=C_SHADOW)
    # Legs (Little black trotters)
    for lx in [6, 10, 18, 22]:
        d.line([(lx, 15), (lx, 20)], fill=face_c)
        d.point([(lx, 20)], fill=(20, 20, 20, 255))
    # Fluffy Wool Body (Cloud bumps)
    d.ellipse([3, 5, 25, 17], fill=wool_shd)
    d.ellipse([4, 4, 24, 16], fill=wool_mid)
    d.ellipse([5, 4, 23, 14], fill=wool_hi)
    # Puffy texture curls
    for bx, by in [(7, 6), (12, 5), (17, 6), (10, 11), (15, 10), (20, 11)]:
        d.point([(bx, by)], fill=wool_hi)
        d.point([(bx+1, by+1)], fill=wool_shd)

    # Head (Right, Black face with white cap)
    d.ellipse([20, 6, 28, 14], fill=face_c)
    d.point([(24, 8), (25, 8)], fill=face_hi)
    # White wool puff on top of head
    d.ellipse([21, 4, 26, 7], fill=wool_hi)
    # Ears
    d.point([(19, 8), (18, 9)], fill=face_c)
    # Eye
    d.point([(25, 9)], fill=(240, 240, 240, 255))
    d.point([(26, 9)], fill=(20, 20, 20, 255))
    return im

def make_deer():
    im = Image.new("RGBA", (32, 32), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    fur_hi  = (205, 145, 85, 255)
    fur_mid = (165, 105, 55, 255)
    fur_shd = (115, 68, 30, 255)
    white_c = (245, 240, 230, 255)
    antler  = (220, 200, 160, 255)

    # Shadow
    d.ellipse([4, 26, 28, 31], fill=C_SHADOW)
    # Slender legs
    for lx in [7, 10, 20, 23]:
        d.line([(lx, 19), (lx, 28)], fill=fur_shd)
        d.point([(lx, 28)], fill=(30, 25, 20, 255))
    # Body
    d.ellipse([4, 12, 24, 21], fill=fur_shd)
    d.ellipse([5, 11, 23, 20], fill=fur_mid)
    d.ellipse([6, 11, 21, 18], fill=fur_hi)
    # White belly & spots
    d.ellipse([10, 17, 18, 20], fill=white_c)
    d.point([(10, 13), (14, 12), (18, 14)], fill=white_c)
    # Little tail
    d.polygon([(4, 13), (1, 11), (3, 15)], fill=white_c)

    # Slender Neck & Head (Right)
    d.polygon([(18, 14), (24, 7), (27, 9), (21, 16)], fill=fur_mid)
    d.ellipse([22, 6, 29, 12], fill=fur_hi)
    # Muzzle
    d.polygon([(27, 9), (31, 10), (27, 12)], fill=(40, 30, 25, 255))
    # Eye
    d.point([(26, 8)], fill=(20, 15, 15, 255))
    d.point([(26, 7)], fill=(255, 255, 255, 255))
    # Branching Antlers
    d.line([(24, 6), (22, 1)], fill=antler)
    d.line([(22, 3), (20, 2)], fill=antler)
    d.line([(23, 2), (24, 0)], fill=antler)
    d.line([(26, 6), (28, 1)], fill=antler)
    d.line([(27, 3), (29, 2)], fill=antler)
    return im

def make_dog():
    im = Image.new("RGBA", (28, 22), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    fur_hi  = (225, 165, 80, 255)
    fur_mid = (185, 125, 50, 255)
    fur_shd = (130, 80, 28, 255)
    white_c = (245, 240, 235, 255)
    collar  = (215, 45, 45, 255)

    # Shadow
    d.ellipse([3, 16, 25, 21], fill=C_SHADOW)
    # Legs
    for lx in [6, 9, 17, 20]:
        d.line([(lx, 12), (lx, 18)], fill=fur_shd)
        d.point([(lx, 18), (lx+1, 18)], fill=white_c)
    # Body
    d.ellipse([4, 6, 21, 15], fill=fur_shd)
    d.ellipse([5, 5, 20, 14], fill=fur_mid)
    d.ellipse([6, 5, 18, 12], fill=fur_hi)
    d.ellipse([10, 10, 16, 14], fill=white_c) # white chest
    # Wagging Tail (Curved up)
    d.line([(4, 8), (1, 4)], fill=fur_mid, width=2)
    d.point([(1, 3)], fill=white_c)

    # Head (Right)
    d.ellipse([17, 3, 26, 11], fill=fur_mid)
    d.ellipse([18, 4, 25, 10], fill=fur_hi)
    # Red collar with gold tag
    d.line([(18, 9), (20, 11)], fill=collar, width=2)
    d.point([(19, 11)], fill=(255, 215, 50, 255))
    # Floppy ear
    d.polygon([(18, 4), (16, 8), (19, 8)], fill=fur_shd)
    # Eye
    d.point([(23, 5)], fill=(20, 15, 15, 255))
    # Snout & Nose
    d.rectangle([24, 6, 27, 9], fill=fur_hi)
    d.point([(27, 6)], fill=(30, 20, 20, 255)) # wet nose
    return im

print("Generating Fauna Master Sprite Pack...")

make_chicken_frames().save(f"{FAUNA_DIR}/animal_chicken.png")
make_cow().save(f"{FAUNA_DIR}/animal_cow.png")
make_sheep().save(f"{FAUNA_DIR}/animal_sheep.png")
make_deer().save(f"{FAUNA_DIR}/animal_deer.png")
make_dog().save(f"{FAUNA_DIR}/animal_dog.png")

print("SUCCESS: All fauna sprites generated in godot/assets/sprites/world/!")
