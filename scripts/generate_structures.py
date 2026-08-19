import os
from PIL import Image, ImageDraw

OUT_DIR = "godot/assets/sprites/world"
os.makedirs(OUT_DIR, exist_ok=True)

# 1. WOODEN FENCE (48x48)
fence = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
# Horizontal rails (y: 20..24, y: 32..36)
for y in range(20, 25):
    for x in range(48):
        fence.putpixel((x, y), (120, 75, 38, 255))
for y in range(32, 37):
    for x in range(48):
        fence.putpixel((x, y), (110, 68, 34, 255))
        
# Vertical fence posts (x: 4..10, x: 21..27, x: 38..44)
for px in [4, 21, 38]:
    for x in range(px, px + 7):
        for y in range(12, 46):
            # Pointed top tip
            if y < 16 and (x == px or x == px + 6):
                continue
            r, g, b = 145, 95, 52
            if x == px or x == px + 1:
                r += 25; g += 20; b += 15 # Light bevel
            elif x >= px + 5:
                r -= 30; g -= 25; b -= 20 # Shadow
            fence.putpixel((x, y), (r, g, b, 255))
            
fence.save(f"{OUT_DIR}/wooden_fence.png")
fence.save(f"{OUT_DIR}/tile_wooden_fence.png")

# 2. NOTICE BOARD (48x48)
board = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
# Two wooden posts
for x in range(8, 13):
    for y in range(10, 46):
        board.putpixel((x, y), (110, 70, 35, 255))
for x in range(35, 40):
    for y in range(10, 46):
        board.putpixel((x, y), (100, 65, 30, 255))
# Wood signboard
for y in range(10, 32):
    for x in range(4, 44):
        r, g, b = 155, 110, 65
        if x == 4 or y == 10: r += 25; g += 20; b += 15
        elif x == 43 or y == 31: r -= 30; g -= 25; b -= 20
        board.putpixel((x, y), (r, g, b, 255))
# Paper notices pinned on board
for px, py, pw, ph in [(8, 14, 12, 12), (24, 14, 14, 14)]:
    for y in range(py, py + ph):
        for x in range(px, px + pw):
            board.putpixel((x, y), (235, 225, 200, 255))
    board.putpixel((px + pw//2, py + 1), (180, 40, 40, 255)) # Red pin

board.save(f"{OUT_DIR}/notice_board.png")

# 3. LANTERN / CANDLE STAND (48x48)
lantern = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
# Wooden post
for x in range(22, 26):
    for y in range(16, 46):
        lantern.putpixel((x, y), (90, 55, 28, 255))
# Lantern box on top (x: 18..30, y: 8..20)
for y in range(8, 21):
    for x in range(18, 31):
        if x in [18, 30] or y in [8, 20]:
            lantern.putpixel((x, y), (50, 48, 52, 255)) # Wrought iron frame
        else:
            lantern.putpixel((x, y), (255, 220, 90, 230)) # Glowing glass
# Bright yellow center flame
lantern.putpixel((24, 14), (255, 255, 200, 255))
lantern.putpixel((24, 13), (255, 255, 220, 255))

lantern.save(f"{OUT_DIR}/candle_stand.png")
lantern.save(f"{OUT_DIR}/lantern.png")

print("SUCCESS: wooden_fence, notice_board, and candle_stand generated!")
