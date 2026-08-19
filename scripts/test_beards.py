import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    'beards/basic/adult/blonde.png',
    'beards/full/adult/blonde.png',
    'beards/stubble/adult/blonde.png',
    'beards/trimmed/adult/blonde.png',
    'beards/basic/adult/brown.png',
    'beards/full/adult/brown.png',
    'beards/stubble/adult/brown.png',
    'beards/trimmed/adult/brown.png',
    'beards/basic/adult/black.png',
    'beards/full/adult/black.png',
    'beards/stubble/adult/black.png',
    'beards/trimmed/adult/black.png'
]

found = []
for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            found.append(c)
            print(">>> FOUND BEARD:", c)
    except Exception:
        pass

print("Total beards found:", len(found))
