from PIL import Image

im_terrain = Image.open("temp_lpc/Terrain/terrain_summer.png").convert("RGBA")
im_plants = Image.open("temp_lpc/Terrain/plants_summer.png").convert("RGBA")
im_wild = Image.open("temp_lpc/Terrain/wildflowers_summer.png").convert("RGBA")

# Take grass texture from (0, 32, 32, 64) of terrain_summer
grass_tex_crop = im_terrain.crop((0, 32, 32, 64)).resize((48, 48), Image.NEAREST)

# Overlay subtle grass blades
tuft = im_plants.crop((0, 0, 32, 32)).resize((20, 20), Image.NEAREST)

rich_grass = grass_tex_crop.copy()
rich_grass.alpha_composite(tuft, (14, 14))

rich_grass.save("godot/assets/sprites/world/tile_grass.png")
print("Saved rich textured tile_grass.png!")
