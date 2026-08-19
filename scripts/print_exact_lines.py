with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Print lines 1966-2010 with exact repr
for i, line in enumerate(lines[1965:2011], start=1966):
    print(f"{i}: {repr(line)}")
