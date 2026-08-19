class_name SettlementManager
extends RefCounted

## МЕНЕДЖЕР ОСНОВАНИЯ И РАЗВИТИЯ ПОСЕЛЕНИЙ KINGDOMS

const SettlementDatabase = preload("res://src/economy/SettlementDatabase.gd")

static func ensure_settlement(p: CharacterData) -> void:
	if not p: return
	if not p.get('settlement') or p.settlement.is_empty():
		p.settlement = {
			"has_town": false,
			"town_name": "Новое Поселение",
			"banner_tile": Vector2i(-1, -1),
			"tier": 1,
			"treasury": 0,
			"tax_rate": 0.10, # 10% налог
			"citizens": []
		}

static func found_settlement(p: CharacterData, town_name: String, banner_tile: Vector2i) -> Dictionary:
	ensure_settlement(p)
	p.settlement["has_town"] = true
	p.settlement["town_name"] = town_name if town_name != "" else "Вольный Удел"
	p.settlement["banner_tile"] = banner_tile
	p.settlement["tier"] = 1
	p.settlement["treasury"] = 25
	p.settlement["tax_rate"] = 0.10
	
	p.renown += 15
	p.honor += 10
	return {"success": true, "town_name": p.settlement["town_name"]}

static func add_citizen(p: CharacterData, citizen: Dictionary) -> bool:
	ensure_settlement(p)
	if not p.settlement.get("has_town", false): return false
	
	var c_list: Array = p.settlement.get("citizens", [])
	c_list.append(citizen)
	p.settlement["citizens"] = c_list
	return true

static func remove_citizen(p: CharacterData, citizen_id: String) -> bool:
	ensure_settlement(p)
	var c_list: Array = p.settlement.get("citizens", [])
	for i in range(c_list.size()):
		if c_list[i].get("id") == citizen_id:
			c_list.remove_at(i)
			p.settlement["citizens"] = c_list
			return true
	return false

static func set_citizen_profession(p: CharacterData, citizen_id: String, prof_id: String) -> bool:
	ensure_settlement(p)
	var c_list: Array = p.settlement.get("citizens", [])
	for c in c_list:
		if c.get("id") == citizen_id:
			c["profession"] = prof_id
			return true
	return false

static func set_tax_rate(p: CharacterData, rate: float) -> void:
	ensure_settlement(p)
	p.settlement["tax_rate"] = clampf(rate, 0.05, 0.30)

static func collect_daily_taxes(p: CharacterData) -> Dictionary:
	ensure_settlement(p)
	if not p.settlement.get("has_town", false):
		return {"tax_collected": 0, "guards_paid": 0, "net_income": 0}
		
	var tax_rate: float = float(p.settlement.get("tax_rate", 0.10))
	var c_list: Array = p.settlement.get("citizens", [])
	
	var total_tax := 0
	var total_guard_wages := 0
	
	for c in c_list:
		var prof_id = c.get("profession", "farmer")
		var p_def = SettlementDatabase.get_profession_def(prof_id)
		
		if prof_id == "guard":
			total_guard_wages += p_def.get("daily_wage", 3)
		else:
			var income = p_def.get("daily_income", 6)
			# Житель зарабатывает золото
			c["gold"] = c.get("gold", 10) + int(income * (1.0 - tax_rate))
			# Налог идет в казну
			var tax = maxi(1, int(income * tax_rate))
			total_tax += tax
			
	var cur_treasury: int = int(p.settlement.get("treasury", 0))
	cur_treasury += total_tax
	cur_treasury = maxi(0, cur_treasury - total_guard_wages)
	p.settlement["treasury"] = cur_treasury
	
	return {
		"tax_collected": total_tax,
		"guards_paid": total_guard_wages,
		"net_income": total_tax - total_guard_wages,
		"current_treasury": cur_treasury
	}

static func withdraw_treasury(p: CharacterData, amount: int) -> int:
	ensure_settlement(p)
	var cur = int(p.settlement.get("treasury", 0))
	var taken = mini(cur, amount)
	p.settlement["treasury"] = cur - taken
	p.gold += taken
	return taken

static func deposit_treasury(p: CharacterData, amount: int) -> bool:
	ensure_settlement(p)
	if p.gold < amount: return false
	p.gold -= amount
	p.settlement["treasury"] = int(p.settlement.get("treasury", 0)) + amount
	return true

static func update_tier_progress(p: CharacterData, total_beds: int) -> Dictionary:
	ensure_settlement(p)
	if not p.settlement.get("has_town", false):
		return {"tier": 1, "leveled_up": false}
		
	var pop = p.settlement.get("citizens", []).size()
	var cur_tier: int = int(p.settlement.get("tier", 1))
	var new_tier = cur_tier
	
	for t in range(5, 0, -1):
		var t_def = SettlementDatabase.get_tier_def(t)
		if pop >= t_def.get("pop_req", 1) and total_beds >= t_def.get("beds_req", 1):
			new_tier = t
			break
			
	var leveled_up = (new_tier > cur_tier)
	p.settlement["tier"] = new_tier
	return {
		"tier": new_tier,
		"leveled_up": leveled_up,
		"tier_def": SettlementDatabase.get_tier_def(new_tier)
	}

static func build_project(p: CharacterData, proj_id: String, origin_tile: Vector2i, world_map: Node2D) -> Dictionary:
	ensure_settlement(p)
	var pr_def = SettlementDatabase.get_project_def(proj_id)
	if pr_def.is_empty():
		return {"success": false, "reason": "Проект не найден"}
		
	var cost = pr_def.get("cost", {})
	for it_id in cost.keys():
		if it_id == "gold":
			if p.gold < cost[it_id]:
				return {"success": false, "reason": "Недостаточно золота (нужно %d з.)" % cost[it_id]}
		else:
			if p.get_item_count(it_id) < cost[it_id]:
				var it = ItemDatabase.get_item(it_id)
				return {"success": false, "reason": "Недостаточно ресурса: %s (нужно %d шт.)" % [it.get("name", it_id), cost[it_id]]}
				
	# Списание ресурсов
	for it_id in cost.keys():
		if it_id == "gold":
			p.gold -= cost[it_id]
		else:
			p.remove_item(it_id, cost[it_id])
			
	# Размещение структур
	var structures = pr_def.get("structures", [])
	for s in structures:
		var place_pos = origin_tile + s.get("rel_pos", Vector2i.ZERO)
		world_map.place_structure(place_pos, s.get("type", "wall_wood"))
		
	p.renown += 10
	return {"success": true, "name": pr_def.get("name", "")}

static func host_feast(p: CharacterData) -> Dictionary:
	ensure_settlement(p)
	
	if p.get_item_count("bread") < 3:
		return {"success": false, "reason": "Для пира нужно 3 буханки хлеба (хлеб в инвентаре: %d)" % p.get_item_count("bread")}
	if p.get_item_count("meat_raw") < 3 and p.get_item_count("meat_cooked") < 3 and p.get_item_count("fish_salmon") < 3:
		return {"success": false, "reason": "Для пира нужно 3 куска мяса или рыбы"}
	if p.get_item_count("mead") < 3 and p.gold < 30:
		return {"success": false, "reason": "Для пира нужно 3 кувшина медовухи или 30 золотых на выпивку"}
		
	p.remove_item("bread", 3)
	if p.get_item_count("meat_cooked") >= 3:
		p.remove_item("meat_cooked", 3)
	elif p.get_item_count("meat_raw") >= 3:
		p.remove_item("meat_raw", 3)
	else:
		p.remove_item("fish_salmon", 3)
		
	if p.get_item_count("mead") >= 3:
		p.remove_item("mead", 3)
	else:
		p.gold -= 30
		
	p.settlement["feast_timer"] = 120.0
	p.renown += 20
	p.honor += 15
	
	# Сброс забастовок и повышение настроения всех граждан
	var citizens: Array = p.settlement.get("citizens", [])
	for c in citizens:
		c["drank_ale_today"] = true
		c["hunger"] = 100.0
		
	return {
		"success": true,
		"message": "Королевский пир объявлен! Все жители города собрались на площади и празднуют!"
	}


