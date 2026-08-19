class_name ContractsModal
extends RefCounted

## ContractsModal: фасад окна "Феодальные контракты" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (построение, табы, списки, рендер деталей) и состояние
## выбора (contracts_tab_idx / selected_contract_id). Действия (взять/сдать/отказаться)
## делегируются в монолит через колбэки on_action / on_abandon — там вся мутация
## состояния (ContractManager), единственный источник правды (GAME.md §8).

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

var _panel: PanelContainer
var _list: ItemList
var _detail_label: RichTextLabel
var _action_btn: Button
var _abandon_btn: Button
var _tab_idx: int = 0
var _selected_id: String = ""
var _get_manager: Callable
var _on_log: Callable
var _on_floating_text: Callable   # (pos, text, color, size)
var _on_spark: Callable          # (pos, color)
var _on_action: Callable         # () -> void  (accept or claim reward)
var _on_abandon: Callable        # () -> void


func build(canvas: CanvasLayer, get_manager: Callable, on_log: Callable,
		on_floating_text: Callable, on_spark: Callable,
		on_action: Callable, on_abandon: Callable, on_close: Callable) -> void:
	_get_manager = get_manager
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_on_action = on_action
	_on_abandon = on_abandon
	_on_close = on_close

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
	title.text = "📜 ФЕОДАЛЬНЫЕ КОНТРАКТЫ И ДОСКА ОБЪЯВЛЕНИЙ ОЛДЕРИИ"
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

	var tab_avail_btn = Button.new()
	tab_avail_btn.text = "📜 Доступные заказы Доски"
	UIHelpersScript.style_button(tab_avail_btn)
	tab_avail_btn.pressed.connect(_on_tab_avail)
	tab_bar.add_child(tab_avail_btn)

	var tab_active_btn = Button.new()
	tab_active_btn.text = "⭐ Мои активные задания"
	UIHelpersScript.style_button(tab_active_btn)
	tab_active_btn.pressed.connect(_on_tab_active)
	tab_bar.add_child(tab_active_btn)

	var tab_rep_btn = Button.new()
	tab_rep_btn.text = "⚖️ Отношения с Фракциями"
	UIHelpersScript.style_button(tab_rep_btn)
	tab_rep_btn.pressed.connect(_on_tab_rep)
	tab_bar.add_child(tab_rep_btn)

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 410)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(320, 390)
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

	_detail_label = RichTextLabel.new()
	_detail_label.bbcode_enabled = true
	_detail_label.custom_minimum_size = Vector2(560, 330)
	right_p.add_child(_detail_label)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)

	_action_btn = Button.new()
	_action_btn.text = "Взять контракт"
	_action_btn.custom_minimum_size = Vector2(220, 38)
	UIHelpersScript.style_button(_action_btn)
	_action_btn.pressed.connect(_on_action_pressed)
	act_h.add_child(_action_btn)

	_abandon_btn = Button.new()
	_abandon_btn.text = "Отказаться"
	_abandon_btn.custom_minimum_size = Vector2(140, 38)
	UIHelpersScript.style_button(_abandon_btn)
	_abandon_btn.pressed.connect(_on_abandon_pressed)
	act_h.add_child(_abandon_btn)


func open() -> void:
	_panel.visible = true
	_tab_idx = 0
	_selected_id = ""
	refresh()


func close() -> void:
	_panel.visible = false


func is_open() -> bool:
	return _panel != null and _panel.visible


func refresh() -> void:
	var p = _get_player()
	if p == null:
		return
	ContractManager.ensure_player_contracts(p)
	ContractManager.sync_supply_contracts(p)
	_list.clear()

	if _tab_idx == 0:
		var av = ContractManager.get_available_contracts(p)
		for c in av:
			_list.add_item("%s" % c.get("title", "Контракт"))
			_list.set_item_metadata(_list.get_item_count() - 1, c.get("id", ""))
		_action_btn.visible = true
		_action_btn.text = "📜 Взять контракт"
		_abandon_btn.visible = false
		if av.size() > 0:
			if _selected_id == "" or not ContractDatabase.contracts.has(_selected_id):
				_selected_id = av[0].get("id", "")
			_render_contract_details(ContractDatabase.get_contract(_selected_id), false)
		else:
			_detail_label.text = "[center][color=gray]\n\nНа Доске Объявлений сейчас нет новых заказов.\nЗагляните позже или проверьте активные задания![/color][/center]"
			_action_btn.visible = false

	elif _tab_idx == 1:
		for c in p.active_contracts:
			var is_ready = c.get("current_count", 0) >= c.get("required_count", 1)
			var status_icon = "✅" if is_ready else "⏳"
			_list.add_item("%s %s" % [status_icon, c.get("title", "Задание")])
			_list.set_item_metadata(_list.get_item_count() - 1, c.get("id", ""))
		if p.active_contracts.size() > 0:
			if _selected_id == "":
				_selected_id = p.active_contracts[0].get("id", "")
			var cur_c: Dictionary = {}
			for c in p.active_contracts:
				if c.get("id") == _selected_id:
					cur_c = c
					break
			if cur_c.is_empty():
				cur_c = p.active_contracts[0]
			_render_contract_details(cur_c, true)
		else:
			_detail_label.text = "[center][color=gray]\n\nУ вас нет активных контрактов.\nВозьмите поручение на Доске Заказов [Вкладка 1]![/color][/center]"
			_action_btn.visible = false
			_abandon_btn.visible = false

	elif _tab_idx == 2:
		_action_btn.visible = false
		_abandon_btn.visible = false
		var f_data = [
			{"id": "crown", "name": "👑 Дворянский Дом Нортвуд", "desc": "Феодальная знать, контролирующая замки, правопорядок и сбор налогов."},
			{"id": "merchants", "name": "⚖️ Лига Купцов Золотой Монеты", "desc": "Гильдия торговцев и караванщиков. Высокая репутация дает скидки на рынке."},
			{"id": "peasants", "name": "🌾 Община Вольных Крестьян", "desc": "Деревенские жители, фермеры, пекари и плотники Олдерии."},
			{"id": "outlaws", "name": "🦹‍♂️ Лесное Братство (Разбойники)", "desc": "Шайки лесных бродяг и бандитов, промышляющие грабежом на трактах."}
		]
		for f in f_data:
			var rep = p.faction_reputation.get(f["id"], 0)
			_list.add_item("%s (%+d)" % [f["name"], rep])
			_list.set_item_metadata(_list.get_item_count() - 1, f["id"])
		_render_faction_details(p)


func _render_contract_details(c: Dictionary, is_active: bool) -> void:
	if c.is_empty():
		return
	var f_name = ContractDatabase.get_faction_name(c.get("faction", ""))
	var cur = c.get("current_count", 0)
	var req = c.get("required_count", 1)
	var is_done = cur >= req
	var r = c.get("rewards", {})
	var g_rew = r.get("gold", 0)
	var ren_rew = r.get("renown", 0)
	var rep_rew: Dictionary = r.get("reputation", {})
	var rep_str = ""
	for f_id in rep_rew.keys():
		rep_str += " %+d %s," % [rep_rew[f_id], ContractDatabase.get_faction_name(f_id)]
	if rep_str.ends_with(","):
		rep_str = rep_str.left(-1)
	var target_label = ""
	match c.get("category", ""):
		"hunting": target_label = "Уничтожить цель: %s" % c.get("target_type", "")
		"supply": target_label = "Доставить предмет: %s" % ItemDatabase.get_item(c.get("target_type", "")).get("name", "")
		"delivery": target_label = "Добраться до локации на Карте Мира [ M ]"
		_: target_label = "Выполнить цель"
	var status_text = ""
	if is_active:
		status_text = "[color=green]✅ ГОТОВО К СДАЧЕ![/color]" if is_done else "[color=yellow]⏳ В ПРОЦЕССЕ ВЫПОЛНЕНИЯ[/color]"
	else:
		status_text = "[color=cyan]📜 ДОСТУПЕН ДЛЯ ВЗЯТИЯ[/color]"
	_detail_label.text = """[b][font_size=18]%s[/font_size][/b]

[color=gold]Заказчик:[/color] %s | [color=yellow]Фракция:[/color] %s

[color=lightgray]%s[/color]



---------------------------------------------------------

[b]🎯 Цель задания:[/b] %s

[b]📊 Прогресс:[/b] [color=%s]%d / %d[/color] | %s



[b]💰 Награда за выполнение:[/b]

 • Золото: [color=gold]%d монет[/color]

 • Слава: [color=cyan]+%d славы[/color]

 • Репутация:%s

""" % [
		c.get("title", ""),
		c.get("issuer", "Совет Олдерии"),
		f_name,
		c.get("desc", ""),
		target_label,
		"green" if is_done else "orange",
		cur, req,
		status_text,
		g_rew, ren_rew, rep_str
	]
	if is_active:
		_action_btn.visible = true
		_action_btn.text = "💰 Сдать и получить награду" if is_done else "⏳ Задание не завершено"
		_action_btn.disabled = not is_done
		_abandon_btn.visible = true
	else:
		_action_btn.visible = true
		_action_btn.text = "📜 Взять контракт"
		_action_btn.disabled = false
		_abandon_btn.visible = false


func _render_faction_details(p: CharacterData) -> void:
	var rep_dict = p.faction_reputation
	var crown_rep = rep_dict.get("crown", 0)
	var merch_rep = rep_dict.get("merchants", 0)
	var peas_rep = rep_dict.get("peasants", 0)
	var out_rep = rep_dict.get("outlaws", 0)
	_detail_label.text = """[b][font_size=18]⚖️ ДИНАМИЧЕСКИЕ ОТНОШЕНИЯ С ФРАКЦИЯМИ[/font_size][/b]

[color=lightgray]Ваши поступки, выполненные контракты и торговые сделки напрямую влияют на отношение ключевых сил региона.[/color]



---------------------------------------------------------

👑 [b]Дворянский Дом Нортвуд:[/b] [color=%s]%+d[/color] (%s)

  • Владеет замком Нортвуд, сторожевыми башнями и гарнизоном стражи.



⚖️ [b]Лига Купцов Золотой Монеты:[/b] [color=%s]%+d[/color] (%s)

  • Торговая гильдия караванщиков. Высокая репутация дает скидку на рынках.



🌾 [b]Община Вольных Крестьян:[/b] [color=%s]%+d[/color] (%s)

  • Жители деревни, ремесленники, фермеры и кузнецы Олдерии.



🦹‍♂️ [b]Лесное Братство (Разбойники):[/b] [color=%s]%+d[/color] (%s)

  • Лесные бандиты. При высокой репутации не нападают в глухих чащах.

""" % [
		"green" if crown_rep >= 0 else "red", crown_rep, _get_rep_tier_name(crown_rep),
		"green" if merch_rep >= 0 else "red", merch_rep, _get_rep_tier_name(merch_rep),
		"green" if peas_rep >= 0 else "red", peas_rep, _get_rep_tier_name(peas_rep),
		"green" if out_rep >= 0 else "red", out_rep, _get_rep_tier_name(out_rep)
	]


func _get_rep_tier_name(val: int) -> String:
	if val >= 60:
		return "Почетный союзник ⭐"
	elif val >= 20:
		return "Уважение и доверие 👍"
	elif val >= -10:
		return "Нейтралитет ⚖️"
	elif val >= -50:
		return "Подозрение и враждебность ⚠️"
	else:
		return "Заклятый враг 💀"


# --- сигналы / колбэки ---

func _on_tab_avail() -> void:
	_tab_idx = 0
	_selected_id = ""
	refresh()


func _on_tab_active() -> void:
	_tab_idx = 1
	_selected_id = ""
	refresh()


func _on_tab_rep() -> void:
	_tab_idx = 2
	_selected_id = ""
	refresh()


func _on_list_selected(idx: int) -> void:
	_selected_id = _list.get_item_metadata(idx)
	var p = _get_player()
	if p == null:
		return
	if _tab_idx == 0:
		_render_contract_details(ContractDatabase.get_contract(_selected_id), false)
	elif _tab_idx == 1:
		for c in p.active_contracts:
			if c.get("id") == _selected_id:
				_render_contract_details(c, true)
				break
	elif _tab_idx == 2:
		_render_faction_details(p)


func _on_action_pressed() -> void:
	if _on_action.is_valid():
		_on_action.call()


func _on_abandon_pressed() -> void:
	if _on_abandon.is_valid():
		_on_abandon.call()


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


func get_selected_id() -> String:
	return _selected_id


func get_tab_idx() -> int:
	return _tab_idx


var _on_close: Callable
