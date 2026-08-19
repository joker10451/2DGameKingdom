class_name OverworldMap2D
extends Node2D

## ГЛОБАЛЬНАЯ КАРТА МИРА ОЛДЕРИИ (OVERWORLD 128x128)
## Процедурные биомы, города, тракты, горы, болота и подземелья

const MAP_WIDTH: int = 128
const MAP_HEIGHT: int = 128
const TILE_SIZE: int = 36

var overworld_tiles: Dictionary = {} # Vector2i -> String
var locations: Dictionary = {}       # Vector2i -> Dictionary
var player_tile: Vector2i = Vector2i(54, 70)

const LOCATIONS_DEF := {
	Vector2i(54, 70): {
		"id": "village_olderia",
		"name": "Деревня Олдерия",
		"type": "village",
		"icon": "🏡",
		"color": Color(0.3, 0.85, 0.3),
		"desc": "Уютная деревня с таверной «Пьяный Вепрь», кузницей и пшеничными полями."
	},
	Vector2i(64, 64): {
		"id": "capital_olderia",
		"name": "Венец Олдерии (Столица)",
		"type": "city",
		"icon": "🏰",
		"color": Color(1.0, 0.85, 0.2),
		"desc": "Величественный каменный город, резиденция Верховного Барона и Гильдии Купцов."
	},
	Vector2i(64, 25): {
		"id": "mines_zhilnik",
		"name": "Кряж Жильников (Шахты)",
		"type": "mine",
		"icon": "⛏️",
		"color": Color(0.7, 0.7, 0.9),
		"desc": "Северные скалистые рудники Ордена Жильников. Добыча синего чугуна и серебра."
	},
	Vector2i(95, 65): {
		"id": "plains_farms",
		"name": "Вольные Жатвы (Мельницы)",
		"type": "farms",
		"icon": "🌾",
		"color": Color(0.95, 0.8, 0.3),
		"desc": "Бескрайние золотые поля и ветряные мельницы. Главная житница королевства."
	},
	Vector2i(25, 45): {
		"id": "fort_blackwood",
		"name": "🏰 Чернолесный Форт Разбойников",
		"type": "fort",
		"icon": "🏰",
		"color": Color(0.95, 0.3, 0.3),
		"enemy_count": 8,
		"gold_reward": 180,
		"captives": 2,
		"desc": "Укрепленный частокол в северных лесах. Шайка лесных грабителей держит здесь в неволе караванщиков."
	},
	Vector2i(75, 20): {
		"id": "fort_red_gorge",
		"name": "🏴‍☠️ Крепость Красного Ущелья",
		"type": "fort",
		"icon": "🏴‍☠️",
		"color": Color(0.95, 0.2, 0.2),
		"enemy_count": 12,
		"boss": "Атаман Гримвульф",
		"gold_reward": 320,
		"captives": 3,
		"desc": "Неприступная цитадель в скалах. Здесь скрывается грозный атаман Гримвульф со своими ветеранами."
	},
	Vector2i(18, 90): {
		"id": "fort_smugglers",
		"name": "⛓️ Лагерь Контрабандистов",
		"type": "fort",
		"icon": "⛓️",
		"color": Color(0.85, 0.4, 0.3),
		"enemy_count": 5,
		"gold_reward": 120,
		"captives": 2,
		"desc": "Тайная стоянка контрабандистов на речных затонах с сундуками краденого золота."
	},
	Vector2i(60, 105): {
		"id": "swamp_trostyanka",
		"name": "Топи Тростянок",
		"type": "swamp",
		"icon": "🌿",
		"color": Color(0.4, 0.8, 0.5),
		"desc": "Мглистые болота травников и знахарей. Сбор целебных бальзамов."
	},
	Vector2i(35, 85): {
		"id": "ancient_crypt",
		"name": "Склеп Первых Королей",
		"type": "dungeon",
		"icon": "💀",
		"color": Color(0.8, 0.4, 0.9),
		"desc": "Древний курган с некрополем и забытыми сокровищами."
	},
	Vector2i(10, 20): {
		"id": "island_isle_of_coves",
		"name": "🌴 Остров Пиратских Бухт",
		"type": "island",
		"icon": "🌴",
		"color": Color(0.2, 0.85, 0.85),
		"enemy_count": 8,
		"gold_reward": 380,
		"desc": "Тропический архипелаг в океане. Шайка корсаров прячет здесь сундуки с заморским шелком и золотом."
	},
	Vector2i(110, 110): {
		"id": "island_ancient_temple",
		"name": "🗿 Затонувший Храм Морей",
		"type": "island",
		"icon": "🗿",
		"color": Color(0.3, 0.65, 0.95),
		"enemy_count": 12,
		"boss": "Капитан Черная Борода",
		"gold_reward": 550,
		"desc": "Загадочные руины среди бушующих волн. Здесь скрывается грозный Капитан Черная Борода и древние сокровища."
	}
}

func _ready() -> void:
	generate_overworld()

func generate_overworld() -> void:
	overworld_tiles.clear()
	locations.clear()
	
	# Базовое заполнение биомов
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var pos = Vector2i(x, y)
			
			# Водные границы карты и озеро на западе
			if x <= 4 or x >= MAP_WIDTH - 5 or y <= 4 or y >= MAP_HEIGHT - 5:
				overworld_tiles[pos] = "water"
			elif x >= 14 and x <= 32 and y >= 68 and y <= 86:
				overworld_tiles[pos] = "water" # Западное Великое Озеро
			elif y < 35:
				# Север: скалы и горы
				overworld_tiles[pos] = "mountain" if (randf() < 0.65 or y < 20) else "grass"
			elif y > 95:
				# Юг: болота и топи
				overworld_tiles[pos] = "swamp" if randf() < 0.70 else "grass"
			elif x < 40:
				# Запад: дремучие леса
				overworld_tiles[pos] = "forest" if randf() < 0.65 else "grass"
			elif x > 85:
				# Восток: степи и поля
				overworld_tiles[pos] = "grass"
			else:
				# Центр: луга и перелески
				overworld_tiles[pos] = "forest" if randf() < 0.22 else "grass"
	
	# Главные мощеные королевские тракты (соединяют города)
	_draw_road(Vector2i(54, 70), Vector2i(64, 64)) # Олдерия -> Столица
	_draw_road(Vector2i(64, 64), Vector2i(64, 25)) # Столица -> Шахты
	_draw_road(Vector2i(64, 64), Vector2i(95, 65)) # Столица -> Жатвы
	_draw_road(Vector2i(54, 70), Vector2i(60, 105)) # Олдерия -> Топи
	_draw_road(Vector2i(54, 70), Vector2i(35, 85))  # Олдерия -> Склеп
	_draw_road(Vector2i(25, 45), Vector2i(64, 64))  # Утёс -> Столица
	
	# Регистрация ключевых локаций
	for l_pos in LOCATIONS_DEF.keys():
		locations[l_pos] = LOCATIONS_DEF[l_pos]
		overworld_tiles[l_pos] = "road"

func _draw_road(from: Vector2i, to: Vector2i) -> void:
	var cur = from
	while cur != to:
		overworld_tiles[cur] = "road"
		if cur.x < to.x: cur.x += 1
		elif cur.x > to.x: cur.x -= 1
		elif cur.y < to.y: cur.y += 1
		elif cur.y > to.y: cur.y -= 1
	overworld_tiles[to] = "road"

func can_travel(pos: Vector2i) -> bool:
	if not overworld_tiles.has(pos):
		return false
	var t = overworld_tiles[pos]
	return t != "water" and t != "mountain"

func get_travel_speed_mult(pos: Vector2i) -> float:
	var t = overworld_tiles.get(pos, "grass")
	match t:
		"road": return 1.4
		"grass": return 1.0
		"forest": return 0.75
		"swamp": return 0.55
		_: return 1.0

func get_location_at(pos: Vector2i) -> Dictionary:
	return locations.get(pos, {})

func set_player_tile(p_tile: Vector2i) -> void:
	player_tile = p_tile
	queue_redraw()

func _draw() -> void:
	# Рисуем карту мира с четкой средневековой палитрой
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var pos = Vector2i(x, y)
			var w_pos = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			var t_type = overworld_tiles.get(pos, "grass")
			
			var col: Color
			match t_type:
				"water": col = Color(0.20, 0.45, 0.75) # Яркая чистая вода
				"mountain": col = Color(0.48, 0.48, 0.52) # Каменные вершины
				"forest": col = Color(0.22, 0.48, 0.25) # Сочные дубравы
				"swamp": col = Color(0.35, 0.45, 0.28) # Мшистые топи
				"road": col = Color(0.85, 0.76, 0.58) # Светлый мощеный тракт
				_: col = Color(0.48, 0.72, 0.38) # Изумрудные луга
				
			draw_rect(Rect2(w_pos, Vector2(TILE_SIZE, TILE_SIZE)), col)
			
			# Контуры дорог
			if t_type == "road":
				draw_rect(Rect2(w_pos + Vector2(2, 2), Vector2(TILE_SIZE - 4, TILE_SIZE - 4)), Color(0.92, 0.84, 0.65))
			elif t_type == "forest":
				# Миниатюрные деревья в чащах
				draw_circle(w_pos + Vector2(TILE_SIZE/2.0, TILE_SIZE/2.0), 5.0, Color(0.14, 0.32, 0.16))
			elif t_type == "mountain":
				# Горные пики
				var pts = PackedVector2Array([
					w_pos + Vector2(TILE_SIZE/2.0, 4),
					w_pos + Vector2(4, TILE_SIZE - 4),
					w_pos + Vector2(TILE_SIZE - 4, TILE_SIZE - 4)
				])
				draw_colored_polygon(pts, Color(0.62, 0.62, 0.66))
	
	# Рисуем все ключевые города и локации с яркими плашками
	for l_pos in locations.keys():
		var loc = locations[l_pos]
		var w_pos = Vector2(l_pos.x * TILE_SIZE, l_pos.y * TILE_SIZE)
		var center = w_pos + Vector2(TILE_SIZE/2.0, TILE_SIZE/2.0)
		
		# Золотистый ореол под городом
		draw_circle(center, 18.0, Color(0.1, 0.1, 0.14, 0.85))
		draw_circle(center, 14.0, loc.get("color", Color.GOLD))
		draw_circle(center, 10.0, Color(0.12, 0.12, 0.16))
		
		# Табличка с названием локации
		var name_str: String = loc.get("name", "")
		var icon_str: String = loc.get("icon", "📍")
		var full_label = "%s %s" % [icon_str, name_str]
		
		var label_w = full_label.length() * 8.5
		var label_rect = Rect2(center.x - label_w/2.0 - 6, center.y - 34, label_w + 12, 20)
		draw_rect(label_rect, Color(0.10, 0.11, 0.16, 0.95))
		draw_rect(label_rect, loc.get("color", Color.GOLD), false, 1.5)
		draw_string(ThemeDB.fallback_font, Vector2(center.x - label_w/2.0, center.y - 19), full_label, HORIZONTAL_ALIGNMENT_CENTER, -1, 13, Color(1.0, 0.95, 0.8))

	# Рисуем маркер текущего положения игрока (Пульсирующий флаг / Фишка отряда)
	var p_center = Vector2(player_tile.x * TILE_SIZE + TILE_SIZE/2.0, player_tile.y * TILE_SIZE + TILE_SIZE/2.0)
	draw_circle(p_center, 16.0, Color(1.0, 0.25, 0.25, 0.95))
	draw_circle(p_center, 12.0, Color(1.0, 0.9, 0.2))
	draw_circle(p_center, 7.0, Color(0.1, 0.1, 0.15))
	
	var player_box = Rect2(p_center.x - 48, p_center.y + 14, 96, 18)
	draw_rect(player_box, Color(0.85, 0.15, 0.15, 0.95))
	draw_rect(player_box, Color.GOLD, false, 1.5)
	draw_string(ThemeDB.fallback_font, Vector2(p_center.x - 42, p_center.y + 27), "🚩 ВАШ ОТРЯД", HORIZONTAL_ALIGNMENT_CENTER, -1, 11, Color.WHITE)
