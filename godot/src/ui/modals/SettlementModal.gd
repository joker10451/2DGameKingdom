class_name SettlementModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## SettlementModal: Фасад ратуши и управления поселением
## Управляет казной, налогами, распределением профессий, проектами и гарнизоном

var _on_action: Callable
var _on_close: Callable

var _panel: PanelContainer
var _tab_idx: int = 0
var _list: ItemList
var _info_label: RichTextLabel
var _withdraw_btn: Button
var _deposit_btn: Button
var _action_btn: Button
var _is_open: bool = false

var _player_ref: CharacterData
var _settlement_ref: Dictionary = {}
var _stockpile_ref: RefCounted
var _unrest_ref: RefCounted
var _council_ref: RefCounted
var _selected_item_idx: int = 0
var _selected_project_id: String = "house_peasant"

const TABS := [
	"📊 Обзор и Казна",
	"👨‍🌾 Граждане и Труд",
	"📜 Налоги и Законы",
	"🔨 Городские Проекты",
	"🛡️ Гарнизон и Стража"
]

func build(canvas: CanvasLayer, on_action: Callable, on_close: Callable) -> void:
	_on_action = on_action
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(160, 50)
	_panel.custom_minimum_size = Vector2(960, 560)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	# Шапка
	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)

	var title = Label.new()
	title.text = "🏛️ РАТУША И УПРАВЛЕНИЕ ПОСЕЛЕНИЕМ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_h.add_child(title)

	var close_btn = Button.new()
	close_btn.text = "✖ Закрыть [ ESC ]"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	top_h.add_child(close_btn)

	# Вкладки
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 8)
	vbox.add_child(tab_bar)

	for i in range(TABS.size()):
		var t_btn = Button.new()
		t_btn.text = TABS[i]
		UIHelpersScript.style_button(t_btn)
		var t_idx = i
		t_btn.pressed.connect(func():
			_tab_idx = t_idx
			_refresh()
		)
		tab_bar.add_child(t_btn)

	# Тело
	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(360, 410)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(340, 390)
	_list.item_selected.connect(_on_item_selected)
	left_p.add_child(_list)

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
	_info_label.custom_minimum_size = Vector2(530, 330)
	right_p.add_child(_info_label)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)

	_withdraw_btn = Button.new()
	_withdraw_btn.text = "💰 Забрать 25 з."
	UIHelpersScript.style_button(_withdraw_btn)
	_withdraw_btn.pressed.connect(func(): _trigger_action("withdraw_treasury", 25))
	act_h.add_child(_withdraw_btn)

	_deposit_btn = Button.new()
	_deposit_btn.text = "🪙 Пополнить казну (25 з.)"
	UIHelpersScript.style_button(_deposit_btn)
	_deposit_btn.pressed.connect(func(): _trigger_action("deposit_treasury", 25))
	act_h.add_child(_deposit_btn)

	_action_btn = Button.new()
	_action_btn.text = "⚡ Выполнить действие"
	UIHelpersScript.style_button(_action_btn)
	_action_btn.pressed.connect(_on_main_action_pressed)
	act_h.add_child(_action_btn)

func open(p: CharacterData, stockpile_sys: RefCounted, unrest_sys: RefCounted, council_sys: RefCounted) -> void:
	_player_ref = p
	_stockpile_ref = stockpile_sys
	_unrest_ref = unrest_sys
	_council_ref = council_sys
	_is_open = true
	_panel.visible = true
	_refresh()

func close() -> void:
	_is_open = false
	_panel.visible = false

func is_open() -> bool:
	return _is_open

func _refresh() -> void:
	_list.clear()
	var s_data = _player_ref.settlement if _player_ref else {}
	var town_name = s_data.get("town_name", "Олдерия")
	var treasury = s_data.get("treasury", 50)
	var citizens = s_data.get("citizens", [])
	var contentment = _unrest_ref.contentment if _unrest_ref else 75
	var sp_text = _stockpile_ref.get_stockpile_text() if _stockpile_ref else ""

	match _tab_idx:
		0: # Обзор и Казна
			_withdraw_btn.visible = true
			_deposit_btn.visible = true
			_action_btn.visible = false
			_list.add_item("🏛️ Ратуша Олдерии")
			_list.add_item("🌾 Запасы Провизии")
			_list.add_item("🪙 Городская Казна")
			_list.add_item("🛡️ Довольство Народа")

			_info_label.text = """[b][font_size=18]Поселение: %s[/font_size][/b]
[b]Ранг вотчины:[/b] Деревня Олдерия
[b]Казна поселения:[/b] [color=gold]%d золотых[/color]
[b]Численность жителей:[/b] 👨‍🌾 %d человек
[b]Уровень довольства:[/b] [color=lightgreen]%d%%[/color]

[b]📦 Амбары и склады:[/b]
%s

[color=cyan]Каждое утро в 08:00 жители платят налоги в городскую казну.[/color]""" % [
				town_name, treasury, citizens.size(), contentment, sp_text
			]

		1: # Граждане и Труд
			_withdraw_btn.visible = false
			_deposit_btn.visible = false
			_action_btn.visible = true
			_action_btn.text = "💰 Выдать премию (10 з., +15 настр.)"
			for c in citizens:
				_list.add_item("%s (%s)" % [c.get("name", "Житель"), c.get("role", "Фермер")])

			if citizens.is_empty():
				_info_label.text = "[color=gray]В городе пока нет свободных жителей. Стройте дома и кровати для привлечения мигрантов![/color]"
			else:
				var c = citizens[clamp(_selected_item_idx, 0, citizens.size() - 1)]
				_info_label.text = """[b][font_size=18]Житель: %s[/font_size][/b]
[b]Профессия:[/b] %s
[b]Настроение:[/b] [color=lightgreen]%s (%d%%)[/color]
[b]Личные сбережения:[/b] [color=gold]%d золотых[/color]

[color=lightgray]Житель ежедневно трудится на закрепленном рабочем месте и продает товары в своей лавке.[/color]""" % [
					c.get("name", "Житель"), c.get("role", "Фермер"),
					c.get("mood_status", "Доволен"), c.get("mood", 80),
					c.get("gold", 10)
				]

		2: # Налоги и Законы
			_withdraw_btn.visible = false
			_deposit_btn.visible = false
			_action_btn.visible = true
			_action_btn.text = "⚖️ Изменить ставку налога"
			_list.add_item("🪙 Ставка Подати: 10% (Умеренная)")
			_list.add_item("🍞 Зерновое Обеспечение: Включено")
			_list.add_item("🛡️ Стражная Повинность: Активна")

			var tax_rate = int(s_data.get("tax_rate", 0.10) * 100)
			_info_label.text = """[b][font_size=18]Законы и Налогообложение[/font_size][/b]
[b]Текущая ставка податей:[/b] [color=gold]%d%%[/color]
[b]Ожидаемый сбор налогов в 08:00:[/b] +%d золотых

[color=lightgray]Высокие налоги (>20%) обогащают казну, но вызывают ропот и риск бунта. Низкие налоги привлекают новых поселенцев.[/color]""" % [
				tax_rate, int(citizens.size() * 3.5 * (tax_rate / 10.0))
			]

		3: # Городские Проекты
			_withdraw_btn.visible = false
			_deposit_btn.visible = false
			_action_btn.visible = true
			_action_btn.text = "🏗️ Заказать постройку проекта"
			_list.add_item("🏡 Бревенчатая изба (+2 кровати, 40 бруса, 50з)")
			_list.add_item("🌾 Зерновой амбар (+100 вместимость, 50 бруса, 60з)")
			_list.add_item("⚒️ Кузнечный горн (+ковка доспехов, 40 камня, 80з)")
			_list.add_item("🍺 Деревенская таверна (+вечерние посиделки, 60 бруса, 90з)")
			_list.add_item("🛡️ Сторожевая вышка (+обзор и лучники, 35 бруса, 45з)")

			_info_label.text = """[b][font_size=18]Городское Строительство[/font_size][/b]
Выберите строительный проект слева и нажмите «Заказать постройку».
Жители и плотники автоматически приступят к возведению выбранного здания."""

		4: # Гарнизон и Стража
			_withdraw_btn.visible = false
			_deposit_btn.visible = false
			_action_btn.visible = true
			_action_btn.text = "🛡️ Нанять городского стражника (50 з.)"
			_list.add_item("🛡️ Городской дозор ворот")
			_list.add_item("🔔 Тревожный колокол обороны")
			_list.add_item("🏹 Стрелковые вышки частокола")

			_info_label.text = """[b][font_size=18]Оборона и Городской Гарнизон[/font_size][/b]
[b]Статус гарнизона:[/b] 🛡️ Стража на посту
[b]Защищенность поселения:[/b] [color=lightgreen]Высокая (Частокол и ворота)[/color]

[color=lightgray]Стражники автоматически атакуют подступающих разбойников и защищают крестьян.[/color]"""

func _on_item_selected(idx: int) -> void:
	_selected_item_idx = idx

func _on_main_action_pressed() -> void:
	match _tab_idx:
		1: # Премия
			_trigger_action("give_bonus", _selected_item_idx)
		2: # Налоги
			_trigger_action("toggle_tax", 0)
		3: # Стройка
			var proj_ids = ["house_peasant", "granary", "blacksmith", "tavern", "watchtower"]
			var p_id = proj_ids[clamp(_selected_item_idx, 0, proj_ids.size() - 1)]
			_trigger_action("build_project", p_id)
		4: # Гарнизон
			_trigger_action("hire_guard", 0)
	_refresh()

func _trigger_action(action_name: String, param: Variant) -> void:
	if _on_action.is_valid():
		_on_action.call(action_name, param)
	_refresh()

func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
