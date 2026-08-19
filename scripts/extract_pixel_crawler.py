import os
from PIL import Image

PC_ROOT = "temp_pixel_crawler/Pixel Crawler - Free Pack"
OUT_WORLD = "godot/assets/sprites/world"
OUT_CHAR = "godot/assets/sprites/npcs"
OUT_PLAYER = "godot/assets/sprites"

os.makedirs(OUT_WORLD, exist_ok=True)
os.makedirs(OUT_CHAR, exist_ok=True)

# Helper: Integer 3x nearest scale (16px -> 48px, 32px -> 96px, etc.)
def scale3x(img):
    w, h = img.size
    return img.resize((w * 3, h * 3), Image.NEAREST)

# 1. FLOORS & WALLS
floors = Image.open(f"{PC_ROOT}/Environment/Tilesets/Floors_Tiles.png").convert("RGBA")
walls = Image.open(f"{PC_ROOT}/Environment/Tilesets/Wall_Tiles.png").convert("RGBA")

# Grass tile from Floors_Tiles (e.g. col 1, row 1 = 16x16)
# Let's check common positions
grass_16 = floors.crop((16, 16, 32, 32))
grass_48 = scale3x(grass_16)
grass_48.save(f"{OUT_WORLD}/tile_grass.png")

# Stone floor / Road
stone_16 = floors.crop((16, 112, 32, 128))
stone_48 = scale3x(stone_16)
stone_48.save(f"{OUT_WORLD}/tile_road.png")
stone_48.save(f"{OUT_WORLD}/tile_stone_floor.png")

# Wood floor
wood_16 = floors.crop((16, 208, 32, 224))
wood_48 = scale3x(wood_16)
wood_48.save(f"{OUT_WORLD}/tile_wood_floor.png")

# Dirt / Farmland
dirt_16 = floors.crop((16, 304, 32, 320))
dirt_48 = scale3x(dirt_16)
dirt_48.save(f"{OUT_WORLD}/tile_dirt.png")
dirt_48.save(f"{OUT_WORLD}/tile_farmland.png")

# Wall tiles
wall_stone_16 = walls.crop((16, 16, 32, 48)) # 16x32 wall
wall_stone_48 = wall_stone_16.resize((48, 48), Image.NEAREST)
wall_stone_48.save(f"{OUT_WORLD}/tile_wall_stone.png")

wall_wood_16 = walls.crop((16, 112, 32, 144))
wall_wood_48 = wall_wood_16.resize((48, 48), Image.NEAREST)
wall_wood_48.save(f"{OUT_WORLD}/tile_wall_wood.png")


# 2. TREES & VEGETATION (From Environment/Props/Static/Trees/)
# Model_01: Size_02 (256x128 containing tree states)
tree_sheet = Image.open(f"{PC_ROOT}/Environment/Props/Static/Trees/Model_01/Size_02.png").convert("RGBA")
# First tree in sheet is 64x64 at (0, 0, 64, 64) or (0, 64, 64, 128)
tree_01 = tree_sheet.crop((0, 0, 64, 128)).resize((48, 48), Image.NEAREST)
# Let's crop full tree bounding box
tree_crop = tree_sheet.crop((0, 0, 64, 64)).resize((48, 48), Image.NEAREST)
tree_crop.save(f"{OUT_WORLD}/tree.png")
tree_crop.save(f"{OUT_WORLD}/tree_oak.png")

# Model_02
tree_m2 = Image.open(f"{PC_ROOT}/Environment/Props/Static/Trees/Model_02/Size_02.png").convert("RGBA")
tree_birch = tree_m2.crop((0, 0, 64, 96)).resize((48, 48), Image.NEAREST)
tree_birch.save(f"{OUT_WORLD}/tree_birch.png")

# Model_03
tree_m3 = Image.open(f"{PC_ROOT}/Environment/Props/Static/Trees/Model_03/Size_02.png").convert("RGBA")
tree_pine = tree_m3.crop((0, 0, 64, 96)).resize((48, 48), Image.NEAREST)
tree_pine.save(f"{OUT_WORLD}/tree_pine.png")


# 3. FARM & NATURE PROPS (Bushes, Rocks, Crops)
farm = Image.open(f"{PC_ROOT}/Environment/Props/Static/Farm.png").convert("RGBA")
# Crop wheat / plants
wheat_16 = farm.crop((16, 16, 32, 32))
scale3x(wheat_16).save(f"{OUT_WORLD}/crop_wheat.png")

# Bush
bush_16 = farm.crop((64, 16, 80, 32))
scale3x(bush_16).save(f"{OUT_WORLD}/bush.png")

# Dungeon Props: Rocks, Ore, Chests, Anvils
dungeon = Image.open(f"{PC_ROOT}/Environment/Props/Static/Dungeon_Props.png").convert("RGBA")
rock_16 = dungeon.crop((16, 16, 32, 32))
scale3x(rock_16).save(f"{OUT_WORLD}/rock.png")
scale3x(rock_16).save(f"{OUT_WORLD}/stone.png")

chest_16 = dungeon.crop((64, 16, 80, 32))
scale3x(chest_16).save(f"{OUT_WORLD}/chest.png")


# 4. STATIONS (Anvil, Bonfire/Campfire, Workbench)
anvil_img = Image.open(f"{PC_ROOT}/Environment/Structures/Stations/Anvil/Anvil.png").convert("RGBA")
anvil_crop = anvil_img.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
anvil_crop.save(f"{OUT_WORLD}/anvil.png")

bonfire_img = Image.open(f"{PC_ROOT}/Environment/Structures/Stations/Bonfire/Bonfire.png").convert("RGBA")
bonfire_crop = bonfire_img.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
bonfire_crop.save(f"{OUT_WORLD}/campfire.png")
bonfire_crop.save(f"{OUT_WORLD}/fireplace.png")

workbench_img = Image.open(f"{PC_ROOT}/Environment/Structures/Stations/Workbench/Workbench.png").convert("RGBA")
workbench_crop = workbench_img.crop((0, 0, 32, 32)).resize((48, 48), Image.NEAREST)
workbench_crop.save(f"{OUT_WORLD}/carpentry.png")


# 5. CHARACTERS FROM PIXEL CRAWLER
# Body_A (Player Walk & Idle)
# Walk: Walk_Down (4 frames), Walk_Side (4 frames), Walk_Up (4 frames)
# Knight, Rogue, Wizzard, Peasant_A, Tavern_A, Tavern_B
print("Successfully extracted Pixel Crawler assets!")
