with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add Preloads and variables
old_vars = '''const BanditCampSystemScript = preload("res://src/combat/BanditCampSystem.gd")'''
new_vars = '''const BanditCampSystemScript = preload("res://src/combat/BanditCampSystem.gd")
const DungeonGenerator2DScript = preload("res://src/dungeon/DungeonGenerator2D.gd")
const DungeonTrapSystemScript = preload("res://src/dungeon/DungeonTrapSystem.gd")
const DungeonBossSystemScript = preload("res://src/dungeon/DungeonBossSystem.gd")

var dungeon_generator: RefCounted
var dungeon_trap_system: RefCounted
var dungeon_boss_system: RefCounted
var is_in_dungeon: bool = false'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tif world_map:
\t\tbandit_camp_system.spawn_camp_structures(world_map)'''

new_ready_end = '''\tif world_map:
\t\tbandit_camp_system.spawn_camp_structures(world_map)
\t
\t# 5.8. Подземелья и Склеп Забытых (Этап 3)
\tdungeon_generator = DungeonGenerator2DScript.new()
\tdungeon_trap_system = DungeonTrapSystemScript.new()
\tdungeon_boss_system = DungeonBossSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Dungeon Helper Methods
helpers = '''
# =========================================================
# ПОДЗЕМЕЛЬЕ: СКЛЕП ЗАБЫТЫХ И БОСС МАЛЬГРИМ (ЭТАП 3)
# =========================================================
func _enter_dungeon() -> void:
	is_in_dungeon = true
	_close_all_modals()
	
	if day_night_modulate:
		day_night_modulate.color = Color(0.06, 0.07, 0.12) # Глубокая тьма подземелья
		
	if player_torch:
		player_torch.enabled = true
		player_torch.energy = 1.4
		player_torch.texture_scale = 1.8
		
	player_pos = Vector2(5 * 48, 5 * 48)
	
	_log("[color=purple][b]🕳️ ВЫ СПУСТИЛИСЬ В СКЛЕП ЗАБЫТЫХ![/b][/color]")
	_log("[color=gray]Каменные своды окутаны вековой тьмой. Зажгите факел и остерегайтесь нажимных плит с шипами![/color]")
	_spawn_floating_text(player_pos, "🕳️ СКЛЕП ЗАБЫТЫХ", Color.PURPLE, 22)
	
func _exit_dungeon() -> void:
	is_in_dungeon = false
	_close_all_modals()
	
	player_pos = Vector2(6 * 48, 7 * 48) # Рядом со входом на поверхности
	
	var tm = _get_game_manager()
	_update_day_night_cycle(TimeManager.hour if TimeManager else 12, TimeManager.minute if TimeManager else 0)
	
	_log("[color=gold][b]☀️ ВЫ ВЕРНУЛИСЬ НА ПОВЕРХНОСТЬ В ОКРЕСТНОСТИ ОЛДЕРИИ.[/b][/color]")
	_spawn_floating_text(player_pos, "☀️ ПОВЕРХНОСТЬ", Color.GOLD, 20)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Dungeon and Crypt of the Forgotten integrated into GameWorld2D.gd!")
