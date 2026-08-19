class_name SpriteGenerator2D
extends RefCounted

## ГЕНЕРАТОР СОЧНОЙ 2D PIXEL-ART ГРАФИКИ (STARDEW VALLEY / GRAVEYARD KEEPER STYLE)
## Создает детализированные текстуры тайлов, персонажей, диких животных, ресурсов и мебели

static var _texture_cache: Dictionary = {}

static func get_light_texture(radius: int = 256, color: Color = Color(1.0, 0.85, 0.5, 1.0)) -> ImageTexture:
	var key = "light_%d_%s" % [radius, color.to_html()]
	if _texture_cache.has(key):
		return _texture_cache[key]
	
	var img = Image.create(radius * 2, radius * 2, false, Image.FORMAT_RGBA8)
	var center = Vector2(radius, radius)
	
	for y in range(radius * 2):
		for x in range(radius * 2):
			var dist = center.distance_to(Vector2(x, y))
			if dist <= radius:
				var factor = 1.0 - (dist / float(radius))
				factor = pow(factor, 2.0) # Мягкий органичный спад света
				var c = Color(color.r, color.g, color.b, factor * color.a)
				img.set_pixel(x, y, c)
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
	
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_shadow_texture(rx: int = 20, ry: int = 10) -> ImageTexture:
	var key = "shadow_%d_%d" % [rx, ry]
	if _texture_cache.has(key):
		return _texture_cache[key]
		
	var w = rx * 2
	var h = ry * 2
	var img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	
	for y in range(h):
		for x in range(w):
			var nx = (x - rx) / float(rx)
			var ny = (y - ry) / float(ry)
			var dist = sqrt(nx * nx + ny * ny)
			if dist <= 1.0:
				var a = pow(1.0 - dist, 1.5) * 0.45
				img.set_pixel(x, y, Color(0.04, 0.05, 0.08, a))
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
				
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_tile_texture(type: String, size: int = 48) -> ImageTexture:
	var key = "tile_%s_%d" % [type, size]
	if _texture_cache.has(key):
		return _texture_cache[key]
	
	var file_path = "res://assets/sprites/world/tile_%s.png" % type
	if FileAccess.file_exists(file_path):
		var img = Image.load_from_file(file_path)
		if img and not img.is_empty():
			if img.get_width() != size or img.get_height() != size:
				img.resize(size, size, Image.INTERPOLATE_NEAREST)
			var itex = ImageTexture.create_from_image(img)
			_texture_cache[key] = itex
			return itex
	
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	
	for y in range(size):
		for x in range(size):
			var c: Color
			
			match type:
				"grass":
					# Сочный луговой ковер: изумрудная база, пучки травы, клевер и цветы
					var n = sin(x * 0.35 + y * 0.28) * 0.04 + cos(x * 0.65 - y * 0.45) * 0.03
					c = Color(0.28 + n, 0.58 + n, 0.22 + n)
					
					# Травинки и текстура дерна
					if (x * 7 + y * 13) % 19 == 0:
						c = Color(0.38, 0.68, 0.28) # Светлый блик
					elif (x * 11 + y * 17) % 23 == 0:
						c = Color(0.20, 0.45, 0.16) # Тень под травинкой
						
					# Полевые цветы (ромашки, одуванчики, васильки)
					var flower_seed = (x * 37 + y * 59) % 151
					if flower_seed == 0:
						c = Color(0.98, 0.92, 0.30) # Желтый одуванчик
					elif flower_seed == 1:
						c = Color(0.95, 0.95, 0.95) # Белая ромашка
					elif flower_seed == 2:
						c = Color(0.40, 0.65, 0.95) # Голубой василек
						
				"dirt":
					# Земляная тропа с камешками
					var n = sin(x * 0.5 + y * 0.4) * 0.05 + cos(x * 0.9 + y * 0.7) * 0.03
					c = Color(0.52 + n, 0.38 + n, 0.24 + n)
					if (x * 13 + y * 29) % 31 == 0:
						c = Color(0.68, 0.62, 0.55) # Камешек
					elif (x * 17 + y * 19) % 27 == 0:
						c = Color(0.38, 0.26, 0.15) # Углубление
					
				"road", "stone_floor":
					# Мощеная средневековая мостовая с фасками и мхом
					var block_h = 12
					var block_w = 24
					var row = y / block_h
					var col_offset = (row % 2) * (block_w / 2)
					var local_x = (x + col_offset) % block_w
					var local_y = y % block_h
					
					var is_seam = (local_x == 0 or local_y == 0 or local_x == block_w - 1 or local_y == block_h - 1)
					if is_seam:
						c = Color(0.22, 0.22, 0.25) # Шов
						if (x * 3 + y * 7) % 11 == 0:
							c = Color(0.25, 0.40, 0.22) # Мох в швах
					else:
						var n = sin(x * 0.4 + y * 0.6) * 0.04
						c = Color(0.58 + n, 0.56 + n, 0.54 + n)
						if local_x <= 2 or local_y <= 2:
							c = c.lightened(0.18) # Фаска света сверху-слева
						elif local_x >= block_w - 2 or local_y >= block_h - 2:
							c = c.darkened(0.18) # Тень снизу-справа
						
				"farmland":
					# Вспаханные грядки с бороздами
					var furrow = sin(y * 0.52) * 0.08
					c = Color(0.38 + furrow, 0.24 + furrow, 0.14 + furrow)
					if y % 8 == 0 or y % 8 == 1:
						c = c.darkened(0.25) # Тень борозды
					elif y % 8 == 4:
						c = c.lightened(0.15) # Гребень борозды
						
				"farmland_wet":
					# Влажная политая земля
					var furrow_w = sin(y * 0.52) * 0.06
					c = Color(0.22 + furrow_w, 0.14 + furrow_w, 0.08 + furrow_w)
					if (x * 7 + y * 13) % 17 == 0:
						c = Color(0.35, 0.30, 0.28) # Влажный отблеск
					
				"wood_floor":
					# Тесаный дубовый пол с гвоздями и волокнами древесины
					var plank_h = 12
					var local_y = y % plank_h
					if local_y == 0 or local_y == plank_h - 1:
						c = Color(0.28, 0.16, 0.08) # Зазор между досками
					else:
						var n = sin(x * 0.15 + y * 0.85) * 0.03 + cos(x * 0.4) * 0.02
						c = Color(0.68 + n, 0.46 + n, 0.28 + n)
						if local_y == 1: c = c.lightened(0.12) # Блик на ребре доски
						if (int(x) % 32 == 4 or int(x) % 32 == 28) and (local_y == 3 or local_y == plank_h - 4):
							c = Color(0.20, 0.18, 0.18) # Кованый гвоздь
						
				"wall_wood":
					# Бревенчатая стена из дубового сруба
					var log_h = 16
					var local_y = y % log_h
					if local_y == 0 or local_y == log_h - 1 or x == 0 or x == size - 1:
						c = Color(0.22, 0.12, 0.06) # Паз между бревнами
					else:
						var n = sin(x * 0.2 + y * 0.5) * 0.04
						c = Color(0.50 + n, 0.32 + n, 0.18 + n)
						if local_y <= 3:
							c = c.lightened(0.20) # Верхняя освещенная часть бревна
						elif local_y >= log_h - 4:
							c = c.darkened(0.25) # Нижняя затененная часть
						
				"wall_stone":
					# Каменная замковая стена с тесаными блоками
					var block_h = 16
					var block_w = 24
					var row = y / block_h
					var col_offset = (row % 2) * (block_w / 2)
					var local_x = (x + col_offset) % block_w
					var local_y = y % block_h
					
					if local_x == 0 or local_y == 0 or local_x == block_w - 1 or local_y == block_h - 1 or x == 0 or x == size - 1:
						c = Color(0.18, 0.18, 0.22) # Раствор
					else:
						var n = sin(x * 0.6 + y * 0.7) * 0.05
						c = Color(0.48 + n, 0.50 + n, 0.54 + n)
						if local_x <= 2 or local_y <= 2:
							c = c.lightened(0.22) # Верхний фасочный блик
						elif local_x >= block_w - 3 or local_y >= block_h - 3:
							c = c.darkened(0.22) # Нижняя тень блока
							
				"water":
					# Вода с мягкими градиентами
					var wave = sin(x * 0.25 + y * 0.35) * 0.06 + cos(x * 0.5 - y * 0.3) * 0.04
					c = Color(0.18 + wave, 0.44 + wave, 0.72 + wave)
					if (x * 5 + y * 11) % 29 == 0:
						c = Color(0.65, 0.85, 1.0, 0.85) # Блик на воде
					
				_:
					c = Color(0.3, 0.3, 0.3)
					
			img.set_pixel(x, y, c)
			
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_node_texture(type: String, size: int = 48) -> ImageTexture:
	var key = "node_%s_%d" % [type, size]
	if _texture_cache.has(key):
		return _texture_cache[key]
		
	var file_path = "res://assets/sprites/world/%s.png" % type
	if FileAccess.file_exists(file_path):
		var img = Image.load_from_file(file_path)
		if img and not img.is_empty():
			if img.get_width() != size or img.get_height() != size:
				img.resize(size, size, Image.INTERPOLATE_NEAREST)
			var itex = ImageTexture.create_from_image(img)
			_texture_cache[key] = itex
			return itex
		
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var cx = size / 2.0
	var cy = size / 2.0
	
	for y in range(size):
		for x in range(size):
			var p = Vector2(x, y)
			var c = Color(0, 0, 0, 0)
			
			match type:
				"tree", "tree_oak":
					# Пышный дуб с объемной многослойной кроной
					if abs(x - cx) <= 3 and y >= cy + 4 and y <= size - 2:
						c = Color(0.32, 0.18, 0.09) # Ствол
						if abs(x - cx) == 1 and y < size - 6:
							c = c.lightened(0.18)
					
					var foliage_center = Vector2(cx, cy - 5)
					var dist = (p - foliage_center).length()
					if dist < 18.0:
						var n = sin(x * 0.75 + y * 0.65) * 0.08 + cos(x * 1.2 - y * 0.8) * 0.05
						c = Color(0.20 + n, 0.52 + n, 0.18 + n)
						
						# Объемное освещение кроны: свет сверху-слева
						var light_vec = (p - (foliage_center - Vector2(5, 5))).normalized()
						var light_dot = -light_vec.x * 0.5 - light_vec.y * 0.7
						
						if light_dot > 0.3:
							c = c.lightened(0.30) # Яркие освещенные листья
						elif light_dot < -0.2:
							c = c.darkened(0.35) # Глубокая тень внизу кроны
							
						if dist > 15.5:
							c = c.darkened(0.25) # Контур кроны
							
				"tree_birch":
					# Береза со светлой корой
					if abs(x - cx) <= 2 and y >= cy + 2 and y <= size - 2:
						c = Color(0.92, 0.92, 0.88)
						if (y % 6 == 0 or y % 6 == 1) and x == int(cx):
							c = Color(0.18, 0.18, 0.18)
					var dist = (p - Vector2(cx, cy - 6)).length()
					if dist < 14.5:
						var n = sin(x * 0.8 + y * 0.9) * 0.06
						c = Color(0.28 + n, 0.62 + n, 0.25 + n)
						if y < cy - 6: c = c.lightened(0.22)
						elif y > cy: c = c.darkened(0.30)
						
				"ore_iron":
					# Каменная глыба с мерцающими кристаллами железа
					var dist = Vector2((x - cx) * 1.05, (y - cy) * 1.25).length()
					if dist < 15.0:
						var n = sin(x * 0.85 + y * 0.75) * 0.06
						c = Color(0.42 + n, 0.44 + n, 0.48 + n)
						if y < cy - 4 and x < cx + 2: c = c.lightened(0.25) # Блик камня
						if dist > 12.5: c = c.darkened(0.35) # Теневой край
						
						# Кристаллические вкрапления
						if (abs(x - cx - 2) < 4 and abs(y - cy + 2) < 4) or (abs(x - cx + 4) < 3 and abs(y - cy - 4) < 3):
							c = Color(0.55, 0.82, 1.0)
							if (x + y) % 3 == 0: c = Color(0.90, 0.96, 1.0)
							
				"crop_stage_0":
					# Стадия 0: Семена в лунках
					if (abs(x - cx) <= 2 or abs(x - (cx - 6)) <= 2 or abs(x - (cx + 6)) <= 2) and abs(y - (cy + 4)) <= 2:
						c = Color(0.15, 0.10, 0.06)
						if (x + y) % 2 == 0: c = Color(0.65, 0.55, 0.25)
						
				"crop_stage_1":
					# Стадия 1: Маленькие зеленые росточки
					if (abs(x - cx) <= 2 or abs(x - (cx - 6)) <= 2 or abs(x - (cx + 6)) <= 2) and y >= cy - 2 and y <= cy + 8:
						c = Color(0.35, 0.68, 0.22)
						if y < cy: c = Color(0.55, 0.85, 0.35)
						
				"crop_stage_2":
					# Стадия 2: Высокие сочные зеленые стебли
					var d2 = Vector2((x - cx) * 1.2, (y - (cy + 2)) * 0.95).length()
					if d2 < 12.0:
						c = Color(0.28, 0.58, 0.20)
						if y < cy - 2: c = Color(0.45, 0.75, 0.30)
						
				"crop_stage_3", "crop_wheat":
					# Стадия 3: Спелые золотые колосья
					var dist = Vector2((x - cx) * 1.15, (y - (cy + 2)) * 0.95).length()
					if dist < 14.5:
						if y >= cy + 5:
							c = Color(0.38, 0.56, 0.20) # Зеленый стебель
						else:
							var n = sin(x * 1.1 + y * 0.8) * 0.06
							c = Color(0.92 + n, 0.78 + n, 0.28 + n) # Золотое зерно
							if y < cy - 3:
								c = Color(0.98, 0.90, 0.45) # Светлая верхушка
						if dist > 12.0: c = c.darkened(0.20)
						
				"grindstone":
					# Точильный станок с круглым камнем
					if abs(x - cx) <= 12 and y >= cy and y <= cy + 10:
						c = Color(0.48, 0.30, 0.16) # Деревянная станина
					var wheel_dist = (p - Vector2(cx, cy - 2)).length()
					if wheel_dist <= 8.5:
						c = Color(0.55, 0.56, 0.58) # Точильный камень
						if wheel_dist <= 3.0: c = Color(0.25, 0.25, 0.28) # Ось
						if (x + y) % 3 == 0: c = c.lightened(0.12)
						
				"door", "door_closed":
					# Массивная деревянная дверь с коваными полосами и кольцом
					if abs(x - cx) <= 14 and abs(y - cy) <= 18:
						c = Color(0.56, 0.36, 0.20)
						if int(abs(x - cx)) % 7 == 0:
							c = Color(0.30, 0.18, 0.10) # Вертикальные доски
						if abs(y - cy + 8) <= 2 or abs(y - cy - 8) <= 2:
							c = Color(0.22, 0.22, 0.25) # Кованые железные петли
						if abs(x - cx - 5) <= 2 and abs(y - cy) <= 2:
							c = Color(0.85, 0.72, 0.25) # Латунное кольцо-ручка
						if abs(x - cx) == 14 or abs(y - cy) == 18:
							c = Color(0.25, 0.16, 0.08) # Рама двери
							
				"door_open":
					# Распахнутая дверь
					if abs(x - (cx - 10)) <= 4 and abs(y - cy) <= 18:
						c = Color(0.48, 0.30, 0.16)
						if abs(y - cy + 8) <= 2 or abs(y - cy - 8) <= 2:
							c = Color(0.20, 0.20, 0.22)
					elif abs(x - (cx + 4)) <= 8 and abs(y - cy) <= 16:
						c = Color(0.08, 0.06, 0.05, 0.85) # Темный проем входа
						
				"chest":
					# Окованный дубовый сундук
					if abs(x - cx) <= 14 and abs(y - cy) <= 10:
						c = Color(0.54, 0.36, 0.20)
						if abs(x - cx) == 14 or abs(y - cy) == 10 or abs(y - cy) == 0 or abs(x - cx) == 8:
							c = Color(0.26, 0.26, 0.30) # Кованые полосы
						if abs(x - cx) <= 2 and abs(y - cy + 1) <= 2:
							c = Color(0.95, 0.80, 0.25) # Золотой замок
							
				"bed":
					# Кровать с красным бархатным покрывалом и подушкой
					if abs(x - cx) <= 13 and abs(y - cy) <= 16:
						c = Color(0.75, 0.18, 0.22) # Покрывало
						if y < cy - 8:
							c = Color(0.95, 0.95, 0.90) # Мягкая белая подушка
							if (x + y) % 5 == 0: c = c.darkened(0.08)
						if abs(x - cx) == 13 or y == cy - 16 or y == cy + 16:
							c = Color(0.42, 0.26, 0.14) # Резное деревянное изголовье
							
				"fireplace", "campfire":
					# Каменный очаг с горящим пламенем
					var stone_dist = Vector2((x - cx) * 1.1, (y - cy) * 1.2).length()
					if stone_dist < 15.0 and stone_dist > 8.0:
						c = Color(0.45, 0.45, 0.48) # Каменная кладка
						if y < cy: c = c.lightened(0.18)
					elif stone_dist <= 8.0:
						# Огонь
						var fire_dist = (p - Vector2(cx, cy - 1)).length()
						if fire_dist < 6.5:
							c = Color(1.0, 0.45, 0.10)
							if fire_dist < 3.5: c = Color(1.0, 0.92, 0.35)
							
				"chair_oak":
					# Резной стул
					if abs(x - cx) <= 8 and abs(y - cy) <= 8:
						c = Color(0.56, 0.38, 0.22)
						if y < cy - 2: c = Color(0.45, 0.28, 0.15) # Спинка
						if abs(x - cx) <= 6 and abs(y - (cy + 2)) <= 4:
							c = Color(0.68, 0.48, 0.30) # Сиденье
							
				"table_oak":
					# Дубовый стол с кружками
					if abs(x - cx) <= 16 and abs(y - cy) <= 11:
						c = Color(0.58, 0.40, 0.24)
						if abs(x - cx) == 16 or abs(y - cy) == 11:
							c = Color(0.38, 0.24, 0.14)
						# Кружка эля на столе
						if (p - Vector2(cx - 6, cy - 2)).length() < 3.0:
							c = Color(0.85, 0.65, 0.20)
						elif (p - Vector2(cx + 6, cy + 2)).length() < 3.0:
							c = Color(0.90, 0.90, 0.85) # Тарелка
							
				"candle_stand", "lantern":
					# Кованый подсвечник / фонарь с теплым огоньком
					if abs(x - cx) <= 2 and y >= cy - 4 and y <= cy + 12:
						c = Color(0.28, 0.26, 0.24) # Кованая ножка
					if (p - Vector2(cx, cy - 8)).length() < 4.5:
						c = Color(1.0, 0.75, 0.20) # Пламя свечи
						if (p - Vector2(cx, cy - 8)).length() < 2.0:
							c = Color(1.0, 0.98, 0.70)
							
				"rug_wolf":
					# Ковер из шкуры серого волка
					var rug_dist = Vector2((x - cx) * 1.0, (y - cy) * 1.3).length()
					if rug_dist < 15.0:
						var n = sin(x * 0.8 + y * 0.7) * 0.05
						c = Color(0.48 + n, 0.48 + n, 0.50 + n)
						if rug_dist > 12.0: c = c.darkened(0.25)
						if y < cy - 9 and abs(x - cx) < 5:
							c = Color(0.32, 0.32, 0.35) # Волчья морда
							
				"bakery_oven":
					# Пекарня
					if abs(x - cx) <= 15 and abs(y - cy) <= 13:
						c = Color(0.58, 0.34, 0.22)
						if abs(x - cx) < 7 and y > cy - 2 and y < cy + 10:
							c = Color(0.12, 0.06, 0.04)
							if (p - Vector2(cx, cy + 5)).length() < 4.5:
								c = Color(1.0, 0.65, 0.15) # Жар в печи
						elif y < cy - 9 and abs(x - cx + 7) < 3:
							c = Color(0.38, 0.38, 0.40) # Труба
							
				"notice_board":
					# Доска объявлений
					if abs(x - cx) <= 14 and abs(y - cy) <= 14:
						c = Color(0.52, 0.34, 0.18)
						if abs(x - cx) < 11 and abs(y - cy) < 10:
							c = Color(0.92, 0.88, 0.72) # Пергаменты
							if (x + y) % 4 == 0: c = Color(0.3, 0.2, 0.1)
							
				_:
					if abs(x - cx) <= 10 and abs(y - cy) <= 10:
						c = Color(0.6, 0.5, 0.4)
						
			img.set_pixel(x, y, c)
			
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_character_texture(role_name: String, size: int = 48) -> ImageTexture:
	var key = "char_%s_%d" % [role_name, size]
	if _texture_cache.has(key):
		return _texture_cache[key]
		
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var cx = size / 2.0
	var cy = size / 2.0
	
	for y in range(size):
		for x in range(size):
			var p = Vector2(x, y)
			var c = Color(0, 0, 0, 0)
			
			# Тело персонажа (Pixel-Art пропорции: голова, тело, плащ, пояс, оружие)
			if (p - Vector2(cx, cy - 6)).length() < 6.5:
				# Голова / Шлем
				if "Рыцарь" in role_name or "Player" in role_name or "Страж" in role_name:
					c = Color(0.72, 0.75, 0.80) # Стальной шлем с забралом
					if abs(y - (cy - 6)) <= 1 and abs(x - cx) <= 3:
						c = Color(0.12, 0.12, 0.15) # Прорезь для глаз
					elif y < cy - 10:
						c = Color(0.85, 0.20, 0.25) # Красный плюмаж
				else:
					c = Color(0.92, 0.76, 0.62) # Лицо / Волосы
					if y < cy - 8:
						c = Color(0.40, 0.25, 0.15) # Каштановые волосы
						
			elif abs(x - cx) <= 7 and y >= cy and y <= cy + 12:
				# Туловище / Одеяние
				if "Player" in role_name:
					c = Color(0.20, 0.45, 0.82) # Синий королевский сюрко
					if abs(x - cx) == 0: c = Color(0.95, 0.85, 0.30) # Золотая полоса
				elif "Кузнец" in role_name:
					c = Color(0.45, 0.30, 0.18) # Кожаный фартук
				elif "Пекарь" in role_name:
					c = Color(0.92, 0.90, 0.85) # Белый фартук
				elif "Охотник" in role_name:
					c = Color(0.25, 0.48, 0.22) # Зеленая туника
				else:
					c = Color(0.62, 0.42, 0.28) # Шерстяная туника
					
				# Ремень
				if y == cy + 6:
					c = Color(0.22, 0.14, 0.08)
					if abs(x - cx) <= 1: c = Color(0.90, 0.80, 0.30) # Пряжка
					
			elif (abs(x - (cx - 4)) <= 2 or abs(x - (cx + 4)) <= 2) and y >= cy + 13 and y <= cy + 18:
				# Сапоги
				c = Color(0.24, 0.15, 0.08)
				
			img.set_pixel(x, y, c)
			
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_projectile_texture(type: String = "arrow", size: int = 16) -> ImageTexture:
	var key = "proj_%s_%d" % [type, size]
	if _texture_cache.has(key):
		return _texture_cache[key]
		
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var cx = size / 2.0
	var cy = size / 2.0
	
	for y in range(size):
		for x in range(size):
			var c = Color(0, 0, 0, 0)
			if abs(y - cy) <= 1 and abs(x - cx) <= 5:
				c = Color(0.45, 0.28, 0.14) # Древко стрелы
				if x >= cx + 3:
					c = Color(0.85, 0.85, 0.90) # Стальной наконечник
				elif x <= cx - 3:
					c = Color(0.95, 0.95, 0.95) # Оперение
			img.set_pixel(x, y, c)
			
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex

static func get_animal_texture(type: String = "wolf", size: int = 48) -> ImageTexture:
	var key = "animal_%s_%d" % [type, size]
	if _texture_cache.has(key):
		return _texture_cache[key]
		
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var cx = size / 2.0
	var cy = size / 2.0
	
	for y in range(size):
		for x in range(size):
			var p = Vector2(x, y)
			var c = Color(0, 0, 0, 0)
			
			if type == "wolf":
				# Серый волк
				if (p - Vector2(cx, cy)).length() < 12.0:
					c = Color(0.38, 0.38, 0.40)
					if y < cy - 4: c = Color(0.48, 0.48, 0.50)
					if abs(x - (cx + 3)) <= 1 and y == int(cy - 2):
						c = Color(0.95, 0.85, 0.20) # Желтый глаз
			elif type == "deer":
				# Олень
				if (p - Vector2(cx, cy)).length() < 12.0:
					c = Color(0.60, 0.40, 0.22)
					if y < cy - 6 and (abs(x - cx) == 4 or abs(x - cx) == 6):
						c = Color(0.85, 0.80, 0.70) # Ветвистые рога
			elif type == "dog":
				# Верный пес
				if (p - Vector2(cx, cy)).length() < 11.0:
					c = Color(0.75, 0.55, 0.28)
					if y < cy - 4: c = Color(0.55, 0.35, 0.18) # Уши
			else:
				if (p - Vector2(cx, cy)).length() < 10.0:
					c = Color(0.5, 0.5, 0.5)
					
			img.set_pixel(x, y, c)
			
	var tex = ImageTexture.create_from_image(img)
	_texture_cache[key] = tex
	return tex
