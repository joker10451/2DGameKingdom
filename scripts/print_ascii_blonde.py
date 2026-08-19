from PIL import Image

im = Image.open('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_blonde_front_view.png').resize((64, 64), Image.NEAREST)

ascii_art = []
for y in range(0, 64, 2):
    line = ""
    for x in range(16, 48):
        c = im.getpixel((x, y))
        if c[3] < 50:
            line += " "
        else:
            # Blonde Hair (high R, high G, low/med B)
            if c[0] > 180 and c[1] > 150 and c[2] < 120:
                line += "B" # Blonde Hair!
            # Skin / Face (high R, medium G, low B)
            elif c[0] > 170 and c[1] > 120 and c[2] > 90 and c[0] > c[2]:
                line += "F" # Face
            # Steel Plate (R approx G approx B)
            elif abs(c[0] - c[1]) < 15 and abs(c[1] - c[2]) < 15 and c[0] > 80:
                line += "S" # Steel
            # Pants / Teal
            elif c[1] > c[0] and c[2] > c[0]:
                line += "T" # Teal
            else:
                line += "#"
    ascii_art.append(f"{y:2d}: {line}")

print("\n".join(ascii_art))
