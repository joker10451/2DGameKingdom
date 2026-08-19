import os
import math
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

def cl(v, lo=0, hi=255):
    return max(lo, min(hi, int(v)))

# =========================================================================
# 1. MAJESTIC HAND-CRAFTED OAK TREE (48x48)
# =========================================================================
def make_oak_tree():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(im)
    
    # 1. Dark Root / Trunk base
    # Trunk: x: 21..27, y: 26..45
    for y in range(26, 46):
        w = 3 if y < 38 else (4 if y < 43 else 5)
        for x in range(24 - w, 24 + w + 1):
            # Wood grain shading: light left, shadow right
            pct = (x - (24 - w)) / float(w * 2 + 1)
            base = 110 - pct * 55 + ((x * 3 + y * 7) % 8)
            im.putpixel((x, y), (cl(base * 1.1), cl(base * 0.7), cl(base * 0.4), 255))
            
    # Roots touching ground
    for rx, ry in [(18, 44), (19, 44), (17, 45), (18, 45), (19, 45), (28, 44), (29, 44), (28, 45), (29, 45), (30, 45)]:
        im.putpixel((rx, ry), (60, 36, 18, 255))

    # 2. Volumetric Leafy Canopy (Layered puffs)
    # Background shadow puff (y: 10..32, x: 8..40)
    puffs = [
        # (cx, cy, rx, ry, base_color_light)
        (24, 18, 16, 15), # Main volume
        (16, 19, 11, 10), # Left lobe
        (32, 19, 11, 10), # Right lobe
        (24, 11, 12, 9),  # Top crown
        (18, 26, 9, 7),   # Bottom left foliage
        (30, 26, 9, 7),   # Bottom right foliage
    ]
    
    for y in range(48):
        for x in range(48):
            # Check canopy coverage
            inside = False
            best_val = -999.0
            for cx, cy, rx, ry in puffs:
                dx = (x - cx) / float(rx)
                dy = (y - cy) / float(ry)
                d = math.sqrt(dx * dx + dy * dy)
                if d <= 1.0:
                    inside = True
                    # Directional shading: Top-Left light
                    light = -dx * 0.6 - dy * 0.8
                    best_val = max(best_val, light - (d * 0.5))
            
            if inside:
                # Lush emerald palette with leaf cluster texturing
                tex = math.sin(x * 0.75 + y * 0.85) * 12.0
                g = cl(135 + best_val * 70 + tex)
                r = cl(g * 0.52)
                b = cl(g * 0.28)
                im.putpixel((x, y), (r, g, b, 255))
                
    return im


# =========================================================================
# 2. PINE / SPRUCE EVERGREEN TREE (48x48)
# =========================================================================
def make_pine_tree():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # Trunk
    for y in range(36, 46):
        for x in range(22, 26):
            im.putpixel((x, y), (85, 48, 22, 255))
            
    # Tiers of pine needles (Top to bottom)
    tiers = [
        (24, 4, 14, 7),   # Tier 1 (top)
        (24, 11, 22, 11), # Tier 2
        (24, 18, 30, 15), # Tier 3
        (24, 26, 38, 19), # Tier 4 (base)
    ]
    for cx, ty, by, max_w in tiers:
        h = by - ty
        for y in range(ty, by + 1):
            t = (y - ty) / float(h)
            w = int(t * max_w)
            for x in range(cx - w, cx + w + 1):
                if 0 <= x < 48 and 0 <= y < 48:
                    pct = (x - (cx - w)) / float(w * 2 + 1)
                    # Sunlight on left, dark forest green on right
                    light = (1.0 - pct) * 0.8 + (1.0 - t) * 0.4
                    g = cl(90 + light * 75 + ((x * 7 + y * 13) % 9))
                    r = cl(g * 0.32)
                    b = cl(g * 0.42)
                    im.putpixel((x, y), (r, g, b, 255))
    return im


# =========================================================================
# 3. BIRCH TREE (48x48)
# =========================================================================
def make_birch_tree():
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    # White birch trunk
    for y in range(25, 46):
        for x in range(22, 26):
            r, g, b = 230, 228, 220
            # Black notches
            if (y == 28 and x in [22, 23]) or (y == 34 and x in [24, 25]) or (y == 40 and x in [23, 24]):
                r, g, b = 40, 40, 42
            im.putpixel((x, y), (r, g, b, 255))
            
    # Lighter sunny yellow-green canopy
    puffs = [
        (24, 16, 14, 13),
        (17, 18, 9, 9),
        (31, 18, 9, 9),
        (24, 9, 10, 8),
    ]
    for y in range(48):
        for x in range(48):
            inside = False
            best_val = -999.0
            for cx, cy, rx, ry in puffs:
                dx = (x - cx) / float(rx)
                dy = (y - cy) / float(ry)
                d = math.sqrt(dx * dx + dy * dy)
                if d <= 1.0:
                    inside = True
                    light = -dx * 0.6 - dy * 0.8
                    best_val = max(best_val, light - (d * 0.5))
            if inside:
                g = cl(160 + best_val * 60 + ((x * 5 + y * 7) % 11))
                r = cl(g * 0.75)
                b = cl(g * 0.3)
                im.putpixel((x, y), (r, g, b, 255))
    return im


# =========================================================================
# 4. CRISP PIXEL-ART ROCK BOULDER & ORES (48x48)
# =========================================================================
def make_clean_boulder(ore_type=None):
    im = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    
    # Smooth, rounded chiseled boulder base polygon (x: 8..40, y: 16..42)
    # Defined by rounded ellipse with cut facets
    cx, cy = 24, 29
    rx, ry = 16, 13
    
    for y in range(48):
        for x in range(48):
            dx = (x - cx) / float(rx)
            dy = (y - cy) / float(ry)
            d = math.sqrt(dx * dx + dy * dy)
            
            # Bottom flattening (ground contact)
            if dy > 0.65:
                d = math.sqrt(dx * dx + ((y - (cy + 4)) / float(ry * 0.6))**2)
                
            if d <= 1.0:
                # Top-Left illumination
                light = -dx * 0.65 - dy * 0.75
                
                # Facet shading: 3 distinct facets (Top-lit facet, Mid-tone face, Bottom-shadow face)
                if dy < -0.2:
                    # Top facet (brightest)
                    base = 165 + light * 40
                elif dx > 0.15:
                    # Right shadow face
                    base = 95 + light * 30
                else:
                    # Front face
                    base = 130 + light * 35
                    
                base += ((x * 7 + y * 13) % 9) - 4
                
                r = cl(base * 1.02)
                g = cl(base * 0.98)
                b = cl(base * 1.05)
                
                # Outline border
                if d > 0.90:
                    r = cl(r * 0.55); g = cl(g * 0.55); b = cl(b * 0.6)
                elif d > 0.80 and dx < -0.1 and dy < -0.1:
                    # Highlight rim
                    r = cl(r * 1.25); g = cl(g * 1.25); b = cl(b * 1.25)
                    
                im.putpixel((x, y), (r, g, b, 255))
                
    # ORE VEINS (embedded shimmering crystal nuggets)
    if ore_type:
        vein_clusters = [
            [(18, 24), (19, 24), (20, 25), (19, 25)],
            [(26, 22), (27, 22), (28, 23), (27, 23)],
            [(22, 30), (23, 30), (24, 31), (23, 31)],
            [(15, 29), (16, 29)],
            [(31, 27), (32, 28)],
        ]
        
        for cluster in vein_clusters:
            for vx, vy in cluster:
                if ore_type == "iron":
                    col_main = (125, 195, 245, 255)
                    col_shine = (235, 250, 255, 255)
                elif ore_type == "gold":
                    col_main = (250, 205, 45, 255)
                    col_shine = (255, 248, 155, 255)
                elif ore_type == "copper":
                    col_main = (235, 125, 60, 255)
                    col_shine = (255, 195, 140, 255)
                elif ore_type == "coal":
                    col_main = (30, 30, 38, 255)
                    col_shine = (85, 90, 110, 255)
                    
                im.putpixel((vx, vy), col_main)
            # Top-left of cluster gets specular sparkle
            im.putpixel(cluster[0], col_shine)
            
    return im


# Save clean assets
oak = make_oak_tree()
oak.save(f"{OUT_DIR}/tree.png")
oak.save(f"{OUT_DIR}/tree_oak.png")

birch = make_birch_tree()
birch.save(f"{OUT_DIR}/tree_birch.png")

pine = make_pine_tree()
pine.save(f"{OUT_DIR}/tree_pine.png")

rock = make_clean_boulder(None)
rock.save(f"{OUT_DIR}/rock.png")
rock.save(f"{OUT_DIR}/stone.png")

iron = make_clean_boulder("iron")
iron.save(f"{OUT_DIR}/ore_iron.png")

gold = make_clean_boulder("gold")
gold.save(f"{OUT_DIR}/ore_gold.png")

copper = make_clean_boulder("copper")
copper.save(f"{OUT_DIR}/ore_copper.png")

coal = make_clean_boulder("coal")
coal.save(f"{OUT_DIR}/ore_coal.png")

# Showcase strip
strip = Image.new("RGBA", (48 * 8, 48), (35, 45, 30, 255))
items = [oak, birch, pine, rock, iron, gold, copper, coal]
for i, item in enumerate(items):
    strip.paste(item, (i * 48, 0), item)
strip.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/clean_nature_strip.png")

print("SUCCESS: Masterpiece trees and boulders generated!")
