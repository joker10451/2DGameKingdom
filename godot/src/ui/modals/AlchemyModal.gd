class_name AlchemyModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## AlchemyModal: фасад "Алхимический стол" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (список рецептов, карточка, кнопка варки) + состояние выбора.
## Данные заносятся монолитом через set_recipes(recipe_ids) + show_detail(rec).
## Варка вызывает колбэк on_craft(), который мутирует p.inventory через AlchemySystem.

var _on_craft: Callable
var _on_close: Callable

var _selected_id: String = "potion_healing"
var _panel: PanelContainer
var _list: ItemList
var _info: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer, on_craft: Callable, on_close: Callable) -> void:
	_on_craft = on_craft
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
	title.text = "🧪 АЛХИМИЧЕСКИЙ СТОЛ И ЗЕЛЬЕВАРЕНИЕ"
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

	var craft_btn = Button.new()
	craft_btn.text = "⚗️ Сварить Зелье / Эликсир"
	UIHelpersScript.style_button(craft_btn)
	craft_btn.pressed.connect(_on_craft_pressed)
	right_v.add_child(craft_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_id() -> String:
	return _selected_id


func set_recipes(recipe_ids: Array) -> void:
	_list.clear()
	for rec_id in recipe_ids:
		var rec = AlchemySystem.RECIPES[rec_id]
		_list.add_item("%s %s" % [rec.get("icon", "🧪"), rec.get("name", "")])
		_list.set_item_metadata(_list.get_item_count() - 1, rec_id)


func show_detail(rec: Dictionary) -> void:
	_selected_id = rec.get("id", _selected_id)
	var cost_str = ""
	for it_id in rec.get("cost", {}).keys():
		var it = ItemDatabase.get_item(it_id)
		cost_str += "%s %s: %d шт.  " % [it.get("icon", "📦"), it.get("name", it_id), rec["cost"][it_id]]
	_info.text = """[b][font_size=18]%s %s[/font_size][/b]

[b]Необходимые ингредиенты:[/b] %s

[b]Выход готовой продукции:[/b] %d шт.



[color=lightgray]%s[/color]



[color=gold]Поместите травы и компоненты в котел и нажмите кнопку «⚗️ Сварить Зелье»![/color]
""" % [
		rec.get("icon", "🧪"), rec.get("name", ""),
		cost_str,
		rec.get("yield", 1),
		rec.get("desc", "")
	]


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _on_list_selected(idx: int) -> void:
	var rec_id = _list.get_item_metadata(idx)
	if rec_id:
		_selected_id = rec_id
		var rec = AlchemySystem.RECIPES.get(rec_id, {})
		if not rec.is_empty():
			show_detail(rec)


func _on_craft_pressed() -> void:
	if _on_craft.is_valid():
		_on_craft.call()
