with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const FaunaVisualLayerScript = preload("res://src/world/FaunaVisualLayer.gd")'''
new_vars = '''const FaunaVisualLayerScript = preload("res://src/world/FaunaVisualLayer.gd")
const DungeonGenerator2DScript = preload("res://src/world/DungeonGenerator2D.gd")
const DungeonMonstersSystemScript = preload("res://src/world/DungeonMonstersSystem.gd")
const DungeonBossSystemScript = preload("res://src/world/DungeonBossSystem.gd")
const DungeonLootSystemScript = preload("res://src/world/DungeonLootSystem.gd")

var dungeon_generator: RefCounted
var dungeon_monsters_system: RefCounted
var dungeon_boss_system: RefCounted
var dungeon_loot_system: RefCounted
var is_in_dungeon: bool = false'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tfauna_visual_layer = FaunaVisualLayerScript.new()
\tfauna_visual_layer.name = "FaunaVisualLayer"
\tadd_child(fauna_visual_layer)'''
new_ready_end = '''\tfauna_visual_layer = FaunaVisualLayerScript.new()
\tfauna_visual_layer.name = "FaunaVisualLayer"
\tadd_child(fauna_visual_layer)
\t
\t# 5.17. Большие Подземелья, Склепы и Босс
\tdungeon_generator = DungeonGenerator2DScript.new()
\tdungeon_monsters_system = DungeonMonstersSystemScript.new()
\tdungeon_boss_system = DungeonBossSystemScript.new()
\tdungeon_loot_system = DungeonLootSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Helper Methods
helpers = '''
# =========================================================
# БОЛЬШИЕ ПОДЗЕМЕЛЬЯ, СКЛЕПЫ И БОСС (DUNGEON CRAWLING)
# =========================================================
func _enter_crypt_dungeon() -> void:
	if not dungeon_generator or not dungeon_monsters_system: return
	is_in_dungeon = true
	dungeon_generator.generate_crypt()
	dungeon_monsters_system.spawn_monsters()
	player_pos = Vector2(6 * 48, 6 * 48)
	_play_sfx("door_open")
	_log("[color=darkred][b]🕳️ ВЫ СПУСТИЛИСЬ В СКЛЕП ЗАБЫТЫХ! Повсюду веет могильным холодом, впереди слышен скрежет костей...[/b][/color]")
	_spawn_floating_text(player_pos, "🕳️ СКЛЕП ЗАБЫТЫХ", Color.RED, 22)

func _exit_crypt_dungeon() -> void:
	is_in_dungeon = false
	player_pos = Vector2(6 * 48, 6 * 48)
	_play_sfx("door_open")
	_log("[color=lightgreen][b]☀️ ВЫ ПОДНЯЛИСЬ НА ПОВЕРХНОСТЬ В ОЛДЕРИЮ![/b][/color]")

func _trigger_boss_fight() -> void:
	if not dungeon_boss_system: return
	var res = dungeon_boss_system.activate_boss()
	_shake_screen(12.0, 0.5)
	_play_sfx("sword_hit")
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "👑 БОСС: МАЛГОР!", Color.RED, 24)

func _strike_boss_malgor(dmg: int = 120) -> void:
	if not dungeon_boss_system: return
	_play_sfx("sword_hit")
	_shake_screen(8.0, 0.3)
	var res = dungeon_boss_system.take_damage(dmg)
	if res.get("killed", false):
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_play_sfx("level_up")
		_spawn_floating_text(player_pos, "🏆 БОСС ПОВЕРЖЕН!", Color.GOLD, 24)
	else:
		_log("[color=orange]⚔️ Удар по Малгору! Осталось HP: %d (Фаза %d)[/color]" % [res["hp"], res["phase"]])

func _loot_crypt_boss_chest() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not dungeon_loot_system or not p: return
	var res = dungeon_loot_system.open_royal_chest(p)
	if res.get("success", false):
		_play_sfx("coins")
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_spawn_floating_text(player_pos, "👑 ЛЕГЕНДАРНЫЙ ЛУТ!", Color.GOLD, 22)
	else:
		_log("[color=orange]%s[/color]" % res.get("msg", ""))
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Dungeon & Boss system integrated into GameWorld2D.gd!")
