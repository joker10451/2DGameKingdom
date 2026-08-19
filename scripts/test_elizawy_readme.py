import urllib.request

candidates = [
    "https://raw.githubusercontent.com/ElizaWy/LPC/master/README.md",
    "https://raw.githubusercontent.com/ElizaWy/LPC/main/README.md",
]

for c in candidates:
    try:
        req = urllib.request.Request(c, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as resp:
            print("Found branch:", c)
            content = resp.read().decode('utf-8')
            print(content[:500])
    except Exception as e:
        print("Failed:", c, e)
