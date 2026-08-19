from PIL import Image

im = Image.open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_down_single.png')

chars = " .:-=+*#%@"
ascii_art = []
for y in range(0, 64, 2):
    line = ""
    for x in range(16, 48):
        c = im.getpixel((x, y))
        if c[3] < 50:
            line += " "
        else:
            # Check if it is skin (high R, G, low B)
            if c[0] > 140 and c[1] > 100 and c[2] > 70 and abs(c[0] - c[1]) > 20:
                line += "F" # Face / Skin
            elif c[0] < 40 and c[1] < 40 and c[2] < 40:
                line += "H" # Black Hair
            elif abs(c[0] - c[1]) < 10 and abs(c[1] - c[2]) < 10:
                line += "S" # Steel Armor
            else:
                line += "#"
    ascii_art.append(f"{y:2d}: {line}")

print("\n".join(ascii_art))
