import urllib.request
import json

base_api = "https://api.github.com/repos/ElizaWy/LPC/contents"
req = urllib.request.Request(base_api, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
        for item in data:
            print(f"{item['type']}: {item['name']} ({item['path']})")
except Exception as e:
    print("Error:", e)
