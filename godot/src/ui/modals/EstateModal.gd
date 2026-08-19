class_name EstateModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## EstateModal: фасад окна "Феодальное поместье" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (построение, вкладки, списки, рендер) и состояние выбора
## (_selected_id, _tab_idx). Действия (покупка грамоты, отдых, наём рабочего,
## постройка, забор со склада) вызывают колбэки on_action(action) / on_take_all,
## которые реализует GameWorld2D (мутация p.* через EstateManager + HUD-спрайты).

var _get_manager: Callable
var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _on_action: Callable
var _on_take_all: Callable
var _on_close: Callable

var _tab_idx := 0                      # 0: Обзор/Склад, 1: Батраки, 2: Постройки
var _selected_id: String = ""
var _panel: PanelContainer
var _list: ItemList
var _info_label: RichTextLabel
var _action_btn: Button
var _take_all_btn: Button
var _is_open := false


func build(canvas: CanvasLayer, get_manager: Callable, on_log: Callable,
		on_floating_text: Callable, on_spark: Callable,
		on_action: Callable, on_take_all: Callable, on_close: Callable) -> void:
	_get_manager = get_manager
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_on_action = on_action
	_on_take_all = on_take_all
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

	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)

	var title = Label.new()
	title.text = "🏰 ФЕОДАЛЬНОЕ ПОМЕСТЬЕ И ЗЕМЛЕВЛАДЕНИЕ"
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

	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 10)
	vbox.add_child(tab_bar)

	var tab_main_btn = Button.new()
	tab_main_btn.text = "📊 Обзор и Склад усадьбы"
	UIHelpersScript.style_button(tab_main_btn)
	tab_main_btn.pressed.connect(func():
		_tab_idx = 0
		_selected_id = ""
		refresh())
	tab_bar.add_child(tab_main_btn)

	var tab_workers_btn = Button.new()
	tab_workers_btn.text = "👨‍🌾 Найм батраков"
	UIHelpersScript.style_button(tab_workers_btn)
	tab_workers_btn.pressed.connect(func():
		_tab_idx = 1
		_selected_id = ""
		refresh())
	tab_bar.add_child(tab_workers_btn)

	var tab_upgrades_btn = Button.new()
	tab_upgrades_btn.text = "🏡 Постройки и Улучшения"
	UIHelpersScript.style_button(tab_upgrades_btn)
	tab_upgrades_btn.pressed.connect(func():
		_tab_idx = 2
		_selected_id = ""
		refresh())
	tab_bar.add_child(tab_upgrades_btn)

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(350, 410)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(330, 390)
	_list.item_selected.connect(_on_estate_item_selected)
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
	_info_label.custom_minimum_size = Vector2(550, 330)
	right_p.add_child(_info_label)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)

	_action_btn = Button.new()
	_action_btn.text = "📜 Выкупить Грамоту на Землю (100 з.)"
	_action_btn.custom_minimum_size = Vector2(260, 38)
	UIHelpersScript.style_button(_action_btn)
	_action_btn.pressed.connect(_on_action_pressed)
	act_h.add_child(_action_btn)

	_take_all_btn = Button.new()
	_take_all_btn.text = "📦 Забрать все со склада"
	_take_all_btn.custom_minimum_size = Vector2(200, 38)
	UIHelpersScript.style_button(_take_all_btn)
	_take_all_btn.pressed.connect(_on_take_all_pressed)
	act_h.add_child(_take_all_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	_tab_idx = 0
	refresh()


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_id() -> String:
	return _selected_id


func get_tab_idx() -> int:
	return _tab_idx


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


func refresh() -> void:
	var p: CharacterData = _get_player()
	if p == null:
		return

	EstateManager.ensure_player_estate(p)
	_list.clear()

	if not p.has_estate:
		_list.add_item("📜 Земельный надел Олдерии")
		_action_btn.visible = true
		_action_btn.text = "📜 Выкупить Грамоту на Землю (100 з.)"
		_take_all_btn.visible = false

		_info_label.text = """[b][font_size=18]🏰 Восточные Угодья Олдерии (Земельный надел)[/font_size][/b]

[color=gold]Статус: Свободная феодальная земля[/color]



Живописный холм у восточной реки с плодородной почвой, дубовой рощей и рудной жилой.

Выкупив Грамоту на Землю у Лорда или Старосты, вы сможете:

 • Нанимать крестьян-батраков для автоматизированного сбора дерева, руды, мяса и муки.

 • Возвести Барский Дом для мгновенного отдыха и снятия усталости.

 • Построить Курятник и Хлев для получения ежедневного пассивного дохода золотом.

 • Складывать всю готовую продукцию в Центральный Склад усадьбы.



---------------------------------------------------------

[b]💰 Стоимость покупки: [color=gold]%d золотых[/color][/b] (У вас: %d з.)""" % [EstateDatabase.LAND_DEED_COST, p.gold]
		return

	# Игрок владеет поместьем
	if _tab_idx == 0:
		_take_all_btn.visible = true
		_action_btn.visible = p.estate_upgrades.has("manor_house")
		_action_btn.text = "🛏️ Отдохнуть в Барском Доме"

		var storage_items = p.estate_storage.keys()
		if storage_items.size() > 0:
			for it_id in storage_items:
				var count = p.estate_storage[it_id]
				var it = ItemDatabase.get_item(it_id)
				_list.add_item("%s %s x%d" % [it.get("icon", "📦"), it.get("name", it_id), count])
		else:
			_list.add_item("📦 Склад пуст")

		var upgrades_str = "Нет построек"
		if p.estate_upgrades.size() > 0:
			var u_names: Array = []
			for u_id in p.estate_upgrades:
				var u_def = EstateDatabase.get_upgrade_def(u_id)
				u_names.append("%s %s" % [u_def.get("icon", "🏡"), u_def.get("name", u_id)])
			upgrades_str = ", ".join(u_names)

		var workers_str = "Нет наемных рабочих"
		if p.estate_workers.size() > 0:
			var w_names: Array = []
			for w_type in p.estate_workers:
				var w_def = EstateDatabase.get_worker_def(w_type)
				w_names.append("%s %s" % [w_def.get("icon", "👨‍🌾"), w_def.get("name", w_type)])
			workers_str = "\n • " + "\n • ".join(w_names)

		_info_label.text = """[b][font_size=18]🏰 Ваше Феодальное Поместье (Уровень %d)[/font_size][/b]

[color=green]Статус: Земля в вашей законной собственности[/color]



[b]🏡 Возведенные строения:[/b] %s

[b]👨‍🌾 Нанятые батраки (%d/%d):[/b] %s



---------------------------------------------------------

[b]📦 Склад поместья:[/b]

Каждые 3 игровых часа нанятые рабочие приносят готовую продукцию на склад усадьбы.

Нажмите [b]«Забрать все со склада»[/b], чтобы переместить ресурсы в свой инвентарь.""" % [p.estate_level, upgrades_str, p.estate_workers.size(), EstateManager.MAX_WORKERS, workers_str]

	elif _tab_idx == 1:
		_take_all_btn.visible = false
		_action_btn.visible = true
		_action_btn.text = "👨‍🌾 Нанять рабочего"

		for w_id in EstateDatabase.WORKERS.keys():
			var w = EstateDatabase.WORKERS[w_id]
			_list.add_item("%s %s (%d з.)" % [w.get("icon", "👨‍🌾"), w.get("name", ""), w.get("hire_cost", 25)])
			_list.set_item_metadata(_list.get_item_count() - 1, w_id)

		if _selected_id == "" or not EstateDatabase.WORKERS.has(_selected_id):
			_selected_id = "farmer"
		_render_worker_details(EstateDatabase.get_worker_def(_selected_id))

	elif _tab_idx == 2:
		_take_all_btn.visible = false
		_action_btn.visible = true
		_action_btn.text = "🔨 Возвести постройку"

		for u_id in EstateDatabase.UPGRADES.keys():
			var u = EstateDatabase.UPGRADES[u_id]
			var built = p.estate_upgrades.has(u_id)
			_list.add_item("%s %s %s" % [u.get("icon", "🏡"), u.get("name", ""), "✅" if built else ""])
			_list.set_item_metadata(_list.get_item_count() - 1, u_id)

		if _selected_id == "" or not EstateDatabase.UPGRADES.has(_selected_id):
			_selected_id = "manor_house"
		_render_upgrade_details(EstateDatabase.get_upgrade_def(_selected_id), p.estate_upgrades.has(_selected_id))


func _render_worker_details(w: Dictionary) -> void:
	if w.is_empty():
		return
	var yields_str = ""
	for it_id in w.get("yield", {}).keys():
		var it = ItemDatabase.get_item(it_id)
		yields_str += "%s %s".replace("%s", "%s") % [it.get("icon", "📦"), it.get("name", it_id), " x" + str(w["yield"][it_id]) + "  "]
	_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]

[color=lightgray]%s[/color]



---------------------------------------------------------

[b]📦 Производство каждые 3 игровых часа:[/b]

%s



[b]💰 Финансовые условия:[/b]

 • Стоимость найма: [color=gold]%d золотых[/color]

 • Ежедневное жалование: [color=cyan]%d золотых / день (в 07:00)[/color]""" % [
		w.get("icon", "👨‍🌾"), w.get("name", ""),
		w.get("desc", ""),
		yields_str,
		w.get("hire_cost", 25),
		w.get("daily_wage", 3)
	]


func _render_upgrade_details(u: Dictionary, is_built: bool) -> void:
	if u.is_empty():
		return
	var status = "[color=green]УЖЕ ВОЗВЕДЕНО В УСАДЬБЕ ✅[/color]" if is_built else "[color=yellow]ДОСТУПНО ДЛЯ ПОСТРОЙКИ[/color]"
	var cost = u.get("cost", {})
	_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]

Статус: %s



%s



---------------------------------------------------------

[b]🔨 Требуемые материалы и средства:[/b]

 • Золото: [color=gold]%d з.[/color]

 • Дубовые бревна: %d шт.

 • Обрезные доски: %d шт.""" % [
		u.get("icon", "🏡"), u.get("name", ""),
		status,
		u.get("desc", ""),
		cost.get("gold", 0),
		cost.get("wood", 0),
		cost.get("plank", 0)
	]
	_action_btn.disabled = is_built


func _on_estate_item_selected(idx: int) -> void:
	var id = _list.get_item_metadata(idx)
	if id:
		_selected_id = id
		if _tab_idx == 1:
			_render_worker_details(EstateDatabase.get_worker_def(id))
		elif _tab_idx == 2:
			var p: CharacterData = _get_player()
			var is_built = p.estate_upgrades.has(id) if p else false
			_render_upgrade_details(EstateDatabase.get_upgrade_def(id), is_built)


func _on_action_pressed() -> void:
	# Делегируем действие монолиту: он ветвится по tab_idx/selected_id.
	if _on_action.is_valid():
		_on_action.call()


func _on_take_all_pressed() -> void:
	if _on_take_all.is_valid():
		_on_take_all.call()
