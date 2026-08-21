p = 'godot/src/game2d/GameWorld2D.gd'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

start_marker = '\t# 2. Поведение NPC и агрессивных разбойников'
end_marker = '\t# 4. Поведение дикой фауны (волки, вепри, олени, скелеты)'

idx1 = content.find(start_marker)
idx2 = content.find(end_marker)
assert idx1 != -1 and idx2 != -1, f'Markers not found! {idx1}, {idx2}'

npc_call = '\t# 2. Поведение NPC и агрессивных разбойников (только на поверхности)\n\tif not is_in_dungeon and not is_overworld_mode:\n\t\t_update_surface_npcs(delta)\n\n'

func_def = """
func _update_surface_npcs(delta: float) -> void:
\tfor i in npc_data.size():
\t\tvar npc = npc_data[i]
\t\tif npc.get("is_dead", false):
\t\t\tcontinue
\t\tvar spr = npc_sprites[i]
\t\tvar cur_p = npc_positions[i]

\t\tif npc["role"] in ["Бандит", "Разбойник"]:
\t\t\tvar d_p = cur_p.distance_to(player_pos)
\t\t\tif d_p < 140.0 and d_p > 45.0:
\t\t\t\tvar dir = (player_pos - cur_p).normalized()
\t\t\t\tcur_p += dir * 100.0 * delta
\t\t\t\tnpc_positions[i] = cur_p
\t\t\t\tspr.position = cur_p
\t\t\t\tnpc["thought"] = "⚔️"
\t\t\telif d_p <= 45.0 and attack_cooldown <= 0.0:
\t\t\t\t_bandit_attack_player(i)
\t\telse:
\t\t\tvar idle_t: float = npc.get("idle_timer", 0.0) - delta
\t\t\tnpc["idle_timer"] = idle_t
\t\t\tif idle_t <= 0.0:
\t\t\t\tvar home: Vector2i = npc.get("home_tile", Vector2i(27, 30))
\t\t\t\tvar target_tile = home + Vector2i(randi_range(-3, 3), randi_range(-3, 3))
\t\t\t\tif world_map.can_walk(target_tile):
\t\t\t\t\tnpc["target_pos"] = Vector2(target_tile.x * TILE_SIZE + TILE_SIZE/2.0, target_tile.y * TILE_SIZE + TILE_SIZE/2.0)
\t\t\t\t\tnpc["idle_timer"] = randf_range(4.0, 9.0)
\t\t\t\telse:
\t\t\t\t\tnpc["idle_timer"] = randf_range(1.5, 3.5)

\t\t\tvar target_p: Vector2 = npc.get("target_pos", cur_p)
\t\t\tvar dist_to_t = cur_p.distance_to(target_p)
\t\t\tif dist_to_t > 5.0:
\t\t\t\tvar move_dir = (target_p - cur_p).normalized()
\t\t\t\tvar spd: float = npc.get("walk_speed", 40.0)
\t\t\t\tvar next_p = cur_p + move_dir * spd * delta
\t\t\t\tvar next_tile = Vector2i(int(next_p.x / TILE_SIZE), int(next_p.y / TILE_SIZE))
\t\t\t\tif world_map.can_walk(next_tile):
\t\t\t\t\tcur_p = next_p
\t\t\t\t\tnpc_positions[i] = cur_p
\t\t\t\t\tspr.position = cur_p
\t\t\t\t\tvar w_time: float = npc.get("anim_t", 0.0) + delta * 9.0
\t\t\t\t\tnpc["anim_t"] = w_time
\t\t\t\tif spr.hframes == 9:
\t\t\t\t\tvar dir_row := 0
\t\t\t\t\tif abs(move_dir.x) > abs(move_dir.y):
\t\t\t\t\t\tdir_row = 3 if move_dir.x > 0 else 2
\t\t\t\t\telse:
\t\t\t\t\t\tdir_row = 0 if move_dir.y > 0 else 1
\t\t\t\t\tnpc["anim_dir_row"] = dir_row
\t\t\t\t\tvar step_col := (int(w_time) % 8) + 1
\t\t\t\t\tspr.frame = dir_row * 9 + step_col
\t\t\t\t\tspr.flip_h = false
\t\t\t\t\tspr.rotation_degrees = 0.0
\t\t\t\t\tspr.offset.y = 0.0
\t\t\t\telse:
\t\t\t\t\tspr.offset.y = sin(w_time) * -2.5
\t\t\t\t\tspr.rotation_degrees = sin(w_time) * 3.5
\t\t\t\t\tif move_dir.x != 0:
\t\t\t\t\t\tspr.flip_h = (move_dir.x < 0)
\t\t\t\telse:
\t\t\t\t\tnpc["target_pos"] = cur_p
\t\t\t\t\tnpc["idle_timer"] = randf_range(2.0, 4.0)
\t\t\telse:
\t\t\t\tif spr.hframes == 9:
\t\t\t\t\tvar dir_row: int = npc.get("anim_dir_row", 0)
\t\t\t\t\tspr.frame = dir_row * 9
\t\t\t\t\tspr.rotation_degrees = 0.0
\t\t\t\t\tspr.offset.y = 0.0
\t\t\t\telse:
\t\t\t\t\tspr.rotation_degrees = lerpf(spr.rotation_degrees, 0.0, delta * 8.0)
\t\t\t\t\tspr.offset.y = sin(Time.get_ticks_msec() * 0.0025 + i * 1.5) * -1.0

\t\tvar plate = spr.get_node_or_null("Nameplate") as Label
\t\tif plate:
\t\t\tplate.visible = (i == interaction_target)
\t\t\tif plate.visible:
\t\t\t\tvar nick = (" «" + npc["nickname"] + "»") if npc.get("nickname", "") != "" else ""
\t\t\t\tplate.text = "%s%s" % [npc["name"], nick]

\t# Мягкое отталкивание живых NPC друг от друга
\tfor i in npc_positions.size():
\t\tif npc_data[i].get("is_dead", false): continue
\t\tfor j in range(i + 1, npc_positions.size()):
\t\t\tif npc_data[j].get("is_dead", false): continue
\t\t\tvar diff = npc_positions[i] - npc_positions[j]
\t\t\tvar d = diff.length()
\t\t\tif d < 28.0 and d > 0.01:
\t\t\t\tvar push = diff.normalized() * (28.0 - d) * 3.5 * delta
\t\t\t\tnpc_positions[i] += push
\t\t\t\tnpc_positions[j] -= push
\t\t\t\tnpc_sprites[i].position = npc_positions[i]
\t\t\t\tnpc_sprites[j].position = npc_positions[j]
"""

new_content = content[:idx1] + npc_call + content[idx2:] + '\n\n' + func_def
with open(p, 'w', encoding='utf-8') as f:
    f.write(new_content)
print('Successfully extracted _update_surface_npcs function!')
