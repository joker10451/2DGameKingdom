class_name RaidSystem
extends RefCounted

## СИСТЕМА БАНДИТСКИХ НАБЕГОВ НА ПОСЕЛЕНИЕ (WARFARE & RAIDS)
## Управляет волнами разбойников, штурмующих Олдерию

signal raid_started(raid_data: Dictionary)
signal raid_repelled(reward_data: Dictionary)

var is_raid_active: bool = false
var current_wave: int = 1
var active_raiders: Array[Dictionary] = []
var raid_target_pos: Vector2i = Vector2i(25, 25) # Центр деревни

func check_should_start_raid(day: int, treasury_gold: int, player_gold: int) -> bool:
	if is_raid_active: return false
	# Набег происходит каждые 4-5 дней, если накоплено золото (> 100 з.)
	if day >= 2 and (treasury_gold + player_gold >= 80):
		return true
	return false

func start_raid(spawn_corner: Vector2i = Vector2i(5, 5)) -> Dictionary:
	is_raid_active = true
	active_raiders.clear()
	
	var raider_types = [
		{"role": "Разбойник", "hp": 70.0, "max_hp": 70.0, "dmg": 12, "gold": 15},
		{"role": "Разбойник-Лучник", "hp": 55.0, "max_hp": 55.0, "dmg": 15, "gold": 18},
		{"role": "Разбойник", "hp": 70.0, "max_hp": 70.0, "dmg": 12, "gold": 15},
		{"role": "Главарь Банды", "hp": 120.0, "max_hp": 120.0, "dmg": 18, "gold": 40}
	]
	
	for i in range(raider_types.size()):
		var r = raider_types[i].duplicate()
		r["id"] = "raider_" + str(i) + "_" + str(Time.get_ticks_msec())
		r["pos"] = spawn_corner + Vector2i(randi_range(-2, 2), randi_range(-2, 2))
		r["target_pos"] = raid_target_pos
		r["name"] = "Бандит #" + str(i + 1)
		active_raiders.append(r)
		
	var raid_info = {
		"wave": current_wave,
		"count": active_raiders.size(),
		"message": "⚠️ ВНИМАНИЕ! Бандитский отряд из Чернолесья штурмует Олдерию! Звоните в колокол [23, 21]!"
	}
	raid_started.emit(raid_info)
	return raid_info

func on_raider_killed(raider_id: String) -> bool:
	for i in range(active_raiders.size()):
		if active_raiders[i]["id"] == raider_id:
			active_raiders.remove_at(i)
			break
			
	if active_raiders.is_empty() and is_raid_active:
		is_raid_active = false
		current_wave += 1
		var reward = {
			"renown": 25,
			"gold": 50,
			"msg": "🎉 Бандитский набег успешно отражен! Жители ликуют (+25 славы, +50 золота награды)!"
		}
		raid_repelled.emit(reward)
		return true
	return false
