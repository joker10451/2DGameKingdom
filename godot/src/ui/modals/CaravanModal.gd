class_name CaravanModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## CaravanModal: Фасад снаряжения торговых караванов
## Позволяет выбрать пункт назначения, груз из амбаров и охрану

var _on_dispatch: Callable
var _on_close: Callable

var _panel: PanelContainer
var _dest_list: ItemList
var _info_label: RichTextLabel
var _goods_opt: OptionButton
var _escort_opt: OptionButton
var _dispatch_btn: Button
var _is_open: bool = false

var _player_ref: CharacterData
var _stockpiles_ref: Dictionary = {}
var _regional_map_ref: RefCounted

const DESTINATIONS := [
	{
		"id": "ironhold",
		"name": "Стальной Предел 🛡️",
		"desc": "Скалистая твердыня Герцога Вальдемара. Острый дефицит провизии!",
		"demands": "Зерно / Хлеб",
		"reward_desc": "+140 золотых, слитки чугуна, доспехи",
		"travel_days": 1,
		"base_profit": 140,
		"recommended_good": "grain"
	},
	{
		"id": "goldvale",
		"name": "Золотая Долина 🌾",
		"desc": "Богатый торговый полис Гильдии Купцов. Требуются стройматериалы и инструмент.",
		"demands": "Дубовый брус / Инструменты",
		"reward_desc": "+120 золотых, пряности, шелк, вино",
		"travel_days": 1,
		"base_profit": 120,
		"recommended_good": "timber"
	},
	{
		"id": "blackwood",
		"name": "Чернолесье 🌲",
		"desc": "Вольный форпост охотников и следопытов. Спрос на добротные клинки.",
		"demands": "Стальные мечи / Оружие",
		"reward_desc": "+110 золотых, пушнина, шкуры",
		"travel_days": 1,
		"base_profit": 110,
		"recommended_good": "swords"
	},
	{
		"id": "highkeep",
		"name": "Вершинный Замок 👑",
		"desc": "Столица Короны и цитадель Верховного Короля Олдерика III.",
		"demands": "Свежий Хлеб / Дары",
		"reward_desc": "+170 золотых, милость Короны, слава",
		"travel_days": 2,
		"base_profit": 170,
		"recommended_good": "bread"
	}
]

func build(canvas: CanvasLayer, on_dispatch: Callable, on_close: Callable) -> void:
	_on_dispatch = on_dispatch
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(200, 70)
	_panel.custom_minimum_size = Vector2(880, 540)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.15, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	# Заголовок
	var title_h = HBoxContainer.new()
	vbox.add_child(title_h)
	var title = Label.new()
	title.text = "🐫 СНАРЯЖЕНИЕ ТОРГОВОГО КАРАВАНА"
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

	# Левая колонка: города назначения
	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 420)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_dest_list = ItemList.new()
	_dest_list.custom_minimum_size = Vector2(320, 400)
	_dest_list.item_selected.connect(_on_dest_selected)
	left_p.add_child(_dest_list)

	# Правая колонка: параметры обоза, груз, эскорт
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
	_info_label.custom_minimum_size = Vector2(480, 240)
	right_p.add_child(_info_label)

	# Настройка груза
	var config_v = VBoxContainer.new()
	config_v.add_theme_constant_override("separation", 8)
	right_v.add_child(config_v)

	var goods_h = HBoxContainer.new()
	var g_lbl = Label.new()
	g_lbl.text = "📦 Выбор груза обоза:"
	g_lbl.custom_minimum_size = Vector2(180, 0)
	goods_h.add_child(g_lbl)

	_goods_opt = OptionButton.new()
	_goods_opt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	goods_h.add_child(_goods_opt)
	config_v.add_child(goods_h)

	# Настройка эскорта
	var escort_h = HBoxContainer.new()
	var e_lbl = Label.new()
	e_lbl.text = "🛡️ Охрана каравана:"
	e_lbl.custom_minimum_size = Vector2(180, 0)
	escort_h.add_child(e_lbl)

	_escort_opt = OptionButton.new()
	_escort_opt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_escort_opt.add_item("🚶 Без охраны (Бесплатно, Риск засады 40%)", 0)
	_escort_opt.add_item("🛡️ 2 Ополченца с копьями (25 з., Риск 15%)", 1)
	_escort_opt.add_item("⚔️ 4 Рыцаря-ветерана (60 з., Риск 0%)", 2)
	escort_h.add_child(_escort_opt)
	config_v.add_child(escort_h)

	_dispatch_btn = Button.new()
	_dispatch_btn.text = "🐫 Отправить караван в путь!"
	UIHelpersScript.style_button(_dispatch_btn)
	_dispatch_btn.pressed.connect(_on_dispatch_pressed)
	right_v.add_child(_dispatch_btn)

func open(p: CharacterData, regional_map: RefCounted, stockpiles: Dictionary) -> void:
	_player_ref = p
	_regional_map_ref = regional_map
	_stockpiles_ref = stockpiles
	_is_open = true
	_panel.visible = true
	_refresh_destinations()
	_refresh_goods()
	if _dest_list.get_item_count() > 0:
		_dest_list.select(0)
		_on_dest_selected(0)

func close() -> void:
	_is_open = false
	_panel.visible = false

func is_open() -> bool:
	return _is_open

func _refresh_destinations() -> void:
	_dest_list.clear()
	for d in DESTINATIONS:
		var city_id = d["id"]
		var relation = 0
		if _regional_map_ref and _regional_map_ref.has_method("get_city"):
			var c = _regional_map_ref.get_city(city_id)
			relation = c.get("relation", 0)
		_dest_list.add_item("%s (Отношение: %d)" % [d["name"], relation])

func _refresh_goods() -> void:
	_goods_opt.clear()
	var grain_c = _stockpiles_ref.get("grain", 50)
	var bread_c = _stockpiles_ref.get("bread", 20)
	var timber_c = _stockpiles_ref.get("timber", 40)
	var swords_c = _stockpiles_ref.get("swords", 5)
	var iron_c = _stockpiles_ref.get("iron_ingots", 10)

	_goods_opt.add_item("🌾 Зерно (10 мешков) [В амбаре: %d]" % grain_c, 0)
	_goods_opt.set_item_metadata(0, {"id": "grain", "amount": 10, "avail": grain_c})
	
	_goods_opt.add_item("🍞 Свежий Хлеб (10 буханок) [В амбаре: %d]" % bread_c, 1)
	_goods_opt.set_item_metadata(1, {"id": "bread", "amount": 10, "avail": bread_c})

	_goods_opt.add_item("🪵 Дубовый Брус (10 шт.) [В амбаре: %d]" % timber_c, 2)
	_goods_opt.set_item_metadata(2, {"id": "timber", "amount": 10, "avail": timber_c})

	_goods_opt.add_item("⚔️ Стальные Мечи (3 шт.) [В арсенале: %d]" % swords_c, 3)
	_goods_opt.set_item_metadata(3, {"id": "swords", "amount": 3, "avail": swords_c})

	_goods_opt.add_item("🧱 Синий Чугун (5 слитков) [На складе: %d]" % iron_c, 4)
	_goods_opt.set_item_metadata(4, {"id": "iron_ingots", "amount": 5, "avail": iron_c})

func _on_dest_selected(idx: int) -> void:
	if idx < 0 or idx >= DESTINATIONS.size(): return
	var d = DESTINATIONS[idx]
	var city_id = d["id"]
	var c_data = {}
	if _regional_map_ref and _regional_map_ref.has_method("get_city"):
		c_data = _regional_map_ref.get_city(city_id)

	var rel = c_data.get("relation", 0)
	var ruler = c_data.get("ruler", "Наместник")
	var rel_str = "Союз (+%d)" % rel if rel >= 50 else ("Дружба (+%d)" % rel if rel >= 20 else ("Нейтралитет (%d)" % rel if rel >= -15 else "Вражда (%d)" % rel))

	_info_label.text = """[b][font_size=18]%s[/font_size][/b]
[b]Правитель:[/b] %s
[b]Дипломатический статус:[/b] [color=gold]%s[/color]

[color=lightgray]%s[/color]

[b]📦 Спрос и дефицит:[/b] [color=yellow]%s[/color]
[b]💰 Ожидаемая выгода:[/b] [color=lightgreen]%s[/color]
[b]⏳ Время пути:[/b] %d дн.

[color=cyan]Караван принесет золото в городскую казну, повысит славу и укрепит связи с соседним полисом![/color]""" % [
		d["name"], ruler, rel_str, d["desc"], d["demands"], d["reward_desc"], d["travel_days"]
	]

func _on_dispatch_pressed() -> void:
	var sel_dest_idx = _dest_list.get_selected_items()
	if sel_dest_idx.is_empty(): return
	var d = DESTINATIONS[sel_dest_idx[0]]
	
	var sel_g_idx = _goods_opt.selected
	var g_meta = _goods_opt.get_item_metadata(sel_g_idx)
	if not g_meta: return
	
	var escort_idx = _escort_opt.selected
	var escort_cost = 0
	var escort_risk = 0.40
	var escort_name = "Без охраны"
	match escort_idx:
		1:
			escort_cost = 25
			escort_risk = 0.15
			escort_name = "2 Ополченца"
		2:
			escort_cost = 60
			escort_risk = 0.0
			escort_name = "4 Рыцаря"

	if _player_ref and _player_ref.gold < escort_cost:
		return

	if _on_dispatch.is_valid():
		_on_dispatch.call(d["id"], g_meta["id"], g_meta["amount"], escort_cost, escort_risk, escort_name)

func _on_close_pressed() -> void:
	close()
	if _on_close.is_valid():
		_on_close.call()

