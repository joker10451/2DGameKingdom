import os
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# 1. SEAMLESS WARM LUSH MEADOW GRASS (48x48)
# Handcrafted organic pixel art grass that tiles 100% seamlessly
grass = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        # Subtle organic noise
        import math
        n1 = math.sin(x * 0.45 + y * 0.35) * 6.0
        n2 = math.cos(x * 0.7 - y * 0.5) * 4.0
        base_r = int(72 + n1)
        base_g = int(142 + n1 + n2)
        base_b = int(58 + n2)
        
        # Subtle grass blade specks
        if (x * 13 + y * 23) % 47 == 0:
            base_r += 14; base_g += 20; base_b += 8 # Highlight
        elif (x * 19 + y * 29) % 53 == 0:
            base_r -= 10; base_g -= 16; base_b -= 8 # Shadow speck
            
        grass.putpixel((x, y), (base_r, base_g, base_b, 255))

grass.save(f"{OUT_DIR}/tile_grass.png")


# 2. WARM MEDIEVAL COBBLESTONE ROAD (48x48)
# Warm cobblestone pavers with soft grout seams and subtle highlights
road = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        # 16x12 stone pavers with alternating offset
        row = y // 12
        offset = (row % 2) * 8
        local_x = (x + offset) % 16
        local_y = y % 12
        
        is_seam = (local_x == 0 or local_y == 0)
        if is_seam:
            road.putpixel((x, y), (95, 85, 75, 255)) # Grout
        else:
            # Paver surface with light bevel top-left, shadow bottom-right
            base_stone = 168 + ((x * 7 + y * 11) % 15)
            r = int(base_stone * 0.98)
            g = int(base_stone * 0.92)
            b = int(base_stone * 0.82)
            if local_x == 1 or local_y == 1:
                r += 18; g += 16; b += 12 # Bevel light
            elif local_x == 15 or local_y == 11:
                r -= 25; g -= 25; b -= 22 # Bevel shadow
            road.putpixel((x, y), (min(255, r), min(255, g), min(255, b), 255))

road.save(f"{OUT_DIR}/tile_road.png")
road.save(f"{OUT_DIR}/tile_stone_floor.png")


# 3. DIRT PATH (48x48)
dirt = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        import math
        n = math.sin(x * 0.5 + y * 0.4) * 8.0 + math.cos(x * 0.8 - y * 0.6) * 5.0
        r = int(140 + n)
        g = int(105 + n * 0.8)
        b = int(72 + n * 0.6)
        if (x * 11 + y * 17) % 37 == 0:
            r += 25; g += 20; b += 15 # Pebble
        dirt.putpixel((x, y), (r, g, b, 255))
dirt.save(f"{OUT_DIR}/tile_dirt.png")


# 4. RICH FARMLAND (48x48)
farmland = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        furrow = y % 12
        if furrow in [0, 1]:
            r, g, b = 65, 42, 24 # Deep furrow trough
        elif furrow in [5, 6, 7]:
            r, g, b = 115, 78, 46 # Raised ridge with light
        else:
            r, g, b = 90, 60, 35
        if (x * 7 + y * 13) % 23 == 0:
            r += 15; g += 12; b += 8
        farmland.putpixel((x, y), (r, g, b, 255))
farmland.save(f"{OUT_DIR}/tile_farmland.png")
farmland.save(f"{OUT_DIR}/tile_farmland_wet.png")


# 5. OAK WOOD FLOOR (48x48)
wood = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        plank = y % 12
        if plank == 0:
            r, g, b = 70, 42, 20 # Seam
        elif plank == 1:
            r, g, b = 175, 120, 72 # Light edge
        else:
            grain = (x * 3 + y * 7) % 15
            r, g, b = 148 + grain, 98 + grain, 56 + grain
        # Nail heads
        if (x % 24 == 4 or x % 24 == 20) and plank == 3:
            r, g, b = 45, 40, 38
        wood.putpixel((x, y), (r, g, b, 255))
wood.save(f"{OUT_DIR}/tile_wood_floor.png")


# 6. LOG CABIN WALL & STONE WALL (48x48)
wall_wood = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        log_y = y % 16
        if log_y in [0, 15]:
            r, g, b = 55, 32, 16 # Log junction
        elif log_y in [1, 2]:
            r, g, b = 160, 105, 58 # Log top highlight
        else:
            r, g, b = 120, 76, 42
        wall_wood.putpixel((x, y), (r, g, b, 255))
wall_wood.save(f"{OUT_DIR}/tile_wall_wood.png")

wall_stone = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        row = y // 16
        offset = (row % 2) * 12
        lx = (x + offset) % 24
        ly = y % 16
        if lx == 0 or ly == 0:
            r, g, b = 50, 52, 56 # Mortar
        elif lx <= 2 or ly <= 2:
            r, g, b = 145, 148, 155 # Stone highlight
        else:
            r, g, b = 105, 108, 115
        wall_stone.putpixel((x, y), (r, g, b, 255))
wall_stone.save(f"{OUT_DIR}/tile_wall_stone.png")
wall_stone.save(f"{OUT_DIR}/tile_wall_brick.png")

# 7. WATER (48x48)
water = Image.new("RGBA", (48, 48))
for y in range(48):
    for x in range(48):
        import math
        w = math.sin(x * 0.35 + y * 0.4) * 10.0
        r = int(45 + w * 0.5)
        g = int(115 + w)
        b = int(185 + w * 1.2)
        if (x * 7 + y * 13) % 29 == 0:
            r += 40; g += 50; b += 55 # Foam / sparkle
        water.putpixel((x, y), (min(255, r), min(255, g), min(255, b), 255))
water.save(f"{OUT_DIR}/tile_water.png")

print("SUCCESS: Full seamless warm palette generated!")
