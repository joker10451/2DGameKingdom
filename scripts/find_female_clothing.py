import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"
CACHE_DIR = "godot/assets/sprites/lpc_raw"
SPRITES_DIR = "godot/assets/sprites/npcs"

LPC_WALK_ROWS = [10, 8, 9, 11]

def download_layer(path):
    filename = path.replace("/", "_")
    local_path = os.path.join(CACHE_DIR, filename)
    url = BASE_URL + path
    if not os.path.exists(local_path):
        print(f"  Downloading {path}...")
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as resp, open(local_path, 'wb') as f:
                f.write(resp.read())
        except Exception as e:
            print(f"  WARNING: {path} not available: {e}")
            return None
    return local_path

def composite_and_slice(name, layers):
    print(f"\n[{name}]")
    master = Image.new("RGBA", (832, 2944))

    for path in layers:
        lpath = download_layer(path)
        if lpath is None:
            continue
        img = Image.open(lpath).convert("RGBA")
        if img.size == (832, 2944):
            master.alpha_composite(img)
        elif img.size == (832, 1344):
            temp = Image.new("RGBA", (832, 2944))
            temp.paste(img, (0, 0))
            master.alpha_composite(temp)

    walk_sheet = Image.new("RGBA", (64 * 9, 64 * 4))
    for out_row, lpc_row in enumerate(LPC_WALK_ROWS):
        for col in range(9):
            box = (col * 64, lpc_row * 64, (col+1)*64, (lpc_row+1)*64)
            frame = master.crop(box)
            walk_sheet.paste(frame, (col * 64, out_row * 64), frame)

    out_path = os.path.join(SPRITES_DIR, f"npc_{name}.png")
    walk_sheet.save(out_path)
    print(f"  Saved: {out_path}")
    return walk_sheet

# Смотрим какие женские слои реально существуют
test_female = [
    "body/bodies/female/light.png",
    "head/heads/human/female/light.png",
    "eyes/human/adult/blue.png",
    "hair/loose/female/chestnut.png",
    "legs/pants/female/brown.png",
    "feet/shoes/female/brown.png",
    "torso/clothes/laced/female/white.png",
    "torso/clothes/blouse/female/white.png",
    "torso/clothes/dress/female/white.png",
    "torso/clothes/tunic/female/blue.png",
    "torso/clothes/peasant/female/white.png",
    "torso/peasant_shirt/female/white.png",
    "torso/shirt/female/white.png",
]

print("Testing female clothing layers...")
found = []
for path in test_female:
    lpath = download_layer(path)
    if lpath:
        found.append(path)
        print(f"  FOUND: {path}")

print(f"\nFound {len(found)} female layers")
