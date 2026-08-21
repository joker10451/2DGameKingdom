class_name RaidSystem
extends RefCounted

## СИСТЕМА БАНДИТСКИХ НАБЕГОВ НА ПОСЕЛЕНИЕ (WARFARE & RAIDS)
## Управляет волнами разбойников, штурмующих Олдерию

signal raid_started(raid_data: Dictionary)
signal raid_repelled(reward_data: Dictionary)
signal raid_breached(penalty_data: Dictionary)

var is_raid_active: bool = false
var current_wave: int = 1
var active_raiders: Array[Dictionary] = []
var raid_target_pos: Vector2i = Vector2i(25, 25) # Центр деревни (Очаг/Ратуша)
var raid_gold_stolen: int = 0
var total_raids_repelled: int = 0

func check_should_start_raid(day: int, treasury_gold: int, player_gold: int) -> bool:
	if is_raid_active: return false
	# Набег происходит при накоплении золота в казне или у игрока
	if day >= 2 and (treasury_gold + player_gold >= 60):
		return true
	return false

func start_raid(spawn_corner: Vector2i = Vector2i(6, 6)) -> Dictionary:
	is_raid_active = true
	active_raiders.clear()
	raid_gold_stolen = 0
	
	# Формирование отряда в зависимости от номера волны
	var wave_comp = []
	match current_wave:
		1:
			wave_comp = [
				{"role": "Разбойник", "name": "Шнырь из Чернолесья", "hp": 65.0, "max_hp": 65.0, "dmg": 10, "gold": 12, "icon": "🗡️", "is_ranged": false},
				{"role": "Разбойник-лучник", "name": "Лесной Стрелок", "hp": 50.0, "max_hp": 50.0, "dmg": 14, "gold": 15, "icon": "🏹", "is_ranged": true},
				{"role": "Разбойник", "name": "Грабитель Трактов", "hp": 70.0, "max_hp": 70.0, "dmg": 12, "gold": 15, "icon": "🗡️", "is_ranged": false},
				{"role": "Главарь Банды", "name": "Десятник Вульф", "hp": 110.0, "max_hp": 110.0, "dmg": 18, "gold": 35, "icon": "👑", "is_ranged": false}
			]
		2:
			wave_comp = [
				{"role": "Разбойник", "name": "Берсерк с Топором", "hp": 85.0, "max_hp": 85.0, "dmg": 15, "gold": 20, "icon": "🪓", "is_ranged": false},
				{"role": "Разбойник-лучник", "name": "Стрелок-Браконьер", "hp": 55.0, "max_hp": 55.0, "dmg": 16, "gold": 18, "icon": "🏹", "is_ranged": true},
				{"role": "Разбойник-лучник", "name": "Опытный Лучник", "hp": 55.0, "max_hp": 55.0, "dmg": 16, "gold": 18, "icon": "🏹", "is_ranged": true},
				{"role": "Разбойник", "name": "Ветеран Банды", "hp": 80.0, "max_hp": 80.0, "dmg": 14, "gold": 22, "icon": "🗡️", "is_ranged": false},
				{"role": "Главарь Банды", "name": "Сотник Рагнар", "hp": 140.0, "max_hp": 140.0, "dmg": 22, "gold": 60, "icon": "👑", "is_ranged": false}
			]
		_:
			wave_comp = [
				{"role": "Разбойник", "name": "Головорез", "hp": 95.0, "max_hp": 95.0, "dmg": 18, "gold": 25, "icon": "🪓", "is_ranged": false},
				{"role": "Разбойник", "name": "Мечник Чернолесья", "hp": 90.0, "max_hp": 90.0, "dmg": 16, "gold": 25, "icon": "🗡️", "is_ranged": false},
				{"role": "Разбойник-лучник", "name": "Меткий Егерь", "hp": 65.0, "max_hp": 65.0, "dmg": 20, "gold": 25, "icon": "🏹", "is_ranged": true},
				{"role": "Разбойник-лучник", "name": "Ядовитый Стрелок", "hp": 60.0, "max_hp": 60.0, "dmg": 22, "gold": 30, "icon": "🏹", "is_ranged": true},
				{"role": "Главарь Банды", "name": "Атаман Бран «Кровавый Топор»", "hp": 180.0, "max_hp": 180.0, "dmg": 26, "gold": 100, "icon": "👑", "is_boss": true, "is_ranged": false}
			]
	
	for i in range(wave_comp.size()):
		var r = wave_comp[i].duplicate()
		r["id"] = "raider_" + str(i) + "_" + str(Time.get_ticks_msec())
		r["tile_pos"] = spawn_corner + Vector2i(randi_range(-2, 2), randi_range(-2, 2))
		r["target_pos"] = raid_target_pos
		r["attack_cd"] = 0.0
		r["is_dead"] = false
		active_raiders.append(r)
		
	var raid_info = {
		"wave": current_wave,
		"count": active_raiders.size(),
		"message": "⚠️ ВНИМАНИЕ! Волна #%d: Бандитский отряд (%d бойцов) штурмует Олдерию! Звоните в колокол [23, 21]!" % [current_wave, active_raiders.size()]
	}
	raid_started.emit(raid_info)
	return raid_info

func on_raider_killed(raider_id: String) -> Dictionary:
	var dropped_loot = {}
	for i in range(active_raiders.size()):
		if active_raiders[i].get("id") == raider_id:
			var r = active_raiders[i]
			dropped_loot = {
				"gold": r.get("gold", 15),
				"weapon": "iron_sword" if not r.get("is_boss", false) else "damascus_sword",
				"name": r.get("name", "Бандит")
			}
			active_raiders.remove_at(i)
			break
			
	var is_cleared = active_raiders.is_empty()
	if is_cleared and is_raid_active:
		is_raid_active = false
		total_raids_repelled += 1
		current_wave += 1
		var reward = {
			"renown": 25 * current_wave,
			"gold": 50 * current_wave,
			"msg": "🎉 Бандитский набег успешно отражен! Жители ликуют (+%d славы, +%d золота в казну)!" % [25 * current_wave, 50 * current_wave]
		}
		raid_repelled.emit(reward)
		return {"repelled": true, "reward": reward, "dropped_loot": dropped_loot}
		
	return {"repelled": false, "remaining": active_raiders.size(), "dropped_loot": dropped_loot}

func handle_breach(stockpiles: Dictionary) -> Dictionary:
	if not is_raid_active or active_raiders.is_empty():
		return {}
	
	# Разграбление части припасов
	var stolen_grain = int(stockpiles.get("grain", 0) * 0.25)
	var stolen_bread = int(stockpiles.get("bread", 0) * 0.25)
	var stolen_iron = int(stockpiles.get("iron_ingots", 0) * 0.20)
	
	stockpiles["grain"] = max(0, stockpiles.get("grain", 0) - stolen_grain)
	stockpiles["bread"] = max(0, stockpiles.get("bread", 0) - stolen_bread)
	stockpiles["iron_ingots"] = max(0, stockpiles.get("iron_ingots", 0) - stolen_iron)
	
	is_raid_active = false
	active_raiders.clear()
	
	var penalty = {
		"stolen_grain": stolen_grain,
		"stolen_bread": stolen_bread,
		"stolen_iron": stolen_iron,
		"msg": "💔 РАЗГРАБЛЕНИЕ! Разбойники прорвались к амбару и унесли %d зерна, %d хлеба и %d слитков!" % [stolen_grain, stolen_bread, stolen_iron]
	}
	raid_breached.emit(penalty)
	return penalty
