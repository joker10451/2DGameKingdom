import os
import zipfile
from PIL import Image

zip_path = r'D:\Downloads\Pixel Crawler - Free Pack 2.11.zip'
temp_dir = 'temp_pc'
with zipfile.ZipFile(zip_path, 'r') as z:
    z.extractall(temp_dir)

PC_ROOT = os.path.join(temp_dir, "Pixel Crawler - Free Pack")
OUT_WORLD = "godot/assets/sprites/world"
OUT_NPCS = "godot/assets/sprites/npcs"
OUT_SPRITES = "godot/assets/sprites"

os.makedirs(OUT_WORLD, exist_ok=True)
os.makedirs(OUT_NPCS, exist_ok=True)

def scale3x(img):
    w, h = img.size
    return img.resize((w * 3, h * 3), Image.NEAREST)

# 1. FLOORS & TILES
floors = Image.open(f"{PC_ROOT}/Environment/Tilesets/Floors_Tiles.png").convert("RGBA")
walls = Image.open(f"{PC_ROOT}/Environment/Tilesets/Wall_Tiles.png").convert("RGBA")

# Pure solid grass: (16, 160, 32, 176)
grass_16 = floors.crop((16, 160, 32, 176))
scale3x(grass_16).save(f"{OUT_WORLD}/tile_grass.png")

# Pure solid stone brick road: (256, 16, 272, 32)
stone_16 = floors.crop((256, 16, 272, 32))
scale3x(stone_16).save(f"{OUT_WORLD}/tile_road.png")
scale3x(stone_16).save(f"{OUT_WORLD}/tile_stone_floor.png")

# Pure solid wood floor: (176, 160, 192, 176)
wood_16 = floors.crop((176, 160, 192, 176))
scale3x(wood_16).save(f"{OUT_WORLD}/tile_wood_floor.png")

# Pure solid dirt/farmland: (96, 160, 112, 176)
dirt_16 = floors.crop((96, 160, 112, 176))
scale3x(dirt_16).save(f"{OUT_WORLD}/tile_dirt.png")
scale3x(dirt_16).save(f"{OUT_WORLD}/tile_farmland.png")

# Pure walls:
# Stone wall: (128, 256, 144, 272)
wall_stone_16 = walls.crop((128, 256, 144, 272))
scale3x(wall_stone_16).save(f"{OUT_WORLD}/tile_wall_stone.png")

# Wood wall: (32, 256, 48, 272)
wall_wood_16 = walls.crop((32, 256, 48, 272))
scale3x(wall_wood_16).save(f"{OUT_WORLD}/tile_wall_wood.png")

print("Pure seamless tiles extracted successfully!")
