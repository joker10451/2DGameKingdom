with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const ApprenticeshipSystemScript = preload("res://src/social/ApprenticeshipSystem.gd")'''
new_vars = '''const ApprenticeshipSystemScript = preload("res://src/social/ApprenticeshipSystem.gd")
const EquipmentSlotSystemScript = preload("res://src/combat/EquipmentSlotSystem.gd")
const CombatTacticsSystemScript = preload("res://src/combat/CombatTacticsSystem.gd")
const InjuryMedicineSystemScript = preload("res://src/combat/InjuryMedicineSystem.gd")

var equipment_slot_system: RefCounted
var combat_tactics_system: RefCounted
var injury_medicine_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tapprenticeship_system = ApprenticeshipSystemScript.new()'''
new_ready_end = '''\tapprenticeship_system = ApprenticeshipSystemScript.new()
\t
\t# 5.12. Углубление Боя и Экипировки (Блок №3)
\tequipment_slot_system = EquipmentSlotSystemScript.new()
\tcombat_tactics_system = CombatTacticsSystemScript.new()
\tinjury_medicine_system = InjuryMedicineSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Dodge roll in _unhandled_input
old_input = '''\t\tKEY_I:
\t\t\t_toggle_inventory()'''
new_input = '''\t\tKEY_SPACE:
\t\t\t_perform_dodge_roll()
\t\tKEY_I:
\t\t\t_toggle_inventory()'''
text = text.replace(old_input, new_input, 1)

# 4. Add Helper Methods
helpers = '''
# =========================================================
# УГЛУБЛЕНИЕ БОЯ, 8 СЛОТОВ ЭКИПИРОВКИ И ТРАВМЫ
# =========================================================
func _perform_dodge_roll() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not combat_tactics_system or not p: return
	var input_vec = Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_vec.y -= 1
	if Input.is_key_pressed(KEY_S): input_vec.y += 1
	if Input.is_key_pressed(KEY_A): input_vec.x -= 1
	if Input.is_key_pressed(KEY_D): input_vec.x += 1
	
	var res = combat_tactics_system.start_dodge_roll(input_vec, p.stamina)
	if res.get("success", false):
		p.stamina = max(0.0, p.stamina - res["stamina_cost"])
		_spawn_floating_text(player_pos, "💨 КУВЫРОК!", Color.WHITE, 16)

func _use_bandage() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not injury_medicine_system or not p: return
	var res = injury_medicine_system.apply_bandage(p)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🩹 ПЕРЕВЯЗКА: +15 HP", Color.LIGHT_GREEN, 18)

func _use_salve() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not injury_medicine_system or not p: return
	var res = injury_medicine_system.apply_salve(p)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🧪 ЦЕЛЕБНАЯ МАЗЬ", Color.LIGHT_GREEN, 18)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Pillar 3 Combat Deepening integrated into GameWorld2D.gd!")
