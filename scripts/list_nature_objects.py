import os

for sub in ["Terrain", "Objects", "Structure"]:
    dir_p = os.path.join("temp_lpc", sub)
    print(f"\n=== {sub} ===")
    for root, dirs, files in os.walk(dir_p):
        for f in files:
            if f.endswith(".png"):
                full_p = os.path.join(root, f)
                rel_p = os.path.relpath(full_p, dir_p)
                print(" ", rel_p)
