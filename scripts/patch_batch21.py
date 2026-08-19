with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload AtmosphereSystem
old_preload = '''const PetCompanionSystem = preload("res://src/character/PetCompanionSystem.gd")'''
new_preload = '''const PetCompanionSystem = preload("res://src/character/PetCompanionSystem.gd")
const AtmosphereSystem = preload("res://src/world/AtmosphereSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Add weather and atmosphere variables
old_vars = '''# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary'''

new_vars = '''# Атмосфера, погода, дым из труб и вечерние окна 🕯️🌧️💨
var current_weather: String = "clear"
var weather_cycle_timer: float = 90.0
var smoke_emit_timer: float = 0.0

# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary'''

text = text.replace(old_vars, new_vars, 1)

# 3. Update weather cycle and smoke emission in _physics_process
old_phys_top = '''\t_update_character_stats(delta)'''
new_phys_top = '''\t_update_character_stats(delta)
\t_process_weather_and_atmosphere(delta)'''

text = text.replace(old_phys_top, new_phys_top, 1)

# 4. Pass current_weather to ColonistAISystem in _process_citizens
old_colonist_call = '''\t\t\tvar res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile, cur_hour, m_data)'''
new_colonist_call = '''\t\t\tvar res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile, cur_hour, m_data, current_weather)'''

text = text.replace(old_colonist_call, new_colonist_call, 1)

# 5. Append _process_weather_and_atmosphere function
atm_func = '''

# =========================================================
# АТМОСФЕРА, ПОГОДА, ДЫМ ИЗ ТРУБ И ВЕЧЕРНИЕ ОКНА 🕯️🌧️💨
# =========================================================
func _process_weather_and_atmosphere(delta: float) -> void:
\tweather_cycle_timer -= delta
\tsmoke_emit_timer -= delta
\t
\t# 1. Цикл погоды
\tif weather_cycle_timer <= 0.0:
\t\tweather_cycle_timer = randf_range(80.0, 150.0)
\t\tvar prev_w = current_weather
\t\tvar w_list = AtmosphereSystem.WEATHERS
\t\tcurrent_weather = w_list[randi() % w_list.size()]
\t\t
\t\tif current_weather != prev_w:
\t\t\tif current_weather == "rain":
\t\t\t\t_log("[color=lightblue]🌧️ [b]ПОГОДА:[/b] Начался теплый летний дождь. Посевы пшеницы наливаются силой (+50% к росту)![/color]")
\t\t\t\t_spawn_floating_text(player_pos, "🌧️ ТЕПЛЫЙ ДОЖДЬ", Color.LIGHT_BLUE, 18)
\t\t\telif current_weather == "storm":
\t\t\t\t_log("[color=cyan]⛈️ [b]ПОГОДА:[/b] Надвинулась гроза с далекими раскатами грома![/color]")
\t\t\t\t_spawn_floating_text(player_pos, "⛈️ ГРОЗА", Color.CYAN, 18)
\t\t\telif current_weather == "fog":
\t\t\t\t_log("[color=lightgray]🌫️ [b]ПОГОДА:[/b] Над рекой и лугами стелется утренний туман.[/color]")
\t\t\t\t_spawn_floating_text(player_pos, "🌫️ ТУМАН", Color.LIGHT_GRAY, 18)
\t\t\telse:
\t\t\t\t_log("[color=gold]☀️ [b]ПОГОДА:[/b] Непогода утихла. Выглянуло ласковое солнце.[/color]")
\t\t\t\t_spawn_floating_text(player_pos, "☀️ СОЛНЕЧНО", Color.GOLD, 18)
\t
\t# 2. Клубы дыма над печными трубами и каминами
\tif smoke_emit_timer <= 0.0:
\t\tsmoke_emit_timer = 0.9
\t\tvar chimneys = AtmosphereSystem.get_chimney_nodes(world_map)
\t\tfor c_pos in chimneys:
\t\t\t_spawn_spark_particles(c_pos + Vector2(randf_range(-3, 3), -6), Color(0.88, 0.90, 0.95, 0.6))
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + atm_func)

print('Successfully patched GameWorld2D.gd for Batch 21 Atmosphere!')
