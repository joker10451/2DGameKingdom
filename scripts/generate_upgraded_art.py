import os
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# ==============================================================================
# 1. CRISP, VIBRANT CAMPFIRE & HEARTH (48x48)
# ==============================================================================
im_fire = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_fire = ImageDraw.Draw(im_fire)

# Dark Stone Hearth Ring (y: 28 to 44)
stones = [
    (8, 36, 6, 4), (14, 41, 7, 5), (24, 43, 8, 5), (34, 41, 7, 5), (40, 36, 6, 4),
    (38, 30, 6, 4), (24, 28, 7, 4), (10, 30, 6, 4)
]
for sx, sy, rx, ry in stones:
    d_fire.ellipse([sx - rx, sy - ry, sx + rx, sy + ry], fill=(60, 62, 68, 255), outline=(32, 34, 38, 255))
    d_fire.ellipse([sx - rx + 2, sy - ry + 1, sx + rx - 2, sy + ry - 2], fill=(95, 100, 108, 255))

# Dark Charcoal bed & Intense Hot Coals
d_fire.ellipse([14, 30, 34, 41], fill=(24, 14, 10, 255))
d_fire.ellipse([17, 32, 31, 39], fill=(210, 45, 10, 255))
d_fire.ellipse([20, 33, 28, 38], fill=(255, 150, 20, 255))

# Heavy Burning Firewood Logs (Crossed)
d_fire.polygon([(11, 39), (15, 42), (36, 29), (32, 26)], fill=(85, 45, 18, 255), outline=(42, 22, 8, 255))
d_fire.polygon([(37, 39), (33, 42), (12, 29), (16, 26)], fill=(95, 52, 22, 255), outline=(42, 22, 8, 255))
d_fire.ellipse([11, 39, 15, 42], fill=(140, 80, 35, 255))
d_fire.ellipse([33, 39, 37, 42], fill=(140, 80, 35, 255))

# Big, Vibrant, Multi-Tiered Flame
# Outer Deep Orange Fire
d_fire.polygon([(24, 4), (35, 18), (38, 28), (30, 36), (18, 36), (10, 28), (13, 18)], fill=(240, 80, 10, 245))
d_fire.polygon([(16, 12), (20, 22), (14, 30)], fill=(240, 80, 10, 245))
d_fire.polygon([(32, 12), (28, 22), (34, 30)], fill=(240, 80, 10, 245))

# Middle Golden Yellow Flame
d_fire.polygon([(24, 8), (32, 20), (33, 32), (15, 32), (16, 20)], fill=(255, 185, 20, 255))
d_fire.polygon([(21, 14), (27, 14), (29, 28), (19, 28)], fill=(255, 215, 40, 255))

# Inner White-Hot Flame Core
d_fire.polygon([(24, 14), (28, 24), (26, 32), (22, 32), (20, 24)], fill=(255, 255, 180, 255))
d_fire.ellipse([22, 22, 26, 30], fill=(255, 255, 240, 255))

im_fire.save(f"{OUT_DIR}/campfire.png")
im_fire.save(f"{OUT_DIR}/fireplace.png")
print("Saved upgraded campfire.png and fireplace.png")


# ==============================================================================
# 2. GRAND ALCHEMY LAB TABLE (48x48)
# ==============================================================================
im_alc = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_alc = ImageDraw.Draw(im_alc)

# Dark Mahogany Desk Legs
d_alc.rectangle([4, 26, 9, 45], fill=(55, 30, 15, 255), outline=(28, 14, 6, 255))
d_alc.rectangle([39, 26, 44, 45], fill=(55, 30, 15, 255), outline=(28, 14, 6, 255))
d_alc.rectangle([5, 41, 43, 44], fill=(42, 22, 10, 255)) # Lower crossbeam

# Upper Wooden Shelf (y: 6 to 12)
d_alc.rectangle([6, 10, 42, 14], fill=(85, 50, 25, 255), outline=(40, 22, 10, 255))
d_alc.rectangle([7, 11, 41, 12], fill=(120, 75, 40, 255))

# Mini Potion Vials on Top Shelf (Red, Green, Blue)
d_alc.rectangle([9, 4, 13, 10], fill=(230, 40, 40, 230), outline=(120, 20, 20, 255)) # Red health vial
d_alc.rectangle([10, 2, 12, 4], fill=(200, 200, 210, 255)) # Cork
d_alc.rectangle([16, 3, 20, 10], fill=(40, 220, 60, 230), outline=(20, 110, 30, 255)) # Green stamina vial
d_alc.rectangle([17, 1, 19, 3], fill=(200, 200, 210, 255))
d_alc.rectangle([23, 4, 27, 10], fill=(40, 120, 240, 230), outline=(20, 60, 130, 255)) # Blue mana vial
d_alc.rectangle([24, 2, 26, 4], fill=(200, 200, 210, 255))

# Main Table Surface (y: 22 to 32)
d_alc.rectangle([2, 22, 46, 32], fill=(95, 55, 28, 255), outline=(42, 24, 10, 255))
d_alc.rectangle([3, 23, 45, 25], fill=(145, 88, 48, 255)) # Tabletop highlight

# Brass Retort / Distillation Alembic (Center)
d_alc.ellipse([18, 14, 30, 25], fill=(225, 175, 45, 255), outline=(130, 95, 20, 255))
d_alc.ellipse([20, 16, 26, 21], fill=(255, 215, 80, 255)) # Brass sheen
d_alc.polygon([(23, 8), (25, 8), (27, 15), (21, 15)], fill=(235, 185, 55, 255)) # Neck
d_alc.polygon([(25, 8), (36, 16), (35, 18), (24, 10)], fill=(200, 150, 35, 255)) # Pipe into flask

# Glowing Glass Beaker with bubbling cyan potion (Right)
d_alc.ellipse([32, 17, 44, 28], fill=(30, 195, 240, 230), outline=(15, 100, 130, 255))
d_alc.ellipse([35, 20, 41, 25], fill=(160, 245, 255, 255)) # Glowing magic core
d_alc.rectangle([36, 12, 40, 17], fill=(180, 235, 255, 180), outline=(15, 100, 130, 255))

# Mortar & Pestle (Left)
d_alc.ellipse([5, 18, 15, 26], fill=(110, 112, 120, 255), outline=(60, 62, 68, 255))
d_alc.polygon([(9, 14), (11, 13), (16, 22), (14, 23)], fill=(150, 90, 45, 255))

# Open Magic Grimoire / Scroll (Center-Left)
d_alc.polygon([(14, 25), (23, 25), (25, 30), (12, 30)], fill=(240, 235, 205, 255), outline=(110, 80, 40, 255))
d_alc.line([(18, 25), (18, 30)], fill=(140, 100, 50, 255))

im_alc.save(f"{OUT_DIR}/alchemy_lab.png")
print("Saved upgraded alchemy_lab.png")


# ==============================================================================
# 3. DISTINCT SKELETON WARRIOR (48x48)
# ==============================================================================
im_skel = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_skel = ImageDraw.Draw(im_skel)

# Skull (y: 6 to 19)
d_skel.ellipse([17, 6, 31, 18], fill=(240, 238, 225, 255), outline=(130, 125, 110, 255))
d_skel.rectangle([20, 17, 28, 21], fill=(225, 222, 210, 255), outline=(130, 125, 110, 255)) # Teeth
d_skel.line([(22, 17), (22, 21)], fill=(120, 115, 100, 255))
d_skel.line([(24, 17), (24, 21)], fill=(120, 115, 100, 255))
d_skel.line([(26, 17), (26, 21)], fill=(120, 115, 100, 255))

# Fiery Red Evil Eyes
d_skel.ellipse([19, 10, 23, 14], fill=(255, 20, 20, 255))
d_skel.ellipse([25, 10, 29, 14], fill=(255, 20, 20, 255))
d_skel.point([(20, 11), (26, 11)], fill=(255, 255, 180, 255))

# Exposed White Ribcage & Spine
d_skel.line([(24, 21), (24, 35)], fill=(235, 232, 220, 255), width=3)
for ry in [23, 26, 29, 32]:
    d_skel.arc([16, ry - 2, 32, ry + 2], start=0, end=180, fill=(240, 238, 225, 255), width=2)

# Pelvis & Bone Legs
d_skel.polygon([(18, 34), (30, 34), (24, 38)], fill=(220, 215, 200, 255))
d_skel.line([(20, 38), (19, 46)], fill=(240, 238, 225, 255), width=3)
d_skel.line([(28, 38), (29, 46)], fill=(240, 238, 225, 255), width=3)
d_skel.line([(17, 46), (20, 46)], fill=(210, 205, 190, 255), width=2)
d_skel.line([(28, 46), (31, 46)], fill=(210, 205, 190, 255), width=2)

# Spiked Iron Round Shield (Left Arm)
d_skel.ellipse([6, 20, 18, 34], fill=(90, 92, 100, 255), outline=(45, 46, 50, 255))
d_skel.ellipse([8, 22, 16, 32], fill=(130, 134, 145, 255))
d_skel.ellipse([10, 25, 14, 29], fill=(220, 40, 40, 255)) # Red boss
d_skel.point([(12, 27)], fill=(255, 255, 255, 255)) # Spike

# Rusty Broadsword (Right Arm)
d_skel.polygon([(34, 8), (37, 6), (39, 36), (35, 36)], fill=(160, 165, 175, 255), outline=(95, 55, 35, 255))
d_skel.line([(31, 30), (41, 30)], fill=(130, 75, 35, 255), width=3) # Crossguard
d_skel.line([(36, 30), (36, 38)], fill=(90, 50, 20, 255), width=2) # Hilt

im_skel.save(f"{OUT_DIR}/skeleton.png")
print("Saved distinct skeleton.png")


# ==============================================================================
# 4. SKELETON ARCHER (48x48)
# ==============================================================================
im_arch = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_arch = ImageDraw.Draw(im_arch)

# Skull
d_arch.ellipse([17, 6, 31, 18], fill=(240, 238, 225, 255), outline=(130, 125, 110, 255))
d_arch.rectangle([20, 17, 28, 21], fill=(225, 222, 210, 255), outline=(130, 125, 110, 255))
d_arch.line([(22, 17), (22, 21)], fill=(120, 115, 100, 255))
d_arch.line([(24, 17), (24, 21)], fill=(120, 115, 100, 255))
d_arch.line([(26, 17), (26, 21)], fill=(120, 115, 100, 255))

# Glowing Toxic Green Eyes
d_arch.ellipse([19, 10, 23, 14], fill=(50, 255, 60, 255))
d_arch.ellipse([25, 10, 29, 14], fill=(50, 255, 60, 255))
d_arch.point([(20, 11), (26, 11)], fill=(220, 255, 200, 255))

# Ribs & Bones
d_arch.line([(24, 21), (24, 35)], fill=(235, 232, 220, 255), width=3)
for ry in [23, 26, 29, 32]:
    d_arch.arc([16, ry - 2, 32, ry + 2], start=0, end=180, fill=(240, 238, 225, 255), width=2)
d_arch.line([(20, 38), (19, 46)], fill=(240, 238, 225, 255), width=3)
d_arch.line([(28, 38), (29, 46)], fill=(240, 238, 225, 255), width=3)

# Longbow & Feathered Arrow
d_arch.arc([28, 6, 44, 42], start=270, end=90, fill=(130, 75, 30, 255), width=3)
d_arch.line([(36, 6), (36, 42)], fill=(235, 235, 245, 255), width=1) # String
d_arch.line([(18, 24), (38, 24)], fill=(175, 120, 55, 255), width=2) # Arrow shaft
d_arch.polygon([(38, 22), (42, 24), (38, 26)], fill=(180, 185, 195, 255)) # Arrowhead
d_arch.polygon([(17, 22), (14, 24), (17, 26)], fill=(230, 230, 80, 255)) # Fletching

im_arch.save(f"{OUT_DIR}/skeleton_archer.png")
print("Saved distinct skeleton_archer.png")


# ==============================================================================
# 5. BOSS: CURSED KNIGHT MALGRIM (48x48)
# ==============================================================================
im_boss = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_boss = ImageDraw.Draw(im_boss)

# Purple Spectral Aura
d_boss.ellipse([2, 2, 46, 46], fill=(130, 20, 220, 45))

# Tattered Crimson War Cloak
d_boss.polygon([(8, 14), (40, 14), (45, 46), (3, 46)], fill=(120, 15, 25, 240), outline=(60, 8, 12, 255))

# Obsidian Heavy Plate Armor
d_boss.rectangle([12, 16, 36, 36], fill=(32, 32, 42, 255), outline=(15, 15, 22, 255))
d_boss.rectangle([14, 18, 34, 34], fill=(50, 52, 65, 255))

# Massive Spiked Pauldrons
d_boss.ellipse([6, 14, 18, 26], fill=(40, 42, 54, 255), outline=(18, 18, 25, 255))
d_boss.polygon([(12, 14), (7, 6), (15, 11)], fill=(160, 25, 35, 255)) # Pauldron spike
d_boss.ellipse([30, 14, 42, 26], fill=(40, 42, 54, 255), outline=(18, 18, 25, 255))
d_boss.polygon([(36, 14), (41, 6), (33, 11)], fill=(160, 25, 35, 255))

# Great Horned Death Helm (y: 4 to 18)
d_boss.rectangle([16, 5, 32, 17], fill=(45, 45, 58, 255), outline=(20, 20, 28, 255))
d_boss.polygon([(16, 7), (9, 0), (18, 4)], fill=(170, 30, 40, 255)) # Horn left
d_boss.polygon([(32, 7), (39, 0), (30, 4)], fill=(170, 30, 40, 255)) # Horn right

# Glowing Demonic Purple Visor Slit
d_boss.rectangle([18, 9, 30, 13], fill=(220, 40, 255, 255))
d_boss.rectangle([21, 10, 27, 12], fill=(255, 220, 255, 255))

# Runic Executioner Greatsword
d_boss.polygon([(37, 0), (42, 0), (44, 42), (39, 42)], fill=(65, 70, 95, 255), outline=(25, 28, 40, 255))
d_boss.line([(37, 6), (42, 38)], fill=(210, 70, 255, 255), width=2) # Glowing purple rune
d_boss.line([(33, 34), (47, 34)], fill=(220, 175, 40, 255), width=3) # Gold Guard

im_boss.save(f"{OUT_DIR}/boss_malgrim.png")
print("Saved distinct boss_malgrim.png")
