import re

with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

sources = re.findall(r'spritesheets/[^\"]+\.png', text)
print(f"Total spritesheet paths found in HTML: {len(sources)}")
unique = sorted(list(set(sources)))

for kw in ['body', 'hair', 'hat', 'torso', 'legs', 'feet', 'weapon', 'shield']:
    sample = [s for s in unique if f'/{kw}/' in s or s.startswith(f'spritesheets/{kw}/')][:6]
    print(f"\n--- {kw.upper()} ---")
    for s in sample:
        print(" ", s)
