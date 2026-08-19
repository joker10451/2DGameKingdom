from PIL import Image

img = Image.open('godot/assets/sprites/player_walk_cycle.png')
print(f"Walk sheet size: {img.size}")

# Crop first 4 frames of Row 0 (Down), Row 1 (Up), Row 2 (Left), Row 3 (Right)
# Scale them up 4x with nearest neighbor so they are huge and super clear to see!
for row_idx, row_name in enumerate(['Down', 'Up', 'Left', 'Right']):
    frame_0 = img.crop((0, row_idx * 64, 64, (row_idx + 1) * 64))
    frame_0_big = frame_0.resize((256, 256), Image.NEAREST)
    out_path = f"C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/debug_frame_{row_name}.png"
    frame_0_big.save(out_path)
    print(f"Saved {out_path}")
