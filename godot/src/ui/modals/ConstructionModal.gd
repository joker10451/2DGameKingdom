class_name ConstructionModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## ConstructionModal: фасад окна "Чертежи строительства" (вынесен из GameWorld2D.gd).
## Self-contained: строит список из build_catalog, показывает стоимость,
## кнопка "Начать размещение" вызывает колбэк on_start_placement.
## Состояние выбора (_selected_idx) внутри фасада; при выборе зовёт on_select(idx).

var _on_log: Callable
var _on_start_placement: Callable
var _on_close: Callable

var _catalog: Array = []
var _selected_idx: int = 0
var _panel: PanelContainer
var _list: ItemList
var _cost_label: Label
var _is_open := false


func build(canvas: CanvasLayer, catalog: Array, on_log: Callable,
		on_start_placement: Callable, on_close: Callable) -> void:
	_on_log = on_log
	_on_start_placement = on_start_placement
	_on_close = on_close
	_catalog = catalog
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(300, 100)
	_panel.custom_minimum_size = Vector2(680, 460)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "🔨 ЧЕРТЕЖИ СТРОИТЕЛЬСТВА И ПОСЕЛЕНИЯ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(640, 240)
	_list.item_selected.connect(_on_build_item_selected)
	for i in _catalog.size():
		var b = _catalog[i]
		_list.add_item(b["name"])
	vbox.add_child(_list)

	_cost_label = Label.new()
	_cost_label.text = "Выберите чертеж для постройки..."
	_cost_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.6))
	vbox.add_child(_cost_label)

	var select_btn = Button.new()
	select_btn.text = "📐 Начать размещение (Клик по клетке)"
	UIHelpersScript.style_button(select_btn)
	select_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(select_btn)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	vbox.add_child(close_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	if _catalog.size() > 0:
		_list.select(0)
		_selected_idx = 0
		_render_cost(0)


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_idx() -> int:
	return _selected_idx


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _on_start_pressed() -> void:
	if _on_start_placement.is_valid():
		_on_start_placement.call()


func _on_build_item_selected(idx: int) -> void:
	_selected_idx = idx
	_render_cost(idx)


func _render_cost(idx: int) -> void:
	if idx < 0 or idx >= _catalog.size():
		return
	var b = _catalog[idx]
	var cost_str := ""
	for req_id in b["cost"].keys():
		var it = ItemDatabase.get_item(req_id)
		cost_str += "%s %s x%d " % [it.get("icon", ""), it.get("name", req_id), b["cost"][req_id]]
	_cost_label.text = "Требуется: %s\n%s" % [cost_str, b["desc"]]
