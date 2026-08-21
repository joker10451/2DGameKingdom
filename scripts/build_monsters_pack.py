"""
Enemies & Monsters Pixel-Art Master Generator
- animal_wolf.png & wolf.png (40x28)
- skeleton.png & skeleton_warrior.png (32x40)
- skeleton_archer.png (32x40)
- boss_malgrim.png (48x56)
- bandit.png (32x40)
Style: Diablo II / Graveyard Keeper / Stardew Valley / Sea of Stars
"""

import os
from PIL import Image, ImageDraw

WORLD_DIR = "godot/assets/sprites/world"
os.makedirs(WORLD_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (14, 10, 16, 120)

def make_wolf():
    # 40x28 Fierce Timber Wolf
    im = Image.new("RGBA", (40, 28), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    fur_hi   = (175, 178, 185, 255)
    fur_mid  = (125, 130, 140, 255)
    fur_dark = (80, 85, 95, 255)
    fur_deep = (45, 48, 55, 255)
    belly_c  = (215, 218, 225, 255)
    eye_c    = (255, 210, 45, 255) # glowing yellow eye
    mouth_c  = (185, 40, 50, 255)
    fang_c   = (255, 255, 255, 255)

    # Drop shadow
    d.ellipse([5, 20, 35, 26], fill=C_SHADOW)

    # Legs (4 muscular paws with claws)
    # Back legs (dark shadow)
    d.polygon([(7, 14), (5, 23), (8, 23), (10, 16)], fill=fur_deep)
    d.polygon([(26, 14), (25, 23), (28, 23), (29, 16)], fill=fur_deep)
    # Front legs
    d.polygon([(11, 14), (9, 23), (12, 23), (14, 16)], fill=fur_dark)
    d.polygon([(29, 14), (28, 23), (31, 23), (33, 16)], fill=fur_dark)
    for px in [7, 11, 27, 30]:
        d.point([(px, 23), (px+1, 23)], fill=(25, 25, 30, 255)) # claws

    # Muscular Body & Spine (Thick grey fur)
    d.ellipse([6, 8, 30, 19], fill=fur_dark)
    d.ellipse([7, 7, 29, 18], fill=fur_mid)
    # Dark spine ridge
    d.line([(8, 7), (28, 7)], fill=fur_deep, width=2)
    # Light belly & chest fur
    d.ellipse([12, 13, 25, 18], fill=belly_c)
    d.polygon([(24, 10), (30, 14), (26, 18)], fill=belly_c)

    # Fluffy Tail (Bushy, angled down-left)
    d.polygon([(8, 9), (1, 14), (0, 19), (3, 20), (7, 14)], fill=fur_dark)
    d.polygon([(6, 10), (2, 14), (1, 18), (3, 19), (6, 14)], fill=fur_mid)
    d.point([(0, 19), (1, 20)], fill=belly_c) # tail tip

    # Head, Snout & Ears (Right side)
    d.polygon([(26, 11), (32, 5), (37, 11), (32, 16)], fill=fur_dark)
    d.polygon([(27, 10), (32, 6), (36, 11), (31, 15)], fill=fur_mid)
    # Ears (Pointed, alert)
    d.polygon([(28, 7), (29, 1), (31, 5)], fill=fur_deep)
    d.polygon([(31, 6), (33, 1), (35, 5)], fill=fur_dark)
    d.polygon([(32, 3), (33, 2), (34, 4)], fill=(195, 145, 155, 255)) # inner ear

    # Snout & Open Snarl
    d.polygon([(34, 9), (39, 11), (35, 14)], fill=fur_mid)
    d.point([(39, 11)], fill=(20, 20, 25, 255)) # black nose
    # Snarl mouth & Fangs
    d.line([(35, 13), (38, 12)], fill=mouth_c)
    d.point([(36, 12), (37, 13)], fill=fang_c) # sharp fangs

    # Glowing Eye
    d.point([(33, 8)], fill=eye_c)
    d.point([(34, 8)], fill=(255, 255, 200, 255))

    return im

def make_skeleton_warrior():
    # 32x40 Undead Skeleton Warrior with Rusted Broadsword & Shield
    im = Image.new("RGBA", (32, 40), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    bone_hi   = (245, 242, 230, 255)
    bone_mid  = (210, 205, 190, 255)
    bone_shd  = (150, 145, 130, 255)
    bone_dark = (90, 85, 75, 255)
    rust_iron = (120, 95, 80, 255)
    iron_hi   = (175, 175, 185, 255)
    iron_dark = (65, 65, 75, 255)
    red_eye   = (255, 30, 40, 255)

    # Shadow
    d.ellipse([8, 34, 24, 39], fill=C_SHADOW)

    # 1. Legs (Bone Femur, Tibia, Feet)
    # Left leg
    d.line([(12, 24), (11, 30)], fill=bone_mid, width=2)
    d.line([(11, 30), (10, 36)], fill=bone_mid, width=2)
    d.line([(10, 36), (8, 37)], fill=bone_hi)
    # Right leg
    d.line([(18, 24), (19, 30)], fill=bone_shd, width=2)
    d.line([(19, 30), (20, 36)], fill=bone_shd, width=2)
    d.line([(20, 36), (22, 37)], fill=bone_mid)

    # 2. Pelvis & Spine
    d.polygon([(11, 22), (20, 22), (16, 25)], fill=bone_shd)
    d.line([(15, 16), (15, 22)], fill=bone_mid, width=2)

    # 3. Ribcage (Cage with dark hollows)
    d.rectangle([11, 14, 19, 21], fill=bone_dark)
    # Individual ribs
    for ry in [15, 17, 19, 21]:
        d.line([(11, ry), (19, ry)], fill=bone_hi)
        d.point([(15, ry)], fill=bone_mid)

    # 4. Cracked Skull & Iron Barbute Helmet
    d.rectangle([11, 6, 19, 13], fill=bone_mid)
    d.rectangle([12, 5, 18, 12], fill=bone_hi)
    # Eye sockets (Glowing crimson souls)
    d.point([(13, 8), (17, 8)], fill=(30, 10, 10, 255))
    d.point([(13, 8), (17, 8)], fill=red_eye)
    # Nasal cavity & Teeth
    d.point([(15, 10)], fill=bone_dark)
    for tx in [13, 15, 17]:
        d.point([(tx, 12)], fill=bone_hi)
        d.point([(tx+1, 12)], fill=bone_dark)
    # Rusted Iron Helmet Cap
    d.polygon([(10, 5), (15, 2), (20, 5)], fill=rust_iron)
    d.line([(10, 5), (20, 5)], fill=iron_hi)

    # 5. Left Arm: Round Wooden/Iron Shield
    d.ellipse([2, 14, 12, 24], fill=iron_dark)
    d.ellipse([3, 15, 11, 23], fill=(115, 75, 45, 255))
    d.ellipse([5, 17, 9, 21], fill=iron_hi) # center boss
    d.point([(7, 19)], fill=(235, 185, 50, 255))

    # 6. Right Arm & Rusted Broadsword
    # Arm bones
    d.line([(19, 14), (23, 18)], fill=bone_hi, width=2)
    d.line([(23, 18), (25, 22)], fill=bone_hi, width=2)
    # Sword (Blade pointed up)
    d.rectangle([24, 21, 26, 23], fill=rust_iron) # crossguard
    d.line([(25, 6), (25, 21)], fill=iron_hi, width=2) # blade
    d.line([(25, 6), (25, 21)], fill=rust_iron, width=1)
    d.point([(25, 5)], fill=(255, 255, 255, 255)) # tip
    d.point([(25, 24)], fill=(185, 145, 50, 255)) # pommel

    return im

def make_skeleton_archer():
    # 32x40 Undead Skeleton Archer with Bone Bow & Quiver
    im = Image.new("RGBA", (32, 40), C_TRANSPARENT)
    d = ImageDraw.Draw(im)

    bone_hi   = (245, 242, 230, 255)
    bone_mid  = (210, 205, 190, 255)
    bone_shd  = (150, 145, 130, 255)
    bone_dark = (90, 85, 75, 255)
    hood_c    = (60, 75, 65, 255) # ragged green hood
    hood_hi   = (85, 105, 90, 255)
    wood_c    = (145, 95, 45, 255)
    string_c  = (225, 225, 225, 255)
    red_eye   = (255, 45, 45, 255)

    # Shadow
    d.ellipse([8, 34, 24, 39], fill=C_SHADOW)

    # Legs
    d.line([(12, 24), (11, 30), (10, 36)], fill=bone_mid, width=2)
    d.line([(18, 24), (19, 30), (20, 36)], fill=bone_shd, width=2)
    d.point([(9, 36), (21, 36)], fill=bone_hi)

    # Spine & Ribs
    d.line([(15, 15), (15, 23)], fill=bone_mid, width=2)
    for ry in [16, 18, 20]:
        d.line([(12, ry), (18, ry)], fill=bone_hi)

    # Ragged Quiver with arrows on back
    d.rectangle([8, 14, 11, 23], fill=(95, 65, 40, 255))
    d.line([(8, 10), (8, 14)], fill=bone_hi)
    d.line([(10, 9), (10, 14)], fill=bone_hi)

    # Skull with Ragged Hunter Hood
    d.polygon([(9, 4), (15, 1), (21, 4), (20, 11), (10, 11)], fill=hood_c)
    d.polygon([(11, 3), (15, 2), (19, 3), (18, 10), (12, 10)], fill=hood_hi)
    # Face cavity
    d.rectangle([12, 6, 18, 12], fill=bone_dark)
    d.rectangle([13, 6, 17, 11], fill=bone_mid)
    d.point([(13, 8), (16, 8)], fill=red_eye)
    d.line([(13, 11), (17, 11)], fill=bone_hi) # teeth

    # Bone / Yew Bow in hands (Left side, aiming forward)
    # Curved Bow Arc
    d.line([(24, 6), (28, 12)], fill=wood_c, width=2)
    d.line([(28, 12), (28, 24)], fill=wood_c, width=2)
    d.line([(28, 24), (24, 30)], fill=wood_c, width=2)
    # Bowstring
    d.line([(24, 6), (24, 30)], fill=string_c)
    # Arrow nocked
    d.line([(15, 18), (30, 18)], fill=(185, 155, 110, 255), width=2)
    d.point([(30, 18), (31, 18)], fill=(225, 225, 230, 255)) # arrowhead
    d.point([(15, 18), (14, 18)], fill=bone_hi) # fletching

    return im

def make_boss_malgrim():
    # 48x56 Dread Necromancer Lord Boss Malgrim
    im = Image.new("RGBA", (48, 56), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx = 24

    robe_dark  = (22, 16, 32, 255)
    robe_mid   = (55, 32, 85, 255)
    robe_hi    = (95, 55, 140, 255)
    gold_c     = (235, 195, 55, 255)
    gold_hi    = (255, 240, 150, 255)
    skull_bone = (235, 230, 215, 255)
    void_fire  = (215, 60, 255, 255)
    void_hi    = (255, 200, 255, 255)

    # Shadow with necrotic aura
    d.ellipse([8, 48, 40, 55], fill=(30, 10, 45, 160))
    d.ellipse([10, 49, 38, 54], fill=C_SHADOW)

    # 1. Flowing Dark Violet Robe / Shroud (y: 20 to 52)
    d.polygon([(cx - 7, 20), (cx + 7, 20), (cx + 17, 52), (cx - 17, 52)], fill=robe_dark)
    d.polygon([(cx - 6, 21), (cx + 6, 21), (cx + 14, 50), (cx - 14, 50)], fill=robe_mid)
    # Robe folds & Gold runes on hem
    d.line([(cx, 22), (cx, 50)], fill=robe_hi, width=2)
    d.line([(cx - 8, 30), (cx - 11, 48)], fill=robe_hi)
    d.line([(cx + 8, 30), (cx + 11, 48)], fill=robe_hi)
    d.line([(cx - 16, 51), (cx + 16, 51)], fill=gold_c, width=2)

    # 2. Golden Neck Torc / Amulet of the Lich
    d.polygon([(cx - 6, 19), (cx + 6, 19), (cx, 25)], fill=gold_c)
    d.point([(cx, 22)], fill=void_fire)

    # 3. Horned Goat Skull Crown & Hood
    d.polygon([(cx - 9, 7), (cx + 9, 7), (cx + 8, 20), (cx - 8, 20)], fill=robe_dark)
    d.polygon([(cx - 8, 8), (cx + 8, 8), (cx + 7, 19), (cx - 7, 19)], fill=robe_mid)
    
    # White Skull Face
    d.rectangle([cx - 5, 9, cx + 5, 17], fill=skull_bone)
    # Burning Purple Eyes
    d.point([(cx - 3, 12), (cx + 3, 12)], fill=void_fire)
    d.point([(cx - 3, 11), (cx + 3, 11)], fill=void_hi)
    # Sharp Teeth
    d.line([(cx - 3, 16), (cx + 3, 16)], fill=(30, 20, 30, 255))
    d.point([(cx - 2, 15), (cx, 15), (cx + 2, 15)], fill=skull_bone)

    # Majestic Branching Obsidian Horns
    d.line([(cx - 6, 8), (cx - 14, 2), (cx - 16, -2)], fill=(35, 30, 45, 255), width=3)
    d.line([(cx - 6, 8), (cx - 14, 2), (cx - 16, -2)], fill=gold_c, width=1)
    d.line([(cx + 6, 8), (cx + 14, 2), (cx + 16, -2)], fill=(35, 30, 45, 255), width=3)
    d.line([(cx + 6, 8), (cx + 14, 2), (cx + 16, -2)], fill=gold_c, width=1)

    # 4. Dread Necromancer Staff (Left Hand)
    # Staff pole
    d.line([(cx + 14, 4), (cx + 14, 52)], fill=(65, 45, 30, 255), width=3)
    d.line([(cx + 14, 4), (cx + 14, 52)], fill=(125, 90, 60, 255), width=1)
    # Staff head: Gold Dragon Claw clutching Void Orb
    d.polygon([(cx + 10, 3), (cx + 14, -4), (cx + 18, 3)], fill=gold_c)
    d.ellipse([cx + 11, -2, cx + 17, 4], fill=void_fire)
    d.ellipse([cx + 12, -1, cx + 16, 3], fill=void_hi)
    # Floating spark particles around orb
    d.point([(cx + 10, -5), (cx + 18, -4), (cx + 14, -7), (cx + 20, 0)], fill=void_fire)

    # 5. Skeletal Hand clutching the staff
    d.rectangle([cx + 12, 24, cx + 16, 27], fill=skull_bone)

    return im

def make_bandit():
    # 32x40 Forest Brigand / Bandit
    im = Image.new("RGBA", (32, 40), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx = 16

    leather_hi  = (175, 115, 65, 255)
    leather_mid = (135, 80, 40, 255)
    leather_shd = (85, 45, 20, 255)
    hood_c      = (55, 60, 50, 255) # dark forest cloak
    hood_hi     = (80, 90, 75, 255)
    skin_c      = (225, 175, 140, 255)
    steel_c     = (210, 215, 225, 255)

    # Shadow
    d.ellipse([6, 34, 26, 39], fill=C_SHADOW)

    # Boots & Pants
    d.rectangle([10, 24, 14, 36], fill=(50, 45, 40, 255))
    d.rectangle([18, 24, 22, 36], fill=(45, 40, 35, 255))
    d.rectangle([9, 33, 14, 37], fill=(30, 25, 20, 255))
    d.rectangle([18, 33, 23, 37], fill=(30, 25, 20, 255))

    # Studded Leather Tunic
    d.rectangle([10, 13, 22, 24], fill=leather_shd)
    d.rectangle([11, 14, 21, 23], fill=leather_mid)
    # Studs
    for sy in [15, 18, 21]:
        d.point([(13, sy), (16, sy), (19, sy)], fill=(225, 195, 75, 255))
    # Belt with iron buckle
    d.line([(10, 23), (22, 23)], fill=(40, 30, 25, 255), width=2)
    d.point([(16, 23)], fill=(210, 215, 220, 255))

    # Hood & Bandit Mask
    d.polygon([(9, 4), (16, 1), (23, 4), (22, 13), (10, 13)], fill=hood_c)
    d.polygon([(11, 3), (16, 2), (21, 3), (20, 12), (12, 12)], fill=hood_hi)
    # Face slit
    d.rectangle([12, 6, 20, 9], fill=skin_c)
    d.point([(14, 7), (18, 7)], fill=(20, 20, 20, 255)) # eyes
    # Dark cloth mask over mouth
    d.rectangle([11, 9, 21, 13], fill=(35, 35, 40, 255))

    # Weapons: Dual Wicked Daggers
    # Left dagger
    d.line([(7, 16), (4, 23)], fill=steel_c, width=2)
    d.point([(3, 24)], fill=(255, 255, 255, 255))
    # Right dagger
    d.line([(25, 16), (28, 23)], fill=steel_c, width=2)
    d.point([(29, 24)], fill=(255, 255, 255, 255))

    return im

print("Generating Monsters Master Pixel-Art Pack...")

w_img = make_wolf()
w_img.save(f"{WORLD_DIR}/animal_wolf.png")
w_img.save(f"{WORLD_DIR}/wolf.png")

skel_img = make_skeleton_warrior()
skel_img.save(f"{WORLD_DIR}/skeleton.png")
skel_img.save(f"{WORLD_DIR}/skeleton_warrior.png")
skel_img.save(f"{WORLD_DIR}/skel.png")

skel_arch_img = make_skeleton_archer()
skel_arch_img.save(f"{WORLD_DIR}/skeleton_archer.png")
skel_arch_img.save(f"{WORLD_DIR}/skel_archer.png")

boss_img = make_boss_malgrim()
boss_img.save(f"{WORLD_DIR}/boss_malgrim.png")
boss_img.save(f"{WORLD_DIR}/boss.png")

bandit_img = make_bandit()
bandit_img.save(f"{WORLD_DIR}/bandit.png")
bandit_img.save(f"{WORLD_DIR}/bandit_leader.png")

print("SUCCESS: All monsters generated in godot/assets/sprites/world/!")
