class_name DogModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## DogModal: фасад "Преданный пес-компаньон" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (текст состояния пса + кнопки кормления/ласки/лапы/следуй/кличка).
## Мутации (PetCompanionSystem) через колбэки:
##   on_log(text), on_floating_text(pos, text, color, size), on_spark(pos, color),
##   get_dog_data() -> Dictionary, on_feed()/on_pet()/on_paw()/on_toggle_stay()/
##   on_rename()/on_close().

var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _get_dog_data: Callable
var _on_feed: Callable
var _on_pet: Callable
var _on_paw: Callable
var _on_toggle_stay: Callable
var _on_rename: Callable
var _on_close: Callable

var _panel: PanelContainer
var _dialogue: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer,
		on_log: Callable, on_floating_text: Callable, on_spark: Callable,
		get_dog_data: Callable,
		on_feed: Callable, on_pet: Callable, on_paw: Callable,
		on_toggle_stay: Callable, on_rename: Callable, on_close: Callable) -> void:
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_get_dog_data = get_dog_data
	_on_feed = on_feed
	_on_pet = on_pet
	_on_paw = on_paw
	_on_toggle_stay = on_toggle_stay
	_on_rename = on_rename
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(280, 100)
	_panel.custom_minimum_size = Vector2(720, 440)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)

	var title = Label.new()
	title.text = "🐕 ПРЕДАННЫЙ ЧЕТВЕРОНОГИЙ ДРУГ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	top_h.add_child(title)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_h.add_child(spacer)

	var close_btn = Button.new()
	close_btn.text = "✖ Отойти [ ESC ]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	top_h.add_child(close_btn)

	var body_p = PanelContainer.new()
	body_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	vbox.add_child(body_p)

	_dialogue = RichTextLabel.new()
	_dialogue.bbcode_enabled = true
	_dialogue.custom_minimum_size = Vector2(680, 240)
	body_p.add_child(_dialogue)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 10)
	vbox.add_child(act_h)

	var feed_btn = Button.new()
	feed_btn.text = "🍖 Угостить мясом / рыбой"
	UIHelpersScript.style_button(feed_btn)
	feed_btn.pressed.connect(_on_feed_pressed)
	act_h.add_child(feed_btn)

	var pet_btn = Button.new()
	pet_btn.text = "✋ Погладить за ушком ❤️"
	UIHelpersScript.style_button(pet_btn)
	pet_btn.pressed.connect(_on_pet_pressed)
	act_h.add_child(pet_btn)

	var paw_btn = Button.new()
	paw_btn.text = "🐾 Дай лапу!"
	UIHelpersScript.style_button(paw_btn)
	paw_btn.pressed.connect(_on_paw_pressed)
	act_h.add_child(paw_btn)

	var follow_btn = Button.new()
	follow_btn.text = "🚶‍♂️ За мной / Охраняй"
	UIHelpersScript.style_button(follow_btn)
	follow_btn.pressed.connect(_on_toggle_stay_pressed)
	act_h.add_child(follow_btn)

	var name_btn = Button.new()
	name_btn.text = "🏷️ Дать кличку"
	UIHelpersScript.style_button(name_btn)
	name_btn.pressed.connect(_on_rename_pressed)
	act_h.add_child(name_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	refresh()


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func refresh() -> void:
	var dd = _get_dog_data.call() if _get_dog_data.is_valid() else {}
	if not (dd is Dictionary):
		dd = {}
	var is_t = dd.get("is_tamed", false)
	var d_name = dd.get("name", "Бродячий пес")
	var loyalty = dd.get("loyalty", 0)
	var state = dd.get("state", "stay")

	if not is_t:
		_dialogue.text = """[b][font_size=18]🐕 Бродячий Пес[/font_size][/b]

[color=lightgray]Перед вами сидит лохматый худой пес с умными и немного грустными глазами.
Он тихо поскуливает от холода и с надеждой смотрит на вас, прижимая уши.
В его взгляде читается тоска по заботе и теплому очагу...[/color]

[b]Статус:[/b] [color=orange]Бродячий и одинокий 🥺[/color]
[color=gold]💡 Угостите его жареным мясом или рыбкой, чтобы заслужить его доверие и сделать верным спутником![/color]
"""
	else:
		var state_str = "Бежит рядом 🐾" if state == "follow" else "Охраняет место 🛑"
		_dialogue.text = """[b][font_size=18]🐕 %s — Ваш Верный Пес[/font_size][/b]

[color=lightgreen]Пес радостно крутится вокруг ваших ног, довольно сопит и преданно заглядывает вам в глаза.
Рядом с ним на душе становится спокойно и тепло. В бою он защитит вас от волков и бандитов![/color]

[b]Уровень привязанности (Loyalty):[/b] [color=gold]%d / 100 ❤️[/color]
[b]Текущая команда:[/b] %s
[b]Здоровье друга:[/b] %.0f / %.0f HP

[color=lightblue]🔥 Домашний уют:[/color]
Когда вы дома у камина, пес ложится спать у ваших ног на теплый ковер и тихо посапывает.
""" % [
		d_name, loyalty, state_str,
		dd.get("hp", 80.0), dd.get("max_hp", 80.0)
	]


func _on_feed_pressed() -> void:
	if _on_feed.is_valid():
		_on_feed.call()
	if _is_open:
		refresh()


func _on_pet_pressed() -> void:
	if _on_pet.is_valid():
		_on_pet.call()
	if _is_open:
		refresh()


func _on_paw_pressed() -> void:
	if _on_paw.is_valid():
		_on_paw.call()
	if _is_open:
		refresh()


func _on_toggle_stay_pressed() -> void:
	if _on_toggle_stay.is_valid():
		_on_toggle_stay.call()
	if _is_open:
		refresh()


func _on_rename_pressed() -> void:
	if _on_rename.is_valid():
		_on_rename.call()
	if _is_open:
		refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
