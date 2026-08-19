with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Build new block to replace lines 1966-2010 (0-indexed: 1965-2009)
new_block = '''\t\t\tif dist_to_t > 5.0:

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

\t\t\t\t\tif spr.hframes == 9:
\t\t\t\t\t\t# LPC walk animation: pick row based on movement direction
\t\t\t\t\t\tvar dir_row := 0
\t\t\t\t\t\tif abs(move_dir.x) > abs(move_dir.y):
\t\t\t\t\t\t\tdir_row = 3 if move_dir.x > 0 else 2
\t\t\t\t\t\telse:
\t\t\t\t\t\t\tdir_row = 0 if move_dir.y > 0 else 1
\t\t\t\t\t\tnpc["anim_dir_row"] = dir_row
\t\t\t\t\t\tvar step_col := (int(w_time) % 8) + 1
\t\t\t\t\t\tspr.frame = dir_row * 9 + step_col
\t\t\t\t\t\tspr.flip_h = false
\t\t\t\t\t\tspr.rotation_degrees = 0.0
\t\t\t\t\t\tspr.offset.y = 0.0
\t\t\t\t\telse:
\t\t\t\t\t\tspr.offset.y = sin(w_time) * -2.5
\t\t\t\t\t\tspr.rotation_degrees = sin(w_time) * 3.5
\t\t\t\t\t\tif move_dir.x != 0:
\t\t\t\t\t\t\tspr.flip_h = (move_dir.x < 0)

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

\t\t
'''

# Lines to replace: 1965 to 2010 inclusive (0-indexed)
new_lines = lines[:1965] + [new_block + '\n'] + lines[2010:]

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print("NPC LPC walk animation injected successfully!")
print(f"Old line count: {len(lines)}, New: {len(new_lines)}")
