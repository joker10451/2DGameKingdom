class_name SmithingModal
extends RefCounted

## SmithingModal: фасад окна "Кузнечный горн" (вынесен из GameWorld2D.gd).
## Крафт мутирует player_data.inventory и skills напрямую (через колбэки
## on_award_xp), единственный источник правды — монолит (GAME.md §8).
## Состояние выбора рецепта живёт внутри фасада.

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

var _panel: PanelContainer
var _recipe_list: ItemList
var _details_label: RichTextLabel
var _selected_idx: int = -1
var _recipes: Array = []
var _get_manager: Callable
var _on_log: Callable
var _on_award_xp: Callable
var _on_close: Callable


func build(canvas: CanvasLayer, recipes: Array, get_manager: Callable, on_log: Callable, on_award_xp: Callable, on_close: Callable) -> void:
	_recipes = recipes
	_get_manager = get_manager
	_on_log = on_log
	_on_award_xp = on_award_xp
	_on_close = on_close

	_panel = PanelContainer.new()
	_panel.position = Vector2(270, 90)
	_panel.custom_minimum_size = Vector2(740, 460)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "⚒️ КУЗНИЧНЫЙ ГОРН И НАКОВАЛЬНЯ ВУЛЬФРИКА"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 16)
	vbox.add_child(hbox)

	_recipe_list = ItemList.new()
	_recipe_list.custom_minimum_size = Vector2(340, 260)
	_recipe_list.item_selected.connect(_on_recipe_selected)
	hbox.add_child(_recipe_list)

	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(right_vbox)

	_details_label = RichTextLabel.new()
	_details_label.bbcode_enabled = true
	_details_label.custom_minimum_size = Vector2(330, 180)
	_details_label.fit_content = true
	right_vbox.add_child(_details_label)

	var craft_btn = Button.new()
	craft_btn.text = "🔥 Выковать предмет"
	UIHelpersScript.style_button(craft_btn)
	craft_btn.pressed.connect(_on_craft_pressed)
	right_vbox.add_child(craft_btn)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	vbox.add_child(close_btn)


func open() -> void:
	_panel.visible = true
	_recipe_list.clear()
	for i in _recipes.size():
		var r = _recipes[i]
		var item = ItemDatabase.get_item(r["result_id"])
		_recipe_list.add_item("%s %s" % [item.get("icon", "⚒️"), r["name"]])
	if _recipes.size() > 0:
		_recipe_list.select(0)
		_on_recipe_selected(0)


func close() -> void:
	_panel.visible = false


func is_open() -> bool:
	return _panel != null and _panel.visible


func _on_recipe_selected(idx: int) -> void:
	_selected_idx = idx
	if idx < 0 or idx >= _recipes.size():
		return
	var r = _recipes[idx]
	var item = ItemDatabase.get_item(r["result_id"])
	var p = _get_player()
	var req_str = ""
	for req_id in r["req"].keys():
		var req_item = ItemDatabase.get_item(req_id)
		var req_amt = r["req"][req_id]
		var have_amt = p.get_item_count(req_id) if p else 0
		var col = "green" if have_amt >= req_amt else "red"
		req_str += "• %s %s: [color=%s]%d / %d[/color]\n" % [req_item.get("icon", ""), req_item.get("name", req_id), col, have_amt, req_amt]
	_details_label.text = """[b]%s %s[/b]

%s



[b]Необходимые ресурсы:[/b]

%s""" % [item.get("icon", ""), r["name"], r["desc"], req_str]


func _on_craft_pressed() -> void:
	if _selected_idx < 0 or _selected_idx >= _recipes.size():
		return
	var r = _recipes[_selected_idx]
	var p = _get_player()
	if p == null:
		return
	for req_id in r["req"].keys():
		if p.get_item_count(req_id) < r["req"][req_id]:
			_log_msg("[color=red]Недостаточно ресурсов для ковки![/color]")
			return
	for req_id in r["req"].keys():
		p.remove_item(req_id, r["req"][req_id])
	p.add_item(r["result_id"], 1)
	var xp_amt = 35.0 if r["result_id"] == "iron_ingot" else 85.0
	if _on_award_xp.is_valid():
		_on_award_xp.call("smithing", xp_amt)
	var res_item = ItemDatabase.get_item(r["result_id"])
	_log_msg("[color=gold]🔥 Вы успешно выковали: %s %s![/color]" % [res_item.get("icon", ""), res_item.get("name", "")])
	_on_recipe_selected(_selected_idx)


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _get_player():
	if _get_manager.is_valid() == false:
		return null
	var gm = _get_manager.call()
	if gm == null:
		return null
	return gm.player_data


func _log_msg(msg: String) -> void:
	if _on_log.is_valid():
		_on_log.call(msg)
