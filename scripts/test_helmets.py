import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    'hat/helmets/kettle/male/steel.png',
    'hat/helmets/sallet/male/steel.png',
    'hat/helmets/nasal/male/steel.png',
    'hat/helmets/norman/male/steel.png',
    'hat/helmets/chainmail/male/gray.png',
    'hat/helmets/greathelm/male/steel.png',
    'hat/helmets/horned/male/steel.png',
    'hat/helmets/knight/male/steel.png',
    'hat/helmets/spangenhelm/male/steel.png',
    'hat/caps/leather/male/brown.png',
    'hat/hoods/male/brown.png',
    'hat/hoods/male/blue.png',
    # Blonde hair / Chestnut hair
    'hair/bedhead/male/blonde.png',
    'hair/plain/male/blonde.png',
    'hair/plain/male/chestnut.png',
    'hair/bedhead/male/chestnut.png',
    'hair/bedhead/male/brown.png',
    'hair/parted/male/blonde.png',
    'hair/spiked/male/blonde.png'
]

found = []
for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            found.append(c)
            print(">>> FOUND HELMET/HAIR:", c)
    except Exception as e:
        pass

print("\nAll found:")
for f in found:
    print(f)
