class_name FaunaVisualLayer
extends Node2D

## ВИЗУАЛЬНЫЙ СЛОЙ ЖИВОЙ ФАУНЫ, ТОЧЕК ИНТЕРЕСА И АТМОСФЕРЫ
## Спавнит и анимирует кур, коров, овец, оленей, собаку, мельницу, капище и декорации

var animals: Array[Dictionary] = []
var windmill_center: Node2D
var windmill_rotor: Node2D
var wind_leaves: Array[Dictionary] = []

func _ready() -> void:
	_spawn_all_decorations()
	_spawn_all_fauna()
	_init_wind_leaves()

func _spawn_all_decorations() -> void:
	# 1. 🌾 ВЕТРЯНАЯ МЕЛЬНИЦА (38, 14)
	windmill_center = Node2D.new()
	windmill_center.position = Vector2(38 * 48, 14 * 48)
	add_child(windmill_center)
	
	# Корпус мельницы
	var tower = Polygon2D.new()
	tower.polygon = PackedVector2Array([
		Vector2(-24, 32), Vector2(24, 32), Vector2(16, -36), Vector2(-16, -36)
	])
	tower.color = Color(0.82, 0.76, 0.65) # Светлый камень
	windmill_center.add_child(tower)
	
	# Купол крыши
	var roof = Polygon2D.new()
	roof.polygon = PackedVector2Array([
		Vector2(-20, -36), Vector2(20, -36), Vector2(0, -60)
	])
	roof.color = Color(0.55, 0.28, 0.15) # Деревянный купол
	windmill_center.add_child(roof)
	
	# Ротор с лопастями
	windmill_rotor = Node2D.new()
	windmill_rotor.position = Vector2(0, -36)
	windmill_center.add_child(windmill_rotor)
	
	for i in range(4):
		var ang = i * PI * 0.5
		var sail = Polygon2D.new()
		sail.polygon = PackedVector2Array([
			Vector2(0, 0), Vector2(38, -6), Vector2(38, 6), Vector2(0, 3)
		])
		sail.rotation = ang
		sail.color = Color(0.95, 0.92, 0.85, 0.9)
		windmill_rotor.add_child(sail)
		
	# 2. 🗿 ДРЕВНЕЕ РУНИЧЕСКОЕ КАПИЩЕ (8, 8)
	var shrine = Node2D.new()
	shrine.position = Vector2(8 * 48, 8 * 48)
	add_child(shrine)
	
	var shrine_poly = Polygon2D.new()
	shrine_poly.polygon = PackedVector2Array([
		Vector2(-14, 24), Vector2(14, 24), Vector2(10, -28), Vector2(-10, -28)
	])
	shrine_poly.color = Color(0.35, 0.38, 0.42)
	shrine.add_child(shrine_poly)
	
	var rune_core = Polygon2D.new()
	rune_core.polygon = PackedVector2Array([
		Vector2(-4, -4), Vector2(4, -4), Vector2(4, 4), Vector2(-4, 4)
	])
	rune_core.color = Color(0.2, 0.85, 1.0, 0.9)
	shrine.add_child(rune_core)

func _spawn_all_fauna() -> void:
	# 🐔 Куры у фермы (32, 28)
	for i in range(4):
		_create_animal("chicken", Vector2((32 + randf_range(-3, 3)) * 48, (28 + randf_range(-2, 2)) * 48), Color(0.95, 0.95, 0.95), Vector2(10, 8))
		
	# 🐄 Коровы на пастбище (15, 38)
	for i in range(2):
		_create_animal("cow", Vector2((15 + randf_range(-2, 2)) * 48, (38 + randf_range(-2, 2)) * 48), Color(0.90, 0.88, 0.82), Vector2(28, 18))
		
	# 🐑 Овечки на лугу (17, 39)
	for i in range(3):
		_create_animal("sheep", Vector2((17 + randf_range(-2, 2)) * 48, (39 + randf_range(-2, 2)) * 48), Color(0.95, 0.95, 0.92), Vector2(18, 14))
		
	# 🦌 Олени в лесу (10, 10)
	for i in range(2):
		_create_animal("deer", Vector2((10 + randf_range(-3, 3)) * 48, (10 + randf_range(-3, 3)) * 48), Color(0.68, 0.42, 0.22), Vector2(22, 16))
		
	# 🐕 Деревенский Пес на площади (25, 27)
	_create_animal("dog", Vector2(25 * 48, 27 * 48), Color(0.85, 0.55, 0.20), Vector2(16, 12))

func _create_animal(type: String, pos: Vector2, col: Color, size: Vector2) -> void:
	var root = Node2D.new()
	root.position = pos
	add_child(root)
	
	# Мягкая тень
	var shadow = Polygon2D.new()
	shadow.polygon = PackedVector2Array([
		Vector2(-size.x/2.0, size.y/2.0), Vector2(size.x/2.0, size.y/2.0),
		Vector2(size.x/2.0 - 2, size.y/2.0 + 4), Vector2(-size.x/2.0 + 2, size.y/2.0 + 4)
	])
	shadow.color = Color(0, 0, 0, 0.25)
	root.add_child(shadow)
	
	# Тело
	var body = Polygon2D.new()
	body.polygon = PackedVector2Array([
		Vector2(-size.x/2.0, -size.y/2.0), Vector2(size.x/2.0, -size.y/2.0),
		Vector2(size.x/2.0, size.y/2.0), Vector2(-size.x/2.0, size.y/2.0)
	])
	body.color = col
	root.add_child(body)
	
	# Детали мордочки / гребешка
	if type == "chicken":
		var comb = Polygon2D.new()
		comb.polygon = PackedVector2Array([Vector2(2, -size.y/2.0 - 3), Vector2(5, -size.y/2.0 - 3), Vector2(3, -size.y/2.0)])
		comb.color = Color(0.9, 0.2, 0.2)
		root.add_child(comb)
	elif type == "cow":
		var spot = Polygon2D.new()
		spot.polygon = PackedVector2Array([Vector2(-4, -4), Vector2(4, -4), Vector2(4, 4), Vector2(-4, 4)])
		spot.color = Color(0.18, 0.18, 0.18)
		root.add_child(spot)
	elif type == "dog":
		var tail = Line2D.new()
		tail.points = PackedVector2Array([Vector2(-size.x/2.0, 0), Vector2(-size.x/2.0 - 6, -4)])
		tail.width = 3.0
		tail.default_color = col
		root.add_child(tail)
		
	animals.append({
		"type": type,
		"root": root,
		"pos": pos,
		"target_pos": pos,
		"timer": randf_range(1.0, 4.0),
		"speed": 22.0 if type != "deer" else 45.0
	})

func _init_wind_leaves() -> void:
	for i in range(25):
		var leaf = Polygon2D.new()
		leaf.polygon = PackedVector2Array([Vector2(-2, -2), Vector2(2, -2), Vector2(3, 3), Vector2(-2, 2)])
		leaf.color = Color(0.4, 0.75, 0.25, 0.85)
		add_child(leaf)
		
		wind_leaves.append({
			"node": leaf,
			"pos": Vector2(randf_range(0, 50 * 48), randf_range(0, 50 * 48)),
			"speed": randf_range(40.0, 75.0),
			"sway": randf() * 10.0
		})

func _process(delta: float) -> void:
	# Вращение мельницы
	if windmill_rotor:
		windmill_rotor.rotation += delta * 1.2
		
	# Анимация животных
	for a in animals:
		a["timer"] -= delta
		if a["timer"] <= 0.0:
			a["timer"] = randf_range(2.0, 5.0)
			a["target_pos"] = a["pos"] + Vector2(randf_range(-30, 30), randf_range(-30, 30))
			
		if a["root"].position.distance_to(a["target_pos"]) > 2.0:
			var dir = (a["target_pos"] - a["root"].position).normalized()
			a["root"].position += dir * a["speed"] * delta
			a["root"].position.y += sin(Time.get_ticks_msec() * 0.01) * 0.4 # Пошатывание при ходьбе
			
	# Листья на ветру
	for l in wind_leaves:
		l["sway"] += delta * 3.0
		l["pos"].x += l["speed"] * delta
		l["pos"].y += sin(l["sway"]) * 15.0 * delta
		if l["pos"].x > 50 * 48:
			l["pos"].x = 0
			l["pos"].y = randf_range(0, 50 * 48)
		l["node"].position = l["pos"]
