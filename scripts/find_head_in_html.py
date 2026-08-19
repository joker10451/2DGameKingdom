with open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/.system_generated/steps/5432/content.md', 'r', encoding='utf-8') as f:
    text = f.read()

lines = text.splitlines()
for i, line in enumerate(lines):
    if 'Human_Male' in line or 'name="head"' in line or 'id="head' in line or 'head/heads' in line:
        for j in range(max(0, i-2), min(len(lines), i+6)):
            print(f"{j}: {lines[j]}")
        print("---")
