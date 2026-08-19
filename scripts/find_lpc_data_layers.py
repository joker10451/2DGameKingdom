import re

with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

# Look for data-layer
matches = re.findall(r'data-layer[^=\s>]*="([^"]+)"', text)
print(f"Total data-layer values found: {len(matches)}")
for m in matches[:30]:
    print("Layer:", m)
