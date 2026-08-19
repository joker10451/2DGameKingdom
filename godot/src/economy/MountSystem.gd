class_name MountSystem
extends RefCounted

## СИСТЕМА КОНЮШЕН, ВЕРХОВОЙ ЕЗДЫ И РАЗВЕДЕНИЯ ЛОШАДЕЙ

const HORSE_BREEDS := {
	"horse_bay": {
		"id": "horse_bay",
		"name": "Гнедая Рабочая Лошадь",
		"icon": "🐎",
		"cost": 40,
		"speed_mult": 1.70,
		"max_hp": 120.0,
		"ram_dmg": 12,
		"desc": "Выносливая крестьянская лошадь. Увеличивает скорость перемещения на +70%."
	},
	"horse_courser": {
		"id": "horse_courser",
		"name": "Вороной Скакун",
		"icon": "⚡",
		"cost": 85,
		"speed_mult": 2.20,
		"max_hp": 100.0,
		"ram_dmg": 16,
		"desc": "Стремительный чистокровный скакун. Увеличивает скорость перемещения на +120%."
	},
	"horse_destrier": {
		"id": "horse_destrier",
		"name": "Бронированный Дестриэ",
		"icon": "🛡️",
		"cost": 150,
		"speed_mult": 1.80,
		"max_hp": 220.0,
		"ram_dmg": 26,
		"desc": "Тяжелый рыцарский конь в кольчужной попоне. Сбивает врагов с ног на скаку (+26 таранного урона)."
	}
}

static func ensure_mount_data(p: CharacterData) -> void:
	if not p: return
	if not p.settlement.has("horses"):
		p.settlement["horses"] = []
	if not p.settlement.has("active_horse"):
		p.settlement["active_horse"] = ""

static func buy_horse(p: CharacterData, breed_id: String) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	ensure_mount_data(p)
	
	var h_def = HORSE_BREEDS.get(breed_id, {})
	if h_def.is_empty():
		return {"success": false, "reason": "Неизвестная порода лошади"}
		
	var cost = int(h_def["cost"])
	if p.gold < cost:
		return {"success": false, "reason": "Недостаточно золота для покупки скакуна (требуется %d з.)" % cost}
		
	p.gold -= cost
	var horses: Array = p.settlement.get("horses", [])
	var horse_inst = {
		"id": "horse_%d" % Time.get_ticks_msec(),
		"breed": breed_id,
		"name": h_def["name"],
		"hp": h_def["max_hp"],
		"max_hp": h_def["max_hp"]
	}
	horses.append(horse_inst)
	p.settlement["horses"] = horses
	p.settlement["active_horse"] = breed_id
	p.add_skill_xp("survival", 35.0)
	
	return {
		"success": true,
		"name": h_def["name"],
		"icon": h_def["icon"]
	}

static func get_mount_speed_mult(p: CharacterData) -> float:
	if not p: return 1.0
	ensure_mount_data(p)
	var active_b = p.settlement.get("active_horse", "")
	if active_b == "": return 1.0
	var h_def = HORSE_BREEDS.get(active_b, {})
	return float(h_def.get("speed_mult", 1.70))

static func get_mount_ram_damage(p: CharacterData) -> int:
	if not p: return 0
	ensure_mount_data(p)
	var active_b = p.settlement.get("active_horse", "")
	if active_b == "": return 0
	var h_def = HORSE_BREEDS.get(active_b, {})
	return int(h_def.get("ram_dmg", 12))
