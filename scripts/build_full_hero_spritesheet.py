import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"

# Полноценные слои Рыцаря / Главного Героя
layers_to_fetch = [
    "body/bodies/male/light.png",          # Тело
    "head/heads/human/male/light.png",     # Голова и Лицо
    "hair/bedhead/male/brown.png",         # Прическа (коричневая)
    "legs/pants/male/brown.png",           # Штаны
    "feet/boots/male/brown.png",           # Сапоги
    "torso/chainmail/male/gray.png",       # Кольчуга
    "torso/armour/plate/male/steel.png",   # Стальной панцирь
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
    # 1. Склейка всех слоев в единый мастер-лист
    base_img = Image.new("RGBA", downloaded_images[0].size)
    for layer in downloaded_images:
        base_img.alpha_composite(layer)
        
    master_path = "godot/assets/sprites/player_lpc_master.png"
    base_img.save(master_path)
    print(f"Composited full LPC master with Head & Hair: {base_img.size}")
    
    # 2. Нарезка чистого 4-направленного цикла ходьбы (Walk Cycle)
    # Row 0: Down (Row 10 in LPC, 9 frames)
    # Row 1: Up (Row 8 in LPC, 9 frames)
    # Row 2: Left (Row 9 in LPC, 9 frames)
    # Row 3: Right (Row 11 in LPC, 9 frames)
    walk_sheet = Image.new("RGBA", (64 * 9, 64 * 4))
    
    lpc_rows = [10, 8, 9, 11]
    for out_row_idx, lpc_row_idx in enumerate(lpc_rows):
        for col_idx in range(9):
            src_box = (col_idx * 64, lpc_row_idx * 64, (col_idx + 1) * 64, (lpc_row_idx + 1) * 64)
            frame = base_img.crop(src_box)
            walk_sheet.paste(frame, (col_idx * 64, out_row_idx * 64), frame)
            
    walk_path = "godot/assets/sprites/player_walk_cycle.png"
    walk_sheet.save(walk_path)
    
    # Сохраняем в артефакты для мгновенного просмотра
    artifact_preview = "C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_with_head_and_hair.png"
    walk_sheet.save(artifact_preview)
    print(f"Pristine Walk Cycle saved to {walk_path} and {artifact_preview}!")
