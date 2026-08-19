import re
from collections import defaultdict

with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

pngs = sorted(list(set(re.findall(r'data-layer[^=\s>]*="([^"]+\.png)"', text))))
print(f"Total PNG layers: {len(pngs)}")

groups = defaultdict(list)
for p in pngs:
    top = p.split('/')[0]
    groups[top].append(p)

for top, items in sorted(groups.items()):
    print(f"\n[{top.upper()}] ({len(items)} items):")
    for item in items[:6]:
        print(" ", item)
