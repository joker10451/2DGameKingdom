import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    # Hair
    'hair/plain/adult/brown.png',
    'hair/short/adult/brown.png',
    'hair/messy/adult/brown.png',
    'hair/page/adult/brown.png',
    'hair/parted/adult/brown.png',
    'hair/spiked/adult/brown.png',
    'hair/loose/adult/brown.png',
    'hair/plain/brown.png',
    'hair/short/brown.png',
    'hair/messy/brown.png',
    'hair/plain/male/brown.png',
    'hair/afro/male/brown.png',
    'hair/afro/male/black.png',
    'hair/bangs/male/brown.png',
    
    # Eyes
    'eyes/adult/blue.png',
    'eyes/male/blue.png',
    'eyes/standard/blue.png',
    'eyes/standard/male/blue.png',
    
    # Beards
    'beards/basic/adult/brown.png',
    'beards/trimmed/adult/brown.png',
    'beards/full/adult/brown.png',
    'beards/stubble/adult/brown.png',
    'facial/beard/male/brown.png',
    
    # Armor / Torso
    'torso/armour/plate/male/steel.png',
    'torso/armour/plate/male/iron.png',
    'torso/clothes/tunic/male/blue.png',
    'torso/clothes/tunic/male/green.png',
    'torso/chainmail/male/gray.png',
    
    # Legs
    'legs/pants/male/brown.png',
    'legs/pants/male/teal.png',
    'legs/pants/male/black.png',
    
    # Feet
    'feet/boots/male/brown.png',
    'feet/boots/male/black.png',
    'feet/shoes/male/brown.png',
    
    # Head
    'head/heads/human/male/light.png'
]

found = []
for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            found.append(c)
            print(">>> FOUND:", c)
    except Exception as e:
        pass

print("\n--- ALL FOUND LAYERS ---")
for f in found:
    print(" ", f)
