import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"

layers_to_fetch = [
    ("body", "body/bodies/male/light.png"),
    ("head", "head/heads/human/male/light.png"),
    ("eyes", "eyes/human/adult/blue.png"),          # Выразительные глаза!
    ("pants", "legs/pants/male/teal.png"),          # Штаны
    ("boots", "feet/boots/male/brown.png"),         # Сапоги
    ("chainmail", "torso/chainmail/male/gray.png"), # Кольчуга
    ("plate", "torso/armour/plate/male/steel.png"), # Стальной панцирь
    ("hair", "hair/bedhead/male/blonde.png"),       # Яркие золотистые волосы
]

CACHE_DIR = "godot/assets/sprites/lpc_raw"
os.makedirs(CACHE_DIR, exist_ok=True)

loaded_layers = []

for name, path in layers_to_fetch:
    filename = path.replace("/", "_")
    local_path = os.path.join(CACHE_DIR, filename)
    url = BASE_URL + path
    
    if not os.path.exists(local_path):
        print(f"Downloading {url}...")
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp, open(local_path, 'wb') as out_f:
            out_f.write(resp.read())
            
    img = Image.open(local_path).convert("RGBA")
    loaded_layers.append(img)

# Composite all layers onto master (832 x 2944)
master = Image.new("RGBA", (832, 2944))
for img in loaded_layers:
    if img.size == (832, 2944):
        master.alpha_composite(img)
    else:
        temp = Image.new("RGBA", (832, 2944))
        temp.paste(img, (0, 0))
        master.alpha_composite(temp)

master.save("godot/assets/sprites/player_lpc_master.png")

# Extract 4-direction Walk Cycle:
# Row 0: Down (Row 10 in LPC)
# Row 1: Up (Row 8 in LPC)
# Row 2: Left (Row 9 in LPC)
# Row 3: Right (Row 11 in LPC)
walk_sheet = Image.new("RGBA", (64 * 9, 64 * 4))
lpc_rows = [10, 8, 9, 11]

for out_row, lpc_row in enumerate(lpc_rows):
    for col in range(9):
        box = (col * 64, lpc_row * 64, (col + 1) * 64, (lpc_row + 1) * 64)
        frame = master.crop(box)
        walk_sheet.paste(frame, (col * 64, out_row * 64), frame)

walk_sheet.save("godot/assets/sprites/player_walk_cycle.png")

# Save enlarged front view (256x256) to artifacts for preview
single_front = walk_sheet.crop((0, 0, 64, 64)).resize((256, 256), Image.NEAREST)
single_front.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_perfect_preview.png")

print("SUCCESS: Perfect hero with body, head, blue eyes, blonde hair, and armor built!")
