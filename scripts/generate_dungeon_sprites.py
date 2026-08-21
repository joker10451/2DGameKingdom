import os
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# -------------------------------------------------------------
# 1. SKELETON WARRIOR (48x48)
# -------------------------------------------------------------
im_skel = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_skel = ImageDraw.Draw(im_skel)

# Skull (y: 8 to 20)
d_skel.ellipse([18, 8, 30, 20], fill=(230, 228, 215, 255), outline=(140, 135, 120, 255))
d_skel.rectangle([21, 18, 27, 22], fill=(210, 208, 195, 255), outline=(140, 135, 120, 255)) # Jaw & teeth
d_skel.ellipse([20, 12, 23, 15], fill=(255, 30, 30, 255)) # Glowing red eye left
d_skel.ellipse([25, 12, 28, 15], fill=(255, 30, 30, 255)) # Glowing red eye right
d_skel.point([(21, 13), (26, 13)], fill=(255, 255, 200, 255))

# Spine and Ribcage (y: 22 to 34)
d_skel.line([(24, 22), (24, 36)], fill=(220, 218, 200, 255), width=2)
for ry in [24, 27, 30, 33]:
    d_skel.ellipse([17, ry - 1, 31, ry + 2], outline=(200, 195, 180, 255))

# Pelvis and Leg bones
d_skel.polygon([(19, 36), (29, 36), (24, 40)], fill=(210, 205, 190, 255))
d_skel.line([(20, 40), (19, 46)], fill=(220, 215, 200, 255), width=2)
d_skel.line([(28, 40), (29, 46)], fill=(220, 215, 200, 255), width=2)

# Rusty Iron Sword in right hand
d_skel.polygon([(32, 14), (34, 12), (36, 38), (34, 38)], fill=(150, 155, 165, 255), outline=(90, 50, 30, 255))
d_skel.line([(30, 32), (38, 32)], fill=(120, 70, 30, 255), width=2) # Crossguard

# Wooden round shield in left hand
d_skel.ellipse([10, 22, 20, 34], fill=(130, 80, 40, 255), outline=(70, 40, 20, 255))
d_skel.ellipse([13, 26, 17, 30], fill=(180, 180, 190, 255)) # Iron boss

im_skel.save(f"{OUT_DIR}/skeleton.png")
print("Saved skeleton.png")


# -------------------------------------------------------------
# 2. SKELETON ARCHER (48x48)
# -------------------------------------------------------------
im_arch = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_arch = ImageDraw.Draw(im_arch)

# Skull
d_arch.ellipse([18, 8, 30, 20], fill=(230, 228, 215, 255), outline=(140, 135, 120, 255))
d_arch.rectangle([21, 18, 27, 22], fill=(210, 208, 195, 255), outline=(140, 135, 120, 255))
d_arch.ellipse([20, 12, 23, 15], fill=(80, 240, 80, 255)) # Glowing green eyes
d_arch.ellipse([25, 12, 28, 15], fill=(80, 240, 80, 255))

# Bones
d_arch.line([(24, 22), (24, 36)], fill=(220, 218, 200, 255), width=2)
for ry in [24, 27, 30, 33]:
    d_arch.ellipse([17, ry - 1, 31, ry + 2], outline=(200, 195, 180, 255))
d_arch.line([(20, 40), (19, 46)], fill=(220, 215, 200, 255), width=2)
d_arch.line([(28, 40), (29, 46)], fill=(220, 215, 200, 255), width=2)

# Wooden shortbow
d_arch.arc([30, 12, 42, 38], start=270, end=90, fill=(120, 70, 30, 255), width=3)
d_arch.line([(36, 12), (36, 38)], fill=(220, 220, 230, 255), width=1) # Bowstring
d_arch.line([(22, 25), (38, 25)], fill=(160, 110, 50, 255), width=2) # Arrow nocked

im_arch.save(f"{OUT_DIR}/skeleton_archer.png")
print("Saved skeleton_archer.png")


# -------------------------------------------------------------
# 3. BOSS: CURSED KNIGHT MALGRIM (48x48)
# -------------------------------------------------------------
im_boss = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_boss = ImageDraw.Draw(im_boss)

# Dark Obsidian Plate Armor & Cloak
d_boss.polygon([(10, 16), (38, 16), (42, 44), (6, 44)], fill=(140, 20, 30, 230)) # Crimson tattered cape

# Heavy plate chest & shoulders
d_boss.rectangle([14, 18, 34, 36], fill=(45, 45, 55, 255), outline=(20, 20, 28, 255))
d_boss.ellipse([10, 16, 20, 26], fill=(65, 65, 75, 255), outline=(25, 25, 32, 255)) # Left pauldrons
d_boss.ellipse([28, 16, 38, 26], fill=(65, 65, 75, 255), outline=(25, 25, 32, 255)) # Right pauldrons

# Horned Great Helm
d_boss.rectangle([17, 6, 31, 18], fill=(55, 55, 68, 255), outline=(25, 25, 35, 255))
d_boss.polygon([(17, 8), (12, 2), (18, 5)], fill=(160, 30, 40, 255)) # Left Horn
d_boss.polygon([(31, 8), (36, 2), (30, 5)], fill=(160, 30, 40, 255)) # Right Horn
# Glowing purple demonic visor slit
d_boss.rectangle([19, 11, 29, 13], fill=(210, 60, 255, 255))
d_boss.rectangle([21, 12, 27, 13], fill=(255, 220, 255, 255))

# Cursed Runic Greatsword
d_boss.polygon([(38, 4), (42, 2), (44, 40), (40, 40)], fill=(75, 80, 110, 255), outline=(30, 35, 50, 255))
d_boss.line([(38, 10), (42, 36)], fill=(180, 60, 255, 255), width=1) # Purple magic rune blade
d_boss.line([(34, 32), (46, 32)], fill=(210, 170, 40, 255), width=2) # Gold Crossguard

im_boss.save(f"{OUT_DIR}/boss_malgrim.png")
print("Saved boss_malgrim.png")


# -------------------------------------------------------------
# 4. ANCIENT SARCOPHAGUS (48x48)
# -------------------------------------------------------------
im_sarc = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_sarc = ImageDraw.Draw(im_sarc)

# Stone base slab
d_sarc.rectangle([8, 12, 40, 38], fill=(95, 98, 105, 255), outline=(50, 52, 58, 255))
d_sarc.rectangle([10, 14, 38, 36], fill=(130, 135, 145, 255))

# Carved Knight Effigy / Relic Cross
d_sarc.line([(24, 16), (24, 34)], fill=(70, 72, 78, 255), width=3)
d_sarc.line([(16, 22), (32, 22)], fill=(70, 72, 78, 255), width=3)
# Gold leaf ornaments
d_sarc.ellipse([21, 16, 27, 22], fill=(220, 180, 45, 255), outline=(130, 100, 20, 255))
d_sarc.rectangle([12, 14, 14, 16], fill=(220, 180, 45, 255))
d_sarc.rectangle([34, 14, 36, 16], fill=(220, 180, 45, 255))
d_sarc.rectangle([12, 34, 14, 36], fill=(220, 180, 45, 255))
d_sarc.rectangle([34, 34, 36, 36], fill=(220, 180, 45, 255))

im_sarc.save(f"{OUT_DIR}/sarcophagus.png")
print("Saved sarcophagus.png")


# -------------------------------------------------------------
# 5. LADDER TO SURFACE (48x48)
# -------------------------------------------------------------
im_lad = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
d_lad = ImageDraw.Draw(im_lad)

# Deep pit hole
d_lad.ellipse([6, 6, 42, 42], fill=(25, 25, 30, 255), outline=(80, 85, 95, 255))
d_lad.ellipse([10, 10, 38, 38], fill=(15, 15, 18, 255))

# Wooden ladder leading up
d_lad.line([(18, 8), (18, 40)], fill=(120, 70, 30, 255), width=2)
d_lad.line([(30, 8), (30, 40)], fill=(120, 70, 30, 255), width=2)
for rung_y in [12, 18, 24, 30, 36]:
    d_lad.line([(18, rung_y), (30, rung_y)], fill=(160, 100, 45, 255), width=2)

# Sunbeam light effect
d_lad.ellipse([20, 18, 28, 26], fill=(255, 255, 180, 80))

im_lad.save(f"{OUT_DIR}/ladder_up.png")
im_lad.save(f"{OUT_DIR}/cave_entrance.png")
print("Saved ladder_up.png and cave_entrance.png")
