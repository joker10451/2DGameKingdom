import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

hair_types = ['afro', 'bangs', 'bedhead', 'braid', 'buzzcut', 'curly', 'curtains', 'dreadlocks', 'loose', 'messy', 'mohawk', 'page', 'parted', 'pixie', 'plain', 'ponytail', 'princess', 'shaved', 'short', 'single', 'spiked', 'straight', 'twist']
colors = ['black.png', 'brown.png', 'blonde.png', 'chestnut.png', 'dark_brown.png', 'gray.png', 'red.png', 'white.png']

found_hairs = []
for h in hair_types:
    for c in colors:
        url = BASE + f'hair/{h}/male/{c}'
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as resp:
                found_hairs.append(f'hair/{h}/male/{c}')
                print("FOUND HAIR:", f'hair/{h}/male/{c}')
                break
        except Exception:
            pass

print("Total found hair styles:", len(found_hairs))
