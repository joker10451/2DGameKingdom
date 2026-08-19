class_name GarrisonManager
extends RefCounted

## УПРАВЛЕНИЕ ГОРОДСКИМ ГАРНИЗОНОМ И СТРАЖЕЙ ПОСЕЛЕНИЯ

const UNIT_TYPES := {
	"militia": {
		"id": "militia",
		"name": "Городской Ополченец",
		"icon": "🗡️",
		"cost": 15,
		"wage": 2,
		"hp": 75.0,
		"defense": 6,
		"is_ranged": false,
		"desc": "Пехотинец с мечом и деревянным щитом. Защищает порядок и патрулирует частокол."
	},
	"archer": {
		"id": "archer",
		"name": "Дозорный Лучник",
		"icon": "🏹",
		"cost": 25,
		"wage": 3,
		"hp": 65.0,
		"defense": 4,
		"is_ranged": true,
		"desc": "Меткий стрелок из лука. Занимает вышки и прикрывает союзников издали."
	},
	"man_at_arms": {
		"id": "man_at_arms",
		"name": "Ветеран-Латник",
		"icon": "🛡️",
		"cost": 45,
		"wage": 5,
		"hp": 120.0,
		"defense": 12,
		"is_ranged": false,
		"desc": "Тяжелый рыцарский пехотинец в пластинчатых латах. Несокрушимая сила в штурмах."
	}
}

static func ensure_garrison(p: CharacterData) -> void:
	if not p: return
	if not p.settlement.has("garrison"):
		p.settlement["garrison"] = []

static func get_garrison_units(p: CharacterData) -> Array:
	if not p: return []
	ensure_garrison(p)
	return p.settlement.get("garrison", [])

static func recruit_unit(p: CharacterData, unit_type: String) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	ensure_garrison(p)
	
	var u_def = UNIT_TYPES.get(unit_type, {})
	if u_def.is_empty():
		return {"success": false, "reason": "Неизвестный тип бойца"}
		
	var treasury = int(p.settlement.get("treasury", 0))
	var cost = int(u_def.get("cost", 15))
	
	if treasury < cost:
		return {"success": false, "reason": "В казне поселения недостаточно золота (требуется %d з., в казне: %d з.)" % [cost, treasury]}
		
	p.settlement["treasury"] = treasury - cost
	
	var rand_names = ["Олаф", "Данте", "Роланд", "Эрик", "Седрик", "Бьёрн", "Гавейн", "Торвальд"]
	var soldier = {
		"id": "garrison_%d" % Time.get_ticks_msec(),
		"name": "%s %s" % [u_def.get("name", "Стражник"), rand_names[randi() % rand_names.size()]],
		"unit_type": unit_type,
		"hp": u_def["hp"],
		"max_hp": u_def["hp"],
		"defense": u_def["defense"],
		"is_ranged": u_def["is_ranged"],
		"wage": u_def["wage"]
	}
	
	var g_list: Array = p.settlement.get("garrison", [])
	g_list.append(soldier)
	p.settlement["garrison"] = g_list
	
	return {
		"success": true,
		"soldier": soldier,
		"name": soldier["name"]
	}

static func dismiss_unit(p: CharacterData, unit_idx: int) -> bool:
	if not p: return false
	ensure_garrison(p)
	var g_list: Array = p.settlement.get("garrison", [])
	if unit_idx >= 0 and unit_idx < g_list.size():
		g_list.remove_at(unit_idx)
		p.settlement["garrison"] = g_list
		return true
	return false

static func calculate_daily_wages(p: CharacterData) -> int:
	if not p: return 0
	ensure_garrison(p)
	var total := 0
	for s in p.settlement.get("garrison", []):
		total += int(s.get("wage", 2))
	return total

static func pay_daily_wages(p: CharacterData) -> Dictionary:
	if not p: return {"paid": 0, "shortfall": 0}
	ensure_garrison(p)
	var wages = calculate_daily_wages(p)
	var treasury = int(p.settlement.get("treasury", 0))
	
	if treasury >= wages:
		p.settlement["treasury"] = treasury - wages
		return {"paid": wages, "shortfall": 0}
	else:
		p.settlement["treasury"] = 0
		return {"paid": treasury, "shortfall": wages - treasury}

static func get_garrison_power(p: CharacterData) -> int:
	if not p: return 0
	ensure_garrison(p)
	var pwr := 0
	for s in p.settlement.get("garrison", []):
		match s.get("unit_type", ""):
			"militia": pwr += 10
			"archer": pwr += 15
			"man_at_arms": pwr += 25
	return pwr
