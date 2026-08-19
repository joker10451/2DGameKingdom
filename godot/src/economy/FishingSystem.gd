class_name FishingSystem
extends RefCounted

## СИСТЕМА РЕЧНОЙ РЫБАЛКИ И КУЛИНАРИИ УХИ

const FISH_TABLE := [
	{"id": "fish_trout", "name": "Речная Форель", "icon": "🐟", "weight": 35},
	{"id": "fish_carp", "name": "Зеркальный Карп", "icon": "🐟", "weight": 25},
	{"id": "fish_pike", "name": "Озерная Щука", "icon": "🐟", "weight": 20},
	{"id": "fish_catfish", "name": "Речной Сом", "icon": "🐟", "weight": 12},
	{"id": "fish_eel", "name": "Речной Угорь", "icon": "🐟", "weight": 8}
]

static func is_near_water(tile_pos: Vector2i, world_map: Node2D) -> bool:
	if not world_map: return false
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			var check_tile = tile_pos + Vector2i(dx, dy)
			if world_map.ground_tiles.get(check_tile) == "water":
				return true
	return false

static func catch_fish(p: CharacterData) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	
	if p.get_item_count("fishing_rod") < 1:
		return {"success": false, "reason": "Вам нужна удочка в инвентаре (Удочка из ясеня)!"}
		
	var has_bait = (p.get_item_count("bait") >= 1)
	if has_bait:
		p.remove_item("bait", 1)
		
	# Выбор рыбы
	var total_w := 0
	for f in FISH_TABLE:
		total_w += f["weight"]
		
	var roll = randi_range(1, total_w)
	var accumulated := 0
	var caught_fish = FISH_TABLE[0]
	
	for f in FISH_TABLE:
		accumulated += f["weight"]
		if roll <= accumulated:
			caught_fish = f
			break
			
	p.inventory[caught_fish["id"]] = p.inventory.get(caught_fish["id"], 0) + 1
	p.add_skill_xp("survival", 25.0)
	
	return {
		"success": true,
		"fish_id": caught_fish["id"],
		"fish_name": caught_fish["name"],
		"fish_icon": caught_fish["icon"],
		"used_bait": has_bait
	}

static func cook_fish_soup(p: CharacterData) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	
	var total_fish := 0
	var fish_to_consume: Array[String] = []
	
	for f in FISH_TABLE:
		var c = p.get_item_count(f["id"])
		while c > 0 and fish_to_consume.size() < 2:
			fish_to_consume.append(f["id"])
			c -= 1
			
	if fish_to_consume.size() < 2:
		return {"success": false, "reason": "Для Царской Ухи требуется 2 любые речные рыбы!"}
		
	for f_id in fish_to_consume:
		p.remove_item(f_id, 1)
		
	p.inventory["fish_soup"] = p.inventory.get("fish_soup", 0) + 1
	p.add_skill_xp("survival", 35.0)
	
	return {
		"success": true,
		"item_id": "fish_soup",
		"name": "Царская Уха 🍲"
	}
