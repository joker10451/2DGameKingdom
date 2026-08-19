import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    'hat/helmets/chainmail/male/gray.png',
    'hat/helmets/norman/male/steel.png',
    'hat/helmets/kettle/male/steel.png',
    'hat/helmets/sallet/male/steel.png',
    'hat/cloth/hood/male/brown.png',
    'hat/cloth/hood/male/blue.png',
    'hat/cloth/bandana/male/red.png',
    'hat/cloth/cap/male/brown.png',
    'hat/leather/cap/male/brown.png',
    'hat/leather/helmet/male/brown.png',
    'hat/metal/helmet/male/steel.png',
    'headgear/helmets/male/steel.png',
    'head/hats/male/kettle.png',
    'head/hats/male/sallet.png',
    'hat/armour/kettle/male/steel.png',
    'hat/armour/sallet/male/steel.png',
    'hat/armour/plate/male/steel.png'
]

found = []
for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            found.append(c)
            print(">>> FOUND:", c)
    except Exception:
        pass

print("Total found:", len(found))
