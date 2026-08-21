import os
from PIL import Image, ImageDraw

NPC_DIR = "godot/assets/sprites/npcs"

def draw_npc_weapon(draw, cx, cy, dir_idx, frame_idx, weapon_type):
    # Standard LPC row format: 0=Up, 1=Left, 2=Down, 3=Right
    steel = (215, 220, 230, 255)
    steel_edge = (255, 255, 255, 255)
    wood = (125, 75, 35, 255)
    iron = (70, 65, 75, 255)
    gold = (210, 170, 50, 255)
    shield_wood = (135, 80, 40, 255)
    shield_rim = (180, 185, 195, 255)
    
    if weapon_type == "spear_guard":
        # Royal Guard Spear + Shield
        if dir_idx == 2: # Down (Front)
            # Long spear in right hand
            draw.line([(cx + 12, cy - 16), (cx + 12, cy + 24)], fill=wood, width=2)
            draw.polygon([(cx + 12, cy - 24), (cx + 9, cy - 16), (cx + 15, cy - 16)], fill=steel)
            draw.point((cx + 12, cy - 25), fill=steel_edge)
            # Shield in left hand
            draw.ellipse([cx - 14, cy + 4, cx - 6, cy + 17], fill=shield_wood)
            draw.ellipse([cx - 14, cy + 4, cx - 6, cy + 17], outline=shield_rim, width=1)
            draw.point((cx - 10, cy + 10), fill=gold)
        elif dir_idx == 0: # Up (Back)
            draw.line([(cx + 12, cy - 16), (cx + 12, cy + 24)], fill=wood, width=2)
            draw.polygon([(cx + 12, cy - 24), (cx + 9, cy - 16), (cx + 15, cy - 16)], fill=steel)
            draw.ellipse([cx - 14, cy + 4, cx - 6, cy + 17], fill=shield_wood)
            draw.ellipse([cx - 14, cy + 4, cx - 6, cy + 17], outline=shield_rim, width=1)
        elif dir_idx == 1: # Left
            draw.line([(cx - 10, cy - 16), (cx - 10, cy + 24)], fill=wood, width=2)
            draw.polygon([(cx - 10, cy - 24), (cx - 13, cy - 16), (cx - 7, cy - 16)], fill=steel)
            draw.ellipse([cx + 2, cy + 4, cx + 9, cy + 16], fill=shield_wood)
            draw.ellipse([cx + 2, cy + 4, cx + 9, cy + 16], outline=shield_rim, width=1)
        elif dir_idx == 3: # Right
            draw.line([(cx + 10, cy - 16), (cx + 10, cy + 24)], fill=wood, width=2)
            draw.polygon([(cx + 10, cy - 24), (cx + 7, cy - 16), (cx + 13, cy - 16)], fill=steel)
            draw.ellipse([cx - 9, cy + 4, cx - 2, cy + 16], fill=shield_wood)
            draw.ellipse([cx - 9, cy + 4, cx - 2, cy + 16], outline=shield_rim, width=1)

    elif weapon_type == "bandit_weapons":
        # Bandit Hatchet / Dagger
        if dir_idx == 2: # Down
            draw.line([(cx + 12, cy + 8), (cx + 12, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx + 12, cy + 6, cx + 17, cy + 12], fill=steel)
            draw.line([(cx + 17, cy + 6), (cx + 17, cy + 12)], fill=steel_edge, width=1)
            draw.line([(cx - 12, cy + 10), (cx - 12, cy + 18)], fill=steel, width=1)
        elif dir_idx == 0: # Up
            draw.line([(cx + 12, cy + 8), (cx + 12, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx + 12, cy + 6, cx + 17, cy + 12], fill=steel)
        elif dir_idx == 1: # Left
            draw.line([(cx - 10, cy + 8), (cx - 10, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx - 15, cy + 6, cx - 10, cy + 12], fill=steel)
        elif dir_idx == 3: # Right
            draw.line([(cx + 10, cy + 8), (cx + 10, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx + 10, cy + 6, cx + 15, cy + 12], fill=steel)

    elif weapon_type == "blacksmith_hammer":
        # Blacksmith Hammer
        if dir_idx in [0, 2]: # Up / Down
            draw.line([(cx + 12, cy + 8), (cx + 12, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx + 8, cy + 6, cx + 16, cy + 11], fill=iron)
        elif dir_idx == 1: # Left
            draw.line([(cx - 10, cy + 8), (cx - 10, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx - 14, cy + 6, cx - 6, cy + 11], fill=iron)
        elif dir_idx == 3: # Right
            draw.line([(cx + 10, cy + 8), (cx + 10, cy + 22)], fill=wood, width=2)
            draw.rectangle([cx + 6, cy + 6, cx + 14, cy + 11], fill=iron)

    elif weapon_type == "peasant_pitchfork":
        # Pitchfork
        if dir_idx in [0, 2]: # Up / Down
            draw.line([(cx + 12, cy - 8), (cx + 12, cy + 24)], fill=wood, width=2)
            draw.line([(cx + 9, cy - 14), (cx + 9, cy - 8)], fill=iron, width=1)
            draw.line([(cx + 12, cy - 16), (cx + 12, cy - 8)], fill=iron, width=1)
            draw.line([(cx + 15, cy - 14), (cx + 15, cy - 8)], fill=iron, width=1)
        elif dir_idx == 1: # Left
            draw.line([(cx - 10, cy - 8), (cx - 10, cy + 24)], fill=wood, width=2)
            draw.line([(cx - 10, cy - 16), (cx - 10, cy - 8)], fill=iron, width=1)
        elif dir_idx == 3: # Right
            draw.line([(cx + 10, cy - 8), (cx + 10, cy + 24)], fill=wood, width=2)
            draw.line([(cx + 10, cy - 16), (cx + 10, cy - 8)], fill=iron, width=1)

def process_npc_sheet(filename, weapon_type):
    p = os.path.join(NPC_DIR, filename)
    if not os.path.exists(p): return
    im = Image.open(p).convert("RGBA")
    draw = ImageDraw.Draw(im)
    w, h = im.size
    cols = w // 64
    rows = h // 64
    for r in range(rows):
        for c in range(cols):
            x0 = c * 64
            y0 = r * 64
            draw_npc_weapon(draw, x0 + 32, y0 + 20, r, c, weapon_type)
    im.save(p)
    print(f"Equipped {weapon_type} on {filename}")

# Equip Guards
process_npc_sheet("npc_guard.png", "spear_guard")
process_npc_sheet("npc_guard_female.png", "spear_guard")

# Equip Bandits
process_npc_sheet("npc_bandit.png", "bandit_weapons")
process_npc_sheet("npc_bandit_female.png", "bandit_weapons")

# Equip Blacksmiths
process_npc_sheet("npc_blacksmith.png", "blacksmith_hammer")
process_npc_sheet("npc_blacksmith_female.png", "blacksmith_hammer")

# Equip Peasants
process_npc_sheet("npc_peasant_male.png", "peasant_pitchfork")
process_npc_sheet("npc_peasant_female.png", "peasant_pitchfork")

print("All NPC sprites equipped with authentic weapons in standard LPC rows!")
