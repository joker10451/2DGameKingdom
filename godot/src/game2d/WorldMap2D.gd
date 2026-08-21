class_name WorldMap2D
extends Node2D

## КАРТА МИРА И ИНТЕРАКТИВНЫЕ ОБЪЕКТЫ В СТИЛЕ SOULASH 2
## Управляет сеткой тайлов, интерактивными ресурсами, зданиями, фортификациями и мебелью

const TILE_SIZE := 48
const MAP_WIDTH := 64
const MAP_HEIGHT := 64

# Слои тайлов: [x, y] -> tile_type
var ground_tiles: Dictionary = {}
var structure_tiles: Dictionary = {}

# Интерактивные объекты мира: [Vector2i] -> Dictionary (Node Data)
var interactive_nodes: Dictionary = {}

signal node_harvested(pos: Vector2i, item_id: String, amount: int)
signal tile_changed(pos: Vector2i)

func _ready() -> void:
	generate_world()

func generate_world(_biome: String = "village", _loc_id: String = "village_olderia") -> void:
	ground_tiles.clear()
	structure_tiles.clear()
	interactive_nodes.clear()
	
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var pos = Vector2i(x, y)
			ground_tiles[pos] = "grass"
			
			# Река на востоке (x: 52-55)
			if x >= 52 and x <= 55:
				ground_tiles[pos] = "water"
				# Деревянный мост (y: 30-33)
				if y >= 30 and y <= 33:
					ground_tiles[pos] = "wood_floor"
			
			# Центральная мощеная дорога (y: 31-32)
			if (y == 31 or y == 32) and ground_tiles[pos] != "water":
				ground_tiles[pos] = "road"
				
			# Вертикальная дорога к замку (x: 31-32, y: 12-48)
			if (x == 31 or x == 32) and y >= 12 and y <= 48 and ground_tiles[pos] != "water":
				ground_tiles[pos] = "road"
	
	# Создание зданий деревни
	_build_house(Vector2i(20, 22), 8, 6, "Таверна «Пьяный Вепрь» 🍺")
	_build_house(Vector2i(36, 22), 7, 6, "Кузница Вульфрика ⚒️")
	_build_house(Vector2i(20, 36), 7, 7, "Рыночные ряды ⚖️")
	_build_house(Vector2i(36, 36), 8, 7, "Усадьба Лорда 👑")
	
	# Кровати, сундуки и вход в подземелье
	_spawn_furniture(Vector2i(21, 23), "bed", "Уютная Кровать 🛏️")
	_spawn_furniture(Vector2i(26, 23), "chest", "Дубовый Сундук 📦", {"bread": 3, "ale": 2, "gold_coins": 15})
	_spawn_furniture(Vector2i(37, 23), "chest", "Сундук Кузнеца 📦", {"iron_ore": 6, "iron_ingot": 2})
	_spawn_furniture(Vector2i(24, 25), "campfire", "Очаг Таверны 🔥")
	_spawn_furniture(Vector2i(6, 6), "cave_entrance", "🕳️ Вход в Склеп Забытых (Подземелье)")
	
	# Заборы пастбища и стога сена
	for px in range(12, 20):
		structure_tiles[Vector2i(px, 35)] = "wooden_fence"
		structure_tiles[Vector2i(px, 42)] = "wooden_fence"
	for py in range(36, 42):
		structure_tiles[Vector2i(12, py)] = "wooden_fence"
		structure_tiles[Vector2i(19, py)] = "wooden_fence"
	structure_tiles.erase(Vector2i(15, 35)) # Калитка пастбища

	# Фонарные столбы вдоль дороги
	for ly in [18, 26, 34, 42]:
		_spawn_furniture(Vector2i(30, ly), "candle_stand", "Уличный Фонарь 🕯️")
		_spawn_furniture(Vector2i(33, ly), "candle_stand", "Уличный Фонарь 🕯️")

	# Производственные станки деревни и Доска Объявлений
	_spawn_furniture(Vector2i(23, 21), "alarm_bell", "🔔 Тревожный Колокол Олдерии")
	_spawn_furniture(Vector2i(25, 29), "notice_board", "Доска Объявлений и Контрактов 📜")
	_spawn_furniture(Vector2i(15, 52), "windmill", "Мельничные Жернова 💨")
	_spawn_furniture(Vector2i(22, 25), "bakery_oven", "Деревенская Печь 🍞")
	_spawn_furniture(Vector2i(26, 38), "tannery", "Кожевенный Чан 🧥")
	_spawn_furniture(Vector2i(35, 24), "carpentry", "Плотницкий Верстак 🪚")
	_spawn_furniture(Vector2i(21, 37), "alchemy_lab", "Алхимический Стол 🧪")
	_spawn_furniture(Vector2i(25, 48), "beehive", "Пчелиный Улей 🐝")
	_spawn_furniture(Vector2i(35, 48), "stable", "Конюшня Олдерии 🐎")
	_spawn_furniture(Vector2i(6, 45), "shipyard", "Морская Верфь ⛵")
	
	# 1. Органичные рощи и лесные массивы (Северный бор, Восточный лес, Южные чащи)
	var forest_centers = [
		Vector2i(8, 12), Vector2i(14, 18), Vector2i(8, 24),
		Vector2i(46, 14), Vector2i(52, 20),
		Vector2i(10, 52), Vector2i(46, 52),
	]
	for fc in forest_centers:
		for dy in range(-6, 7):
			for dx in range(-6, 7):
				var pos = fc + Vector2i(dx, dy)
				if pos.x < 1 or pos.x >= MAP_WIDTH - 1 or pos.y < 1 or pos.y >= MAP_HEIGHT - 1:
					continue
				var dist = sqrt(dx * dx + dy * dy)
				if dist <= 5.5 and ground_tiles.get(pos) == "grass" and not structure_tiles.has(pos) and not interactive_nodes.has(pos):
					# Прореживание: деревья растут естественными группами с расстоянием
					if (pos.x + pos.y * 2) % 3 == 0 and randf() < 0.65:
						var t_type = "tree_oak" if randf() < 0.6 else "tree_birch"
						_spawn_node(pos, t_type, "Дуб 🌳" if t_type == "tree_oak" else "Береза 🌲", "wood", randi_range(2, 4), 3)
					elif randf() < 0.08:
						_spawn_node(pos, "bush", "Кустарник 🌿", "wood", 1, 1)
					elif randf() < 0.06:
						_spawn_node(pos, "mushroom", "Лесной Гриб 🍄", "mushroom", 1, 1)

	# 2. Каменные гряды и рудные жилы (Горные выходы на северо-востоке и скалы)
	var rock_outcrops = [Vector2i(44, 8), Vector2i(47, 12), Vector2i(8, 38)]
	for rc in rock_outcrops:
		for dy in range(-3, 4):
			for dx in range(-3, 4):
				var pos = rc + Vector2i(dx, dy)
				if pos.x < 1 or pos.x >= MAP_WIDTH - 1 or pos.y < 1 or pos.y >= MAP_HEIGHT - 1:
					continue
				var dist = sqrt(dx * dx + dy * dy)
				if dist <= 3.0 and ground_tiles.get(pos) == "grass" and not structure_tiles.has(pos) and not interactive_nodes.has(pos):
					if randf() < 0.45:
						var r_roll = randf()
						if r_roll < 0.45:
							_spawn_node(pos, "rock", "Каменный Валун 🪨", "stone", randi_range(2, 4), 4)
						elif r_roll < 0.75:
							_spawn_node(pos, "ore_iron", "Железная Жила ⛏️", "iron_ore", randi_range(2, 5), 4)
						elif r_roll < 0.90:
							_spawn_node(pos, "ore_copper", "Медная Жила ⛏️", "copper_ore", randi_range(2, 4), 4)
						else:
							_spawn_node(pos, "ore_gold", "Золотая Жила ✨", "gold_ore", randi_range(1, 3), 5)

	# 3. Декоративные валуны, руда и деревья на окраинах деревенской площади
	_spawn_node(Vector2i(18, 28), "rock", "Каменный Валун 🪨", "stone", 3, 4)
	_spawn_node(Vector2i(38, 28), "ore_iron", "Железный Валун ⛏️", "iron_ore", 3, 4)
	_spawn_node(Vector2i(18, 20), "tree_oak", "Вековой Дуб 🌳", "wood", 4, 3)
	_spawn_node(Vector2i(38, 20), "tree_birch", "Белая Береза 🌲", "wood", 3, 3)

func _build_house(start_pos: Vector2i, w: int, h: int, building_name: String) -> void:
	for dy in range(h):
		for dx in range(w):
			var p = start_pos + Vector2i(dx, dy)
			ground_tiles[p] = "wood_floor" if "Таверна" in building_name else "stone_floor"
			
			var is_wall = (dx == 0 or dx == w - 1 or dy == 0 or dy == h - 1)
			var is_door = (dy == h - 1 and dx == w / 2)
			
			if is_wall and not is_door:
				structure_tiles[p] = "wall_stone" if ("Кузница" in building_name or "Лорд" in building_name) else "wall_wood"
			elif is_door:
				_spawn_door(p)

func _spawn_door(pos: Vector2i) -> void:
	interactive_nodes[pos] = {
		"type": "door",
		"name": "Деревянная Дверь 🚪",
		"is_open": false,
		"hp": 100,
		"max_hp": 100
	}

func _spawn_furniture(pos: Vector2i, type: String, display_name: String, initial_inv: Dictionary = {}) -> void:
	interactive_nodes[pos] = {
		"type": type,
		"name": display_name,
		"inventory": initial_inv,
		"hp": 999,
		"max_hp": 999
	}

func _spawn_node(pos: Vector2i, type: String, display_name: String, drop_item: String, drop_amt: int, max_hp: int) -> void:
	interactive_nodes[pos] = {
		"type": type,
		"name": display_name,
		"drop_item": drop_item,
		"drop_amt": drop_amt,
		"hp": max_hp,
		"max_hp": max_hp
	}

func toggle_door(pos: Vector2i) -> bool:
	if interactive_nodes.has(pos) and interactive_nodes[pos]["type"] == "door":
		var door = interactive_nodes[pos]
		door["is_open"] = not door.get("is_open", false)
		queue_redraw()
		return door["is_open"]
	return false

func damage_node(pos: Vector2i, dmg: int = 1) -> Dictionary:
	return interact_tile(pos, dmg)

func interact_tile(pos: Vector2i, dmg: int = 1) -> Dictionary:
	if not interactive_nodes.has(pos):
		return {}
	
	var node = interactive_nodes[pos]
	if node["type"] in ["door", "chest", "bed", "campfire"]:
		return {"name": node["name"], "is_furniture": true, "type": node["type"]}
	
	node["hp"] -= dmg
	if node["hp"] <= 0:
		var result = {
			"destroyed": true,
			"item_id": node["drop_item"],
			"amount": node["drop_amt"],
			"name": node["name"],
			"type": node["type"]
		}
		interactive_nodes.erase(pos)
		node_harvested.emit(pos, result["item_id"], result["amount"])
		queue_redraw()
		return result
	else:
		queue_redraw()
		return {
			"destroyed": false,
			"hp": node["hp"],
			"name": node["name"],
			"type": node["type"]
		}

func can_walk(pos: Vector2i) -> bool:
	if pos.x < 0 or pos.x >= MAP_WIDTH or pos.y < 0 or pos.y >= MAP_HEIGHT:
		return false
	
	if ground_tiles.get(pos) == "water":
		return false
	
	if structure_tiles.has(pos):
		return false
		
	if interactive_nodes.has(pos):
		var node = interactive_nodes[pos]
		var t = node["type"]
		if t == "door" and node.get("is_open", false):
			return true
		if t in ["tree", "tree_oak", "tree_birch", "tree_pine", "rock", "stone", "ore_iron", "ore_copper", "ore_gold", "ore_coal", "wall_wood", "wall_stone", "door", "chest", "bed", "wooden_fence", "carpentry", "bakery_oven", "tannery", "windmill", "notice_board", "alarm_bell", "town_banner", "alchemy_lab", "beehive", "stable", "shipyard", "table_oak", "fireplace"]:
			return false
			
	return true

func find_nodes_of_type(type_name: String) -> Array[Vector2i]:
	var res: Array[Vector2i] = []
	for p in interactive_nodes.keys():
		if interactive_nodes[p].get("type") == type_name:
			res.append(p)
	return res

func find_adjacent_walkable_tile(target: Vector2i) -> Vector2i:
	var offsets = [
		Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)
	]
	for o in offsets:
		var check_p = target + o
		if can_walk(check_p):
			return check_p
	return target

func find_closest_walkable_node(from_pos: Vector2i, type_name: String) -> Vector2i:
	var nodes = find_nodes_of_type(type_name)
	if nodes.is_empty():
		return from_pos
	var best_node = nodes[0]
	var best_dist = float(from_pos.distance_squared_to(best_node))
	for n in nodes:
		var d = float(from_pos.distance_squared_to(n))
		if d < best_dist:
			best_dist = d
			best_node = n
	return find_adjacent_walkable_tile(best_node)


func place_structure(pos: Vector2i, type: String) -> bool:
	if structure_tiles.has(pos) or interactive_nodes.has(pos):
		return false
	
	if type in ["wall_wood", "wall_stone"]:
		structure_tiles[pos] = type
	elif type == "wood_floor":
		ground_tiles[pos] = "wood_floor"
	elif type == "door":
		_spawn_door(pos)
	elif type == "chest":
		_spawn_furniture(pos, "chest", "Сундук 📦", {})
	elif type == "bed":
		_spawn_furniture(pos, "bed", "Кровать 🛏️")
	elif type == "campfire":
		_spawn_furniture(pos, "campfire", "Костер 🔥")
	elif type == "wooden_fence":
		_spawn_furniture(pos, "wooden_fence", "Частокол 🪵")
	elif type == "carpentry":
		_spawn_furniture(pos, "carpentry", "Плотницкий Верстак 🪚")
	elif type == "bakery_oven":
		_spawn_furniture(pos, "bakery_oven", "Печь 🍞")
	elif type == "tannery":
		_spawn_furniture(pos, "tannery", "Кожевенный Чан 🧥")
	elif type == "town_banner":
		_spawn_furniture(pos, "town_banner", "🚩 Знамя Поселения")
	elif type == "alchemy_lab":
		_spawn_furniture(pos, "alchemy_lab", "Алхимический Стол 🧪")
	elif type == "beehive":
		_spawn_furniture(pos, "beehive", "Пчелиный Улей 🐝")
	elif type == "stable":
		_spawn_furniture(pos, "stable", "Конюшня 🐎")
	elif type == "shipyard":
		_spawn_furniture(pos, "shipyard", "Верфь ⛵")
	else:
		return false
		
	queue_redraw()
	tile_changed.emit(pos)
	return true

func remove_structure(pos: Vector2i) -> bool:
	if structure_tiles.has(pos):
		structure_tiles.erase(pos)
		queue_redraw()
		tile_changed.emit(pos)
		return true
	if interactive_nodes.has(pos):
		var n = interactive_nodes[pos]
		if n.get("type") in ["door", "chest", "bed", "campfire", "wooden_fence", "carpentry", "bakery_oven", "tannery", "town_banner", "alchemy_lab", "beehive", "stable", "shipyard"]:
			interactive_nodes.erase(pos)
			queue_redraw()
			tile_changed.emit(pos)
			return true
	return false

func _draw() -> void:
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var pos = Vector2i(x, y)
			var world_pos = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			
			# 1. Слой земли
			var g_type = ground_tiles.get(pos, "grass")
			var g_tex = SpriteGenerator2D.get_tile_texture(g_type, TILE_SIZE)
			draw_texture(g_tex, world_pos)
			
			# 2. Стены
			if structure_tiles.has(pos):
				var s_type = structure_tiles[pos]
				var s_tex = SpriteGenerator2D.get_tile_texture(s_type, TILE_SIZE)
				draw_texture(s_tex, world_pos)
			
			# 3. Интерактивные объекты и мебель (Единый Pixel-Art стиль с тенями)
			if interactive_nodes.has(pos):
				var node = interactive_nodes[pos]
				var n_type = node.get("type", "chest")
				if n_type == "door":
					n_type = "door_open" if node.get("is_open", false) else "door_closed"
				
				# Мягкая тень под объектом (не рисуем для колосьев на грядке)
				if n_type != "crop_wheat":
					var shadow_tex = SpriteGenerator2D.get_shadow_texture(18, 8)
					draw_texture(shadow_tex, world_pos + Vector2(6, 28))
				
				# Текстура объекта
				var n_tex = SpriteGenerator2D.get_node_texture(n_type, TILE_SIZE)
				draw_texture(n_tex, world_pos)
