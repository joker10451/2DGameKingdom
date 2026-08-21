class_name RegionalDiplomacyModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## RegionalDiplomacyModal: Фасад феодальной дипломатии и союзов
## Позволяет заключать торговые пакты, союзы и отправлять дары правителям

var _on_sign_treaty: Callable
var _on_send_gift: Callable
var _on_close: Callable

var _panel: PanelContainer
var _city_list: ItemList
var _info_label: RichTextLabel
var _trade_btn: Button
var _nap_btn: Button
var _alliance_btn: Button
var _gift_btn: Button
var _is_open: bool = false

var _player_ref: CharacterData
var _regional_map_ref: RefCounted
var _diplomacy_sys_ref: RefCounted
var _selected_city_id: String = "ironhold"

const CITIES_KEYS := ["ironhold", "goldvale", "blackwood", "highkeep", "olderia"]

func build(canvas: CanvasLayer, on_sign_treaty: Callable, on_send_gift: Callable, on_close: Callable) -> void:
	_on_sign_treaty = on_sign_treaty
	_on_send_gift = on_send_gift
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(180, 60)
	_panel.custom_minimum_size = Vector2(920, 560)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title_h = HBoxContainer.new()
	vbox.add_child(title_h)
	var title = Label.new()
	title.text = "👑 ФЕОДАЛЬНАЯ ДИПЛОМАТИЯ И СОЮЗЫ КОРОЛЕВСТВА"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_h.add_child(title)

	var close_btn = Button.new()
	close_btn.text = "✖ Закрыть"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	title_h.add_child(close_btn)

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	# Левая колонка: список городов
	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 440)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_city_list = ItemList.new()
	_city_list.custom_minimum_size = Vector2(320, 420)
	_city_list.item_selected.connect(_on_city_selected)
	left_p.add_child(_city_list)

	# Правая колонка: досье города и действия
	var right_v = VBoxContainer.new()
	right_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_v.add_theme_constant_override("separation", 10)
	body_h.add_child(right_v)

	var right_p = PanelContainer.new()
	right_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	right_v.add_child(right_p)

	_info_label = RichTextLabel.new()
	_info_label.bbcode_enabled = true
	_info_label.custom_minimum_size = Vector2(500, 280)
	right_p.add_child(_info_label)

	# Кнопки дипломатических действий
	var actions_grid = GridContainer.new()
	actions_grid.columns = 2
	actions_grid.add_theme_constant_override("h_separation", 10)
	actions_grid.add_theme_constant_override("v_separation", 8)
	right_v.add_child(actions_grid)

	_trade_btn = Button.new()
	_trade_btn.text = "📜 Торговый Пакт (+25% караваны)"
	_trade_btn.custom_minimum_size = Vector2(245, 36)
	UIHelpersScript.style_button(_trade_btn)
	_trade_btn.pressed.connect(func(): _on_treaty_btn_pressed("trade"))
	actions_grid.add_child(_trade_btn)

	_nap_btn = Button.new()
	_nap_btn.text = "🤝 Пакт о Ненападении"
	_nap_btn.custom_minimum_size = Vector2(245, 36)
	UIHelpersScript.style_button(_nap_btn)
	_nap_btn.pressed.connect(func(): _on_treaty_btn_pressed("nap"))
	actions_grid.add_child(_nap_btn)

	_alliance_btn = Button.new()
	_alliance_btn.text = "⚔️ Военный Союз (Помощь в осадах)"
	_alliance_btn.custom_minimum_size = Vector2(245, 36)
	UIHelpersScript.style_button(_alliance_btn)
	_alliance_btn.pressed.connect(func(): _on_treaty_btn_pressed("alliance"))
	actions_grid.add_child(_alliance_btn)

	_gift_btn = Button.new()
	_gift_btn.text = "🎁 Отправить Дары (60 з., +20 отн.)"
	_gift_btn.custom_minimum_size = Vector2(245, 36)
	UIHelpersScript.style_button(_gift_btn)
	_gift_btn.pressed.connect(_on_gift_btn_pressed)
	actions_grid.add_child(_gift_btn)

func open(p: CharacterData, regional_map: RefCounted, diplomacy_sys: RefCounted) -> void:
	_player_ref = p
	_regional_map_ref = regional_map
	_diplomacy_sys_ref = diplomacy_sys
	_is_open = true
	_panel.visible = true
	_refresh_list()
	if _city_list.get_item_count() > 0:
		_city_list.select(0)
		_on_city_selected(0)

func close() -> void:
	_is_open = false
	_panel.visible = false

func is_open() -> bool:
	return _is_open

func _refresh_list() -> void:
	_city_list.clear()
	for c_id in CITIES_KEYS:
		if _regional_map_ref and _regional_map_ref.has_method("get_city"):
			var c = _regional_map_ref.get_city(c_id)
			var rel = c.get("relation", 0)
			_city_list.add_item("%s %s (%d)" % [c.get("icon", "🏰"), c.get("name", c_id), rel])

func _on_city_selected(idx: int) -> void:
	if idx < 0 or idx >= CITIES_KEYS.size(): return
	_selected_city_id = CITIES_KEYS[idx]
	_refresh_details()

func _refresh_details() -> void:
	if not _regional_map_ref or not _regional_map_ref.has_method("get_city"): return
	var c = _regional_map_ref.get_city(_selected_city_id)
	if c.is_empty(): return

	var rel = c.get("relation", 0)
	var rel_status = "Союзник (+%d)" % rel if rel >= 50 else ("Дружба (+%d)" % rel if rel >= 20 else ("Нейтралитет (%d)" % rel if rel >= -15 else "Вражда (%d)" % rel))
	var rel_color = "lightgreen" if rel >= 20 else ("salmon" if rel < 0 else "gold")

	var is_olderia = (_selected_city_id == "olderia")
	var has_trade = false
	var has_nap = false
	var has_alliance = false
	if _diplomacy_sys_ref:
		has_trade = _diplomacy_sys_ref.active_treaties.get(_selected_city_id + "_trade", false)
		has_nap = _diplomacy_sys_ref.active_treaties.get(_selected_city_id + "_nap", false)
		has_alliance = _diplomacy_sys_ref.active_treaties.get(_selected_city_id + "_alliance", false)

	var treaties_str = ""
	if has_trade: treaties_str += "📜 [color=lightgreen]Торговый Пакт Активен[/color]  "
	if has_nap: treaties_str += "🤝 [color=cyan]Пакт о Ненападении Скреплен[/color]  "
	if has_alliance: treaties_str += "⚔️ [color=gold]Военный Союз Заключен[/color]  "
	if treaties_str == "": treaties_str = "[color=gray]Нет действующих договоров[/color]"

	_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Правитель:[/b] %s
[b]Военная мощь:[/b] ⚔️ %d полков
[b]Дипломатический статус:[/b] [color=%s]%s[/color]

[b]Действующие трактаты:[/b] %s

[b]📦 Экспортные товары:[/b] %s
[b]📥 Спрос и закупки:[/b] [color=yellow]%s[/color]

[color=lightgray]Поддержание добрых отношений открывает доступ к льготным торговым пошлинам и взаимной военной выручке при осадах.[/color]""" % [
		c.get("icon", "🏰"), c.get("name", ""),
		c.get("ruler", "Наместник"),
		c.get("military_strength", 50),
		rel_color, rel_status,
		treaties_str,
		c.get("export_item", "Разное"),
		c.get("import_item", "Провизия")
	]

	# Активность кнопок
	if is_olderia:
		_trade_btn.disabled = true
		_nap_btn.disabled = true
		_alliance_btn.disabled = true
		_gift_btn.disabled = true
	else:
		_trade_btn.disabled = has_trade or (rel < 15)
		_nap_btn.disabled = has_nap or (rel < 30)
		_alliance_btn.disabled = has_alliance or (rel < 50)
		_gift_btn.disabled = (_player_ref != null and _player_ref.gold < 60)

func _on_treaty_btn_pressed(treaty_type: String) -> void:
	if _on_sign_treaty.is_valid():
		_on_sign_treaty.call(_selected_city_id, treaty_type)
	_refresh_list()
	_refresh_details()

func _on_gift_btn_pressed() -> void:
	if _on_send_gift.is_valid():
		_on_send_gift.call(_selected_city_id)
	_refresh_list()
	_refresh_details()

func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
