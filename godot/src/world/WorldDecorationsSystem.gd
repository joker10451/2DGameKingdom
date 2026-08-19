class_name WorldDecorationsSystem
extends RefCounted

## СИСТЕМА ДЕКОРАЦИЙ И ТОЧЕК ИНТЕРЕСА (POIS)
## Управляет Ветряной Мельницей, Руническим Капищем, Лагерями и уличными декорациями

var windmill_angle: float = 0.0

func update(delta: float) -> void:
	windmill_angle += delta * 1.5

func draw_decorations(ci: CanvasItem, textures: Dictionary) -> void:
	# 1. 🌾 ВЕТРЯНАЯ МЕЛЬНИЦА (38, 14)
	var wm_pos = Vector2(38 * 48, 14 * 48)
	_draw_windmill(ci, wm_pos)
	
	# 2. 🗿 ДРЕВНЕЕ РУНИЧЕСКОЕ КАПИЩЕ (8, 8)
	var shrine_pos = Vector2(8 * 48, 8 * 48)
	_draw_runic_shrine(ci, shrine_pos, textures)
	
	# 3. ⛺ ЛАГЕРЬ В ЧЕРНОЛЕСЬЕ (6, 20)
	var camp_pos = Vector2(6 * 48, 20 * 48)
	_draw_bandit_camp(ci, camp_pos)
	
	# 4. 🛒 ТЕЛЕГИ И СТОГА СЕНА
	if textures.has("haystack"):
		ci.draw_texture(textures["haystack"], Vector2(35 * 48, 16 * 48))
		ci.draw_texture(textures["haystack"], Vector2(36 * 48, 17 * 48))
	if textures.has("barrel_cart"):
		ci.draw_texture(textures["barrel_cart"], Vector2(27 * 48, 24 * 48))
		ci.draw_texture(textures["barrel_cart"], Vector2(23 * 48, 30 * 48))
	if textures.has("street_lamp"):
		ci.draw_texture(textures["street_lamp"], Vector2(24 * 48, 20 * 48))
		ci.draw_texture(textures["street_lamp"], Vector2(26 * 48, 20 * 48))
		ci.draw_texture(textures["street_lamp"], Vector2(24 * 48, 32 * 48))
		ci.draw_texture(textures["street_lamp"], Vector2(26 * 48, 32 * 48))

func _draw_windmill(ci: CanvasItem, pos: Vector2) -> void:
	# Башня мельницы (трапеция)
	var tower = PackedVector2Array([
		pos + Vector2(-22, 32), pos + Vector2(22, 32),
		pos + Vector2(14, -36), pos + Vector2(-14, -36)
	])
	ci.draw_colored_polygon(tower, Color(0.78, 0.72, 0.62)) # Белый камень
	
	# Купол крыши
	ci.draw_circle(pos + Vector2(0, -36), 16.0, Color(0.48, 0.28, 0.15))
	
	# Вращающиеся лопасти
	var center = pos + Vector2(0, -36)
	for i in range(4):
		var ang = windmill_angle + (i * PI * 0.5)
		var arm_end = center + Vector2(cos(ang), sin(ang)) * 42.0
		ci.draw_line(center, arm_end, Color(0.28, 0.15, 0.08), 4.0)
		
		# Полотнище паруса
		var sail_p1 = center + Vector2(cos(ang), sin(ang)) * 14.0 + Vector2(-sin(ang), cos(ang)) * 8.0
		var sail_p2 = arm_end + Vector2(-sin(ang), cos(ang)) * 8.0
		ci.draw_colored_polygon(PackedVector2Array([
			center + Vector2(cos(ang), sin(ang)) * 14.0, arm_end, sail_p2, sail_p1
		]), Color(0.92, 0.90, 0.82, 0.85))

func _draw_runic_shrine(ci: CanvasItem, pos: Vector2, textures: Dictionary) -> void:
	# Древний каменный круг
	ci.draw_arc(pos, 36.0, 0, TAU, 32, Color(0.25, 0.75, 0.95, 0.4), 2.0)
	if textures.has("rune_monolith"):
		ci.draw_texture(textures["rune_monolith"], pos + Vector2(-24, -24))
	ci.draw_circle(pos, 6.0, Color(0.3, 0.85, 1.0, 0.8)) # Магическое ядро

func _draw_bandit_camp(ci: CanvasItem, pos: Vector2) -> void:
	# Палатка 1 (треугольник)
	ci.draw_colored_polygon(PackedVector2Array([
		pos + Vector2(-20, 16), pos + Vector2(20, 16), pos + Vector2(0, -18)
	]), Color(0.45, 0.35, 0.25))
	ci.draw_line(pos + Vector2(-20, 16), pos + Vector2(0, -18), Color(0.25, 0.18, 0.10), 3.0)
	ci.draw_line(pos + Vector2(20, 16), pos + Vector2(0, -18), Color(0.25, 0.18, 0.10), 3.0)
	
	# Кострище
	ci.draw_circle(pos + Vector2(0, 28), 7.0, Color(0.22, 0.22, 0.22))
	ci.draw_circle(pos + Vector2(0, 28), 4.0, Color(0.95, 0.55, 0.10))
