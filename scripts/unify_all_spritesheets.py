"""
Unify all character and NPC spritesheets to the Universal LPC Standard:
- Row 0 = UP (Back view / вид со спины)
- Row 1 = LEFT (Profile left / вид слева)
- Row 2 = DOWN (Front view / вид спереди)
- Row 3 = RIGHT (Profile right / вид справа)
"""

import os
import glob
from PIL import Image

NPC_DIR = "godot/assets/sprites/npcs"

# Old NPC layout from build_female_npcs.py was:
# Row 0: Down (LPC 10)
# Row 1: Up   (LPC 8)
# Row 2: Left (LPC 9)
# Row 3: Right(LPC 11)

# We want new layout:
# Row 0: Up    <- Old Row 1
# Row 1: Left  <- Old Row 2
# Row 2: Down  <- Old Row 0
# Row 3: Right <- Old Row 3

ROW_REORDER = {
    0: 1, # New Row 0 (Up) gets Old Row 1
    1: 2, # New Row 1 (Left) gets Old Row 2
    2: 0, # New Row 2 (Down) gets Old Row 0
    3: 3  # New Row 3 (Right) gets Old Row 3
}

npc_files = glob.glob(os.path.join(NPC_DIR, "*.png"))
print(f"Standardizing {len(npc_files)} NPC sheets to Universal LPC format (0=Up, 1=Left, 2=Down, 3=Right)...")

for fpath in npc_files:
    im = Image.open(fpath).convert("RGBA")
    if im.size != (576, 256):
        print(f"  Skipping {os.path.basename(fpath)} (size: {im.size})")
        continue

    new_sheet = Image.new("RGBA", (576, 256), (0, 0, 0, 0))
    for new_r, old_r in ROW_REORDER.items():
        old_strip = im.crop((0, old_r * 64, 576, (old_r + 1) * 64))
        new_sheet.paste(old_strip, (0, new_r * 64))

    new_sheet.save(fpath)
    print(f"  Standardized {os.path.basename(fpath)}")

print("\nSUCCESS: All NPC sheets now match the Universal LPC format!")
