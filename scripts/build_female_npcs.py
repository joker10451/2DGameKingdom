import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"
CACHE_DIR = "godot/assets/sprites/lpc_raw"
SPRITES_DIR = "godot/assets/sprites/npcs"
os.makedirs(CACHE_DIR, exist_ok=True)

LPC_WALK_ROWS = [10, 8, 9, 11]

def download_layer(path):
    filename = path.replace("/", "_")
    local_path = os.path.join(CACHE_DIR, filename)
    if not os.path.exists(local_path):
        url = BASE_URL + path
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as resp, open(local_path, 'wb') as f:
                f.write(resp.read())
        except Exception as e:
            return None
    return local_path

def composite_and_slice(layers):
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
    return walk_sheet

# Крестьянка — белая блузка, коричневые штаны, рыжие волосы
print("[peasant_female] Building...")
sheet = composite_and_slice([
    "body/bodies/female/light.png",
    "head/heads/human/female/light.png",
    "eyes/human/adult/blue.png",
    "hair/loose/female/chestnut.png",
    "legs/pants/female/brown.png",
    "feet/shoes/female/brown.png",
    "torso/clothes/blouse/female/white.png",
])
sheet.save(f"{SPRITES_DIR}/npc_peasant_female.png")
# Save large preview
sheet.crop((0, 0, 64, 64)).resize((256, 256), Image.NEAREST).save(
    "C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/npc_peasant_female_preview.png")
print("  Done!")

# Торговка — синяя туника
print("[merchant_female] Building...")
sheet2 = composite_and_slice([
    "body/bodies/female/light.png",
    "head/heads/human/female/light.png",
    "eyes/human/adult/blue.png",
    "hair/parted/female/chestnut.png",
    "legs/pants/female/brown.png",
    "feet/shoes/female/brown.png",
    "torso/clothes/tunic/female/blue.png",
])
sheet2.save(f"{SPRITES_DIR}/npc_merchant_female.png")
sheet2.crop((0, 0, 64, 64)).resize((256, 256), Image.NEAREST).save(
    "C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/npc_merchant_female_preview.png")
print("  Done!")

# Rebuild comparison preview strip with both male and female variants
frames = []
for fn in [
    "godot/assets/sprites/npcs/npc_peasant_male.png",
    "godot/assets/sprites/npcs/npc_peasant_female.png",
    "godot/assets/sprites/npcs/npc_blacksmith.png",
    "godot/assets/sprites/npcs/npc_merchant.png",
    "godot/assets/sprites/npcs/npc_guard.png",
    "godot/assets/sprites/npcs/npc_bandit.png",
    "godot/assets/sprites/npcs/npc_lord.png",
]:
    im = Image.open(fn)
    frames.append(im.crop((0, 0, 64, 64)).resize((128, 128), Image.NEAREST))

n = len(frames)
strip = Image.new("RGBA", (128 * n, 128))
for i, f in enumerate(frames):
    strip.paste(f, (i * 128, 0), f)
strip.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/all_npcs_preview.png")
print(f"\nPreview strip updated with {n} characters!")
