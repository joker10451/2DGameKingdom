with open('godot/src/game2d/WorldMap2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add texture preloads
old_top = '''signal tile_changed(pos: Vector2i)
signal node_harvested(pos: Vector2i, item_id: String, amount: int)'''

new_top = '''signal tile_changed(pos: Vector2i)
signal node_harvested(pos: Vector2i, item_id: String, amount: int)

# Фотореалистичные пререндеренные спрайты из Poly Haven 3D
var tex_fort_wall: Texture2D = preload("res://assets/sprites/fort_wall.png")
var tex_fort_tower: Texture2D = preload("res://assets/sprites/fort_tower.png")
var tex_fort_gate: Texture2D = preload("res://assets/sprites/fort_gate.png")
var tex_lantern: Texture2D = preload("res://assets/sprites/lantern.png")'''

text = text.replace(old_top, new_top, 1)

# 2. Update _draw in WorldMap2D.gd
old_draw = '''\t\t\t# 2. Стены
\t\t\tif structure_tiles.has(pos):
\t\t\t\tvar s_type = structure_tiles[pos]
\t\t\t\tvar s_tex = SpriteGenerator2D.get_tile_texture(s_type, TILE_SIZE)
\t\t\t\tdraw_texture(s_tex, world_pos)
\t\t\t
\t\t\t# 3. Интерактивные объекты и мебель (Pixel-Art спрайты с тенями)
\t\t\tif interactive_nodes.has(pos):
\t\t\t\tvar node = interactive_nodes[pos]
\t\t\t\tvar n_type = node.get("type", "chest")
\t\t\t\tif n_type == "door":
\t\t\t\t\tn_type = "door_open" if node.get("is_open", false) else "door_closed"
\t\t\t\t
\t\t\t\t# Мягкая тень под объектом (не рисуем для колосьев на грядке)
\t\t\t\tif n_type != "crop_wheat":
\t\t\t\t\tvar shadow_tex = SpriteGenerator2D.get_shadow_texture(18, 8)
\t\t\t\tdraw_texture(shadow_tex, world_pos + Vector2(6, 28))
\t\t\t\t
\t\t\t\t# Текстура объекта
\t\t\t\tvar n_tex = SpriteGenerator2D.get_node_texture(n_type, TILE_SIZE)
\t\t\t\tdraw_texture(n_tex, world_pos)'''

new_draw = '''\t\t\t# 2. Стены
\t\t\tif structure_tiles.has(pos):
\t\t\t\tvar s_type = structure_tiles[pos]
\t\t\t\tif s_type == "wall_stone" and tex_fort_wall:
\t\t\t\t\tdraw_texture_rect(tex_fort_wall, Rect2(world_pos, Vector2(TILE_SIZE, TILE_SIZE)), false)
\t\t\t\telse:
\t\t\t\t\tvar s_tex = SpriteGenerator2D.get_tile_texture(s_type, TILE_SIZE)
\t\t\t\t\tdraw_texture(s_tex, world_pos)
\t\t\t
\t\t\t# 3. Интерактивные объекты и мебель (Pixel-Art спрайты с тенями)
\t\t\tif interactive_nodes.has(pos):
\t\t\t\tvar node = interactive_nodes[pos]
\t\t\t\tvar n_type = node.get("type", "chest")
\t\t\t\tif n_type == "door":
\t\t\t\t\tn_type = "door_open" if node.get("is_open", false) else "door_closed"
\t\t\t\t
\t\t\t\t# Мягкая тень под объектом (не рисуем для колосьев на грядке)
\t\t\t\tif n_type != "crop_wheat":
\t\t\t\t\tvar shadow_tex = SpriteGenerator2D.get_shadow_texture(18, 8)
\t\t\t\t\tdraw_texture(shadow_tex, world_pos + Vector2(6, 28))
\t\t\t\t
\t\t\t\t# Текстура объекта: фотореалистичные пререндеры или процедурные
\t\t\t\tif n_type in ["candle_stand", "lantern"] and tex_lantern:
\t\t\t\t\tdraw_texture_rect(tex_lantern, Rect2(world_pos, Vector2(TILE_SIZE, TILE_SIZE)), false)
\t\t\t\telif n_type in ["door", "door_closed"] and tex_fort_gate:
\t\t\t\t\tdraw_texture_rect(tex_fort_gate, Rect2(world_pos, Vector2(TILE_SIZE, TILE_SIZE)), false)
\t\t\t\telse:
\t\t\t\t\tvar n_tex = SpriteGenerator2D.get_node_texture(n_type, TILE_SIZE)
\t\t\t\t\tdraw_texture(n_tex, world_pos)'''

text = text.replace(old_draw, new_draw, 1)

with open('godot/src/game2d/WorldMap2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print('Successfully patched WorldMap2D.gd with Poly Haven rendered textures!')
