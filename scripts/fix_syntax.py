with open("godot/src/game2d/GameWorld2D.gd", "r", encoding="utf-8") as f:
    lines = f.readlines()

new_lines = []
skip_until_buy = False

for i, line in enumerate(lines):
    if 'of "Лесоруб", "Лесоруб-Плотник":' in line:
        new_lines.append('\t\t\t"Лесоруб", "Лесоруб-Плотник": prof = "woodcutter"\n')
        continue
    if 'it.get("category", "предмет").capitalize(),' in line:
        skip_until_buy = True
        continue
    if skip_until_buy:
        if 'func _buy_citizen_shop_item' in line:
            skip_until_buy = False
            new_lines.append('\n\n')
            new_lines.append(line)
        continue
    new_lines.append(line)

with open("godot/src/game2d/GameWorld2D.gd", "w", encoding="utf-8") as f:
    f.writelines(new_lines)

print("SUCCESS: Fixed GameWorld2D.gd syntax and removed leftover lines!")
