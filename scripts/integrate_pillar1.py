with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const DungeonBossSystemScript = preload("res://src/dungeon/DungeonBossSystem.gd")'''
new_vars = '''const DungeonBossSystemScript = preload("res://src/dungeon/DungeonBossSystem.gd")
const AgricultureSystem2DScript = preload("res://src/production/AgricultureSystem2D.gd")
const FishingSystem2DScript = preload("res://src/production/FishingSystem2D.gd")
const SmithingQualitySystemScript = preload("res://src/production/SmithingQualitySystem.gd")
const CookingBuffSystemScript = preload("res://src/production/CookingBuffSystem.gd")

var agriculture_system: RefCounted
var fishing_system: RefCounted
var smithing_quality_system: RefCounted
var cooking_buff_system: RefCounted
var buffs_hud_label: Label'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tdungeon_boss_system = DungeonBossSystemScript.new()'''
new_ready_end = '''\tdungeon_boss_system = DungeonBossSystemScript.new()
\t
\t# 5.9. Углубление Производства и Ремесел (Блок №1)
\tagriculture_system = AgricultureSystem2DScript.new()
\tfishing_system = FishingSystem2DScript.new()
\tsmithing_quality_system = SmithingQualitySystemScript.new()
\tcooking_buff_system = CookingBuffSystemScript.new()
\t
\t# Начальный посев пшеницы на грядках
\tfor fx in range(20, 24):
\t\tfor fy in range(4, 7):
\t\t\tagriculture_system.plant_crop(Vector2i(fx, fy), "wheat")
\t
\t# Точильный станок в кузнице
\tif world_map:
\t\tworld_map.place_structure(Vector2i(28, 12), "grindstone")'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add HUD Buff label in _build_ui_hud()
old_hud_bars = '''\t# Сытость
\thud_hunger_bar = ProgressBar.new()'''
new_hud_bars = '''\t# Сытость
\thud_hunger_bar = ProgressBar.new()'''
# Let's check where hud_hunger_bar ends and add buffs_hud_label
old_bars_end = '''\thud_bars_box.add_child(hud_hunger_bar)'''
new_bars_end = '''\thud_bars_box.add_child(hud_hunger_bar)
\t
\tbuffs_hud_label = Label.new()
\tbuffs_hud_label.text = ""
\tbuffs_hud_label.add_theme_font_size_override("font_size", 11)
\tbuffs_hud_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.40))
\thud_bars_box.add_child(buffs_hud_label)'''
text = text.replace(old_bars_end, new_bars_end, 1)

# 4. Add Helper Methods for Agriculture, Fishing, Sharpening, Cooking
helpers = '''
# =========================================================
# УГЛУБЛЕНИЕ ПРОИЗВОДСТВА: ПОЛИВ, РЫБАЛКА, ЗАТОЧКА, БАФФЫ
# =========================================================
func _water_farm_tile(pos: Vector2i) -> void:
	if not agriculture_system: return
	if agriculture_system.water_tile(pos):
		_log("[color=lightblue]💧 Вы полили грядку чистой водой из лейки! Рост пшеницы ускорился в 2.5 раза![/color]")
		_spawn_floating_text(Vector2(pos.x * 48, pos.y * 48), "💧 ПОЛИТО!", Color.CYAN, 16)
		
func _harvest_farm_tile(pos: Vector2i) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not agriculture_system or not p: return
	var res = agriculture_system.harvest_crop(pos, p)
	if res.get("success", false):
		_log("[color=gold]%s[/color]" % res["msg"])
		_spawn_floating_text(Vector2(pos.x * 48, pos.y * 48), "+%d Пшеницы 🌾" % res["yield"], Color.GOLD, 18)
	else:
		_log("[color=gray]%s[/color]" % res.get("msg", ""))

func _use_grindstone() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not smithing_quality_system or not cooking_buff_system or not p: return
	var res = smithing_quality_system.sharpen_weapon(p)
	cooking_buff_system.apply_buff("buff_sharpness")
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "✨ ЗАТОЧЕНО! +15% УРОНА", Color.GOLD, 18)
	_update_buffs_hud()

func _eat_hearty_pie() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not cooking_buff_system or not p: return
	cooking_buff_system.apply_buff("buff_meat_pie")
	_log("[color=gold]🥧 ВЫ СЪЕЛИ СЫТНЫЙ МЯСНОЙ ПИРОГ! Получен бафф: +25 к максимальной выносливости на 12 часов![/color]")
	_spawn_floating_text(player_pos, "🥧 СЫТНЫЙ ПИРОГ: +25 СТАМИНЫ", Color.GOLD, 18)
	_update_buffs_hud()

func _update_buffs_hud() -> void:
	if not buffs_hud_label or not cooking_buff_system: return
	buffs_hud_label.text = cooking_buff_system.get_active_buffs_text()
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Pillar 1 Production Deepening integrated into GameWorld2D.gd!")
