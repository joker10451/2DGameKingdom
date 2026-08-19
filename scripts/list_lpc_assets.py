import os

root_dir = "temp_lpc"
found_categories = {}

for root, dirs, files in os.walk(root_dir):
    for f in files:
        if f.endswith(".png"):
            full_p = os.path.join(root, f)
            rel_p = os.path.relpath(full_p, root_dir)
            parts = rel_p.split(os.sep)
            cat = parts[0] if len(parts) > 1 else "root"
            found_categories.setdefault(cat, []).append(rel_p)

print("Categories and sample PNG counts:")
for cat, flist in sorted(found_categories.items()):
    print(f"[{cat}] ({len(flist)} pngs)")
    for p in flist[:5]:
        print("  ", p)
