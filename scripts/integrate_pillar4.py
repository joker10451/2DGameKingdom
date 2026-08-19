with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const InjuryMedicineSystemScript = preload("res://src/combat/InjuryMedicineSystem.gd")'''
new_vars = '''const InjuryMedicineSystemScript = preload("res://src/combat/InjuryMedicineSystem.gd")
const TownCouncilSystemScript = preload("res://src/settlement/TownCouncilSystem.gd")
const SettlementStockpileSystemScript = preload("res://src/settlement/SettlementStockpileSystem.gd")
const SettlementUnrestSystemScript = preload("res://src/settlement/SettlementUnrestSystem.gd")

var town_council_system: RefCounted
var settlement_stockpile_system: RefCounted
var settlement_unrest_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tinjury_medicine_system = InjuryMedicineSystemScript.new()'''
new_ready_end = '''\tinjury_medicine_system = InjuryMedicineSystemScript.new()
\t
\t# 5.13. Углубление Управления Поселением (Блок №4)
\ttown_council_system = TownCouncilSystemScript.new()
\tsettlement_stockpile_system = SettlementStockpileSystemScript.new()
\tsettlement_unrest_system = SettlementUnrestSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Helper Methods
helpers = '''
# =========================================================
# УГЛУБЛЕНИЕ УПРАВЛЕНИЯ: СОВЕТ ПОСЕЛЕНИЯ, СКЛАДЫ И БУНТЫ
# =========================================================
func _appoint_council_official(office_id: String, npc_name: String) -> void:
	if not town_council_system: return
	var res = town_council_system.appoint_official(office_id, npc_name)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "👑 НАЗНАЧЕН СОВЕТНИК", Color.GOLD, 18)

func _trigger_peasant_revolt_event() -> void:
	if not settlement_unrest_system: return
	var res = settlement_unrest_system.trigger_peasant_revolt()
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(Vector2(25 * 48, 29 * 48), "🔥 КРЕСТЬЯНСКИЙ БУНТ!", Color.RED, 22)

func _resolve_peasant_revolt_feast() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not settlement_unrest_system or not p: return
	var res = settlement_unrest_system.resolve_revolt_feast(p)
	_log("[color=gold][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🎉 ВСЕНАРОДНЫЙ ПРАЗДНИК!", Color.GOLD, 20)

func _resolve_peasant_revolt_grain() -> void:
	if not settlement_unrest_system or not settlement_stockpile_system: return
	var res = settlement_unrest_system.resolve_revolt_grain(settlement_stockpile_system)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🥖 РАЗДАЧА ХЛЕБА: +30 ДОВОЛЬСТВА", Color.GOLD, 18)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Pillar 4 Settlement Deepening integrated into GameWorld2D.gd!")
