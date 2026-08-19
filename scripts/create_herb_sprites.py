import shutil
from PIL import Image

OUT_DIR = "godot/assets/sprites/world"

# Copy flower variants for herbs
shutil.copyfile(f"{OUT_DIR}/flower_yellow.png", f"{OUT_DIR}/herb_hypericum.png")
shutil.copyfile(f"{OUT_DIR}/flower_blue.png", f"{OUT_DIR}/herb_moonroot.png")
shutil.copyfile(f"{OUT_DIR}/flower_red.png", f"{OUT_DIR}/herb_belladonna.png")

print("Created herb_hypericum.png, herb_moonroot.png, herb_belladonna.png!")
