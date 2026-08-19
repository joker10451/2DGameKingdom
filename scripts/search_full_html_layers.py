import re

with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

print(f"Total file size read: {len(text)} characters")

# Find all occurrences of "head" in attributes
heads = re.findall(r'data-layer[^=\s>]*="([^"]*head[^"]*)"', text)
print(f"Found {len(heads)} head data-layers:")
for h in heads[:20]:
    print(" ", h)

# Find all occurrences of "hair" in attributes
hairs = re.findall(r'data-layer[^=\s>]*="([^"]*hair[^"]*)"', text)
print(f"\nFound {len(hairs)} hair data-layers:")
for h in hairs[:20]:
    print(" ", h)

# Find all occurrences of "helmet" or "hat"
hats = re.findall(r'data-layer[^=\s>]*="([^"]*hat[^"]*)"', text)
print(f"\nFound {len(hats)} hat data-layers:")
for h in hats[:20]:
    print(" ", h)
