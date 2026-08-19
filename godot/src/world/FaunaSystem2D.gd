class_name FaunaSystem2D
extends RefCounted

## СИСТЕМА ЖИВОЙ ФАУНЫ И ЖИВОТНЫХ
## Управляет курами, коровами, овцами, оленями и деревенской собакой

# animals: Array of {type: String, pos: Vector2, target_pos: Vector2, timer: float, anim_frame: int, dir: Vector2}
var animals: Array[Dictionary] = []

func init_fauna() -> void:
	animals.clear()
	
	# 🐔 Куры у амбаров и полей (32, 28)
	for i in range(4):
		animals.append({
			"type": "chicken",
			"pos": Vector2((32 + randf_range(-3, 3)) * 48, (28 + randf_range(-2, 2)) * 48),
			"target_pos": Vector2(32 * 48, 28 * 48),
			"timer": randf_range(1.0, 3.0),
			"anim_frame": 0,
			"speed": 25.0
		})
		
	# 🐄 Коровы на пастбище (14, 38)
	for i in range(2):
		animals.append({
			"type": "cow",
			"pos": Vector2((14 + randf_range(-2, 2)) * 48, (38 + randf_range(-2, 2)) * 48),
			"target_pos": Vector2(14 * 48, 38 * 48),
			"timer": randf_range(3.0, 6.0),
			"anim_frame": 0,
			"speed": 12.0
		})
		
	# 🐑 Овечки на лугу (18, 38)
	for i in range(3):
		animals.append({
			"type": "sheep",
			"pos": Vector2((18 + randf_range(-2, 2)) * 48, (38 + randf_range(-2, 2)) * 48),
			"target_pos": Vector2(18 * 48, 38 * 48),
			"timer": randf_range(2.0, 5.0),
			"anim_frame": 0,
			"speed": 15.0
		})
		
	# 🦌 Дикие Олени в Чернолесье (10, 10)
	for i in range(2):
		animals.append({
			"type": "deer",
			"pos": Vector2((10 + randf_range(-3, 3)) * 48, (10 + randf_range(-3, 3)) * 48),
			"target_pos": Vector2(10 * 48, 10 * 48),
			"timer": randf_range(2.0, 4.0),
			"anim_frame": 0,
			"speed": 45.0
		})
		
	# 🐕 Деревенский Пес Дружок на площади (25, 27)
	animals.append({
		"type": "dog",
		"pos": Vector2(25 * 48, 27 * 48),
		"target_pos": Vector2(25 * 48, 27 * 48),
		"timer": 1.0,
		"anim_frame": 0,
		"speed": 35.0
	})

func update_fauna(delta: float, player_pos: Vector2) -> void:
	for a in animals:
		a["timer"] -= delta
		if a["timer"] <= 0.0:
			a["timer"] = randf_range(2.0, 5.0)
			
			if a["type"] == "dog":
				# Собака бегает к игроку или жителям
				if a["pos"].distance_to(player_pos) > 80.0:
					a["target_pos"] = player_pos + Vector2(randf_range(-30, 30), randf_range(-30, 30))
			elif a["type"] == "deer":
				# Олени убегают, если игрок близко
				if a["pos"].distance_to(player_pos) < 120.0:
					var away = (a["pos"] - player_pos).normalized()
					a["target_pos"] = a["pos"] + away * 100.0
				else:
					a["target_pos"] = a["pos"] + Vector2(randf_range(-40, 40), randf_range(-40, 40))
			else:
				# Куры, коровы, овцы бродят рядом
				a["target_pos"] = a["pos"] + Vector2(randf_range(-35, 35), randf_range(-35, 35))
				
		# Перемещение
		if a["pos"].distance_to(a["target_pos"]) > 4.0:
			var dir = (a["target_pos"] - a["pos"]).normalized()
			a["pos"] += dir * a["speed"] * delta

func draw_fauna(ci: CanvasItem) -> void:
	for a in animals:
		var p: Vector2 = a["pos"]
		var t: String = a["type"]
		
		# Мягкая тень под животным
		ci.draw_colored_polygon(PackedVector2Array([
			p + Vector2(-8, 6), p + Vector2(8, 6), p + Vector2(6, 11), p + Vector2(-6, 11)
		]), Color(0, 0, 0, 0.28))
		
		match t:
			"chicken":
				# 🐔 Белая курочка с красным гребешком
				ci.draw_circle(p, 5.0, Color(0.95, 0.95, 0.95)) # Тело
				ci.draw_circle(p + Vector2(4, -3), 3.0, Color(0.95, 0.95, 0.95)) # Голова
				ci.draw_rect(Rect2(p.x + 3, p.y - 7, 3, 3), Color(0.95, 0.2, 0.2)) # Гребешок
				ci.draw_circle(p + Vector2(7, -3), 1.5, Color(0.95, 0.75, 0.1)) # Клюв
			"cow":
				# 🐄 Черно-белая корова
				ci.draw_rect(Rect2(p.x - 14, p.y - 8, 28, 16), Color(0.92, 0.92, 0.92))
				ci.draw_rect(Rect2(p.x - 6, p.y - 6, 12, 10), Color(0.18, 0.18, 0.18)) # Пятно
				ci.draw_circle(p + Vector2(16, -4), 7.0, Color(0.92, 0.92, 0.92)) # Голова
				ci.draw_circle(p + Vector2(21, -3), 4.0, Color(0.95, 0.75, 0.75)) # Мордочка
			"sheep":
				# 🐑 Кудрявая овечка
				ci.draw_circle(p, 9.0, Color(0.95, 0.95, 0.92)) # Шерсть
				ci.draw_circle(p + Vector2(8, -3), 5.0, Color(0.35, 0.32, 0.30)) # Голова
			"deer":
				# 🦌 Благородный лесной олень
				ci.draw_rect(Rect2(p.x - 12, p.y - 8, 24, 14), Color(0.65, 0.40, 0.20)) # Тело
				ci.draw_circle(p + Vector2(14, -6), 6.0, Color(0.65, 0.40, 0.20)) # Голова
				# Ветвистые рога
				ci.draw_line(p + Vector2(14, -10), p + Vector2(12, -18), Color(0.35, 0.20, 0.10), 2.0)
				ci.draw_line(p + Vector2(16, -10), p + Vector2(18, -18), Color(0.35, 0.20, 0.10), 2.0)
			"dog":
				# 🐕 Рыжий пес с виляющим хвостом
				ci.draw_rect(Rect2(p.x - 8, p.y - 5, 16, 10), Color(0.85, 0.55, 0.22)) # Тело
				ci.draw_circle(p + Vector2(10, -4), 5.0, Color(0.85, 0.55, 0.22)) # Голова
				ci.draw_line(p + Vector2(-8, -2), p + Vector2(-14, -6), Color(0.85, 0.55, 0.22), 3.0) # Хвост
