import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/"

# Layers for a Medieval Knight / Adventurer:
# 1. Body (light male)
# 2. Pants (brown)
# 3. Boots (brown)
# 4. Chainmail / Tunic
# 5. Hair (messy/short brown)
# 6. Armor / Plate
layers_to_fetch = [
    "spritesheets/body/bodies/male/light.png",
    "spritesheets/head/heads/human_male/light.png",
    "spritesheets/eyes/male/blue.png",
    "spritesheets/legs/pants/male/brown.png",
    "spritesheets/feet/boots/male/brown.png",
    "spritesheets/torso/chainmail/male/gray.png",
    "spritesheets/hair/messy1/male/brown.png",
]

CACHE_DIR = "godot/assets/sprites/lpc_raw"
os.makedirs(CACHE_DIR, exist_ok=True)
os.makedirs("godot/assets/sprites", exist_ok=True)

downloaded_images = []

for layer_path in layers_to_fetch:
    filename = layer_path.replace("/", "_")
    local_path = os.path.join(CACHE_DIR, filename)
    url = BASE_URL + layer_path
    
    if not os.path.exists(local_path):
        print(f"Downloading {url}...")
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as resp, open(local_path, 'wb') as out_f:
                out_f.write(resp.read())
        except Exception as e:
            print(f"Warning: could not download {layer_path}: {e}")
            continue
            
    if os.path.exists(local_path):
        img = Image.open(local_path).convert("RGBA")
        downloaded_images.append(img)

if downloaded_images:
    # 1. Create full composited spritesheet
    base_img = downloaded_images[0].copy()
    for layer in downloaded_images[1:]:
        base_img.alpha_composite(layer)
        
    master_path = "godot/assets/sprites/player_lpc_master.png"
    base_img.save(master_path)
    print(f"Composited full LPC master spritesheet: {base_img.size} saved to {master_path}")
    
    # 2. In LPC standard format:
    # Row 8: Walk North (Up) - 9 frames of 64x64
    # Row 9: Walk West (Left) - 9 frames of 64x64
    # Row 10: Walk South (Down) - 9 frames of 64x64
    # Row 11: Walk East (Right) - 9 frames of 64x64
    # Let's extract these 4 rows (9 frames each) into a clean 576 x 256 walk cycle sheet!
    walk_sheet = Image.new("RGBA", (64 * 9, 64 * 4))
    
    # Row 0: Down (Row 10 in LPC)
    # Row 1: Up (Row 8 in LPC)
    # Row 2: Left (Row 9 in LPC)
    # Row 3: Right (Row 11 in LPC)
    lpc_rows = [10, 8, 9, 11]
    for out_row_idx, lpc_row_idx in enumerate(lpc_rows):
        for col_idx in range(9):
            src_box = (col_idx * 64, lpc_row_idx * 64, (col_idx + 1) * 64, (lpc_row_idx + 1) * 64)
            frame = base_img.crop(src_box)
            walk_sheet.paste(frame, (col_idx * 64, out_row_idx * 64), frame)
            
    walk_path = "godot/assets/sprites/player_walk_cycle.png"
    walk_sheet.save(walk_path)
    print(f"Generated clean 4-direction Walk Cycle: {walk_sheet.size} saved to {walk_path}!")
