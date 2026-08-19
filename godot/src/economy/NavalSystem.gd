class_name NavalSystem
extends RefCounted

## МОРСКАЯ ВЕРФЬ, СУДОСТРОЕНИЕ И ЭКСПЕДИЦИИ

const SHIPS := {
	"ship_longboat": {
		"id": "ship_longboat",
		"name": "Рыбацкий Баркас",
		"icon": "🚣",
		"cost": 60,
		"wood_cost": 8,
		"desc": "Маневренный баркас для глубоководной морской ловли лосося, тунца и жемчуга."
	},
	"ship_cog": {
		"id": "ship_cog",
		"name": "Купеческий Когг",
		"icon": "⛵",
		"cost": 120,
		"wood_cost": 16,
		"desc": "Вместительный парусный корабль для заморской торговли шелком и пряностями."
	},
	"ship_drakkar": {
		"id": "ship_drakkar",
		"name": "Боевой Драккар",
		"icon": "🏴‍☠️",
		"cost": 220,
		"wood_cost": 24,
		"desc": "Тяжелый боевой корабль викингов для десантных высадок на Забытые Острова."
	}
}

static func ensure_naval_data(p: CharacterData) -> void:
	if not p: return
	if not p.settlement.has("ships"):
		p.settlement["ships"] = []
	if not p.settlement.has("active_ship"):
		p.settlement["active_ship"] = ""

static func build_ship(p: CharacterData, ship_id: String) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	ensure_naval_data(p)
	
	var s_def = SHIPS.get(ship_id, {})
	if s_def.is_empty():
		return {"success": false, "reason": "Неизвестный тип корабля"}
		
	var cost = int(s_def["cost"])
	var wood_req = int(s_def["wood_cost"])
	
	if p.gold < cost:
		return {"success": false, "reason": "Недостаточно золота для постройки судна (требуется %d з.)" % cost}
		
	if p.get_item_count("wood") < wood_req:
		return {"success": false, "reason": "Недостаточно бревен для корпуса корабля (требуется %d шт.)" % wood_req}
		
	p.gold -= cost
	p.remove_item("wood", wood_req)
	
	var ships: Array = p.settlement.get("ships", [])
	var ship_inst = {
		"id": "ship_%d" % Time.get_ticks_msec(),
		"type": ship_id,
		"name": s_def["name"]
	}
	ships.append(ship_inst)
	p.settlement["ships"] = ships
	p.settlement["active_ship"] = ship_id
	p.add_skill_xp("crafting", 60.0)
	
	return {
		"success": true,
		"name": s_def["name"],
		"icon": s_def["icon"]
	}

static func go_sea_fishing(p: CharacterData) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	ensure_naval_data(p)
	
	var active_s = p.settlement.get("active_ship", "")
	if active_s == "":
		return {"success": false, "reason": "Вам нужен корабль (постройте судно на Верфи)!"}
		
	# Ролл улова
	var roll = randf()
	var caught_item := "fish_salmon"
	var count := 1
	
	if roll < 0.45:
		caught_item = "fish_salmon"
		count = randi_range(2, 4)
	elif roll < 0.75:
		caught_item = "fish_tuna"
		count = randi_range(1, 3)
	elif roll < 0.92:
		caught_item = "pearl"
		count = 1
	else:
		caught_item = "ancient_relic"
		count = 1
		
	p.inventory[caught_item] = p.inventory.get(caught_item, 0) + count
	p.add_skill_xp("survival", 40.0)
	var it = ItemDatabase.get_item(caught_item)
	
	return {
		"success": true,
		"item_id": caught_item,
		"name": it.get("name", caught_item),
		"icon": it.get("icon", "🐟"),
		"count": count
	}
