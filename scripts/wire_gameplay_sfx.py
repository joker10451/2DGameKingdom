with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add footstep timer variable
old_vars = '''var walk_anim_time: float = 0.0'''
new_vars = '''var walk_anim_time: float = 0.0
var footstep_timer: float = 0.0'''
text = text.replace(old_vars, new_vars, 1)

# 2. Add footsteps in movement loop
old_move_code = '''\t\twalk_anim_time += delta * (14.0 if is_running else 9.5)

\t\tplayer_sprite.offset.y = sin(walk_anim_time) * -3.5

\t\tplayer_sprite.rotation_degrees = sin(walk_anim_time) * 4.0'''

new_move_code = '''\t\twalk_anim_time += delta * (14.0 if is_running else 9.5)

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
\t\t\t\t_play_sfx("sfx_step_grass")'''

text = text.replace(old_move_code, new_move_code, 1)

# 3. Add swing, mining, chopping, farming sounds in attack
old_attack = '''\t\t\tif res.get("destroyed", false):'''
new_attack = '''\t\t\tif skill_key == "mining":
\t\t\t\t_play_sfx("sfx_pickaxe")
\t\t\telif skill_key == "farming":
\t\t\t\t_play_sfx("sfx_harvest")
\t\t\telse:
\t\t\t\t_play_sfx("sfx_chop")

\t\t\tif res.get("destroyed", false):'''
text = text.replace(old_attack, new_attack, 1)

# 4. Add swing sound when attacking
old_swing = '''\t# Анимация выпада игрока в сторону курсора'''
new_swing = '''\t_play_sfx("sfx_sword_swing")
\t# Анимация выпада игрока в сторону курсора'''
text = text.replace(old_swing, new_swing, 1)

# 5. Add door sound in toggle_door
old_door = '''\t\t\t\tvar is_open = world_map.toggle_door(t_pos)'''
new_door = '''\t\t\t\tvar is_open = world_map.toggle_door(t_pos)
\t\t\t\t_play_sfx("sfx_door_open")'''
text = text.replace(old_door, new_door, 1)

# 6. Add parchment sound on modal open
old_modals = '''func _open_dialogue(npc_index: int) -> void:'''
new_modals = '''func _open_dialogue(npc_index: int) -> void:
\t_play_sfx("sfx_parchment")'''
text = text.replace(old_modals, new_modals, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Gameplay SFX wired cleanly into GameWorld2D.gd!")
