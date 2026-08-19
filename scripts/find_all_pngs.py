import re

with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

# Find all occurrences of strings ending in .png anywhere in text
all_pngs = sorted(list(set(re.findall(r'[\w\-/]+\.png', text))))
print(f"Total .png matches across entire file: {len(all_pngs)}")
for p in all_pngs[:50]:
    print(p)
