import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    # Hair
    'hair/plain/universal/brown.png',
    'hair/short/universal/brown.png',
    'hair/messy/universal/brown.png',
    'hair/page/universal/brown.png',
    'hair/plain/male/brown.png',
    'hair/short/male/brown.png',
    'hair/bedhead/universal/brown.png',
    'hair/curly/universal/brown.png',
    'hair/parted/universal/brown.png',
    'hair/spiked/universal/brown.png',
    'hair/loose/universal/brown.png',
    'hair/messy1/universal/brown.png',
    'hair/messy2/universal/brown.png',
    'hair/buzzcut/universal/brown.png',
    'hair/braid/universal/brown.png',
    
    # Eyes
    'eyes/human/male/blue.png',
    'eyes/human/universal/blue.png',
    'eyes/male/blue.png',
    'eyes/universal/blue.png',
    'eyes/blue.png',
    'eyes/eyes/male/blue.png',
    'eyes/eyes/universal/blue.png',
    
    # Helmet / Hat
    'hat/helmets/kettle/universal/steel.png',
    'hat/helmets/sallet/universal/steel.png',
    'hat/helmets/nasal/universal/steel.png',
    'hat/helmets/norman/universal/steel.png',
    'hat/helmets/kettle/male/steel.png',
    'hat/helmets/chainmail/male/gray.png',
    'hat/helmets/sallet/male/steel.png',
    
    # Weapon (Sword)
    'weapons/right_hand/male/sword.png',
    'weapons/right_hand/universal/sword.png',
    'weapons/left_hand/male/sword.png',
    'weapons/left_hand/universal/sword.png',
    'weapons/sword/arming/male/steel.png',
    'weapons/sword/arming/universal/steel.png',
    'weapon/sword/arming/universal/steel.png',
    'weapon/sword/arming/male/steel.png',
    
    # Shield
    'shield/heater/paint/universal/gray.png',
    'shield/heater/wood/universal.png',
    'shield/crusader/fg/universal/crusader.png'
]

for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print(">>> FOUND:", c)
    except Exception as e:
        pass
