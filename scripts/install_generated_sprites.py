import os
from PIL import Image

BRAIN_DIR = r"C:\Users\Kriri\.gemini\antigravity\brain\5f6ab763-da43-4796-8dcb-d7e2dc2bb594"
OUT_DIR = r"e:\kiro\game\godot\assets\sprites\world"
os.makedirs(OUT_DIR, exist_ok=True)

# Find the most recently created files in the brain directory matching our names
files = os.listdir(BRAIN_DIR)

def get_latest(prefix):
    matches = [f for f in files if f.startswith(prefix) and f.endswith(".jpg")]
    if not matches:
        return None
    matches.sort(key=lambda f: os.path.getmtime(os.path.join(BRAIN_DIR, f)), reverse=True)
    return os.path.join(BRAIN_DIR, matches[0])

def process_sprite(src_path, dest_path, target_size=(48, 48), bg_threshold=22):
    if not src_path or not os.path.exists(src_path):
        print(f"Skipping {dest_path}, source not found: {src_path}")
        return
    
    img = Image.open(src_path).convert("RGBA")
    
    # Remove dark background
    datas = img.getdata()
    new_data = []
    for item in datas:
        # If dark black background
        r, g, b, a = item
        if r <= bg_threshold and g <= bg_threshold and b <= bg_threshold:
            new_data.append((0, 0, 0, 0))
        else:
            # Smooth dark edges
            brightness = max(r, g, b)
            if brightness < 35:
                alpha = int(255 * (brightness - bg_threshold) / (35 - bg_threshold))
                new_data.append((r, g, b, max(0, min(255, alpha))))
            else:
                new_data.append((r, g, b, 255))
                
    img.putdata(new_data)
    
    # Auto-crop non-transparent bounding box
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    # Scale to square sprite maintaining aspect ratio with padding
    w, h = img.size
    max_dim = max(w, h)
    
    square_img = Image.new("RGBA", (max_dim, max_dim), (0, 0, 0, 0))
    offset_x = (max_dim - w) // 2
    offset_y = (max_dim - h) // 2
    square_img.paste(img, (offset_x, offset_y))
    
    # Resize to target 48x48
    final_img = square_img.resize(target_size, Image.Resampling.NEAREST)
    final_img.save(dest_path, "PNG")
    print(f"Saved: {dest_path} ({target_size[0]}x{target_size[1]})")

# 1. Alchemy Lab
alc_src = get_latest("alchemy_lab_sprite")
process_sprite(alc_src, os.path.join(OUT_DIR, "alchemy_lab.png"), (48, 48), 18)

# 2. Campfire & Fireplace
camp_src = get_latest("campfire_sprite")
process_sprite(camp_src, os.path.join(OUT_DIR, "campfire.png"), (48, 48), 16)
process_sprite(camp_src, os.path.join(OUT_DIR, "fireplace.png"), (48, 48), 16)

# 3. Skeleton Warrior & Archer
skel_src = get_latest("skeleton_warrior_sprite")
process_sprite(skel_src, os.path.join(OUT_DIR, "skeleton.png"), (48, 48), 18)
process_sprite(skel_src, os.path.join(OUT_DIR, "skeleton_archer.png"), (48, 48), 18)

# 4. Boss Malgrim
boss_src = get_latest("boss_knight_sprite")
process_sprite(boss_src, os.path.join(OUT_DIR, "boss_malgrim.png"), (48, 48), 18)

print("All AI-generated sprites processed and installed successfully!")
