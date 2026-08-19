import os
from PIL import Image

files_to_check = [
    "temp_lpc/Terrain/trees_summer.png",
    "temp_lpc/Terrain/Rocks, Grasslands.png",
    "temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Iron.png",
    "temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Gold.png",
    "temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Copper.png",
    "temp_lpc/Objects/Small Items/Ores & Ingots/Ore, Coal.png",
    "temp_lpc/Terrain/plants_summer.png",
    "temp_lpc/Terrain/flowers.png",
    "temp_lpc/Terrain/mushrooms.png",
    "temp_lpc/Terrain/terrain_summer.png",
    "temp_lpc/Terrain/tilled_soil.png",
    "temp_lpc/Objects/Small Items/Food/Grains, Grasses.png",
]

for p in files_to_check:
    if os.path.exists(p):
        im = Image.open(p)
        print(f"{os.path.basename(p):35s} size={im.size} mode={im.mode}")
    else:
        print(f"NOT FOUND: {p}")
