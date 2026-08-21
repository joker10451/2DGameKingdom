"""
Overworld Fantasy Cartography & Landmark Generator
Generates:
- 6 Biome Tiles (36x36): ow_water, ow_mountain, ow_forest, ow_grass, ow_swamp, ow_road
- 8 Landmark Icons: loc_capital, loc_village, loc_mine, loc_farms, loc_fort, loc_crypt, loc_swamp, loc_island
- Player Army Token: token_player (32x32)
Style: Heroes of Might and Magic III / Tolkien Map / Total War / Octopath Traveler
"""

import os
from PIL import Image, ImageDraw

OW_DIR = "godot/assets/sprites/overworld"
os.makedirs(OW_DIR, exist_ok=True)

C_TRANSPARENT = (0, 0, 0, 0)
C_SHADOW = (16, 14, 18, 130)

def make_tile_water():
    im = Image.new("RGBA", (36, 36), (35, 85, 145, 255))
    d = ImageDraw.Draw(im)
    # Deep water shading & wave ripples
    for y in range(36):
        for x in range(36):
            if (x + y * 2) % 9 == 0:
                d.point([(x, y)], fill=(50, 115, 180, 255))
            elif (x + y) % 13 == 0:
                d.point([(x, y)], fill=(25, 65, 115, 255))
    # Wave foam lines
    for wy in [8, 20, 30]:
        d.line([(4, wy), (12, wy)], fill=(90, 160, 225, 255))
        d.line([(18, wy + 4), (28, wy + 4)], fill=(90, 160, 225, 255))
        d.point([(3, wy), (13, wy), (17, wy + 4), (29, wy + 4)], fill=(160, 215, 255, 255))
    return im

def make_tile_grass():
    im = Image.new("RGBA", (36, 36), (115, 165, 75, 255))
    d = ImageDraw.Draw(im)
    # Parchment rolling grassland
    for y in range(36):
        for x in range(36):
            if (x * 3 + y * 5) % 11 == 0:
                d.point([(x, y)], fill=(135, 185, 85, 255))
            elif (x * 7 + y * 11) % 17 == 0:
                d.point([(x, y)], fill=(95, 140, 60, 255))
    # Small grass tufts
    for gx, gy in [(6, 10), (22, 8), (14, 24), (28, 22)]:
        d.line([(gx, gy), (gx - 1, gy - 3)], fill=(155, 205, 95, 255))
        d.line([(gx, gy), (gx + 1, gy - 4)], fill=(155, 205, 95, 255))
        d.line([(gx, gy), (gx + 2, gy - 2)], fill=(135, 185, 85, 255))
        d.point([(gx, gy + 1)], fill=(80, 120, 50, 255))
    return im

def make_tile_mountain():
    im = make_tile_grass()
    d = ImageDraw.Draw(im)
    
    # 2 Handcrafted Snow-Capped Mountain Peaks
    # Peak 1 (Large left peak)
    m1_shadow = (75, 80, 95, 255)
    m1_light  = (145, 150, 165, 255)
    m1_snow   = (240, 245, 255, 255)
    m1_ridge  = (45, 48, 58, 255)
    
    # Left ridge & shading
    d.polygon([(14, 4), (4, 30), (14, 32)], fill=m1_light)
    d.polygon([(14, 4), (14, 32), (24, 30)], fill=m1_shadow)
    d.line([(14, 4), (14, 32)], fill=m1_ridge, width=1)
    # Snow cap on Peak 1
    d.polygon([(14, 4), (10, 12), (14, 14), (18, 12)], fill=m1_snow)
    d.line([(14, 4), (14, 14)], fill=(255, 255, 255, 255))

    # Peak 2 (Smaller right peak)
    d.polygon([(26, 12), (18, 32), (26, 33)], fill=m1_light)
    d.polygon([(26, 12), (26, 33), (33, 31)], fill=m1_shadow)
    d.line([(26, 12), (26, 33)], fill=m1_ridge)
    d.polygon([(26, 12), (23, 17), (26, 19), (29, 17)], fill=m1_snow)
    return im

def make_tile_forest():
    im = make_tile_grass()
    d = ImageDraw.Draw(im)
    
    # 3 Miniature Pine / Oak Tree Clusters
    for tx, ty, rad in [(10, 16, 7), (24, 12, 8), (18, 26, 7)]:
        # Shadow
        d.ellipse([tx - rad + 1, ty + rad - 3, tx + rad + 1, ty + rad + 2], fill=(45, 75, 30, 140))
        # Trunk
        d.rectangle([tx - 1, ty + rad - 4, tx + 1, ty + rad], fill=(85, 55, 30, 255))
        # Foliage Canopy
        d.ellipse([tx - rad, ty - rad, tx + rad, ty + rad], fill=(35, 85, 40, 255))
        d.ellipse([tx - rad + 1, ty - rad + 1, tx + rad - 1, ty + rad - 1], fill=(55, 115, 50, 255))
        d.ellipse([tx - rad + 2, ty - rad + 2, tx + rad - 3, ty + rad - 3], fill=(85, 155, 70, 255))
        d.point([(tx - 1, ty - rad + 3), (tx, ty - rad + 2)], fill=(125, 195, 95, 255))
    return im

def make_tile_swamp():
    im = Image.new("RGBA", (36, 36), (65, 85, 55, 255))
    d = ImageDraw.Draw(im)
    # Dark stagnant pools & moss
    d.ellipse([4, 12, 18, 24], fill=(35, 55, 45, 255))
    d.ellipse([16, 6, 30, 16], fill=(30, 50, 40, 255))
    d.ellipse([12, 22, 28, 32], fill=(35, 55, 45, 255))
    # Reeds & Cattails
    for rx, ry in [(8, 14), (22, 8), (18, 24), (26, 26)]:
        d.line([(rx, ry), (rx, ry - 7)], fill=(95, 125, 50, 255))
        d.point([(rx, ry - 6), (rx, ry - 5)], fill=(115, 65, 30, 255)) # cattail brown tip
    return im

def make_tile_road():
    im = make_tile_grass()
    d = ImageDraw.Draw(im)
    # Cobblestone Royal Road (Cross-center road with stone pavers)
    d.rectangle([8, 0, 28, 36], fill=(195, 180, 150, 255))
    # Cobblestones
    for ry in range(2, 36, 6):
        d.line([(8, ry), (28, ry)], fill=(155, 140, 115, 255))
        shift = 0 if (ry // 6) % 2 == 0 else 5
        for rx in range(8 + shift, 28, 9):
            d.line([(rx, ry), (rx, min(35, ry + 6))], fill=(155, 140, 115, 255))
            d.point([(rx + 2, ry + 2)], fill=(225, 215, 185, 255)) # highlight
    # Road edges / Curbs
    d.line([(8, 0), (8, 36)], fill=(125, 110, 90, 255), width=1)
    d.line([(28, 0), (28, 36)], fill=(125, 110, 90, 255), width=1)
    return im

# --- LANDMARK ICONS ---

def make_loc_capital():
    # 44x44 Grand White Stone Citadel with Gold Spires
    im = Image.new("RGBA", (44, 44), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx, cy = 22, 24

    d.ellipse([4, 32, 40, 42], fill=C_SHADOW)
    # Outer Ramparts & Walls
    d.rectangle([8, 16, 36, 36], fill=(155, 155, 165, 255))
    d.rectangle([9, 17, 35, 35], fill=(210, 210, 220, 255))
    # Battlements / Crenellations
    for bx in range(8, 36, 4):
        d.rectangle([bx, 13, bx + 2, 16], fill=(210, 210, 220, 255))
    
    # 3 Towers
    for tx in [10, 22, 34]:
        th = 14 if tx == 22 else 11
        d.rectangle([tx - 4, 18 - th, tx + 4, 30], fill=(185, 185, 195, 255))
        d.rectangle([tx - 3, 18 - th, tx + 3, 30], fill=(235, 235, 245, 255))
        # Blue/Gold Conical Roofs
        d.polygon([(tx, 14 - th - 8), (tx - 5, 18 - th), (tx + 5, 18 - th)], fill=(45, 85, 175, 255))
        d.polygon([(tx, 14 - th - 8), (tx - 3, 18 - th), (tx + 3, 18 - th)], fill=(75, 135, 235, 255))
        # Golden Flags
        d.line([(tx, 14 - th - 8), (tx, 14 - th - 12)], fill=(225, 185, 45, 255))
        d.polygon([(tx, 14 - th - 12), (tx + 5, 14 - th - 10), (tx, 14 - th - 8)], fill=(245, 60, 60, 255))

    # Arched Castle Gate & Portcullis
    d.rectangle([cx - 4, 26, cx + 4, 36], fill=(45, 35, 30, 255))
    d.line([(cx - 2, 26), (cx - 2, 36)], fill=(120, 120, 130, 255))
    d.line([(cx + 2, 26), (cx + 2, 36)], fill=(120, 120, 130, 255))
    d.line([(cx - 4, 30), (cx + 4, 30)], fill=(120, 120, 130, 255))
    return im

def make_loc_village():
    # 36x36 Cozy Village with Thatched Cottages
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([2, 26, 34, 34], fill=C_SHADOW)
    
    # House 1 (Left cottage)
    d.rectangle([4, 18, 18, 30], fill=(220, 210, 195, 255))
    d.polygon([(11, 8), (2, 18), (20, 18)], fill=(185, 75, 45, 255)) # red tile roof
    d.polygon([(11, 10), (4, 18), (18, 18)], fill=(225, 105, 65, 255))
    d.rectangle([9, 23, 13, 30], fill=(95, 55, 25, 255)) # door

    # House 2 (Right cottage with chimney)
    d.rectangle([18, 16, 32, 28], fill=(235, 225, 210, 255))
    d.polygon([(25, 6), (16, 16), (34, 16)], fill=(75, 115, 185, 255)) # blue roof
    d.rectangle([28, 4, 31, 10], fill=(145, 135, 130, 255)) # chimney
    d.point([(29, 2), (30, 1)], fill=(220, 220, 230, 200)) # smoke puff
    return im

def make_loc_mine():
    # 36x36 Mine with Mountain Entrance & Ore Cart
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 26, 32, 34], fill=C_SHADOW)
    # Stone Mountain Clifface
    d.polygon([(6, 30), (18, 8), (30, 30)], fill=(110, 115, 125, 255))
    d.polygon([(10, 28), (18, 10), (26, 28)], fill=(145, 150, 160, 255))
    # Mine Tunnel Mouth
    d.polygon([(13, 30), (18, 16), (23, 30)], fill=(20, 18, 22, 255))
    # Timber Arch Beams
    d.line([(13, 30), (18, 16), (23, 30)], fill=(145, 95, 45, 255), width=2)
    # Ore Cart with glowing blue crystals
    d.rectangle([15, 26, 21, 30], fill=(85, 65, 50, 255))
    d.point([(17, 25), (19, 24)], fill=(60, 215, 255, 255)) # blue crystal ore
    return im

def make_loc_fort():
    # 36x36 Bandit Palisade Fort with Watchtower
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 26, 32, 34], fill=C_SHADOW)
    # Timber Wall Logs (Palisade)
    for lx in range(6, 30, 3):
        d.line([(lx, 16), (lx, 28)], fill=(125, 80, 40, 255), width=2)
        d.point([(lx, 15)], fill=(175, 120, 65, 255)) # pointed log
    # Watchtower
    d.rectangle([14, 8, 22, 28], fill=(95, 60, 30, 255))
    d.polygon([(18, 2), (12, 8), (24, 8)], fill=(185, 45, 45, 255)) # red tent roof
    # Black skull flag
    d.line([(18, 2), (18, -3)], fill=(50, 40, 30, 255))
    d.polygon([(18, -3), (24, -1), (18, 1)], fill=(25, 25, 30, 255))
    d.point([(20, -1)], fill=(255, 255, 255, 255))
    return im

def make_loc_crypt():
    # 36x36 Ancient Barrow Crypt with Glowing Portal
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 24, 32, 33], fill=C_SHADOW)
    # Grassy Mound Barrow
    d.ellipse([6, 12, 30, 28], fill=(65, 85, 55, 255))
    d.ellipse([8, 13, 28, 27], fill=(85, 115, 75, 255))
    # Stone Dolmen Portal
    d.rectangle([14, 18, 22, 28], fill=(25, 15, 35, 255))
    d.line([(13, 17), (23, 17)], fill=(160, 160, 170, 255), width=2) # lintel
    d.line([(13, 17), (13, 28)], fill=(130, 130, 140, 255), width=2)
    d.line([(23, 17), (23, 28)], fill=(130, 130, 140, 255), width=2)
    # Purple Necrotic Glow Portal
    d.ellipse([15, 20, 21, 27], fill=(185, 45, 235, 200))
    d.point([(18, 23)], fill=(255, 210, 255, 255))
    return im

def make_loc_farms():
    # 36x36 Wheat Farm & Mill
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 25, 32, 33], fill=C_SHADOW)
    # Golden Wheat field
    d.rectangle([6, 18, 30, 28], fill=(225, 185, 65, 255))
    for wx in range(8, 30, 3):
        d.line([(wx, 16), (wx, 22)], fill=(255, 225, 105, 255))
    # Windmill
    d.polygon([(18, 6), (14, 24), (22, 24)], fill=(210, 210, 215, 255))
    d.polygon([(18, 3), (13, 6), (23, 6)], fill=(145, 75, 40, 255))
    # Sails
    d.line([(18, 10), (10, 4)], fill=(255, 255, 255, 255), width=2)
    d.line([(18, 10), (26, 16)], fill=(255, 255, 255, 255), width=2)
    d.line([(18, 10), (12, 16)], fill=(255, 255, 255, 255), width=2)
    d.line([(18, 10), (24, 4)], fill=(255, 255, 255, 255), width=2)
    return im

def make_loc_swamp():
    # 36x36 Witch Hut on Stilts
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 25, 32, 33], fill=C_SHADOW)
    # Wooden Stilts in water
    d.line([(12, 20), (12, 29)], fill=(65, 45, 30, 255), width=2)
    d.line([(24, 20), (24, 29)], fill=(65, 45, 30, 255), width=2)
    # Crooked Hut & Thatch
    d.polygon([(10, 18), (14, 8), (22, 9), (26, 19)], fill=(115, 80, 50, 255))
    d.polygon([(18, 2), (8, 11), (28, 12)], fill=(75, 105, 45, 255)) # mossy thatch roof
    # Green Alchemy Smoke
    d.point([(20, 0), (21, 1), (19, 2)], fill=(110, 255, 110, 220))
    return im

def make_loc_island():
    # 36x36 Tropical Palm Island
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 22, 32, 32], fill=(235, 215, 145, 255)) # sand shore
    d.ellipse([8, 20, 28, 28], fill=(125, 185, 75, 255)) # grass
    # Curved Palm Tree
    d.line([(16, 24), (19, 14), (23, 8)], fill=(135, 85, 40, 255), width=2)
    # Palm fronds
    d.line([(23, 8), (15, 4)], fill=(55, 175, 65, 255), width=2)
    d.line([(23, 8), (30, 6)], fill=(55, 175, 65, 255), width=2)
    d.line([(23, 8), (25, 14)], fill=(45, 145, 55, 255), width=2)
    # Treasure Chest on sand
    d.rectangle([10, 22, 15, 26], fill=(155, 95, 45, 255))
    d.point([(12, 23)], fill=(255, 215, 50, 255))
    return im

def make_token_player():
    # 36x36 Royal Knight Banner Token (Player Marker)
    im = Image.new("RGBA", (36, 36), C_TRANSPARENT)
    d = ImageDraw.Draw(im)
    cx, cy = 18, 18
    # Drop shadow
    d.ellipse([6, 26, 30, 34], fill=C_SHADOW)
    # Gold Carved Token Base
    d.ellipse([8, 22, 28, 30], fill=(165, 120, 25, 255))
    d.ellipse([9, 21, 27, 29], fill=(235, 195, 55, 255))
    d.ellipse([11, 22, 25, 28], fill=(255, 235, 130, 255))

    # Royal Golden Shield with Red Crest
    d.polygon([(cx, 8), (cx - 7, 12), (cx - 5, 22), (cx, 26), (cx + 5, 22), (cx + 7, 12)], fill=(215, 165, 35, 255))
    d.polygon([(cx, 10), (cx - 5, 13), (cx - 4, 20), (cx, 23), (cx + 4, 20), (cx + 5, 13)], fill=(225, 35, 45, 255))
    # Golden Heraldic Lion / Sword on shield
    d.line([(cx, 11), (cx, 22)], fill=(255, 235, 130, 255), width=2)
    d.line([(cx - 3, 14), (cx + 3, 14)], fill=(255, 235, 130, 255), width=2)

    # Waving Royal Standard Banner (Top right)
    d.line([(cx + 6, 24), (cx + 6, 2)], fill=(75, 75, 80, 255), width=2)
    d.polygon([(cx + 7, 2), (cx + 17, 5), (cx + 14, 8), (cx + 17, 11), (cx + 7, 10)], fill=(225, 35, 45, 255))
    d.point([(cx + 6, 1)], fill=(255, 215, 50, 255)) # gold finial
    return im

print("Generating Overworld Fantasy Cartography Pack...")

# Biomes
make_tile_water().save(f"{OW_DIR}/ow_water.png")
make_tile_grass().save(f"{OW_DIR}/ow_grass.png")
make_tile_mountain().save(f"{OW_DIR}/ow_mountain.png")
make_tile_forest().save(f"{OW_DIR}/ow_forest.png")
make_tile_swamp().save(f"{OW_DIR}/ow_swamp.png")
make_tile_road().save(f"{OW_DIR}/ow_road.png")

# Landmarks
make_loc_capital().save(f"{OW_DIR}/loc_capital.png")
make_loc_village().save(f"{OW_DIR}/loc_village.png")
make_loc_mine().save(f"{OW_DIR}/loc_mine.png")
make_loc_fort().save(f"{OW_DIR}/loc_fort.png")
make_loc_crypt().save(f"{OW_DIR}/loc_crypt.png")
make_loc_farms().save(f"{OW_DIR}/loc_farms.png")
make_loc_swamp().save(f"{OW_DIR}/loc_swamp.png")
make_loc_island().save(f"{OW_DIR}/loc_island.png")

# Token
make_token_player().save(f"{OW_DIR}/token_player.png")

print("SUCCESS: Overworld Cartography Pack generated in godot/assets/sprites/overworld/!")
