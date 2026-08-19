with open('godot/src/game2d/WorldMap2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# Add rich village decorations in generate_world()
old_furniture = '''\t# Производственные станки деревни и Доска Объявлений'''
new_decor = '''\t# Заборы пастбища и стога сена
\tfor px in range(12, 20):
\t\tstructure_tiles[Vector2i(px, 35)] = "wooden_fence"
\t\tstructure_tiles[Vector2i(px, 42)] = "wooden_fence"
\tfor py in range(36, 42):
\t\tstructure_tiles[Vector2i(12, py)] = "wooden_fence"
\t\tstructure_tiles[Vector2i(19, py)] = "wooden_fence"
\tstructure_tiles.erase(Vector2i(15, 35)) # Калитка пастбища

\t# Фонарные столбы вдоль дороги
\tfor ly in [18, 26, 34, 42]:
\t\t_spawn_furniture(Vector2i(30, ly), "candle_stand", "Уличный Фонарь 🕯️")
\t\t_spawn_furniture(Vector2i(33, ly), "candle_stand", "Уличный Фонарь 🕯️")

\t# Производственные станки деревни и Доска Объявлений'''

text = text.replace(old_furniture, new_decor, 1)

with open('godot/src/game2d/WorldMap2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("WorldMap2D.gd upgraded with fences, street lamps, and village decorations!")
