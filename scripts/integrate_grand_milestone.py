with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const JuiceEffectsSystemScript = preload("res://src/audio/JuiceEffectsSystem.gd")'''
new_vars = '''const JuiceEffectsSystemScript = preload("res://src/audio/JuiceEffectsSystem.gd")
const RegionalMapSystemScript = preload("res://src/world/RegionalMapSystem.gd")
const TradeCaravanSystemScript = preload("res://src/world/TradeCaravanSystem.gd")
const RegionalDiplomacySystemScript = preload("res://src/world/RegionalDiplomacySystem.gd")
const FactionWarfareSystemScript = preload("res://src/world/FactionWarfareSystem.gd")

var regional_map_system: RefCounted
var trade_caravan_system: RefCounted
var regional_diplomacy_system: RefCounted
var faction_warfare_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tjuice_effects_system = JuiceEffectsSystemScript.new()'''
new_ready_end = '''\tjuice_effects_system = JuiceEffectsSystemScript.new()
\t
\t# 5.15. Карта Региона, Караваны, Дипломатия и Война Фракций
\tregional_map_system = RegionalMapSystemScript.new()
\ttrade_caravan_system = TradeCaravanSystemScript.new()
\tregional_diplomacy_system = RegionalDiplomacySystemScript.new()
\tfaction_warfare_system = FactionWarfareSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Helper Methods
helpers = '''
# =========================================================
# КАРТА РЕГИОНА, КАРАВАНЫ, ДИПЛОМАТИЯ И ВОЙНА ФРАКЦИЙ
# =========================================================
func _dispatch_trade_caravan(dest_city: String, goods: String = "grain") -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not trade_caravan_system or not p: return
	var res = trade_caravan_system.dispatch_caravan(dest_city, goods, p, regional_map_system)
	_play_sfx("coin")
	_log("[color=gold][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🐫 КАРАВАН: +%d ЗОЛОТА" % res["profit"], Color.GOLD, 20)

func _sign_trade_pact(city_id: String) -> void:
	if not regional_diplomacy_system: return
	var res = regional_diplomacy_system.sign_trade_agreement(city_id, regional_map_system)
	_play_sfx("coin")
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "📜 ТОРГОВЫЙ ПАКТ ЗАКЛЮЧЕН", Color.GOLD, 18)

func _trigger_siege_warfare(faction_name: String = "Чернолесье") -> void:
	if not faction_warfare_system: return
	var res = faction_warfare_system.declare_war(faction_name)
	_play_sfx("sword")
	_shake_screen(10.0, 0.4)
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(Vector2(25 * 48, 27 * 48), "⚔️ ОСАДА ВОРОТ!", Color.RED, 22)

func _repel_siege_and_sign_peace() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not faction_warfare_system or not p: return
	var res = faction_warfare_system.repel_siege_and_sign_peace(p, regional_map_system)
	_play_sfx("coin")
	_log("[color=gold][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "👑 ВЕЧНЫЙ МИР: +200 ЗОЛОТА!", Color.GOLD, 22)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Grand Milestone integrated into GameWorld2D.gd!")
