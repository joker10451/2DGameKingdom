import os
from PIL import Image, ImageDraw, ImageEnhance

LPC_DIR = "godot/assets/lpc/raw"
OUT_DIR = "godot/assets/lpc/composite"
os.makedirs(OUT_DIR, exist_ok=True)

# 1. COMPOSITE HERO (Body + Chainmail Armor + Brown Hair + Pants & Boots)
for state in ["idle", "walk", "slash", "hurt"]:
    body_path = os.path.join(LPC_DIR, f"male_{state}.png")
    armor_path = os.path.join(LPC_DIR, f"torso_chainmail_male_{state}.png")
    if not os.path.exists(body_path):
        continue
        
    body_im = Image.open(body_path).convert("RGBA")
    
    # Composite chainmail armor if available
    if os.path.exists(armor_path):
        armor_im = Image.open(armor_path).convert("RGBA")
        body_im.alpha_composite(armor_im)
        
    # Draw leather pants (dark brown below waist) & boots on the body
    # Draw medieval hero hair & brown tunic trim
    d = ImageDraw.Draw(body_im)
    w, h = body_im.size
    cols = w // 64
    rows = h // 64
    
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            # Add hair on head (y: y0+12 to y0+20)
            if state != "hurt":
                # Brown hair cap
                if r == 0: # Back
                    d.rectangle([x0 + 26, y0 + 10, x0 + 37, y0 + 22], fill=(85, 50, 25, 255))
                elif r == 1: # Left
                    d.rectangle([x0 + 26, y0 + 10, x0 + 35, y0 + 18], fill=(85, 50, 25, 255))
                elif r == 2: # Front
                    d.rectangle([x0 + 26, y0 + 10, x0 + 37, y0 + 18], fill=(85, 50, 25, 255))
                    d.rectangle([x0 + 26, y0 + 18, x0 + 28, y0 + 22], fill=(85, 50, 25, 255)) # Left lock
                    d.rectangle([x0 + 35, y0 + 18, x0 + 37, y0 + 22], fill=(85, 50, 25, 255)) # Right lock
                elif r == 3: # Right
                    d.rectangle([x0 + 28, y0 + 10, x0 + 37, y0 + 18], fill=(85, 50, 25, 255))
                    
    body_im.save(os.path.join(OUT_DIR, f"hero_{state}.png"))
    print(f"Saved hero_{state}.png")

# 2. SKELETON WITH GLOWING RED EYES (skel_idle, walk, slash, hurt)
for state in ["idle", "walk", "slash", "hurt"]:
    skel_path = os.path.join(LPC_DIR, f"skel_{state}.png")
    if not os.path.exists(skel_path):
        continue
    skel_im = Image.open(skel_path).convert("RGBA")
    d = ImageDraw.Draw(skel_im)
    w, h = skel_im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            # Add glowing red eyes on front & side faces
            if r == 2: # Front
                d.rectangle([x0 + 29, y0 + 18, x0 + 31, y0 + 20], fill=(255, 30, 30, 255))
                d.rectangle([x0 + 33, y0 + 18, x0 + 35, y0 + 20], fill=(255, 30, 30, 255))
            elif r == 1: # Left
                d.rectangle([x0 + 27, y0 + 18, x0 + 29, y0 + 20], fill=(255, 30, 30, 255))
            elif r == 3: # Right
                d.rectangle([x0 + 34, y0 + 18, x0 + 36, y0 + 20], fill=(255, 30, 30, 255))
                
    skel_im.save(os.path.join(OUT_DIR, f"skel_{state}.png"))
    print(f"Saved skel_{state}.png")

# 3. BOSS MALGRIM (Dark Armor + Purple Eyes + Horned Helm + Crimson Cape)
for state in ["idle", "walk", "slash", "hurt"]:
    skel_path = os.path.join(LPC_DIR, f"skel_{state}.png")
    armor_path = os.path.join(LPC_DIR, f"torso_chainmail_male_{state}.png")
    if not os.path.exists(skel_path):
        continue
    skel_im = Image.open(skel_path).convert("RGBA")
    
    if os.path.exists(armor_path):
        armor_im = Image.open(armor_path).convert("RGBA")
        # Dark obsidian tint for armor
        enhancer = ImageEnhance.Brightness(armor_im)
        armor_dark = enhancer.enhance(0.4)
        skel_im.alpha_composite(armor_dark)
        
    d = ImageDraw.Draw(skel_im)
    w, h = skel_im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            # Add Horned Dark Helm & Purple Eyes
            d.polygon([(x0 + 26, y0 + 12), (x0 + 20, y0 + 4), (x0 + 28, y0 + 8)], fill=(180, 25, 45, 255)) # Horn left
            d.polygon([(x0 + 37, y0 + 12), (x0 + 43, y0 + 4), (x0 + 35, y0 + 8)], fill=(180, 25, 45, 255)) # Horn right
            if r == 2: # Front
                d.rectangle([x0 + 28, y0 + 18, x0 + 35, y0 + 20], fill=(220, 40, 255, 255)) # Violet visor
            elif r == 1: # Left
                d.rectangle([x0 + 26, y0 + 18, x0 + 30, y0 + 20], fill=(220, 40, 255, 255))
            elif r == 3: # Right
                d.rectangle([x0 + 33, y0 + 18, x0 + 37, y0 + 20], fill=(220, 40, 255, 255))
                
    skel_im.save(os.path.join(OUT_DIR, f"boss_{state}.png"))
    print(f"Saved boss_{state}.png")

print("LPC composite characters generated successfully!")
