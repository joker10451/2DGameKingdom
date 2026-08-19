import urllib.request

test_urls = [
    "https://raw.githubusercontent.com/the-gorgon/lpc-style-guide/master/assets/tilesets/country.png",
    "https://raw.githubusercontent.com/the-gorgon/lpc-style-guide/master/assets/tilesets/dirt.png",
    "https://raw.githubusercontent.com/the-gorgon/lpc-style-guide/master/assets/tilesets/trees.png",
    "https://raw.githubusercontent.com/the-gorgon/lpc-style-guide/master/assets/tilesets/rocks.png",
    "https://raw.githubusercontent.com/the-gorgon/lpc-style-guide/master/assets/tilesets/water.png",
    # WorkAdventure / map-storage assets
    "https://raw.githubusercontent.com/the-coding-owl/workadventure-starter-kit/master/maps/tilesets/country.png",
    "https://raw.githubusercontent.com/the-coding-owl/workadventure-starter-kit/master/maps/tilesets/tree.png",
    "https://raw.githubusercontent.com/the-coding-owl/workadventure-starter-kit/master/maps/tilesets/dirt.png",
    # OpenGameArt LPC repo mirrors
    "https://raw.githubusercontent.com/Gamer2020/LPC/master/Tiles/country.png",
    "https://raw.githubusercontent.com/Gamer2020/LPC/master/Tiles/tree.png",
    "https://raw.githubusercontent.com/Gamer2020/LPC/master/Tiles/rocks.png",
    "https://raw.githubusercontent.com/Gamer2020/LPC/master/Tiles/dirt.png",
    "https://raw.githubusercontent.com/Gamer2020/LPC/master/Tiles/water.png",
    # Makrohn / LPC
    "https://raw.githubusercontent.com/makrohn/Universal-LPC-Spritesheet-Character-Generator/master/tilesets/country.png",
]

found = []
for u in test_urls:
    try:
        req = urllib.request.Request(u, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print(">>> FOUND:", u)
            found.append(u)
    except Exception as e:
        pass

print("Total found:", len(found))
