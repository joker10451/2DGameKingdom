import os
from PIL import Image

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# 1. Trees:
# In LPC trees_summer.png (512x576), trees are 96x96 or 96x128 or 64x96
im_trees = Image.open("temp_lpc/Terrain/trees_summer.png").convert("RGBA")
# Oak tree top-left large (e.g. 0..96, 0..128)
oak_tree = im_trees.crop((0, 0, 96, 128)).resize((96, 128), Image.NEAREST)
oak_tree.save(f"{OUT_DIR}/tree_oak.png")

# Birch / lighter tree
birch_tree = im_trees.crop((96, 0, 192, 128)).resize((96, 128), Image.NEAREST)
birch_tree.save(f"{OUT_DIR}/tree_birch.png")

# Pine / Fir tree
pine_tree = im_trees.crop((192, 0, 288, 128)).resize((96, 128), Image.NEAREST)
pine_tree.save(f"{OUT_DIR}/tree_pine.png")

# Small tree / Bush
bush = im_trees.crop((288, 32, 352, 96)).resize((48, 48), Image.NEAREST)
bush.save(f"{OUT_DIR}/bush.png")

# Tree stump
stump = im_trees.crop((0, 480, 48, 528)).resize((48, 48), Image.NEAREST)
stump.save(f"{OUT_DIR}/tree_stump.png")

# 2. Rocks & Ores:
im_rocks = Image.open("temp_lpc/Terrain/Rocks, Grasslands.png").convert("RGBA")
# Big grey rock boulder
rock_big = im_rocks.crop((0, 0, 64, 64)).resize((48, 48), Image.NEAREST)
rock_big.save(f"{OUT_DIR}/rock_stone.png")

# Small stone
rock_small = im_rocks.crop((64, 0, 96, 32)).resize((32, 32), Image.NEAREST)
rock_small.save(f"{OUT_DIR}/rock_small.png")

# Iron ore
im_iron = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Iron.png").convert("RGBA")
iron_rock = rock_big.copy()
iron_bits = im_iron.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
# Overlay ore bits onto boulder
iron_rock.paste(iron_bits, (8, 8), iron_bits)
iron_rock.save(f"{OUT_DIR}/ore_iron.png")

# Gold ore
im_gold = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Gold.png").convert("RGBA")
gold_rock = rock_big.copy()
gold_bits = im_gold.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
gold_rock.paste(gold_bits, (8, 8), gold_bits)
gold_rock.save(f"{OUT_DIR}/ore_gold.png")

# Copper ore
im_copper = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Copper.png").convert("RGBA")
copper_rock = rock_big.copy()
copper_bits = im_copper.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
copper_rock.paste(copper_bits, (8, 8), copper_bits)
copper_rock.save(f"{OUT_DIR}/ore_copper.png")

# Coal ore
im_coal = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Coal.png").convert("RGBA")
coal_rock = rock_big.copy()
coal_bits = im_coal.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
coal_rock.paste(coal_bits, (8, 8), coal_bits)
coal_rock.save(f"{OUT_DIR}/ore_coal.png")

# 3. Grass & Flora:
im_plants = Image.open("temp_lpc/Terrain/plants_summer.png").convert("RGBA")
grass_tuft = im_plants.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
grass_tuft.save(f"{OUT_DIR}/grass_tuft.png")

im_flowers = Image.open("temp_lpc/Terrain/flowers.png").convert("RGBA")
flower_red = im_flowers.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
flower_red.save(f"{OUT_DIR}/flower_red.png")

flower_blue = im_flowers.crop((32, 0, 64, 32)).resize((32, 32), Image.NEAREST)
flower_blue.save(f"{OUT_DIR}/flower_blue.png")

flower_yellow = im_flowers.crop((64, 0, 96, 32)).resize((32, 32), Image.NEAREST)
flower_yellow.save(f"{OUT_DIR}/flower_yellow.png")

im_mushrooms = Image.open("temp_lpc/Terrain/mushrooms.png").convert("RGBA")
mushroom = im_mushrooms.crop((0, 0, 32, 32)).resize((32, 32), Image.NEAREST)
mushroom.save(f"{OUT_DIR}/mushroom.png")

# 4. Crops & Wheat:
im_crops = Image.open("temp_lpc/Objects/Small Items/Food/Grains, Grasses.png").convert("RGBA")
wheat_stage0 = im_crops.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
wheat_stage0.save(f"{OUT_DIR}/crop_stage_0.png")

wheat_stage1 = im_crops.crop((32, 0, 64, 32)).resize((48, 48), Image.NEAREST)
wheat_stage1.save(f"{OUT_DIR}/crop_stage_1.png")

wheat_stage2 = im_crops.crop((64, 0, 96, 32)).resize((48, 48), Image.NEAREST)
wheat_stage2.save(f"{OUT_DIR}/crop_stage_2.png")

wheat_stage3 = im_crops.crop((96, 0, 128, 32)).resize((48, 48), Image.NEAREST)
wheat_stage3.save(f"{OUT_DIR}/crop_stage_3.png")
wheat_stage3.save(f"{OUT_DIR}/crop_wheat.png")

# 5. Terrain Ground Tiles:
im_terrain = Image.open("temp_lpc/Terrain/terrain_summer.png").convert("RGBA")
# Base grass tile (32x32 -> 48x48)
tile_grass = im_terrain.crop((32, 32, 64, 64)).resize((48, 48), Image.NEAREST)
tile_grass.save(f"{OUT_DIR}/tile_grass.png")

# Dirt path
tile_dirt = im_terrain.crop((96, 32, 128, 64)).resize((48, 48), Image.NEAREST)
tile_dirt.save(f"{OUT_DIR}/tile_dirt.png")

# Farmland
im_soil = Image.open("temp_lpc/Terrain/tilled_soil.png").convert("RGBA")
tile_farmland = im_soil.crop((32, 32, 64, 64)).resize((48, 48), Image.NEAREST)
tile_farmland.save(f"{OUT_DIR}/tile_farmland.png")

# Water
tile_water = im_terrain.crop((224, 32, 256, 64)).resize((48, 48), Image.NEAREST)
tile_water.save(f"{OUT_DIR}/tile_water.png")

# Wood Floor
im_wood_floor = Image.open("temp_lpc/Structure/Floor/Wood Floor A.png").convert("RGBA")
tile_wood_floor = im_wood_floor.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
tile_wood_floor.save(f"{OUT_DIR}/tile_wood_floor.png")

# Stone Road / Cobblestone
im_stone_road = Image.open("temp_lpc/Structure/Floor/Tile A.png").convert("RGBA")
tile_stone_road = im_stone_road.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
tile_stone_road.save(f"{OUT_DIR}/tile_road.png")

# 6. Build a Showcase Preview of all Nature & Terrain Assets
showcase = Image.new("RGBA", (800, 350), (35, 45, 30, 255))
items_to_show = [
    ("Grass Tile", tile_grass),
    ("Dirt Path", tile_dirt),
    ("Cobblestone", tile_stone_road),
    ("Farmland", tile_farmland),
    ("Oak Tree", oak_tree),
    ("Birch Tree", birch_tree),
    ("Pine Tree", pine_tree),
    ("Iron Ore", iron_rock),
    ("Gold Ore", gold_rock),
    ("Copper Ore", copper_rock),
    ("Coal Ore", coal_rock),
    ("Wheat Crop", wheat_stage3),
    ("Mushroom", mushroom),
    ("Wildflower", flower_red),
]

cur_x = 20
cur_y = 20
for name, img in items_to_show:
    if cur_x + img.width > 780:
        cur_x = 20
        cur_y += 140
    showcase.paste(img, (cur_x, cur_y + (128 - img.height)), img)
    cur_x += max(img.width, 60) + 15

showcase.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/nature_showcase_preview.png")
print("SUCCESS: All nature, ore, tree, and terrain assets extracted and showcase saved!")
