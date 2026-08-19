# Update WorldMap2D.gd to place Stone Fortification Outpost and Lanterns
with open('godot/src/game2d/WorldMap2D.gd', 'r', encoding='utf-8') as f:
    map_text = f.read()

old_map_spawns = '''\t# Производственные станки деревни и Доска Объявлений
\t_spawn_furniture(Vector2i(23, 21), "alarm_bell", "🔔 Тревожный Колокол Олдерии")'''

new_map_spawns = '''\t# Каменные фортификации и уличные фонари (Poly Haven)
\tfor wx in range(21, 30):
\t\tstructure_tiles[Vector2i(wx, 19)] = "wall_stone"
\tstructure_tiles[Vector2i(21, 20)] = "wall_stone"
\tstructure_tiles[Vector2i(29, 20)] = "wall_stone"
\t_spawn_furniture(Vector2i(25, 19), "door", "Крепостные Ворота 🏰")
\t_spawn_furniture(Vector2i(22, 21), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(28, 21), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(25, 27), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(31, 31), "lantern", "Кованый Фонарь 🕯️")

\t# Производственные станки деревни и Доска Объявлений
\t_spawn_furniture(Vector2i(23, 21), "alarm_bell", "🔔 Тревожный Колокол Олдерии")'''

map_text = map_text.replace(old_map_spawns, new_map_spawns)

with open('godot/src/game2d/WorldMap2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(map_text)

print("WorldMap2D.gd updated successfully with stone fortifications and lanterns!")
