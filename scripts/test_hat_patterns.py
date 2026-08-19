import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

hat_types = [
    'kettle', 'sallet', 'nasal', 'norman', 'greathelm', 'horned', 'armet', 'barbute',
    'hood', 'cap', 'bandana', 'coif', 'chainmail_coif', 'mail_coif', 'helmet', 'crown', 'tiara', 'circlet'
]
genders = ['male', 'adult', 'universal', '']
colors = ['steel.png', 'iron.png', 'gray.png', 'brown.png', 'black.png', 'gold.png']

found = []
for h in hat_types:
    for g in genders:
        for c in colors:
            sub = f"hat/{h}/{g}/{c}" if g else f"hat/{h}/{c}"
            url = BASE + sub
            try:
                req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
                with urllib.request.urlopen(req) as resp:
                    print(">>> FOUND HAT/HELMET:", sub)
                    found.append(sub)
                    break
            except Exception:
                pass

print("Total hats found:", len(found))
