class_name TradeModal
extends RefCounted

## TradeModal: фасад окна "Городской рынок" (вынесен из GameWorld2D.gd).
## Мутирует состояние только через gm.local_market.buy_from_market/
## sell_to_market и gm.player_data (единственный источник правды, GAME.md §8).
## Фасад лишь строит UI, читает цены/ассортимент и делегирует лог в колбэк.

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

var _panel: PanelContainer
var _merchant_list: ItemList
var _player_list: ItemList
var _gold_label: Label
var _get_manager: Callable   # () -> Node  (GameManager)
var _on_log: Callable        # (msg: String) -> void
var _on_close: Callable      # () -> void


func build(canvas: CanvasLayer, get_manager: Callable, on_log: Callable, on_close: Callable) -> void:
	_get_manager = get_manager
	_on_log = on_log
	_on_close = on_close

	_panel = PanelContainer.new()
	_panel.position = Vector2(230, 80)
	_panel.custom_minimum_size = Vector2(820, 500)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.96), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "⚖️ ГОРОДСКОЙ РЫНОК ОЛДЕРИИ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	_gold_label = Label.new()
	_gold_label.text = "Ваше золото: 50"
	_gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	vbox.add_child(_gold_label)

	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 20)
	vbox.add_child(hbox)

	var m_vbox = VBoxContainer.new()
	m_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(m_vbox)
	var m_lbl = Label.new()
	m_lbl.text = "🏪 Товары торговца:"
	m_vbox.add_child(m_lbl)
	_merchant_list = ItemList.new()
	_merchant_list.custom_minimum_size = Vector2(370, 260)
	m_vbox.add_child(_merchant_list)
	var buy_btn = Button.new()
	buy_btn.text = "💰 Купить (1 шт.)"
	UIHelpersScript.style_button(buy_btn)
	buy_btn.pressed.connect(_on_buy_pressed)
	m_vbox.add_child(buy_btn)

	var p_vbox = VBoxContainer.new()
	p_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(p_vbox)
	var p_lbl = Label.new()
	p_lbl.text = "🎒 Ваши товары на продажу:"
	p_vbox.add_child(p_lbl)
	_player_list = ItemList.new()
	_player_list.custom_minimum_size = Vector2(370, 260)
	p_vbox.add_child(_player_list)
	var sell_btn = Button.new()
	sell_btn.text = "💵 Продать (1 шт.)"
	UIHelpersScript.style_button(sell_btn)
	sell_btn.pressed.connect(_on_sell_pressed)
	p_vbox.add_child(sell_btn)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	UIHelpersScript.style_button(close_btn)
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
	if _get_manager.is_valid() == false:
		return
	var gm = _get_manager.call()
	if gm == null:
		return
	var p = gm.player_data
	var m = gm.local_market
	if p == null or m == null:
		return

	_merchant_list.clear()
	_player_list.clear()
	_gold_label.text = "💰 Ваше золото: %d золотых" % p.gold

	for item_id in m.inventory.keys():
		var count = m.inventory[item_id]
		var price = m.get_current_price(item_id)
		var item = ItemDatabase.get_item(item_id)
		_merchant_list.add_item("%s %s (Запас: %d) — %.1f з." % [item.get("icon", "📦"), item.get("name", item_id), count, price])
		_merchant_list.set_item_metadata(_merchant_list.get_item_count() - 1, item_id)

	for item_id in p.inventory.keys():
		var count = p.inventory[item_id]
		var item = ItemDatabase.get_item(item_id)
		var price = m.get_current_price(item_id) * 0.8
		_player_list.add_item("%s %s x%d — продажа: %.1f з." % [item.get("icon", "📦"), item.get("name", item_id), count, price])
		_player_list.set_item_metadata(_player_list.get_item_count() - 1, item_id)


func _on_buy_pressed() -> void:
	var sel = _merchant_list.get_selected_items()
	if sel.size() == 0:
		return
	var item_id = _merchant_list.get_item_metadata(sel[0])
	var gm = _get_manager.call() if _get_manager.is_valid() else null
	if gm == null:
		return
	var p = gm.player_data
	var m = gm.local_market
	if p and m and m.buy_from_market(p, item_id, 1):
		_log_msg("[color=green]Куплено: %s[/color]" % ItemDatabase.get_item(item_id).get("name", ""))
		refresh()


func _on_sell_pressed() -> void:
	var sel = _player_list.get_selected_items()
	if sel.size() == 0:
		return
	var item_id = _player_list.get_item_metadata(sel[0])
	var gm = _get_manager.call() if _get_manager.is_valid() else null
	if gm == null:
		return
	var p = gm.player_data
	var m = gm.local_market
	if p and m and m.sell_to_market(p, item_id, 1):
		_log_msg("[color=green]Продано: %s[/color]" % ItemDatabase.get_item(item_id).get("name", ""))
		refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()


func _log_msg(msg: String) -> void:
	if _on_log.is_valid():
		_on_log.call(msg)
