import urllib.request

test_paths = [
    "Tilesets/terrain.png",
    "Tilesets/trees.png",
    "Tilesets/plants.png",
    "Tilesets/country.png",
    "Tilesets/summer.png",
    "Tilesets/spring.png",
    "Tilesets/autumn.png",
    "Tilesets/winter.png",
    "Assets/terrain.png",
    "Assets/trees.png",
    "Assets/plants.png",
    "Assets/rocks.png",
    "tilesets/terrain.png",
    "tilesets/trees.png",
    "tilesets/plants.png",
    "tiles/terrain.png",
    "tiles/trees.png",
    "tiles/plants.png",
    "four-seasons/summer.png",
    "four-seasons/spring.png",
    "four-seasons/autumn.png",
    "four-seasons/winter.png",
    "summer.png",
    "spring.png",
    "autumn.png",
    "winter.png",
    "terrain.png",
    "trees.png",
    "plants.png",
    "rocks.png",
    "nature.png"
]

found = []
for p in test_paths:
    url = f"https://raw.githubusercontent.com/ElizaWy/LPC/main/{p}"
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print(">>> FOUND:", p)
            found.append(p)
    except Exception:
        pass

print("Total found in ElizaWy/LPC:", len(found))
