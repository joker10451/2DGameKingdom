class_name ChestModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## ChestModal: фасад окна "Дубовый сундук (хранилище)" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (два списка: в сундуке / в инвентаре) + состояние выбора.
## Данные сундука и инвентаря заносятся монолитом через set_chest_items/set_player_items
## (монолит читает world_map.interactive_nodes[tile] и p.inventory). Взять/положить
## вызывают колбэки on_take(item_id)/on_store(item_id), которые мутируют world_map+p.

var _on_take: Callable
var _on_store: Callable
var _on_close: Callable

var _active_tile: Vector2i = Vector2i.ZERO
var _selected_chest_id: String = ""
var _selected_player_id: String = ""
var _panel: PanelContainer
var _chest_list: ItemList
var _player_list: ItemList
var _is_open := false


func build(canvas: CanvasLayer, on_take: Callable, on_store: Callable, on_close: Callable) -> void:
	_on_take = on_take
	_on_store = on_store
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(250, 90)
	_panel.custom_minimum_size = Vector2(780, 480)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "📦 ДУБОВЫЙ СУНДУК (ХРАНИЛИЩЕ)"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 16)
	vbox.add_child(hbox)

	var c_vbox = VBoxContainer.new()
	c_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(c_vbox)
	var c_lbl = Label.new()
	c_lbl.text = "📦 В сундуке:"
	c_vbox.add_child(c_lbl)
	_chest_list = ItemList.new()
	_chest_list.custom_minimum_size = Vector2(360, 250)
	_chest_list.item_selected.connect(_on_chest_selected)
	c_vbox.add_child(_chest_list)
	var take_btn = Button.new()
	take_btn.text = "⬇️ Забрать в инвентарь (1 шт.)"
	UIHelpersScript.style_button(take_btn)
	take_btn.pressed.connect(_on_take_pressed)
	c_vbox.add_child(take_btn)

	var p_vbox = VBoxContainer.new()
	p_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(p_vbox)
	var p_lbl = Label.new()
	p_lbl.text = "🎒 В вашем инвентаре:"
	p_vbox.add_child(p_lbl)
	_player_list = ItemList.new()
	_player_list.custom_minimum_size = Vector2(360, 250)
	_player_list.item_selected.connect(_on_player_selected)
	p_vbox.add_child(_player_list)
	var store_btn = Button.new()
	store_btn.text = "⬆️ Положить в сундук (1 шт.)"
	UIHelpersScript.style_button(store_btn)
	store_btn.pressed.connect(_on_store_pressed)
	p_vbox.add_child(store_btn)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	vbox.add_child(close_btn)


func open(tile: Vector2i) -> void:
	_active_tile = tile
	_is_open = true
	_panel.visible = true


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_active_tile() -> Vector2i:
	return _active_tile


func get_selected_chest_id() -> String:
	return _selected_chest_id


func get_selected_player_id() -> String:
	return _selected_player_id


func set_chest_items(inv: Dictionary) -> void:
	_chest_list.clear()
	for item_id in inv.keys():
		var count = inv[item_id]
		var it = ItemDatabase.get_item(item_id)
		_chest_list.add_item("%s %s x%d" % [it.get("icon", "📦"), it.get("name", item_id), count])
		_chest_list.set_item_metadata(_chest_list.get_item_count() - 1, item_id)


func set_player_items(inv: Dictionary) -> void:
	_player_list.clear()
	for item_id in inv.keys():
		var count = inv[item_id]
		var it = ItemDatabase.get_item(item_id)
		_player_list.add_item("%s %s x%d" % [it.get("icon", "📦"), it.get("name", item_id), count])
		_player_list.set_item_metadata(_player_list.get_item_count() - 1, item_id)


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _on_take_pressed() -> void:
	if _selected_chest_id != "" and _on_take.is_valid():
		_on_take.call(_selected_chest_id)


func _on_store_pressed() -> void:
	if _selected_player_id != "" and _on_store.is_valid():
		_on_store.call(_selected_player_id)


func _on_chest_selected(idx: int) -> void:
	_selected_chest_id = _chest_list.get_item_metadata(idx)


func _on_player_selected(idx: int) -> void:
	_selected_player_id = _player_list.get_item_metadata(idx)
