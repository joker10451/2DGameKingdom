import os
import urllib.request
from PIL import Image

BASE_URL = "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/"

# In LPC, all spritesheets are 832px wide with 13-column layout.
# Rows for walk cycle: 8=Up, 9=Left, 10=Down, 11=Right
# Each frame is 64x64 pixels.
# The FULL sheet is 832x2944 (46 animation rows).
# Smaller sheets (1344px tall = 21 rows) are overlays that only have subset of animations.

# Correct LPC walk row order (all in same 832x2944 sheet):
# Row 8  = Walk Up (9 frames @ cols 0-8)
# Row 9  = Walk Left (9 frames)
# Row 10 = Walk Down (9 frames) <- DOWN IS ROW 10!
# Row 11 = Walk Right (9 frames)

layers_to_fetch = [
    ("body",      "body/bodies/male/light.png",         2944),
    ("head",      "head/heads/human/male/light.png",    2944),
    ("eyes",      "eyes/human/adult/blue.png",          2944),
    ("pants",     "legs/pants/male/teal.png",           2944),
    ("boots",     "feet/boots/male/brown.png",          1344),
    ("chainmail", "torso/chainmail/male/gray.png",      1344),
    ("plate",     "torso/armour/plate/male/steel.png",  2944),
    ("hair",      "hair/bedhead/male/blonde.png",       1344),
]

CACHE_DIR = "godot/assets/sprites/lpc_raw"
os.makedirs(CACHE_DIR, exist_ok=True)

loaded_layers = []

for name, path, expected_h in layers_to_fetch:
    filename = path.replace("/", "_")
    local_path = os.path.join(CACHE_DIR, filename)
    url = BASE_URL + path
    
    if not os.path.exists(local_path):
        print(f"Downloading {url}...")
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp, open(local_path, 'wb') as out_f:
            out_f.write(resp.read())
            
    img = Image.open(local_path).convert("RGBA")
    print(f"  {name}: size={img.size}")
    loaded_layers.append((name, img))

# Composite all layers into full 832x2944 master
master = Image.new("RGBA", (832, 2944))
for name, img in loaded_layers:
    if img.size == (832, 2944):
        master.alpha_composite(img)
    elif img.size == (832, 1344):
        # Smaller sheet: paste at top-left (contains same rows 0-20)
        temp = Image.new("RGBA", (832, 2944))
        temp.paste(img, (0, 0))
        master.alpha_composite(temp)
    else:
        print(f"  WARNING: Unexpected size for {name}: {img.size}")

# Walk cycle extraction.
# LPC rows (Down=10, Up=8, Left=9, Right=11) per 64px row height
FRAME_W, FRAME_H = 64, 64
lpc_rows = [10, 8, 9, 11]  # Down, Up, Left, Right
COLS = 9

walk_sheet = Image.new("RGBA", (FRAME_W * COLS, FRAME_H * 4))

for out_row, lpc_row in enumerate(lpc_rows):
    y0 = lpc_row * FRAME_H
    y1 = y0 + FRAME_H
    for col in range(COLS):
        x0 = col * FRAME_W
        x1 = x0 + FRAME_W
        frame = master.crop((x0, y0, x1, y1))
        walk_sheet.paste(frame, (col * FRAME_W, out_row * FRAME_H), frame)

walk_sheet.save("godot/assets/sprites/player_walk_cycle.png")

# Save 4x enlarged single frame for visual inspection
single_down_idle = walk_sheet.crop((0, 0, FRAME_W, FRAME_H))
preview = single_down_idle.resize((256, 256), Image.NEAREST)
preview.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_walk_cycle_preview.png")

# Print pixel content of head area (y=10-30 in frame 0)
print("\nHead region pixel check (frame 0, y=10-30):")
for y in range(10, 32):
    row_px = [single_down_idle.getpixel((x, y)) for x in range(FRAME_W) if single_down_idle.getpixel((x, y))[3] > 30]
    if row_px:
        colors = set((p[0]//50, p[1]//50, p[2]//50) for p in row_px)
        print(f"  y={y}: {len(row_px)} px, RGB palette: {list(colors)[:4]}")

print("DONE. Walk cycle saved!")
