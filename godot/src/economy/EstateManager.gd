class_name EstateManager
extends RefCounted

## МЕНЕДЖЕР ФЕОДАЛЬНОГО ПОМЕСТЬЯ И АВТОМАТИЗАЦИИ ТРУДА

const EstateDatabase = preload("res://src/economy/EstateDatabase.gd")
const MAX_WORKERS := 4

static func ensure_player_estate(p: CharacterData) -> void:
	if not p: return
	if not p.get('estate_workers'):
		p.set('estate_workers', [])
	if not p.get('estate_upgrades'):
		p.set('estate_upgrades', [])
	if not p.get('estate_storage'):
		p.set('estate_storage', {})

static func buy_land_deed(p: CharacterData) -> Dictionary:
	ensure_player_estate(p)
	if p.has_estate:
		return {"success": false, "reason": "У вас уже есть выкупленный земельный надел!"}
	if p.gold < EstateDatabase.LAND_DEED_COST:
		return {"success": false, "reason": "Недостаточно золота для покупки грамоты на землю (требуется %d з.)!" % EstateDatabase.LAND_DEED_COST}
	
	p.gold -= EstateDatabase.LAND_DEED_COST
	p.has_estate = true
	p.estate_level = 1
	if not p.owned_properties.has("estate_east"):
		p.owned_properties.append("estate_east")
	return {"success": true, "cost": EstateDatabase.LAND_DEED_COST}

static func hire_worker(p: CharacterData, worker_type: String) -> Dictionary:
	ensure_player_estate(p)
	if not p.has_estate:
		return {"success": false, "reason": "Сначала выкупите грамоту на землю поместья!"}
	if p.estate_workers.size() >= MAX_WORKERS:
		return {"success": false, "reason": "Достигнут максимум наемных рабочих (%d/%d)!" % [p.estate_workers.size(), MAX_WORKERS]}
	
	var def = EstateDatabase.get_worker_def(worker_type)
	if def.is_empty():
		return {"success": false, "reason": "Неизвестная профессия рабочего!"}
	
	var cost = def.get("hire_cost", 25)
	if p.gold < cost:
		return {"success": false, "reason": "Недостаточно золота для найма (требуется %d з.)!" % cost}
		
	p.gold -= cost
	p.estate_workers.append(worker_type)
	return {"success": true, "worker": def}

static func fire_worker(p: CharacterData, idx: int) -> bool:
	ensure_player_estate(p)
	if idx >= 0 and idx < p.estate_workers.size():
		p.estate_workers.remove_at(idx)
		return true
	return false

static func build_upgrade(p: CharacterData, upgrade_id: String) -> Dictionary:
	ensure_player_estate(p)
	if not p.has_estate:
		return {"success": false, "reason": "Сначала выкупите землю поместья!"}
	if p.estate_upgrades.has(upgrade_id):
		return {"success": false, "reason": "Это улучшение уже возведено в усадьбе!"}
		
	var def = EstateDatabase.get_upgrade_def(upgrade_id)
	if def.is_empty():
		return {"success": false, "reason": "Неизвестное строение!"}
		
	var cost = def.get("cost", {})
	var req_gold = cost.get("gold", 0)
	var req_wood = cost.get("wood", 0)
	var req_plank = cost.get("plank", 0)
	
	if p.gold < req_gold:
		return {"success": false, "reason": "Недостаточно золота (требуется %d з.)!" % req_gold}
	if p.get_item_count("wood") < req_wood:
		return {"success": false, "reason": "Недостаточно дубовых бревен (требуется %d шт.)!" % req_wood}
	if p.get_item_count("plank") < req_plank:
		return {"success": false, "reason": "Недостаточно обрезных досок (требуется %d шт.)!" % req_plank}
		
	p.gold -= req_gold
	if req_wood > 0: p.remove_item("wood", req_wood)
	if req_plank > 0: p.remove_item("plank", req_plank)
	
	p.estate_upgrades.append(upgrade_id)
	p.estate_level += 1
	return {"success": true, "upgrade": def}

static func produce_labor(p: CharacterData) -> Dictionary:
	ensure_player_estate(p)
	if not p.has_estate or p.estate_workers.size() == 0:
		return {"produced": {}}
		
	var total_produced: Dictionary = {}
	for w_type in p.estate_workers:
		var def = EstateDatabase.get_worker_def(w_type)
		var yields = def.get("yield", {})
		for item_id in yields.keys():
			var amt = yields[item_id]
			p.estate_storage[item_id] = p.estate_storage.get(item_id, 0) + amt
			total_produced[item_id] = total_produced.get(item_id, 0) + amt
			
	return {"produced": total_produced}

static func process_daily_estate_finances(p: CharacterData) -> Dictionary:
	ensure_player_estate(p)
	if not p.has_estate:
		return {"wages_paid": 0, "income": 0, "dismissed": []}
		
	var total_wages := 0
	for w_type in p.estate_workers:
		var def = EstateDatabase.get_worker_def(w_type)
		total_wages += def.get("daily_wage", 3)
		
	var income := 0
	if p.estate_upgrades.has("livestock"):
		income = 15
		p.gold += income
		
	var dismissed: Array[String] = []
	if p.gold >= total_wages:
		p.gold -= total_wages
	else:
		# Не хватает денег — рабочие уходят
		while p.estate_workers.size() > 0 and p.gold < total_wages:
			var removed_type = p.estate_workers.pop_back()
			var def = EstateDatabase.get_worker_def(removed_type)
			dismissed.append(def.get("name", "Рабочий"))
			total_wages -= def.get("daily_wage", 3)
		p.gold = maxi(0, p.gold - total_wages)
		
	return {
		"wages_paid": total_wages,
		"income": income,
		"dismissed": dismissed
	}

static func take_all_from_storage(p: CharacterData) -> Dictionary:
	ensure_player_estate(p)
	var taken: Dictionary = {}
	for item_id in p.estate_storage.keys():
		var count = p.estate_storage[item_id]
		if count > 0:
			p.add_item(item_id, count)
			taken[item_id] = count
	p.estate_storage.clear()
	return taken
