import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    'eyes/adult/blue.png',
    'eyes/adult/brown.png',
    'eyes/standard/adult/blue.png',
    'eyes/human/adult/blue.png',
    'facial/eyebrows/male/blonde.png',
    'facial/eyebrows/male/black.png',
    'facial/eyebrows/male/brown.png',
    'beards/basic/male/blonde.png',
    'beards/full/male/blonde.png',
    'beards/stubble/male/blonde.png',
    'beards/trimmed/male/blonde.png',
    'beards/basic/male/black.png',
    'beards/full/male/black.png',
    'beards/stubble/male/black.png',
    'beards/trimmed/male/black.png'
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
