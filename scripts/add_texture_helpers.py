# Append missing helper methods to SpriteGenerator2D.gd
with open('godot/src/game2d/SpriteGenerator2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

helpers = '''
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
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/SpriteGenerator2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Added get_projectile_texture and get_animal_texture to SpriteGenerator2D.gd!")
