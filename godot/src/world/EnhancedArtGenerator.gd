class_name EnhancedArtGenerator
extends RefCounted

## ГЕНЕРАТОР ВЫСОКОДЕТАЛИЗИРОВАННЫХ ТЕКСТУР И СРЕДНЕВЕКОВОГО АРТА
## Создает органические текстуры травы, фахверковых домов, черепичных крыш, воды и декораций

static func generate_enhanced_textures() -> Dictionary:
	var textures: Dictionary = {}
	
	textures["grass_lush"] = _create_lush_grass_texture()
	textures["cobblestone_aged"] = _create_cobblestone_texture()
	textures["water_river"] = _create_river_water_texture()
	textures["roof_tiles"] = _create_roof_tiles_texture()
	textures["roof_thatch"] = _create_roof_thatch_texture()
	textures["half_timber"] = _create_half_timber_texture()
	textures["wooden_fence"] = _create_fence_texture()
	textures["haystack"] = _create_haystack_texture()
	textures["barrel_cart"] = _create_cart_texture()
	textures["rune_monolith"] = _create_rune_monolith_texture()
	textures["street_lamp"] = _create_lamp_texture()
	
	return textures

static func _create_lush_grass_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.24, 0.52, 0.18)) # Сочный средневековый зеленый
	
	for y in range(48):
		for x in range(48):
			var n = sin(x * 0.4) * cos(y * 0.4) + sin((x + y) * 0.2)
			var base = Color(0.24, 0.52, 0.18).lerp(Color(0.20, 0.46, 0.15), (n + 1.0) * 0.25)
			
			# Травинки и штрихи
			if (x + y * 3) % 7 == 0:
				base = base.lightened(0.12)
			elif (x * 2 + y) % 9 == 0:
				base = base.darkened(0.10)
				
			img.set_pixel(x, y, base)
			
	# Цветы и клевер
	_draw_flower(img, 12, 14, Color(0.95, 0.95, 0.40)) # Желтый лютик
	_draw_flower(img, 34, 28, Color(0.98, 0.98, 0.98)) # Белая ромашка
	_draw_flower(img, 22, 38, Color(0.40, 0.70, 0.95)) # Синий василек
	
	return ImageTexture.create_from_image(img)

static func _draw_flower(img: Image, cx: int, cy: int, petal_col: Color) -> void:
	if cx >= 2 and cx < 46 and cy >= 2 and cy < 46:
		img.set_pixel(cx, cy, Color(0.95, 0.65, 0.10)) # Сердцевинка
		img.set_pixel(cx - 1, cy, petal_col)
		img.set_pixel(cx + 1, cy, petal_col)
		img.set_pixel(cx, cy - 1, petal_col)
		img.set_pixel(cx, cy + 1, petal_col)

static func _create_cobblestone_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.22, 0.22, 0.24)) # Темный мох между камнями
	
	var stone_colors = [
		Color(0.48, 0.47, 0.45),
		Color(0.55, 0.53, 0.50),
		Color(0.42, 0.41, 0.40),
		Color(0.50, 0.48, 0.44)
	]
	
	# Рисуем закругленные булыжники
	for row in range(4):
		var y_off = row * 12
		var shift = 6 if row % 2 == 1 else 0
		for col in range(4):
			var x_off = col * 12 + shift
			var colr = stone_colors[(row + col) % stone_colors.size()]
			for dy in range(1, 11):
				for dx in range(1, 11):
					var px = (x_off + dx) % 48
					var py = y_off + dy
					if py < 48:
						var c = colr
						if dx == 1 or dy == 1: c = c.lightened(0.18) # Блик
						elif dx == 10 or dy == 10: c = c.darkened(0.25) # Тень
						img.set_pixel(px, py, c)
						
	return ImageTexture.create_from_image(img)

static func _create_river_water_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.12, 0.35, 0.58)) # Глубокая речная синева
	
	for y in range(48):
		for x in range(48):
			var wave = sin(x * 0.3 + y * 0.1) * 0.5 + cos(x * 0.15 - y * 0.25) * 0.5
			var c = Color(0.12, 0.35, 0.58).lerp(Color(0.20, 0.50, 0.72), (wave + 1.0) * 0.3)
			if (y % 16 == 0 or y % 16 == 1) and (x % 8 < 4):
				c = Color(0.65, 0.85, 0.95) # Пена на волнах
			img.set_pixel(x, y, c)
			
	# Кувшинка
	for dy in range(-2, 3):
		for dx in range(-2, 3):
			if dx * dx + dy * dy <= 4:
				img.set_pixel(24 + dx, 24 + dy, Color(0.15, 0.45, 0.18))
	img.set_pixel(24, 24, Color(0.95, 0.70, 0.85)) # Цветок лотоса
	
	return ImageTexture.create_from_image(img)

static func _create_roof_tiles_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.55, 0.22, 0.14)) # Терракотовая черепица
	
	for y in range(48):
		var tile_row = y / 8
		for x in range(48):
			var shift = 6 if tile_row % 2 == 1 else 0
			var tile_col = (x + shift) % 12
			var c = Color(0.62, 0.26, 0.16)
			if tile_col == 0: c = c.darkened(0.35)
			elif tile_col == 1: c = c.lightened(0.20)
			if y % 8 == 0: c = c.lightened(0.25)
			elif y % 8 == 7: c = c.darkened(0.40)
			img.set_pixel(x, y, c)
			
	return ImageTexture.create_from_image(img)

static func _create_roof_thatch_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.65, 0.52, 0.25)) # Соломенная крыша
	
	for y in range(48):
		for x in range(48):
			var n = sin(x * 1.2) * cos(y * 0.3)
			var c = Color(0.65, 0.52, 0.25).lerp(Color(0.48, 0.38, 0.18), (n + 1.0) * 0.3)
			if y % 12 == 11: c = c.darkened(0.35)
			img.set_pixel(x, y, c)
			
	return ImageTexture.create_from_image(img)

static func _create_half_timber_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.85, 0.80, 0.70)) # Беленая штукатурка
	
	# Темные дубовые балки (фахверк)
	var wood = Color(0.28, 0.16, 0.08)
	for x in range(48):
		for y in range(48):
			if x < 4 or x >= 44 or y < 4 or y >= 44:
				img.set_pixel(x, y, wood)
			elif x == y or (47 - x) == y:
				img.set_pixel(x, y, wood)
				
	return ImageTexture.create_from_image(img)

static func _create_fence_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0)) # Прозрачный
	var wood = Color(0.45, 0.30, 0.15)
	
	# Столбики и перекладины
	for x in range(48):
		for y in range(48):
			if (y >= 14 and y <= 17) or (y >= 30 and y <= 33):
				img.set_pixel(x, y, wood)
			if (x % 16 >= 6 and x % 16 <= 9) and y >= 8:
				img.set_pixel(x, y, wood.lightened(0.1))
				
	return ImageTexture.create_from_image(img)

static func _create_haystack_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var gold_hay = Color(0.82, 0.68, 0.22)
	
	for y in range(48):
		for x in range(48):
			var dx = x - 24
			var dy = y - 28
			if (dx * dx * 1.3 + dy * dy) <= 220 and y >= 10:
				var c = gold_hay
				if (x + y) % 3 == 0: c = c.lightened(0.15)
				elif (x * 2 + y) % 5 == 0: c = c.darkened(0.20)
				img.set_pixel(x, y, c)
				
	return ImageTexture.create_from_image(img)

static func _create_cart_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var wood = Color(0.40, 0.25, 0.12)
	
	# Кузов телеги
	for y in range(12, 36):
		for x in range(6, 42):
			img.set_pixel(x, y, wood)
			
	# Бочки и сено в кузове
	for y in range(14, 26):
		for x in range(10, 24):
			img.set_pixel(x, y, Color(0.55, 0.35, 0.18))
		for x in range(26, 38):
			img.set_pixel(x, y, Color(0.82, 0.68, 0.22)) # Сено
			
	# Колеса
	for dy in range(-4, 5):
		for dx in range(-4, 5):
			if dx * dx + dy * dy <= 16:
				img.set_pixel(10 + dx, 38 + dy, Color(0.20, 0.12, 0.06))
				img.set_pixel(38 + dx, 38 + dy, Color(0.20, 0.12, 0.06))
				
	return ImageTexture.create_from_image(img)

static func _create_rune_monolith_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var stone = Color(0.35, 0.36, 0.38)
	var glow = Color(0.25, 0.85, 1.0, 0.95)
	
	for y in range(6, 44):
		for x in range(14, 34):
			img.set_pixel(x, y, stone)
			if x == 14 or y == 6: img.set_pixel(x, y, stone.lightened(0.2))
			elif x == 33 or y == 43: img.set_pixel(x, y, stone.darkened(0.2))
			
	# Светящиеся руны
	for dy in range(14, 36, 6):
		img.set_pixel(24, dy, glow)
		img.set_pixel(23, dy + 1, glow)
		img.set_pixel(25, dy + 2, glow)
		
	return ImageTexture.create_from_image(img)

static func _create_lamp_texture() -> ImageTexture:
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	
	# Деревянный столб
	for y in range(12, 46):
		for x in range(22, 26):
			img.set_pixel(x, y, Color(0.32, 0.20, 0.10))
			
	# Фонарь
	for y in range(8, 16):
		for x in range(18, 30):
			if x == 18 or x == 29 or y == 8 or y == 15:
				img.set_pixel(x, y, Color(0.15, 0.15, 0.15))
			else:
				img.set_pixel(x, y, Color(1.0, 0.85, 0.30)) # Теплый свет
				
	return ImageTexture.create_from_image(img)
