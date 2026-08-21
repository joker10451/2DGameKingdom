class_name ShipyardModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## ShipyardModal: фасад "Морская верфь и судостроение" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (список судов, карточка, кнопки Построить/Рыбалка) + состояние выбора.
## Мутации (постройка через NavalSystem, морской промысел) через колбэки:
##   on_log(text), on_floating_text(pos, text, color, size), on_spark(pos, color),
##   get_manager() -> GameManager, get_player_pos() -> Vector2,
##   on_build(ship_type_id), on_fish(), on_close().

var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _get_manager: Callable
var _get_player_pos: Callable
var _on_build: Callable
var _on_fish: Callable
var _on_close: Callable

var _selected_type: String = "ship_longboat"
var _panel: PanelContainer
var _list: ItemList
var _info: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer,
		on_log: Callable, on_floating_text: Callable, on_spark: Callable,
		get_manager: Callable, get_player_pos: Callable,
		on_build: Callable, on_fish: Callable, on_close: Callable) -> void:
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_get_manager = get_manager
	_get_player_pos = get_player_pos
	_on_build = on_build
	_on_fish = on_fish
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(250, 75)
	_panel.custom_minimum_size = Vector2(780, 500)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)

	var title = Label.new()
	title.text = "⛵ МОРСКАЯ ВЕРФЬ И СУДОСТРОЕНИЕ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	top_h.add_child(title)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_h.add_child(spacer)

	var close_btn = Button.new()
	close_btn.text = "✖ Закрыть [ ESC ]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	top_h.add_child(close_btn)

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 380)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(320, 360)
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

	_info = RichTextLabel.new()
	_info.bbcode_enabled = true
	_info.custom_minimum_size = Vector2(380, 300)
	right_p.add_child(_info)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)

	var build_btn = Button.new()
	build_btn.text = "🔨 Построить Судно"
	UIHelpersScript.style_button(build_btn)
	build_btn.pressed.connect(_on_build_pressed)
	act_h.add_child(build_btn)

	var fish_btn = Button.new()
	fish_btn.text = "🐟 Морской Промысел"
	UIHelpersScript.style_button(fish_btn)
	fish_btn.pressed.connect(_on_fish_pressed)
	act_h.add_child(fish_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	_selected_type = "ship_longboat"
	refresh()


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_type() -> String:
	return _selected_type


func refresh() -> void:
	_list.clear()
	for s_id in NavalSystem.SHIPS.keys():
		var s = NavalSystem.SHIPS[s_id]
		_list.add_item("%s %s — %d з. (%d др.)" % [s.get("icon", "⛵"), s.get("name", ""), s.get("cost", 60), s.get("wood_cost", 8)])
		_list.set_item_metadata(_list.get_item_count() - 1, s_id)

	var gm = _get_manager.call() if _get_manager.is_valid() else null
	var p = gm.player_data if (gm != null) else null
	NavalSystem.ensure_naval_data(p)

	var s = NavalSystem.SHIPS.get(_selected_type, NavalSystem.SHIPS["ship_longboat"])
	var active_s = p.settlement.get("active_ship", "") if (p != null) else ""
	var has_ship = (active_s != "")

	_info.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Стоимость верфи:[/b] [color=gold]%d золотых[/color]
[b]Необходимые материалы:[/b] %d бревен дерева

[color=lightgray]%s[/color]

---------------------------------------------------------
[b]Флагман поселения в гавани:[/b] %s

[color=lightblue]💡 Возможности флота:[/color]
 • Рыбалка в открытом море (Лосось, Тунец, Жемчуг 🦪)
 • Плавание на Забытые Острова за пиратскими сокровищами через карту мира [M]!
""" % [
		s.get("icon", "⛵"), s.get("name", ""),
		s.get("cost", 60),
		s.get("wood_cost", 8),
		s.get("desc", ""),
		(active_s if has_ship else "Нет корабля в гавани")
	]


func _on_list_selected(idx: int) -> void:
	var s_id = _list.get_item_metadata(idx)
	if s_id:
		_selected_type = s_id
		refresh()


func _on_build_pressed() -> void:
	if _on_build.is_valid():
		_on_build.call(_selected_type)
	if _is_open:
		refresh()


func _on_fish_pressed() -> void:
	if _on_fish.is_valid():
		_on_fish.call()
	if _is_open:
		refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
