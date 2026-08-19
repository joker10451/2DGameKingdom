import urllib.request
import re

# Fetch the main README and CREDITS to find all file paths in the repo
readme_url = "https://raw.githubusercontent.com/ElizaWy/LPC/main/CREDITS.md"
req = urllib.request.Request(readme_url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as resp:
        txt = resp.read().decode('utf-8')
        print(f"CREDITS length: {len(txt)}")
        # Look for image filenames
        pngs = set(re.findall(r'[\w\-/\.]+\.png', txt))
        print("Found PNG mentions:", len(pngs))
        for p in sorted(list(pngs))[:30]:
            print(" ", p)
except Exception as e:
    print("Error:", e)
