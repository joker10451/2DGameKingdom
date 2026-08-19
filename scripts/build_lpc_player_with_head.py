import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"

# Proper LPC Layer Ordering:
# 1. Body Base
# 2. Head (Face/Ears)
# 3. Legs (Pants)
# 4. Feet (Boots)
# 5. Torso (Chainmail)
# 6. Torso Armor (Steel Plate)
# 7. Hair / Helmet
layers_to_fetch = [
    "body/bodies/male/light.png",
    "head/heads/human/male/light.png",
    "legs/pants/male/brown.png",
    "feet/boots/male/brown.png",
    "torso/chainmail/male/gray.png",
    "torso/armour/plate/male/steel.png",
    "hair/afro/male/black.png",
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
    # 1. Composite all layers in order
    base_img = Image.new("RGBA", downloaded_images[0].size)
    for layer in downloaded_images:
        base_img.alpha_composite(layer)
        
    master_path = "godot/assets/sprites/player_lpc_master.png"
    base_img.save(master_path)
    print(f"Composited full LPC master with HEAD: {base_img.size} saved to {master_path}")
    
    # 2. Extract Walk Cycle:
    # LPC Rows:
    # Row 8: Walk Up (North) - 9 frames (64x64)
    # Row 9: Walk Left (West) - 9 frames (64x64)
    # Row 10: Walk Down (South) - 9 frames (64x64)
    # Row 11: Walk Right (East) - 9 frames (64x64)
    walk_sheet = Image.new("RGBA", (64 * 9, 64 * 4))
    
    # Target grid:
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
    
    # Also save to artifact directory for instant viewing
    walk_sheet.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/lpc_hero_walk_with_head.png")
    print(f"Generated clean 4-direction Walk Cycle with HEAD: {walk_sheet.size} saved to {walk_path}!")
