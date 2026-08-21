class_name FaunaVisualLayer
extends Node2D

## ВИЗУАЛЬНЫЙ СЛОЙ ЖИВОЙ ФАУНЫ, ТОЧЕК ИНТЕРЕСА И АТМОСФЕРЫ
## Спавнит и анимирует кур (с перебором кадров и клеванием), коров, овец, оленей, собаку,
## детальную ветряную мельницу с парусиновыми лопастями и древнее светящееся капище

var animals: Array[Dictionary] = []
var windmill_center: Node2D
var windmill_rotor: Sprite2D
var shrine_node: Node2D
var shrine_light: PointLight2D
var wind_leaves: Array[Dictionary] = []
var _tex_cache: Dictionary = {}

func _get_world_texture(name: String) -> Texture2D:
	if _tex_cache.has(name):
		return _tex_cache[name]
	var path = "res://assets/sprites/world/%s.png" % name
	var abs_p = ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(abs_p):
		var img = Image.load_from_file(abs_p)
		if img and not img.is_empty():
			var itex = ImageTexture.create_from_image(img)
			_tex_cache[name] = itex
			return itex
	if ResourceLoader.exists(path):
		var tex = load(path) as Texture2D
		if tex:
			_tex_cache[name] = tex
			return tex
	return null

func _get_fauna_texture(type: String) -> Texture2D:
	return _get_world_texture("animal_%s" % type)

func _ready() -> void:
	_spawn_all_decorations()
	_spawn_all_fauna()
	_init_wind_leaves()

func _spawn_all_decorations() -> void:
	# 1. 🌾 ВЕТРЯНАЯ МЕЛЬНИЦА (38, 14)
	windmill_center = Node2D.new()
	windmill_center.position = Vector2(38 * 48, 14 * 48)
	add_child(windmill_center)
	
	# Башня мельницы (Каменная кладка, дверь, окна, гонтовая крыша)
	var tower_spr = Sprite2D.new()
	tower_spr.texture = _get_world_texture("windmill_tower")
	tower_spr.centered = true
	windmill_center.add_child(tower_spr)
	
	# Вращающийся ротор с 4 парусиновыми крыльями
	windmill_rotor = Sprite2D.new()
	windmill_rotor.texture = _get_world_texture("windmill_sails")
	windmill_rotor.centered = true
	windmill_rotor.position = Vector2(0, -20) # Центр ступицы на крыше
	windmill_center.add_child(windmill_rotor)
		
	# 2. 🗿 ДРЕВНЕЕ РУНИЧЕСКОЕ КАПИЩЕ (8, 8)
	shrine_node = Node2D.new()
	shrine_node.position = Vector2(8 * 48, 8 * 48)
	add_child(shrine_node)
	
	var shrine_spr = Sprite2D.new()
	shrine_spr.texture = _get_world_texture("ancient_shrine")
	shrine_spr.centered = true
	shrine_node.add_child(shrine_spr)
	
	# Магическое свечение рун капища
	shrine_light = PointLight2D.new()
	shrine_light.texture = SpriteGenerator2D.get_light_texture(96, Color(0.2, 0.85, 1.0, 0.85))
	shrine_light.texture_scale = 1.2
	shrine_light.energy = 0.9
	shrine_node.add_child(shrine_light)

func _spawn_all_fauna() -> void:
	# 🐔 Куры у фермы (32, 28)
	for i in range(5):
		_create_animal("chicken", Vector2((32 + randf_range(-3, 3)) * 48, (28 + randf_range(-2, 2)) * 48))
		
	# 🐄 Коровы на пастбище (15, 38)
	for i in range(2):
		_create_animal("cow", Vector2((15 + randf_range(-2, 2)) * 48, (38 + randf_range(-2, 2)) * 48))
		
	# 🐑 Овечки на лугу (17, 39)
	for i in range(3):
		_create_animal("sheep", Vector2((17 + randf_range(-2, 2)) * 48, (39 + randf_range(-2, 2)) * 48))
		
	# 🦌 Олени в лесу (10, 10)
	for i in range(2):
		_create_animal("deer", Vector2((10 + randf_range(-3, 3)) * 48, (10 + randf_range(-3, 3)) * 48))
		
	# 🐕 Деревенский Пес на площади (25, 27)
	_create_animal("dog", Vector2(25 * 48, 27 * 48))

func _create_animal(type: String, pos: Vector2) -> void:
	var root = Node2D.new()
	root.position = pos
	add_child(root)
	
	var spr = Sprite2D.new()
	spr.texture = _get_fauna_texture(type)
	if type == "chicken":
		spr.hframes = 2
		spr.vframes = 1
		spr.frame = 0
	spr.centered = true
	root.add_child(spr)
	
	animals.append({
		"type": type,
		"root": root,
		"sprite": spr,
		"pos": pos,
		"target_pos": pos,
		"timer": randf_range(1.0, 4.0),
		"speed": 22.0 if type != "deer" else 45.0,
		"anim_timer": 0.0,
		"is_moving": false
	})

func _init_wind_leaves() -> void:
	var spr_tex = _get_world_texture("leaf_spring")
	var aut_tex = _get_world_texture("leaf_autumn")
	for i in range(30):
		var leaf = Sprite2D.new()
		leaf.texture = aut_tex if i % 3 == 0 else spr_tex
		leaf.centered = true
		add_child(leaf)
		
		wind_leaves.append({
			"node": leaf,
			"pos": Vector2(randf_range(0, 50 * 48), randf_range(0, 50 * 48)),
			"speed": randf_range(35.0, 70.0),
			"sway": randf() * 10.0,
			"rot_speed": randf_range(1.5, 3.5)
		})

func _process(delta: float) -> void:
	# 1. Плавное вращение крыльев мельницы
	if windmill_rotor:
		windmill_rotor.rotation += delta * 0.9
		
	# 2. Пульсация рунического света капища
	if shrine_light:
		var pulse = sin(Time.get_ticks_msec() * 0.003) * 0.25 + 0.85
		shrine_light.energy = pulse
		
	# 3. Анимация животных
	for a in animals:
		a["timer"] -= delta
		if a["timer"] <= 0.0:
			a["timer"] = randf_range(2.5, 6.0)
			a["target_pos"] = a["pos"] + Vector2(randf_range(-40, 40), randf_range(-40, 40))
			
		var dist = a["root"].position.distance_to(a["target_pos"])
		if dist > 2.0:
			a["is_moving"] = true
			var dir = (a["target_pos"] - a["root"].position).normalized()
			a["root"].position += dir * a["speed"] * delta
			
			# Направление спрайта (влево / вправо)
			if dir.x < -0.1:
				a["sprite"].flip_h = true
			elif dir.x > 0.1:
				a["sprite"].flip_h = false
				
			# Анимация походки
			a["anim_timer"] += delta * 6.0
			if a["type"] == "chicken":
				a["sprite"].frame = int(a["anim_timer"]) % 2
			else:
				a["sprite"].position.y = sin(a["anim_timer"] * 2.0) * 1.5
		else:
			a["is_moving"] = false
			if a["type"] == "chicken":
				# Время от времени клюет землю
				if int(Time.get_ticks_msec() / 800) % 3 == 0:
					a["sprite"].frame = 1
				else:
					a["sprite"].frame = 0
			else:
				a["sprite"].position.y = 0.0
			
	# 4. Листья на ветру (Плавный полет и вращение)
	for l in wind_leaves:
		l["sway"] += delta * 2.5
		l["pos"].x += l["speed"] * delta
		l["pos"].y += sin(l["sway"]) * 18.0 * delta
		if l["pos"].x > 50 * 48:
			l["pos"].x = 0
			l["pos"].y = randf_range(0, 50 * 48)
		l["node"].position = l["pos"]
		l["node"].rotation += delta * l["rot_speed"]
