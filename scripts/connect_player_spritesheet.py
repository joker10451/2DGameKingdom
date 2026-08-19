with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add direction and step variables
old_vars = '''var walk_anim_time: float = 0.0
var footstep_timer: float = 0.0'''
new_vars = '''var walk_anim_time: float = 0.0
var footstep_timer: float = 0.0
var player_direction_row: int = 0
var player_anim_step: float = 0.0'''
text = text.replace(old_vars, new_vars, 1)

# 2. Update _spawn_player()
old_spawn = '''func _spawn_player() -> void:

\tplayer_sprite = Sprite2D.new()

\tplayer_sprite.texture = SpriteGenerator2D.get_character_texture("Player", TILE_SIZE)

\tplayer_sprite.position = player_pos'''

new_spawn = '''func _spawn_player() -> void:

\tplayer_sprite = Sprite2D.new()

\tif ResourceLoader.exists("res://assets/sprites/player_walk_cycle.png"):
\t\tplayer_sprite.texture = load("res://assets/sprites/player_walk_cycle.png")
\t\tplayer_sprite.hframes = 9
\t\tplayer_sprite.vframes = 4
\t\tplayer_sprite.frame = 0
\telse:
\t\tplayer_sprite.texture = SpriteGenerator2D.get_character_texture("Player", TILE_SIZE)

\tplayer_sprite.position = player_pos'''
text = text.replace(old_spawn, new_spawn, 1)

# 3. Update walk cycle frame calculations in movement loop
old_walk_code = '''\t\t# Анимация походки: шаг, покачивание, разворот взгляда

\t\twalk_anim_time += delta * (14.0 if is_running else 9.5)

\t\tplayer_sprite.offset.y = sin(walk_anim_time) * -3.5

\t\tplayer_sprite.rotation_degrees = sin(walk_anim_time) * 4.0

\t\tfootstep_timer -= delta
\t\tif footstep_timer <= 0.0:
\t\t\tfootstep_timer = 0.28 if is_running else 0.40
\t\t\tvar cur_t = Vector2i(int(player_pos.x / TILE_SIZE), int(player_pos.y / TILE_SIZE))
\t\t\tvar g_t = world_map.ground_tiles.get(cur_t, "grass") if world_map else "grass"
\t\t\tif g_t in ["road", "stone_floor"]:
\t\t\t\t_play_sfx("sfx_step_stone")
\t\t\telse:
\t\t\t\t_play_sfx("sfx_step_grass")

\t\tif input.x != 0:

\t\t\tplayer_sprite.flip_h = (input.x < 0)'''

new_walk_code = '''\t\t# Анимация 4-направленной походки из спрайтшита
\t\tif abs(input.x) > abs(input.y):
\t\t\tif input.x < 0: player_direction_row = 2 # Влево
\t\t\telif input.x > 0: player_direction_row = 3 # Вправо
\t\telse:
\t\t\tif input.y > 0: player_direction_row = 0 # Вниз
\t\t\telif input.y < 0: player_direction_row = 1 # Вверх

\t\tplayer_anim_step += delta * (14.0 if is_running else 9.5)
\t\tvar cur_step_frame = (int(player_anim_step) % 8) + 1
\t\tif player_sprite.hframes == 9:
\t\t\tplayer_sprite.frame = player_direction_row * 9 + cur_step_frame
\t\t\tplayer_sprite.flip_h = false

\t\tfootstep_timer -= delta
\t\tif footstep_timer <= 0.0:
\t\t\tfootstep_timer = 0.28 if is_running else 0.40
\t\t\tvar cur_t = Vector2i(int(player_pos.x / TILE_SIZE), int(player_pos.y / TILE_SIZE))
\t\t\tvar g_t = world_map.ground_tiles.get(cur_t, "grass") if world_map else "grass"
\t\t\tif g_t in ["road", "stone_floor"]:
\t\t\t\t_play_sfx("sfx_step_stone")
\t\t\telse:
\t\t\t\t_play_sfx("sfx_step_grass")'''

text = text.replace(old_walk_code, new_walk_code, 1)

# 4. Update idle frame
old_idle = '''\t\twalk_anim_time = 0.0

\t\tplayer_sprite.rotation_degrees = lerpf(player_sprite.rotation_degrees, 0.0, delta * 10.0)

\t\tplayer_sprite.offset.y = sin(Time.get_ticks_msec() * 0.003) * -1.2'''

new_idle = '''\t\tplayer_anim_step = 0.0
\t\tif player_sprite.hframes == 9:
\t\t\tplayer_sprite.frame = player_direction_row * 9 # Кадр 0 - стойка покоя
\t\tplayer_sprite.rotation_degrees = 0.0
\t\tplayer_sprite.offset.y = 0.0'''

text = text.replace(old_idle, new_idle, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Player Walk Cycle Spritesheet connected cleanly into GameWorld2D.gd!")
