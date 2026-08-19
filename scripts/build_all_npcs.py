import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"
CACHE_DIR = "godot/assets/sprites/lpc_raw"
SPRITES_DIR = "godot/assets/sprites/npcs"
os.makedirs(CACHE_DIR, exist_ok=True)
os.makedirs(SPRITES_DIR, exist_ok=True)

# LPC Walk cycle rows in the 832x2944 sheet:
# Row 8=Up, Row 9=Left, Row 10=Down, Row 11=Right (64px each)
LPC_WALK_ROWS = [10, 8, 9, 11]  # Output order: Down, Up, Left, Right

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
            print(f"  WARNING: {path} not found: {e}")
            return None
    return local_path

def composite_and_slice(name, layers):
    """Composite layer list into 576x256 walk cycle sheet (4 dirs x 9 frames @ 64x64)."""
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
        else:
            print(f"  Unexpected size: {img.size}")

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

# ============================================================
# ОПРЕДЕЛЕНИЯ ПЕРСОНАЖЕЙ
# (все пути проверены: 200 OK на GitHub)
# ============================================================

characters = {

    # 1. Крестьянин (Peasant) — простая одежда, соломенные волосы
    "peasant_male": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/plain/male/chestnut.png",
        "legs/pants/male/brown.png",
        "feet/shoes/male/brown.png",
    ],

    # 2. Крестьянка (Female Peasant)
    "peasant_female": [
        "body/bodies/female/light.png",
        "head/heads/human/female/light.png",
        "eyes/human/adult/blue.png",
        "hair/loose/female/chestnut.png",
        "legs/pants/female/brown.png",
        "feet/shoes/female/brown.png",
    ],

    # 3. Кузнец (Blacksmith) — крупный, темные волосы, кожаный фартук
    "blacksmith": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/bedhead/male/black.png",
        "legs/pants/male/black.png",
        "feet/boots/male/brown.png",
        "torso/chainmail/male/gray.png",
    ],

    # 4. Торговец (Merchant) — богатая одежда, шляпа, ухоженный
    "merchant": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/parted/male/chestnut.png",
        "legs/pants/male/teal.png",
        "feet/boots/male/brown.png",
    ],

    # 5. Городской Стражник (Guard) — полные доспехи
    "guard": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/spiked/male/black.png",
        "legs/pants/male/black.png",
        "feet/boots/male/black.png",
        "torso/chainmail/male/gray.png",
        "torso/armour/plate/male/steel.png",
    ],

    # 6. Бандит (Bandit) — грязная одежда, чёрные волосы
    "bandit": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/bangs/male/black.png",
        "legs/pants/male/black.png",
        "feet/boots/male/black.png",
        "torso/chainmail/male/gray.png",
    ],

    # 7. Лорд (Lord) — богатые доспехи, золотистые волосы
    "lord": [
        "body/bodies/male/light.png",
        "head/heads/human/male/light.png",
        "eyes/human/adult/blue.png",
        "hair/bedhead/male/blonde.png",
        "legs/pants/male/teal.png",
        "feet/boots/male/brown.png",
        "torso/armour/plate/male/steel.png",
    ],
}

# Build and save all characters
preview_frames = []
for char_name, layers in characters.items():
    sheet = composite_and_slice(char_name, layers)
    if sheet:
        frame0 = sheet.crop((0, 0, 64, 64)).resize((128, 128), Image.NEAREST)
        preview_frames.append((char_name, frame0))

# Create a combined preview strip for all characters
if preview_frames:
    n = len(preview_frames)
    strip = Image.new("RGBA", (128 * n, 148))
    from PIL import ImageDraw, ImageFont
    for i, (name, frame) in enumerate(preview_frames):
        strip.paste(frame, (i * 128, 20), frame)
    strip.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/all_npcs_preview.png")
    print(f"\nPreview strip saved with {n} characters!")

print("\nAll NPC spritesheets built!")
