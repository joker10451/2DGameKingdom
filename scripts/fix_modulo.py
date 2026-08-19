with open('godot/src/game2d/SpriteGenerator2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# Replace any float % int with int(x) % int or int(abs(...)) % int
text = text.replace('abs(x - cx) % 7 == 0', 'int(abs(x - cx)) % 7 == 0')
text = text.replace('x % 32 == 4', 'int(x) % 32 == 4')
text = text.replace('x % 32 == 28', 'int(x) % 32 == 28')

with open('godot/src/game2d/SpriteGenerator2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Fixed float modulo in SpriteGenerator2D.gd!")
