class_name DungeonGenerator2D
extends RefCounted

## ПРОЦЕДУРНЫЙ ГЕНЕРАТОР СКЛЕПА ЗАБЫТЫХ (32x32 КАТАКОМБЫ)
## Создает залы, коридоры, колонны, ловушки, саркофаги и тронный зал босса

const DUNGEON_SIZE := 32

var ground_tiles: Dictionary = {}
var structure_tiles: Dictionary = {}
var dungeon_nodes: Dictionary = {}

func generate_crypt() -> Dictionary:
	ground_tiles.clear()
	structure_tiles.clear()
	dungeon_nodes.clear()
	
	# Заполняем все каменными стенами склепа
	for y in range(DUNGEON_SIZE):
		for x in range(DUNGEON_SIZE):
			var pos = Vector2i(x, y)
			structure_tiles[pos] = "wall_stone"
			
	# Создаем 4 основных зала
	_carve_room(Vector2i(3, 3), 7, 7)    # Стартовый зал с лестницей наверх
	_carve_room(Vector2i(17, 3), 9, 7)   # Зал саркофагов
	_carve_room(Vector2i(3, 17), 8, 8)   # Зал ритуальных жаровен
	_carve_room(Vector2i(17, 17), 11, 11) # Тронный Зал Мальгрима
	
	# Прорубаем каменные коридоры между залами
	_carve_corridor_h(10, 17, 6)
	_carve_corridor_v(6, 10, 17)
	_carve_corridor_h(11, 17, 21)
	_carve_corridor_v(21, 10, 17)
	
	# Лестница на поверхность в стартовом зале (5, 5)
	dungeon_nodes[Vector2i(5, 5)] = {
		"type": "ladder_up",
		"name": "🪜 Каменная Лестница на Поверхность"
	}
	
	# Саркофаги и сокровища в зале саркофагов
	dungeon_nodes[Vector2i(20, 5)] = {"type": "sarcophagus", "name": "⚰️ Древний Саркофаг Барона", "is_opened": false}
	dungeon_nodes[Vector2i(23, 5)] = {"type": "sarcophagus", "name": "⚰️ Саркофаг Верховного Жреца", "is_opened": false}
	
	# Ловушки на плитах в коридорах
	dungeon_nodes[Vector2i(13, 6)] = {"type": "trap_spikes", "name": "⚠️ Нажимная Плита с Шипами", "dmg": 15}
	dungeon_nodes[Vector2i(21, 13)] = {"type": "trap_spikes", "name": "⚠️ Нажимная Плита с Шипами", "dmg": 15}
	
	# Трон и Сокровищница Мальгрима в тронном зале
	dungeon_nodes[Vector2i(22, 22)] = {
		"type": "boss_throne",
		"name": "👑 Проклятый Трон Мальгрима"
	}
	dungeon_nodes[Vector2i(25, 20)] = {
		"type": "chest_gold",
		"name": "📦 Золотой Ковчег Склепа",
		"inventory": {"gold_coins": 150, "gem_ruby": 2, "damascus_sword": 1}
	}
	
	return {
		"ground": ground_tiles,
		"structures": structure_tiles,
		"nodes": dungeon_nodes
	}

func _carve_room(start: Vector2i, w: int, h: int) -> void:
	for dy in range(h):
		for dx in range(w):
			var p = start + Vector2i(dx, dy)
			ground_tiles[p] = "stone_floor"
			structure_tiles.erase(p)

func _carve_corridor_h(x1: int, x2: int, y: int) -> void:
	for x in range(min(x1, x2), max(x1, x2) + 1):
		var p = Vector2i(x, y)
		ground_tiles[p] = "stone_floor"
		structure_tiles.erase(p)

func _carve_corridor_v(x: int, y1: int, y2: int) -> void:
	for y in range(min(y1, y2), max(y1, y2) + 1):
		var p = Vector2i(x, y)
		ground_tiles[p] = "stone_floor"
		structure_tiles.erase(p)
