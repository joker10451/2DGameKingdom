with open("godot/src/game2d/GameWorld2D.gd", "r", encoding="utf-8") as f:
    code = f.read()

# 1. Update _spawn_npcs to accept loc_type and clear old sprites
old_spawn_npcs = '''func _spawn_npcs() -> void:
\tfor i in npc_data.size():
\t\tvar npc = npc_data[i]
\t\tvar role = npc.get("role", "Крестьянин")
\t\tvar spot_id = npc.get("work", "tavern")
\t\t
\t\t# Равномерное и естественное распределение по всей деревне
\t\tvar start_tile: Vector2i
\t\tmatch role:
\t\t\t"Крестьянин":
\t\t\t\tvar farm_tiles = [Vector2i(18, 48), Vector2i(22, 50), Vector2i(15, 52), Vector2i(25, 48), Vector2i(20, 53), Vector2i(27, 47)]
\t\t\t\tstart_tile = farm_tiles[i % farm_tiles.size()]
\t\t\t"Кузнец":
\t\t\t\tvar smith_tiles = [Vector2i(38, 25), Vector2i(35, 27)]
\t\t\t\tstart_tile = smith_tiles[i % smith_tiles.size()]
\t\t\t"Торговец":
\t\t\t\tvar market_tiles = [Vector2i(23, 38), Vector2i(25, 37), Vector2i(28, 35), Vector2i(27, 39)]
\t\t\t\tstart_tile = market_tiles[i % market_tiles.size()]
\t\t\t"Городской Стражник":
\t\t\t\tvar guard_tiles = [Vector2i(31, 20), Vector2i(31, 35), Vector2i(31, 48), Vector2i(35, 38), Vector2i(28, 28)]
\t\t\t\tstart_tile = guard_tiles[i % guard_tiles.size()]
\t\t\t"Лорд", "Священник":
\t\t\t\tstart_tile = Vector2i(40, 39)
\t\t\t"Бандит", "Разбойник", "Разбойник-лучник":
\t\t\t\tvar bandit_tiles = [Vector2i(8, 12), Vector2i(11, 14), Vector2i(7, 16)]
\t\t\t\tstart_tile = bandit_tiles[i % bandit_tiles.size()]
\t\t\t\tif i % 2 == 1:
\t\t\t\t\tnpc["role"] = "Разбойник-лучник"
\t\t\t\t\tnpc["is_ranged"] = true
\t\t\t_:
\t\t\t\tstart_tile = _get_spot_tile(spot_id)'''

new_spawn_npcs = '''func _spawn_npcs(loc_type: String = "village") -> void:
\t# Очищаем предыдущие спрайты жителей при смене локации
\tfor s in npc_sprites:
\t\tif is_instance_valid(s):
\t\t\ts.queue_free()
\tnpc_sprites.clear()
\tnpc_positions.clear()
\tnpc_data = NPCGenerator.generate_population_for_location(loc_type, 14)
\t
\tfor i in npc_data.size():
\t\tvar npc = npc_data[i]
\t\tvar role = npc.get("role", "Крестьянин")
\t\tvar spot_id = npc.get("work", "tavern")
\t\t
\t\tvar start_tile: Vector2i
\t\tmatch loc_type:
\t\t\t"city":
\t\t\t\tvar city_spots = [Vector2i(31, 12), Vector2i(31, 52), Vector2i(32, 32), Vector2i(20, 38), Vector2i(24, 40), Vector2i(42, 38), Vector2i(30, 16), Vector2i(34, 18), Vector2i(26, 46)]
\t\t\t\tstart_tile = city_spots[i % city_spots.size()]
\t\t\t"mine":
\t\t\t\tvar mine_spots = [Vector2i(22, 44), Vector2i(40, 44), Vector2i(31, 38), Vector2i(31, 20), Vector2i(26, 32), Vector2i(38, 30)]
\t\t\t\tstart_tile = mine_spots[i % mine_spots.size()]
\t\t\t"swamp":
\t\t\t\tvar swamp_spots = [Vector2i(25, 24), Vector2i(34, 28), Vector2i(31, 31), Vector2i(28, 32), Vector2i(36, 30)]
\t\t\t\tstart_tile = swamp_spots[i % swamp_spots.size()]
\t\t\t"farms":
\t\t\t\tvar farm_spots = [Vector2i(28, 18), Vector2i(28, 44), Vector2i(4, 28), Vector2i(18, 18), Vector2i(44, 18), Vector2i(18, 44)]
\t\t\t\tstart_tile = farm_spots[i % farm_spots.size()]
\t\t\t"fort":
\t\t\t\tvar fort_spots = [Vector2i(31, 34), Vector2i(28, 24), Vector2i(22, 36), Vector2i(40, 36), Vector2i(31, 44), Vector2i(32, 44)]
\t\t\t\tstart_tile = fort_spots[i % fort_spots.size()]
\t\t\t_:
\t\t\t\tmatch role:
\t\t\t\t\t"Крестьянин":
\t\t\t\t\t\tvar f_tiles = [Vector2i(18, 48), Vector2i(22, 50), Vector2i(15, 52), Vector2i(25, 48), Vector2i(20, 53)]
\t\t\t\t\t\tstart_tile = f_tiles[i % f_tiles.size()]
\t\t\t\t\t"Кузнец":
\t\t\t\t\t\tvar s_tiles = [Vector2i(38, 25), Vector2i(35, 27)]
\t\t\t\t\t\tstart_tile = s_tiles[i % s_tiles.size()]
\t\t\t\t\t"Торговец":
\t\t\t\t\t\tvar m_tiles = [Vector2i(23, 38), Vector2i(25, 37), Vector2i(28, 35)]
\t\t\t\t\t\tstart_tile = m_tiles[i % m_tiles.size()]
\t\t\t\t\t"Городской Стражник":
\t\t\t\t\t\tvar g_tiles = [Vector2i(31, 20), Vector2i(31, 35), Vector2i(31, 48)]
\t\t\t\t\t\tstart_tile = g_tiles[i % g_tiles.size()]
\t\t\t\t\t"Лорд", "Священник":
\t\t\t\t\t\tstart_tile = Vector2i(40, 39)
\t\t\t\t\t"Бандит", "Разбойник", "Разбойник-лучник":
\t\t\t\t\t\tvar b_tiles = [Vector2i(8, 12), Vector2i(11, 14), Vector2i(7, 16)]
\t\t\t\t\t\tstart_tile = b_tiles[i % b_tiles.size()]
\t\t\t\t\t\tif i % 2 == 1:
\t\t\t\t\t\t\tnpc["role"] = "Разбойник-лучник"
\t\t\t\t\t\t\tnpc["is_ranged"] = true
\t\t\t\t\t_:
\t\t\t\t\t\tstart_tile = _get_spot_tile(spot_id)'''

if old_spawn_npcs in code:
    code = code.replace(old_spawn_npcs, new_spawn_npcs, 1)
    print("SUCCESS: Updated _spawn_npcs!")
else:
    print("WARNING: old_spawn_npcs not matched directly, checking variations...")

# 2. Update _enter_overworld_location to regenerate local map
old_enter = '''func _enter_overworld_location() -> void:

\tvar loc = overworld_map.get_location_at(overworld_player_tile)

\tif loc.size() > 0:

\t\tcurrent_location_id = loc["id"]

\t\t_toggle_overworld_mode()

\t\t_log("[color=gold][b]🏰 Вы вошли в локацию: %s![/b][/color]" % loc["name"])

\t\t_spawn_floating_text(player_pos, "ВХОД: " + loc["name"], Color(1.0, 0.9, 0.3), 20)

\t\t

\t\tvar gm = _get_game_manager()

\t\tvar p: CharacterData = gm.player_data if gm else null

\t\tif p:

\t\t\tvar completed_quests = ContractManager.update_progress(p, "delivery", loc["id"], 1)

\t\t\tfor cq in completed_quests:

\t\t\t\t_log("[color=gold][b]📜 КУРЬЕРСКОЕ ПОРУЧЕНИЕ ВЫПОЛНЕНО: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))

\t\t\t\t_spawn_floating_text(player_pos, "📜 Депеша доставлена!", Color(1.0, 0.9, 0.2), 18)

\telse:

\t\t_log("Здесь дикая равнина. Разбейте лагерь или двигайтесь к поселениям на карте.")'''

new_enter = '''func _enter_overworld_location() -> void:
\tvar loc = overworld_map.get_location_at(overworld_player_tile)
\tif loc.size() > 0:
\t\tcurrent_location_id = loc["id"]
\t\tvar loc_type = loc.get("type", "village")
\t\t
\t\t# 1. Перестраиваем карту под выбранный биом
\t\tworld_map.generate_world(loc_type, current_location_id)
\t\t
\t\t# 2. Переспавниваем жителей для данной зоны
\t\t_spawn_npcs(loc_type)
\t\t
\t\t# 3. Выходим из режима карты мира и позиционируем у южного въезда
\t\t_toggle_overworld_mode()
\t\tplayer_pos = Vector2(31.5 * TILE_SIZE, 58.0 * TILE_SIZE)
\t\tif player_sprite: player_sprite.position = player_pos
\t\tif camera:
\t\t\tcamera.position = player_pos
\t\t\tcamera.reset_smoothing()
\t\t\t
\t\t_log("[color=gold][b]🏰 Вы вошли в локацию: %s![/b][/color]" % loc["name"])
\t\t_spawn_floating_text(player_pos, "ВХОД: " + loc["name"], Color(1.0, 0.9, 0.3), 20)
\t\t
\t\tvar gm = _get_game_manager()
\t\tvar p: CharacterData = gm.player_data if gm else null
\t\tif p:
\t\t\tvar completed_quests = ContractManager.update_progress(p, "delivery", loc["id"], 1)
\t\t\tfor cq in completed_quests:
\t\t\t\t_log("[color=gold][b]📜 КУРЬЕРСКОЕ ПОРУЧЕНИЕ ВЫПОЛНЕНО: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))
\t\t\t\t_spawn_floating_text(player_pos, "📜 Депеша доставлена!", Color(1.0, 0.9, 0.2), 18)
\telse:
\t\t_log("Здесь дикая равнина. Разбейте лагерь или двигайтесь к поселениям на карте.")'''

if old_enter in code:
    code = code.replace(old_enter, new_enter, 1)
    print("SUCCESS: Updated _enter_overworld_location!")
else:
    print("WARNING: old_enter not matched directly, checking variations...")

# 3. Add edge transition check
old_edge = '''\t\t# Проверка коллизий с картой по тайлам'''
new_edge = '''\t\t# Проверка выхода за край карты на глобальный тракт
\t\tif (player_pos.x <= 16.0 or player_pos.x >= 63.0 * TILE_SIZE - 16.0 or player_pos.y <= 16.0 or player_pos.y >= 63.0 * TILE_SIZE - 16.0):
\t\t\t_exit_to_overworld()
\t\t\treturn

\t\t# Проверка коллизий с картой по тайлам'''

if old_edge in code:
    code = code.replace(old_edge, new_edge, 1)
    print("SUCCESS: Added edge transition check!")
else:
    print("WARNING: old_edge not matched directly...")

# 4. Add _exit_to_overworld helper
old_toggle_overworld = '''func _toggle_overworld_mode() -> void:'''
new_toggle_overworld = '''func _exit_to_overworld() -> void:
\t_log("[color=gold]🗺️ Вы вышли за пределы поселения на королевский тракт Олдерии.[/color]")
\t_toggle_overworld_mode()

func _toggle_overworld_mode() -> void:'''

if old_toggle_overworld in code:
    code = code.replace(old_toggle_overworld, new_toggle_overworld, 1)
    print("SUCCESS: Added _exit_to_overworld!")

with open("godot/src/game2d/GameWorld2D.gd", "w", encoding="utf-8") as f:
    f.write(code)

print("ALL GAMEWORLD2D OVERWORLD ENHANCEMENTS APPLIED!")
