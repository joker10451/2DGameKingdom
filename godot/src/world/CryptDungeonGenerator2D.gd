class_name CryptDungeonGenerator2D
extends RefCounted

## ГЕНЕРАТОР ПОДЗЕМЕЛЬЯ «СКЛЕП ЗАБЫТЫХ»
## Создает многокомнатное подземелье с коридорами, факелами, ловушками и тронным залом

const DUNGEON_WIDTH := 32
const DUNGEON_HEIGHT := 32

var ground_tiles: Dictionary = {}
var structure_tiles: Dictionary = {}
var dungeon_nodes: Dictionary = {}
var traps: Array[Vector2i] = []
var boss_arena_center: Vector2i = Vector2i(22, 22)

func generate_crypt() -> void:
	ground_tiles.clear()
	structure_tiles.clear()
	dungeon_nodes.clear()
	traps.clear()
	
	# 1. Заполняем все сплошным монолитным камнем
	for y in range(DUNGEON_HEIGHT):
		for x in range(DUNGEON_WIDTH):
			var pos = Vector2i(x, y)
			structure_tiles[pos] = "wall_stone"
			ground_tiles[pos] = "stone_floor"
			
	# 2. Вырубаем комнаты
	_carve_room(Vector2i(4, 4), 6, 6)   # Зал Входа (Спуск)
	_carve_room(Vector2i(14, 4), 8, 6)  # Зал Саркофагов
	_carve_room(Vector2i(4, 14), 7, 7)  # Зал Тюремных Камер
	_carve_room(Vector2i(14, 14), 6, 6) # Зал Ловушек
	_carve_room(Vector2i(18, 18), 10, 10) # Тронный Зал Короля Малгора (Босс)
	
	# 3. Прорубаем коридоры
	_carve_corridor_h(9, 15, 6)
	_carve_corridor_v(6, 9, 15)
	_carve_corridor_h(10, 15, 16)
	_carve_corridor_v(16, 9, 15)
	_carve_corridor_h(18, 20, 16)
	_carve_corridor_v(16, 16, 20)
	
	# 4. Расставляем саркофаги, факелы и ловушки
	_spawn_dungeon_object(Vector2i(6, 6), "ladder_up", "🪜 Лестница Наверх (Выход в Олдерию)")
	
	# Саркофаги в зале 1
	_spawn_dungeon_object(Vector2i(16, 6), "sarcophagus", "🪦 Древний Саркофаг Воителя")
	_spawn_dungeon_object(Vector2i(19, 6), "sarcophagus", "🪦 Саркофаг Верховного Жреца")
	
	# Напольные шиповые ловушки в Зале Ловушек
	traps.append(Vector2i(15, 15))
	traps.append(Vector2i(17, 16))
	traps.append(Vector2i(16, 17))
	
	# Факелы склепа
	_spawn_dungeon_object(Vector2i(4, 4), "crypt_torch", "🔥 Факел Склепа")
	_spawn_dungeon_object(Vector2i(14, 4), "crypt_torch", "🔥 Факел Склепа")
	_spawn_dungeon_object(Vector2i(18, 18), "crypt_torch", "🔥 Факел Склепа")
	_spawn_dungeon_object(Vector2i(26, 18), "crypt_torch", "🔥 Факел Склепа")
	_spawn_dungeon_object(Vector2i(18, 26), "crypt_torch", "🔥 Факел Склепа")
	_spawn_dungeon_object(Vector2i(26, 26), "crypt_torch", "🔥 Факел Склепа")
	
	# Королевский Сундук в тронном зале
	_spawn_dungeon_object(Vector2i(23, 19), "royal_chest", "👑 Королевский Сундук Малгора")

func _carve_room(start: Vector2i, w: int, h: int) -> void:
	for dy in range(h):
		for dx in range(w):
			var p = start + Vector2i(dx, dy)
			structure_tiles.erase(p)
			ground_tiles[p] = "stone_floor"

func _carve_corridor_h(x1: int, x2: int, y: int) -> void:
	for x in range(min(x1, x2), max(x1, x2) + 1):
		var p = Vector2i(x, y)
		structure_tiles.erase(p)
		ground_tiles[p] = "stone_floor"

func _carve_corridor_v(x: int, y1: int, y2: int) -> void:
	for y in range(min(y1, y2), max(y1, y2) + 1):
		var p = Vector2i(x, y)
		structure_tiles.erase(p)
		ground_tiles[p] = "stone_floor"

func _spawn_dungeon_object(pos: Vector2i, type: String, display_name: String) -> void:
	dungeon_nodes[pos] = {
		"type": type,
		"name": display_name,
		"hp": 999
	}
