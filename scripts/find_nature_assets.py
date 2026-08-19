import os

print("=== Terrain Files ===")
for f in os.listdir("temp_lpc/Terrain"):
    print(" ", f)

print("\n=== Nature / Objects with Tree / Plant / Rock / Ore / Flower ===")
for root, dirs, files in os.walk("temp_lpc"):
    for f in files:
        low = f.lower()
        if any(k in low for k in ["tree", "plant", "rock", "ore", "flower", "grass", "dirt", "wood", "wheat", "mushroom", "bush"]):
            print(" ", os.path.relpath(os.path.join(root, f), "temp_lpc"))
