class_name CitizenShopModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## CitizenShopModal: фасад "Лавка жителя" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (список товаров, карточка, кнопка покупки) + состояние выбора.
## Данные заносятся монолитом через set_items(entries, npc_name, ...). Покупка
## вызывает колбэк on_buy(item_id, price), который мутирует p.gold/inventory + npc.gold.

var _on_buy: Callable
var _on_select: Callable
var _on_close: Callable

var _npc_name: String = "Мастер"
var _selected_meta: Dictionary = {}
var _panel: PanelContainer
var _list: ItemList
var _info: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer, on_buy: Callable, on_select: Callable, on_close: Callable) -> void:
	_on_buy = on_buy
	_on_select = on_select
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(250, 100)
	_panel.custom_minimum_size = Vector2(780, 480)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "🛒 ЛАВКА ЖИТЕЛЯ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(350, 400)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(320, 340)
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
	_info.custom_minimum_size = Vector2(360, 280)
	right_p.add_child(_info)

	var buy_btn = Button.new()
	buy_btn.text = "💰 Купить выбранный товар"
	UIHelpersScript.style_button(buy_btn)
	buy_btn.pressed.connect(_on_buy_pressed)
	right_v.add_child(buy_btn)


func open(_npc_idx: int) -> void:
	_is_open = true
	_panel.visible = true


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func set_items(entries: Array, npc_name: String, npc_role: String, npc_gold: int) -> void:
	_npc_name = npc_name
	_list.clear()
	for it_entry in entries:
		var it = ItemDatabase.get_item(it_entry["id"])
		_list.add_item("%s %s — %d з." % [it.get("icon", "📦"), it.get("name", it_entry["id"]), it_entry["price"]])
		_list.set_item_metadata(_list.get_item_count() - 1, it_entry)
	_info.text = """[b][font_size=18]Прилавок жителя: %s (%s)[/font_size][/b]

[color=lightgray]Житель продает товары собственного ремесленного производства.[/color]



[b]Личные сбережения мастера:[/] [color=gold]%d золотых[/color]



Выберите предмет из списка слева и нажмите кнопку «Купить».""" % [npc_name, npc_role, npc_gold]


func show_detail(meta: Dictionary) -> void:
	_selected_meta = meta
	var it = ItemDatabase.get_item(meta["id"])
	var cat_name = ItemDatabase.get_category_name(it.get("category", "misc"))
	_info.text = """[b][font_size=18]%s %s[/font_size][/b]

[b]Стоимость:[/b] [color=gold]%d золотых[/color]

[b]Категория:[/b] %s

[color=lightgray]%s[/color]

[color=cyan]Покупка обогатит жителя %s и пополнит городскую казну налогами в 08:00![/color]
""" % [
		it.get("icon", "📦"), it.get("name", ""),
		meta["price"],
		cat_name,
		it.get("desc", ""),
		_npc_name
	]


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _on_list_selected(idx: int) -> void:
	var meta = _list.get_item_metadata(idx)
	if not meta:
		return
	show_detail(meta)
	if _on_select.is_valid():
		_on_select.call(meta)


func _on_buy_pressed() -> void:
	if _selected_meta.is_empty():
		return
	if _on_buy.is_valid():
		_on_buy.call(_selected_meta["id"], _selected_meta["price"])
