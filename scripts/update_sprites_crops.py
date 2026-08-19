with open('godot/src/game2d/SpriteGenerator2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add farmland_wet to get_tile_texture
old_farmland = '''				"farmland":
					# Вспаханные грядки с бороздами
					var furrow = sin(y * 0.52) * 0.08
					c = Color(0.38 + furrow, 0.24 + furrow, 0.14 + furrow)
					if y % 8 == 0 or y % 8 == 1:
						c = c.darkened(0.25) # Тень борозды
					elif y % 8 == 4:
						c = c.lightened(0.15) # Гребень борозды'''

new_farmland = '''				"farmland":
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
						c = Color(0.35, 0.30, 0.28) # Влажный отблеск'''

text = text.replace(old_farmland, new_farmland, 1)

# 2. Add crop stages and grindstone to get_node_texture
old_crop = '''				"crop_wheat":
					# Золотые налитые колосья пшеницы
					var dist = Vector2((x - cx) * 1.15, (y - (cy + 2)) * 0.95).length()
					if dist < 14.5:
						if y >= cy + 5:
							c = Color(0.38, 0.56, 0.20) # Зеленый стебель
						else:
							var n = sin(x * 1.1 + y * 0.8) * 0.06
							c = Color(0.92 + n, 0.78 + n, 0.28 + n) # Золотое зерно
							if y < cy - 3:
								c = Color(0.98, 0.90, 0.45) # Светлая верхушка
						if dist > 12.0: c = c.darkened(0.20)'''

new_crop = '''				"crop_stage_0":
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
						if (x + y) % 3 == 0: c = c.lightened(0.12)'''

text = text.replace(old_crop, new_crop, 1)

with open('godot/src/game2d/SpriteGenerator2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Updated SpriteGenerator2D.gd with crop stages, wet soil, and grindstone!")
