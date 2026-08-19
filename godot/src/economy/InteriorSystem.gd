class_name InteriorSystem
extends RefCounted

## СИСТЕМА ИНТЕРЬЕРОВ, МЕБЛИРОВКИ И ОЦЕНКИ УЮТА ДОМОВ

static func evaluate_room_comfort(bed_tile: Vector2i, world_map: Node2D) -> Dictionary:
	if not world_map or bed_tile == Vector2i(-1, -1):
		return {
			"tier": "shack",
			"name": "Простая Лачуга",
			"score": 0,
			"mood_bonus": 0.0,
			"speed_bonus": 1.0,
			"thought": ""
		}
		
	var score := 0
	var found_floor := 0
	var found_table := false
	var found_chair := false
	var found_fire := false
	var found_candle := false
	var found_rug := false
	
	# Сканируем радиус 4x4 тайлов вокруг кровати
	for dy in range(-3, 4):
		for dx in range(-3, 4):
			var pos = bed_tile + Vector2i(dx, dy)
			if world_map.ground_tiles.get(pos) == "wood_floor":
				found_floor += 1
				
			if world_map.interactive_nodes.has(pos):
				var t = world_map.interactive_nodes[pos].get("type", "")
				if t == "table_oak": found_table = true
				elif t == "chair_oak": found_chair = true
				elif t == "fireplace" or t == "campfire": found_fire = true
				elif t == "candle_stand": found_candle = true
				elif t == "rug_wolf": found_rug = true
				
	score += mini(found_floor * 2, 14)
	if found_table: score += 15
	if found_chair: score += 10
	if found_fire: score += 20
	if found_candle: score += 10
	if found_rug: score += 15
	
	if score >= 50:
		return {
			"tier": "luxury",
			"name": "Роскошная Усадьба 🏰",
			"score": score,
			"mood_bonus": 25.0,
			"speed_bonus": 1.20,
			"thought": "🟢 [color=gold]+25 Роскошные покои с камином и коврами[/color]"
		}
	elif score >= 25:
		return {
			"tier": "cozy",
			"name": "Уютное Жилье 🏡",
			"score": score,
			"mood_bonus": 15.0,
			"speed_bonus": 1.10,
			"thought": "🟢 [color=lightgreen]+15 Мой дом опрятен и удобен[/color]"
		}
	else:
		return {
			"tier": "shack",
			"name": "Простая Лачуга 🏚️",
			"score": score,
			"mood_bonus": 0.0,
			"speed_bonus": 1.0,
			"thought": ""
		}
