import urllib.request
import json

urls_to_test = [
    # Makrohn's Universal LPC Spritesheet Character Generator assets
    "https://raw.githubusercontent.com/makrohn/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/tilesets/country.png",
    # Lanea Zimmerman (Sharm) / OpenGameArt LPC Terrain:
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/country.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/barrel.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/chest.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/cave.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/water.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/grass.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/rocks.png",
    "https://raw.githubusercontent.com/solar-us/lpc-base-assets/master/tiles/trees.png",
    # OpenGameArt LPC official repo:
    "https://raw.githubusercontent.com/makrohn/Universal-LPC-Spritesheet-Character-Generator/master/tilesets/country.png",
    # Kenney / Stardew-like open assets:
    "https://raw.githubusercontent.com/KenneyNL/Pixel-Platformer/master/Tiles/tiles_packed.png",
    "https://raw.githubusercontent.com/KenneyNL/Tiny-Town/master/Tilesheet/tiles_packed.png"
]

found = []
for u in urls_to_test:
    try:
        req = urllib.request.Request(u, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print(">>> FOUND:", u)
            found.append(u)
    except Exception:
        pass

print("Total found:", len(found))
