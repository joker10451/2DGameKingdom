class_name PartyModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## PartyModal: фасад окна "Управление дружиной и наемники" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (построение, табы, списки, рендер карточки) и состояние
## выбора (_selected_id, _tab_idx). Действия найма/роспуска вызывают колбэки
## on_action / on_dismiss, которые реализует GameWorld2D (мутация p.party_members
## через PartyManager + обновление HUD-спрайтов). Единый источник правды — монолит.

var _get_manager: Callable
var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _on_action: Callable
var _on_dismiss: Callable
var _on_close: Callable

var _tab_idx := 0                      # 0: Моя дружина, 1: Наемники таверны
var _selected_id: String = ""
var _panel: PanelContainer
var _list: ItemList
var _detail_label: RichTextLabel
var _action_btn: Button
var _dismiss_btn: Button
var _is_open := false


func build(canvas: CanvasLayer, get_manager: Callable, on_log: Callable,
		on_floating_text: Callable, on_spark: Callable,
		on_action: Callable, on_dismiss: Callable, on_close: Callable) -> void:
	_get_manager = get_manager
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_on_action = on_action
	_on_dismiss = on_dismiss
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
	title.text = "👥 УПРАВЛЕНИЕ ДРУЖИНОЙ И НАЕМНИКИ ТАВЕРНЫ"
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

	var tab_my_btn = Button.new()
	tab_my_btn.text = "👥 Моя дружина"
	UIHelpersScript.style_button(tab_my_btn)
	tab_my_btn.pressed.connect(func():
		_tab_idx = 0
		_selected_id = ""
		refresh())
	tab_bar.add_child(tab_my_btn)

	var tab_hire_btn = Button.new()
	tab_hire_btn.text = "🍻 Наемники в таверне «Пьяный Вепрь»"
	UIHelpersScript.style_button(tab_hire_btn)
	tab_hire_btn.pressed.connect(func():
		_tab_idx = 1
		_selected_id = ""
		refresh())
	tab_bar.add_child(tab_hire_btn)

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
	_list.item_selected.connect(_on_party_selected)
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
	_action_btn.text = "💰 Нанять в отряд"
	_action_btn.custom_minimum_size = Vector2(220, 38)
	UIHelpersScript.style_button(_action_btn)
	_action_btn.pressed.connect(_on_action_pressed)
	act_h.add_child(_action_btn)

	_dismiss_btn = Button.new()
	_dismiss_btn.text = "Распустить бойца"
	_dismiss_btn.custom_minimum_size = Vector2(160, 38)
	UIHelpersScript.style_button(_dismiss_btn)
	_dismiss_btn.pressed.connect(_on_dismiss_pressed)
	act_h.add_child(_dismiss_btn)


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

	PartyManager.ensure_player_party(p)
	_list.clear()

	if _tab_idx == 0:
		for m in p.party_members:
			_list.add_item("%s %s" % [m.get("icon", "⚔️"), m.get("name", "Спутник")])
			_list.set_item_metadata(_list.get_item_count() - 1, m.get("id", ""))

		_action_btn.visible = false
		_dismiss_btn.visible = true

		if p.party_members.size() > 0:
			if _selected_id == "":
				_selected_id = p.party_members[0].get("id", "")
			var cur_m: Dictionary = {}
			for m in p.party_members:
				if m.get("id") == _selected_id:
					cur_m = m
					break
			if cur_m.is_empty():
				cur_m = p.party_members[0]
			_render_party_member_details(cur_m, true)
		else:
			_detail_label.text = "[center][color=gray]\n\nВ вашей дружине пока нет наемников.\nЗагляните в таверну «Пьяный Вепрь» [Вкладка 2]![/color][/center]"
			_dismiss_btn.visible = false

	elif _tab_idx == 1:
		var av = PartyManager.get_available_mercenaries(p)
		for m in av:
			_list.add_item("%s %s (%d з.)" % [m.get("icon", "⚔️"), m.get("name", "Наемник"), m.get("hire_cost", 30)])
			_list.set_item_metadata(_list.get_item_count() - 1, m.get("id", ""))

		_action_btn.visible = true
		_action_btn.text = "💰 Нанять в отряд"
		_dismiss_btn.visible = false

		if av.size() > 0:
			if _selected_id == "" or not PartyDatabase.MERCENARIES.has(_selected_id):
				_selected_id = av[0].get("id", "")
			_render_party_member_details(PartyDatabase.get_mercenary(_selected_id), false)
		else:
			_detail_label.text = "[center][color=gold]\n\nВсе доступные наемники уже приняты в вашу дружину!\nУправляйте ими во [Вкладка 1].[/color][/center]"
			_action_btn.visible = false


func _render_party_member_details(m: Dictionary, is_hired: bool) -> void:
	if m.is_empty():
		return
	var status = "[color=green]В ОТРЯДЕ[/color]" if is_hired else "[color=yellow]ДОСТУПЕН ДЛЯ НАЙМА[/color]"

	_detail_label.text = """[b][font_size=18]%s %s[/font_size][/b]

[color=gold]%s[/color] | Статус: %s

[color=lightgray]%s[/color]



---------------------------------------------------------

[b]📊 Боевые показатели:[/b]

 • Здоровье: [color=red]%.0f / %.0f HP[/color]

 • Урон в бою: [color=gold]%.0f ед.[/color] | Броня: [color=lightblue]%.0f DEF[/color]

 • Оружие: %s | Щит/Снаряжение: %s



[b]✨ Особый навык: [color=yellow]%s[/color][/b]
%s



---------------------------------------------------------

[b]💰 Финансовые условия:[/b]

 • Стоимость найма: [color=gold]%d золотых[/color]

 • Ежедневное жалование: [color=cyan]%d золотых / день (в 07:00)[/color]

""" % [
		m.get("icon", "⚔️"), m.get("name", ""),
		m.get("title", ""), status,
		m.get("desc", ""),
		m.get("hp", 80.0), m.get("max_hp", 80.0),
		m.get("dmg", 20.0), m.get("def", 10.0),
		m.get("weapon", "Меч"), m.get("shield", "Щит"),
		m.get("perk_name", "Боевое мастерство"), m.get("perk_desc", ""),
		m.get("hire_cost", 30), m.get("daily_wage", 5)
	]


func _on_party_selected(idx: int) -> void:
	var id = _list.get_item_metadata(idx)
	_selected_id = id
	var p: CharacterData = _get_player()
	if p == null:
		return

	if _tab_idx == 0:
		for m in p.party_members:
			if m.get("id") == id:
				_render_party_member_details(m, true)
				break
	elif _tab_idx == 1:
		_render_party_member_details(PartyDatabase.get_mercenary(id), false)


func _on_action_pressed() -> void:
	if _on_action.is_valid():
		_on_action.call()


func _on_dismiss_pressed() -> void:
	if _on_dismiss.is_valid():
		_on_dismiss.call()
