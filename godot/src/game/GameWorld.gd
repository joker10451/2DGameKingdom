extends Node2D

## ГЛАВНЫЙ ПРОТОТИП: Живая деревня с нуля
## Всё создаётся программно — никаких сломанных зависимостей

# === НАСТРОЙКИ ===
const VILLAGE_SIZE := Vector2(1600, 1000)
const PLAYER_SPEED := 160.0
const NPC_SPEED := 60.0

# === ТОЧКИ ИНТЕРЕСА (здания) ===
var locations := {
	"Ферма 🌾": {"pos": Vector2(200, 600), "size": Vector2(140, 90), "color": Color(0.45, 0.6, 0.2)},
	"Мельница ⚙️": {"pos": Vector2(200, 280), "size": Vector2(100, 80), "color": Color(0.65, 0.55, 0.35)},
	"Пекарня 🥖": {"pos": Vector2(500, 200), "size": Vector2(110, 80), "color": Color(0.8, 0.6, 0.3)},
	"Таверна 🍺": {"pos": Vector2(750, 300), "size": Vector2(130, 100), "color": Color(0.55, 0.3, 0.15)},
	"Рынок ⚖️": {"pos": Vector2(550, 500), "size": Vector2(160, 100), "color": Color(0.7, 0.65, 0.4)},
	"Замок 🏰": {"pos": Vector2(1050, 200), "size": Vector2(180, 140), "color": Color(0.5, 0.5, 0.55)},
	"Пост Стражи 🛡️": {"pos": Vector2(750, 550), "size": Vector2(90, 70), "color": Color(0.35, 0.4, 0.65)},
	"Лагерь Бандитов 🌲": {"pos": Vector2(1300, 700), "size": Vector2(120, 90), "color": Color(0.3, 0.35, 0.2)},
}

# === ДАННЫЕ NPC ===
var npc_list := [
	{"name": "Джайлс", "role": "Крестьянин", "color": Color(0.45, 0.65, 0.35), "home": "Ферма 🌾", "work": "Ферма 🌾", "evening": "Таверна 🍺"},
	{"name": "Аларик", "role": "Торговец", "color": Color(0.85, 0.7, 0.2), "home": "Рынок ⚖️", "work": "Рынок ⚖️", "evening": "Таверна 🍺"},
	{"name": "Роланд", "role": "Стражник", "color": Color(0.3, 0.45, 0.75), "home": "Пост Стражи 🛡️", "work": "Пост Стражи 🛡️", "evening": "Таверна 🍺"},
	{"name": "Каэль", "role": "Бандит", "color": Color(0.7, 0.2, 0.2), "home": "Лагерь Бандитов 🌲", "work": "Лагерь Бандитов 🌲", "evening": "Лагерь Бандитов 🌲"},
	{"name": "Бран", "role": "Пекарь", "color": Color(0.6, 0.4, 0.25), "home": "Пекарня 🥖", "work": "Пекарня 🥖", "evening": "Таверна 🍺"},
	{"name": "Барон Вильгельм", "role": "Лорд", "color": Color(0.6, 0.2, 0.7), "home": "Замок 🏰", "work": "Замок 🏰", "evening": "Замок 🏰"},
]

# === РАНТАЙМ ===
var player_pos := Vector2(500, 400)
var camera_offset := Vector2.ZERO
var npcs := [] # Массив словарей с состоянием каждого NPC
var interaction_target := -1 # Индекс ближайшего NPC (-1 = никого)
var show_dialogue := false
var dialogue_text := ""
var dialogue_npc_name := ""

# HUD ноды (создадим программно)
var time_label: Label
var info_label: Label
var hint_label: Label
var dialogue_panel: PanelContainer
var dialogue_label: RichTextLabel
var close_btn: Button

func _ready() -> void:
	# Инициализация NPC
	for i in npc_list.size():
		var npc_data = npc_list[i]
		var start_loc = locations[npc_data["work"]]
		npcs.append({
			"name": npc_data["name"],
			"role": npc_data["role"],
			"color": npc_data["color"],
			"pos": start_loc["pos"] + Vector2(randf_range(-40, 40), randf_range(-40, 40)),
			"target": start_loc["pos"],
			"home": npc_data["home"],
			"work": npc_data["work"],
			"evening": npc_data["evening"],
			"thought": "💭",
			"hunger": randf_range(10, 40),
			"gold": randi_range(5, 100),
		})
	
	_build_hud()

func _build_hud() -> void:
	var canvas = CanvasLayer.new()
	canvas.name = "HUD"
	add_child(canvas)
	
	# Верхняя панель: время
	time_label = Label.new()
	time_label.position = Vector2(16, 10)
	time_label.add_theme_font_size_override("font_size", 18)
	time_label.add_theme_color_override("font_color", Color.WHITE)
	time_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	time_label.add_theme_constant_override("shadow_offset_x", 1)
	time_label.add_theme_constant_override("shadow_offset_y", 1)
	canvas.add_child(time_label)
	
	# Нижняя панель: инфо об игроке
	info_label = Label.new()
	info_label.position = Vector2(16, 660)
	info_label.add_theme_font_size_override("font_size", 14)
	info_label.add_theme_color_override("font_color", Color(1, 0.95, 0.7))
	info_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	info_label.add_theme_constant_override("shadow_offset_x", 1)
	info_label.add_theme_constant_override("shadow_offset_y", 1)
	canvas.add_child(info_label)
	
	# Подсказка взаимодействия
	hint_label = Label.new()
	hint_label.position = Vector2(400, 680)
	hint_label.add_theme_font_size_override("font_size", 16)
	hint_label.add_theme_color_override("font_color", Color(1, 1, 0.6))
	hint_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	hint_label.add_theme_constant_override("shadow_offset_x", 1)
	hint_label.add_theme_constant_override("shadow_offset_y", 1)
	canvas.add_child(hint_label)
	
	# Панель диалога
	dialogue_panel = PanelContainer.new()
	dialogue_panel.position = Vector2(300, 200)
	dialogue_panel.custom_minimum_size = Vector2(400, 250)
	dialogue_panel.visible = false
	canvas.add_child(dialogue_panel)
	
	var vbox = VBoxContainer.new()
	dialogue_panel.add_child(vbox)
	
	dialogue_label = RichTextLabel.new()
	dialogue_label.bbcode_enabled = true
	dialogue_label.custom_minimum_size = Vector2(380, 180)
	dialogue_label.fit_content = true
	vbox.add_child(dialogue_label)
	
	close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	close_btn.pressed.connect(func(): show_dialogue = false; dialogue_panel.visible = false)
	vbox.add_child(close_btn)

func _process(delta: float) -> void:
	if show_dialogue:
		queue_redraw()
		return
	
	# === ДВИЖЕНИЕ ИГРОКА ===
	var input := Vector2.ZERO
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		input.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		input.x += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		input.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		input.y += 1
	
	if input != Vector2.ZERO:
		player_pos += input.normalized() * PLAYER_SPEED * delta
		player_pos.x = clampf(player_pos.x, 20, VILLAGE_SIZE.x - 20)
		player_pos.y = clampf(player_pos.y, 20, VILLAGE_SIZE.y - 20)
	
	# === КАМЕРА (простое следование) ===
	var viewport_size = get_viewport_rect().size
	camera_offset = player_pos - viewport_size * 0.5
	camera_offset.x = clampf(camera_offset.x, 0, maxf(0, VILLAGE_SIZE.x - viewport_size.x))
	camera_offset.y = clampf(camera_offset.y, 0, maxf(0, VILLAGE_SIZE.y - viewport_size.y))
	
	# === ДВИЖЕНИЕ NPC ===
	for i in npcs.size():
		var npc = npcs[i]
		var dist = npc["pos"].distance_to(npc["target"])
		if dist > 8.0:
			var dir = (npc["target"] - npc["pos"]).normalized()
			npc["pos"] += dir * NPC_SPEED * delta
		else:
			# Достиг цели — выбираем новую
			_pick_npc_destination(i)
		
		# Голод растёт
		npc["hunger"] += delta * 0.3
		if npc["hunger"] > 80:
			npc["thought"] = "🥖"
		elif npc["hunger"] > 50:
			npc["thought"] = "😟"
	
	# === ПОИСК БЛИЖАЙШЕГО NPC ===
	interaction_target = -1
	var closest_dist := 60.0
	for i in npcs.size():
		var d = player_pos.distance_to(npcs[i]["pos"])
		if d < closest_dist:
			closest_dist = d
			interaction_target = i
	
	# === HUD ===
	var time_str = "07:00"
	var date_str = "1-й день, Весна, 1042 год"
	if TimeManager:
		time_str = TimeManager.get_formatted_time()
		date_str = TimeManager.get_formatted_date()
	time_label.text = "🕒 %s | %s" % [time_str, date_str]
	
	var p_gold = GameManager.player_data.gold if GameManager and GameManager.player_data else 15
	var p_role = GameManager.player_data.current_role if GameManager and GameManager.player_data else "Крестьянин"
	info_label.text = "👤 Игрок | Роль: %s | 💰 %d золотых" % [p_role, p_gold]
	
	if interaction_target >= 0:
		hint_label.text = "[ E ] Поговорить с %s" % npcs[interaction_target]["name"]
		hint_label.visible = true
	else:
		hint_label.visible = false
	
	queue_redraw()

func _pick_npc_destination(idx: int) -> void:
	var npc = npcs[idx]
	var hour = TimeManager.hour if TimeManager else 12
	
	var dest_key: String
	if hour >= 22 or hour < 6:
		dest_key = npc["home"]
		npc["thought"] = "💤"
	elif hour >= 6 and hour < 18:
		dest_key = npc["work"]
		match npc["role"]:
			"Крестьянин": npc["thought"] = "🌾"
			"Торговец": npc["thought"] = "⚖️"
			"Стражник": npc["thought"] = "🛡️"
			"Бандит": npc["thought"] = "🗡️"
			"Пекарь": npc["thought"] = "🥖"
			"Лорд": npc["thought"] = "👑"
	else:
		dest_key = npc["evening"]
		npc["thought"] = "🍺"
	
	if locations.has(dest_key):
		var loc = locations[dest_key]
		npc["target"] = loc["pos"] + Vector2(randf_range(-50, 50), randf_range(-30, 30))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E and interaction_target >= 0 and not show_dialogue:
			_open_dialogue(interaction_target)
		elif event.keycode == KEY_ESCAPE and show_dialogue:
			show_dialogue = false
			dialogue_panel.visible = false

func _open_dialogue(npc_idx: int) -> void:
	var npc = npcs[npc_idx]
	show_dialogue = true
	dialogue_panel.visible = true
	
	var greeting := ""
	match npc["role"]:
		"Крестьянин":
			if npc["hunger"] > 60:
				greeting = "Ох, путник... В животе пусто. Хлеба не найдётся?"
			else:
				greeting = "Здравствуй, добрый человек. Земля нынче сухая, тяжело пахать. Но живём."
		"Торговец":
			greeting = "Приветствую! Лучшие товары от Кряжа до побережья. Что ищешь, друг?"
		"Стражник":
			greeting = "Порядок в поселении. Если увидишь подозрительных — дай знать."
		"Бандит":
			greeting = "Чего вылупился? Иди своей дорогой, пока цел."
		"Пекарь":
			greeting = "Хлеб свежий, с утра пёк! Мука нынче дорогая, но для тебя — по старой цене."
		"Лорд":
			greeting = "Говори быстро, простолюдин. Дела графства не терпят промедления."
		_:
			greeting = "Здравствуй, путник."
	
	dialogue_label.text = "[b]%s[/b] (%s)\n\n«%s»\n\n[color=gray]Золото: %d | Голод: %.0f/100[/color]" % [
		npc["name"], npc["role"], greeting, npc["gold"], npc["hunger"]
	]

func _draw() -> void:
	var offset = camera_offset
	
	# === 1. ЗЕМЛЯ (зелёный фон) ===
	draw_rect(Rect2(-offset, VILLAGE_SIZE + Vector2(200, 200)), Color(0.28, 0.45, 0.2))
	
	# Тропинки между зданиями
	var path_color = Color(0.55, 0.45, 0.3, 0.6)
	var loc_keys = locations.keys()
	for i in loc_keys.size():
		for j in range(i + 1, loc_keys.size()):
			var a = locations[loc_keys[i]]["pos"] - offset
			var b = locations[loc_keys[j]]["pos"] - offset
			if a.distance_to(b) < 500:
				draw_line(a + Vector2(50, 40), b + Vector2(50, 40), path_color, 12.0)
	
	# === 2. ЗДАНИЯ ===
	for loc_name in locations:
		var loc = locations[loc_name]
		var rect_pos = loc["pos"] - offset
		var rect_size = loc["size"]
		var col: Color = loc["color"]
		
		# Тень
		draw_rect(Rect2(rect_pos + Vector2(4, 6), rect_size), Color(0, 0, 0, 0.3))
		# Стены
		draw_rect(Rect2(rect_pos, rect_size), col)
		# Крыша (тёмная верхняя полоса)
		draw_rect(Rect2(rect_pos, Vector2(rect_size.x, 14)), col.darkened(0.3))
		# Контур
		draw_rect(Rect2(rect_pos, rect_size), Color(0, 0, 0, 0.5), false, 2.0)
		# Название
		draw_string(ThemeDB.fallback_font, rect_pos + Vector2(6, -6), loc_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color.WHITE)
	
	# === 3. NPC ===
	for i in npcs.size():
		var npc = npcs[i]
		var screen_pos: Vector2 = npc["pos"] - offset
		
		# Тень
		draw_circle(screen_pos + Vector2(0, 10), 11, Color(0, 0, 0, 0.3))
		# Тело (цвет одежды по роли)
		draw_circle(screen_pos, 13, npc["color"])
		# Голова
		draw_circle(screen_pos + Vector2(0, -7), 7, Color(0.93, 0.78, 0.6))
		
		# Облачко мысли
		draw_circle(screen_pos + Vector2(14, -28), 10, Color(1, 1, 1, 0.9))
		draw_circle(screen_pos + Vector2(6, -18), 4, Color(1, 1, 1, 0.7))
		draw_string(ThemeDB.fallback_font, screen_pos + Vector2(8, -24), npc["thought"], HORIZONTAL_ALIGNMENT_CENTER, -1, 12)
		
		# Имя
		draw_string(ThemeDB.fallback_font, screen_pos + Vector2(-30, -40), npc["name"], HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color.WHITE)
		
		# Полоска сытости
		var bar_w := 26.0
		var hunger_ratio = 1.0 - clampf(npc["hunger"] / 100.0, 0, 1)
		draw_rect(Rect2(screen_pos + Vector2(-13, 16), Vector2(bar_w, 4)), Color(0.15, 0.15, 0.15))
		var bar_color = Color(0.2, 0.8, 0.2).lerp(Color.RED, npc["hunger"] / 100.0)
		draw_rect(Rect2(screen_pos + Vector2(-13, 16), Vector2(bar_w * hunger_ratio, 4)), bar_color)
		
		# Подсветка если рядом с игроком
		if i == interaction_target:
			draw_arc(screen_pos, 18, 0, TAU, 24, Color(1, 1, 0.3, 0.8), 2.0)
	
	# === 4. ИГРОК ===
	var p_screen = player_pos - offset
	# Тень
	draw_circle(p_screen + Vector2(0, 12), 13, Color(0, 0, 0, 0.4))
	# Золотое кольцо выделения
	draw_arc(p_screen, 19, 0, TAU, 32, Color(1.0, 0.85, 0.2, 0.9), 2.5)
	# Тело
	draw_circle(p_screen, 15, Color(0.2, 0.55, 0.85))
	# Голова
	draw_circle(p_screen + Vector2(0, -8), 8, Color(0.95, 0.82, 0.65))
	# Подпись
	draw_string(ThemeDB.fallback_font, p_screen + Vector2(-20, -34), "ВЫ", HORIZONTAL_ALIGNMENT_CENTER, 40, 13, Color.GOLD)
