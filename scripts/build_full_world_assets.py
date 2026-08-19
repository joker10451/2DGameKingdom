import os
from PIL import Image

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# 1. GROUND TILES (48x48)
im_terrain = Image.open("temp_lpc/Terrain/terrain_summer.png").convert("RGBA")
im_soil = Image.open("temp_lpc/Terrain/tilled_soil.png").convert("RGBA")
im_wood = Image.open("temp_lpc/Structure/Floor/Wood Floor A.png").convert("RGBA")
im_stone_pave = Image.open("temp_lpc/Structure/Floor/Tile A.png").convert("RGBA")
im_stone_wall = Image.open("temp_lpc/Structure/Walls/Brick Wall A.png").convert("RGBA")

# Grass (32x32 -> 48x48)
grass_tile = im_terrain.crop((32, 32, 64, 64)).resize((48, 48), Image.NEAREST)
grass_tile.save(f"{OUT_DIR}/tile_grass.png")

# Dirt path
dirt_tile = im_terrain.crop((96, 32, 128, 64)).resize((48, 48), Image.NEAREST)
dirt_tile.save(f"{OUT_DIR}/tile_dirt.png")

# Farmland / Tilled Soil
farmland_tile = im_soil.crop((32, 32, 64, 64)).resize((48, 48), Image.NEAREST)
farmland_tile.save(f"{OUT_DIR}/tile_farmland.png")
farmland_tile.save(f"{OUT_DIR}/tile_farmland_wet.png")

# Road / Cobblestone
road_tile = im_stone_pave.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
road_tile.save(f"{OUT_DIR}/tile_road.png")
road_tile.save(f"{OUT_DIR}/tile_stone_floor.png")

# Wood Floor
wood_tile = im_wood.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
wood_tile.save(f"{OUT_DIR}/tile_wood_floor.png")

# Walls
stone_wall_tile = im_stone_wall.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
stone_wall_tile.save(f"{OUT_DIR}/tile_wall_stone.png")
stone_wall_tile.save(f"{OUT_DIR}/tile_wall_brick.png")

# Water
water_tile = im_terrain.crop((224, 32, 256, 64)).resize((48, 48), Image.NEAREST)
water_tile.save(f"{OUT_DIR}/tile_water.png")


# 2. TREES & VEGETATION (48x48 fits perfectly into Godot tile grid)
im_trees = Image.open("temp_lpc/Terrain/trees_summer.png").convert("RGBA")
# Oak Tree (fit nicely into 48x48)
oak_crop = im_trees.crop((0, 0, 96, 128))
tree_oak_48 = oak_crop.resize((48, 48), Image.NEAREST)
tree_oak_48.save(f"{OUT_DIR}/tree.png")
tree_oak_48.save(f"{OUT_DIR}/tree_oak.png")

# Birch Tree
birch_crop = im_trees.crop((96, 0, 192, 128))
tree_birch_48 = birch_crop.resize((48, 48), Image.NEAREST)
tree_birch_48.save(f"{OUT_DIR}/tree_birch.png")

# Pine Tree
pine_crop = im_trees.crop((192, 0, 288, 128))
tree_pine_48 = pine_crop.resize((48, 48), Image.NEAREST)
tree_pine_48.save(f"{OUT_DIR}/tree_pine.png")

# Bush
bush_crop = im_trees.crop((288, 32, 352, 96)).resize((48, 48), Image.NEAREST)
bush_crop.save(f"{OUT_DIR}/bush.png")

# Stump
stump_crop = im_trees.crop((0, 480, 48, 528)).resize((48, 48), Image.NEAREST)
stump_crop.save(f"{OUT_DIR}/tree_stump.png")


# 3. ROCKS & ORES (48x48)
im_rocks = Image.open("temp_lpc/Terrain/Rocks, Grasslands.png").convert("RGBA")
# Clean rock base
base_boulder = im_rocks.crop((0, 0, 64, 64)).resize((48, 48), Image.NEAREST)
base_boulder.save(f"{OUT_DIR}/rock.png")
base_boulder.save(f"{OUT_DIR}/stone.png")

# Small stone
small_stone = im_rocks.crop((64, 0, 96, 32)).resize((32, 32), Image.NEAREST)
rock_small_canvas = Image.new("RGBA", (48, 48))
rock_small_canvas.paste(small_stone, (8, 12), small_stone)
rock_small_canvas.save(f"{OUT_DIR}/rock_small.png")

# Iron ore
im_iron = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Iron.png").convert("RGBA")
ore_iron = base_boulder.copy()
iron_nuggets = im_iron.crop((0, 0, 32, 32)).resize((28, 28), Image.NEAREST)
ore_iron.paste(iron_nuggets, (10, 10), iron_nuggets)
ore_iron.save(f"{OUT_DIR}/ore_iron.png")

# Gold ore
im_gold = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Gold.png").convert("RGBA")
ore_gold = base_boulder.copy()
gold_nuggets = im_gold.crop((0, 0, 32, 32)).resize((28, 28), Image.NEAREST)
ore_gold.paste(gold_nuggets, (10, 10), gold_nuggets)
ore_gold.save(f"{OUT_DIR}/ore_gold.png")

# Copper ore
im_copper = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Copper.png").convert("RGBA")
ore_copper = base_boulder.copy()
copper_nuggets = im_copper.crop((0, 0, 32, 32)).resize((28, 28), Image.NEAREST)
ore_copper.paste(copper_nuggets, (10, 10), copper_nuggets)
ore_copper.save(f"{OUT_DIR}/ore_copper.png")

# Coal ore
im_coal = Image.open("temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Coal.png").convert("RGBA")
ore_coal = base_boulder.copy()
coal_nuggets = im_coal.crop((0, 0, 32, 32)).resize((28, 28), Image.NEAREST)
ore_coal.paste(coal_nuggets, (10, 10), coal_nuggets)
ore_coal.save(f"{OUT_DIR}/ore_coal.png")


# 4. WHEAT & CROPS (48x48)
im_crops = Image.open("temp_lpc/Objects/Small Items/Food/Grains, Grasses.png").convert("RGBA")
for stage in range(4):
    c = im_crops.crop((stage * 32, 0, (stage + 1) * 32, 32)).resize((48, 48), Image.NEAREST)
    c.save(f"{OUT_DIR}/crop_stage_{stage}.png")
# Stage 3 is ready wheat
wheat_full = im_crops.crop((3 * 32, 0, 4 * 32, 32)).resize((48, 48), Image.NEAREST)
wheat_full.save(f"{OUT_DIR}/crop_wheat.png")


# 5. FLOWERS & MUSHROOMS (48x48)
im_flowers = Image.open("temp_lpc/Terrain/flowers.png").convert("RGBA")
flower_spr = im_flowers.crop((0, 0, 32, 32)).resize((40, 40), Image.NEAREST)
flower_canv = Image.new("RGBA", (48, 48))
flower_canv.paste(flower_spr, (4, 6), flower_spr)
flower_canv.save(f"{OUT_DIR}/flower.png")
flower_canv.save(f"{OUT_DIR}/flowers.png")

im_mushrooms = Image.open("temp_lpc/Terrain/mushrooms.png").convert("RGBA")
mush_spr = im_mushrooms.crop((0, 0, 32, 32)).resize((36, 36), Image.NEAREST)
mush_canv = Image.new("RGBA", (48, 48))
mush_canv.paste(mush_spr, (6, 8), mush_spr)
mush_canv.save(f"{OUT_DIR}/mushroom.png")
mush_canv.save(f"{OUT_DIR}/mushrooms.png")


# 6. OBJECTS & FURNITURE (Chest, Door, Anvil, Campfire, Grindstone)
im_chest = Image.open("temp_lpc/Objects/Furniture/Chest.png").convert("RGBA")
chest_spr = im_chest.crop((0, 0, 32, 32)).resize((40, 40), Image.NEAREST)
chest_canv = Image.new("RGBA", (48, 48))
chest_canv.paste(chest_spr, (4, 6), chest_spr)
chest_canv.save(f"{OUT_DIR}/chest.png")

im_fire = Image.open("temp_lpc/Objects/Small Items/Fire, Camp.png").convert("RGBA")
fire_spr = im_fire.crop((0, 0, 32, 32)).resize((42, 42), Image.NEAREST)
fire_canv = Image.new("RGBA", (48, 48))
fire_canv.paste(fire_spr, (3, 4), fire_spr)
fire_canv.save(f"{OUT_DIR}/campfire.png")
fire_canv.save(f"{OUT_DIR}/fireplace.png")

im_anvil = Image.open("temp_lpc/Objects/Furniture/Smithing/Anvils.png").convert("RGBA")
anvil_spr = im_anvil.crop((0, 0, 32, 32)).resize((40, 40), Image.NEAREST)
anvil_canv = Image.new("RGBA", (48, 48))
anvil_canv.paste(anvil_spr, (4, 6), anvil_spr)
anvil_canv.save(f"{OUT_DIR}/anvil.png")

im_grind = Image.open("temp_lpc/Objects/Furniture/Smithing/Grindstone.png").convert("RGBA")
grind_spr = im_grind.crop((0, 0, 32, 32)).resize((40, 40), Image.NEAREST)
grind_canv = Image.new("RGBA", (48, 48))
grind_canv.paste(grind_spr, (4, 6), grind_spr)
grind_canv.save(f"{OUT_DIR}/grindstone.png")

print("SUCCESS: 30+ Pixel-Art World Textures generated and saved in godot/assets/sprites/world/!")
