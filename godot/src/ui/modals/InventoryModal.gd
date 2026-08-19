class_name InventoryModal
extends RefCounted

## InventoryModal: фасад модального окна инвентаря (вынесен из GameWorld2D.gd).
## Строит UI в переданном CanvasLayer и делегирует эффекты использования/
## экипировки во внешние колбэки, чтобы состояние игрока оставалось
## единственным источником правды в GameWorld2D (GAME.md §8).
##
## Использование из GameWorld2D:
##   inventory_modal = InventoryModal.new()
##   inventory_modal.build(canvas, player_data, ItemDatabase,
##       on_use_effects_cb, on_equip_effects_cb, on_close_cb)

signal item_selected(item_id: String)

var _panel: PanelContainer
var _list: ItemList
var _details: RichTextLabel
var _selected_item: String = ""
var _player = null
var _item_db = null
var _on_use_effects: Callable
var _on_equip_effects: Callable
var _on_close: Callable


func build(canvas: CanvasLayer, player_data, item_db, on_use_effects: Callable, on_equip_effects: Callable, on_close: Callable) -> void:
	_player = player_data
	_item_db = item_db
	_on_use_effects = on_use_effects
	_on_equip_effects = on_equip_effects
	_on_close = on_close

	_panel = PanelContainer.new()
	_panel.position = Vector2(230, 80)
	_panel.custom_minimum_size = Vector2(560, 460)
	_panel.add_theme_stylebox_override("panel", UIHelpers.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "🎒 Инвентарь Персонажа"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)

	_list = ItemList.new()
	_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_list.item_selected.connect(_on_list_selected)
	vbox.add_child(_list)

	_details = RichTextLabel.new()
	_details.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_details.bbcode_enabled = true
	_details.text = "Выберите предмет..."
	vbox.add_child(_details)

	var btn_hbox = HBoxContainer.new()
	btn_hbox.add_theme_constant_override("separation", 10)
	vbox.add_child(btn_hbox)

	var equip_btn = Button.new()
	equip_btn.text = "⚔️ Надеть"
	UIHelpers.style_button(equip_btn)
	equip_btn.pressed.connect(_on_equip_pressed)
	btn_hbox.add_child(equip_btn)

	var use_btn = Button.new()
	use_btn.text = "🍞 Съесть/Выпить"
	UIHelpers.style_button(use_btn)
	use_btn.pressed.connect(_on_use_pressed)
	btn_hbox.add_child(use_btn)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	UIHelpers.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	vbox.add_child(close_btn)


func open() -> void:
	_panel.visible = true
	refresh()


func close() -> void:
	_panel.visible = false


func is_open() -> bool:
	return _panel != null and _panel.visible


func refresh() -> void:
	if _list == null or _player == null:
		return
	_list.clear()
	for item_id in _player.inventory.keys():
		var count = _player.inventory[item_id]
		var item = _item_db.get_item(item_id)
		var is_eq = (_player.equipped_weapon == item_id or _player.equipped_shield == item_id or _player.get("equipped_armor") == item_id)
		var equip_tag = " [ЭКИП]" if is_eq else ""
		_list.add_item("%s %s x%d%s" % [item.get("icon", "📦"), item.get("name", item_id), count, equip_tag])
		_list.set_item_metadata(_list.get_item_count() - 1, item_id)


func _on_list_selected(idx: int) -> void:
	_selected_item = _list.get_item_metadata(idx)
	var item = _item_db.get_item(_selected_item)
	_details.text = """[b]%s %s[/b]


[color=gold]Цена продажи:[/color] %d золотых
[color=lightblue]Категория:[/color] %s""" % [item.get("icon", ""), item.get("name", ""), item.get("desc", ""), item.get("value", 1), item.get("category", "Разное")]
	item_selected.emit(_selected_item)


func _on_equip_pressed() -> void:
	if _selected_item == "" or _player == null:
		return
	var it = _item_db.get_item(_selected_item)
	if it.get("category") == "weapon":
		_player.equipped_weapon = _selected_item
	elif it.get("category") == "shield":
		_player.equipped_shield = _selected_item
	elif it.get("category") == "armor":
		_player.set("equipped_armor", _selected_item)
	if _on_equip_effects.is_valid():
		_on_equip_effects.call(_selected_item, it)
	refresh()


func _on_use_pressed() -> void:
	if _selected_item == "" or _player == null:
		return
	if _on_use_effects.is_valid():
		_on_use_effects.call(_selected_item)
	refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
