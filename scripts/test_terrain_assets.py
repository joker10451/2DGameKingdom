import urllib.request
import json

BASE_URLS = [
    "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/",
    "https://raw.githubusercontent.com/wesnoth/wesnoth/master/data/core/images/terrain/",
    "https://raw.githubusercontent.com/OpenGameArt/LPC/master/"
]

test_files = [
    # LPC / OpenGameArt candidates
    "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/tilesets/terrain.png",
    "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/tilesets/trees.png",
    "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/tilesets/plants.png",
    "https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/tilesets/rocks.png",
]

found = []
for url in test_files:
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print("FOUND:", url)
            found.append(url)
    except Exception as e:
        print("404:", url)
