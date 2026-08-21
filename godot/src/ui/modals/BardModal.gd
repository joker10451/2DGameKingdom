class_name BardModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## BardModal: фасад "Бродячий бард Сэр Лютиен" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (список баллад, текст песни, кнопка Заказать) + состояние выбора.
## Мутация (списание золота, подъём настроения жителям) через колбэк on_play(ballad_id).

var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _get_manager: Callable
var _get_bard_pos: Callable
var _on_play: Callable
var _on_close: Callable

var _selected_id: String = "king_ballad"
var _panel: PanelContainer
var _list: ItemList
var _dialogue: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer,
		on_log: Callable, on_floating_text: Callable, on_spark: Callable,
		get_manager: Callable, get_bard_pos: Callable,
		on_play: Callable, on_close: Callable) -> void:
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_get_manager = get_manager
	_get_bard_pos = get_bard_pos
	_on_play = on_play
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(260, 90)
	_panel.custom_minimum_size = Vector2(760, 480)
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
	title.text = "🎸 БРОДЯЧИЙ БАРД СЭР ЛЮТИЕН"
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

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 14)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(320, 360)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(300, 340)
	_list.item_selected.connect(_on_list_selected)
	left_p.add_child(_list)

	var right_v = VBoxContainer.new()
	right_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_v.add_theme_constant_override("separation", 10)
	body_h.add_child(right_v)

	var right_p = PanelContainer.new()
	right_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	right_v.add_child(right_p)

	_dialogue = RichTextLabel.new()
	_dialogue.bbcode_enabled = true
	_dialogue.custom_minimum_size = Vector2(380, 280)
	right_p.add_child(_dialogue)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 10)
	right_v.add_child(act_h)

	var play_btn = Button.new()
	play_btn.text = "🎶 Заказать Балладу (5 з.)"
	UIHelpersScript.style_button(play_btn)
	play_btn.pressed.connect(_on_play_pressed)
	act_h.add_child(play_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	_selected_id = "king_ballad"
	refresh()


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_id() -> String:
	return _selected_id


func refresh() -> void:
	_list.clear()
	for b_id in LivingDialogueSystem.BALLADS.keys():
		var b = LivingDialogueSystem.BALLADS[b_id]
		_list.add_item("%s %s" % [b.get("icon", "🎵"), b.get("title", "")])
		_list.set_item_metadata(_list.get_item_count() - 1, b_id)

	var b = LivingDialogueSystem.BALLADS.get(_selected_id, LivingDialogueSystem.BALLADS["king_ballad"])
	var verses_str = ""
	for l in b.get("lines", []):
		verses_str += "  [i]«" + l + "»[/i]\n"

	_dialogue.text = """[b][font_size=18]🎸 Сэр Лютиен: «Приветствую, благородный лорд!»[/font_size][/b]

[color=lightgray]Любуясь пляской пламени в камине, бард мягко перебирает струны своей верной лютни.
В таверне звенит эль, и вся деревня замирает в ожидании славной песни...[/color]

[b]Выбранная песнь:[/b] [color=gold]%s[/color]
[b]Стоимость исполнения:[/b] 5 золотых монет

%s

[color=lightblue]💡 Эффект песни:[/color]
Все посетители таверны подпевают хором, чокаются кружками эля и получают [b]+30 к Настроению[/b]!
""" % [b.get("title", ""), verses_str]


func _on_list_selected(idx: int) -> void:
	var b_id = _list.get_item_metadata(idx)
	if b_id:
		_selected_id = b_id
		refresh()


func _on_play_pressed() -> void:
	if _on_play.is_valid():
		_on_play.call(_selected_id)
	if _is_open:
		refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
