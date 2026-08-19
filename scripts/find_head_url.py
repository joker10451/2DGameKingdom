import urllib.request

BASE = 'https://raw.githubusercontent.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets/'

candidates = [
    'head/heads/human_male/universal/light.png',
    'head/heads/human_male/light.png',
    'head/heads/male/light.png',
    'head/human_male/light.png',
    'head/male/light.png',
    'head/universal/light.png',
    'head/heads/human/universal/light.png',
    'head/heads/human/light.png',
    'head/heads/human/male/light.png',
    'head/heads/human_male/universal.png',
    'body/male/light.png',
    'body/bodies/male/light.png',
    'body/bodies/male/human.png',
    'body/bodies/male/human_male.png',
    'body/heads/male/light.png',
    'body/heads/human_male/light.png',
    'body/heads/light.png',
    'head/light.png',
    'head/heads/light.png'
]

for c in candidates:
    url = BASE + c
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print(">>> FOUND HEAD:", c)
    except Exception as e:
        pass
