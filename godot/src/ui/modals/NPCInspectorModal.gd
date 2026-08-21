class_name NPCInspectorModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## NPCInspectorModal: «Живой Паспорт» жителя Олдерии
## Отображает потребности (Needs), амбиции (Drives), здоровье, черты характера и социальные связи

var _on_close: Callable

var _panel: PanelContainer
var _title_lbl: Label
var _subtitle_lbl: Label
var _needs_vbox: VBoxContainer
var _drives_vbox: VBoxContainer
var _relations_vbox: VBoxContainer
var _traits_lbl: RichTextLabel
var _is_open: bool = false

var _current_target_data: CharacterData = null
var _current_target_node: Node = null

func build(canvas: CanvasLayer, on_close: Callable) -> void:
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(280, 80)
	_panel.custom_minimum_size = Vector2(720, 560)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.09, 0.10, 0.14, 0.98), Color(0.85, 0.70, 0.32), 2, 10))
	_panel.visible = false
	canvas.add_child(_panel)

	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(main_vbox)

	# --- HEADER ---
	var header_h = HBoxContainer.new()
	main_vbox.add_child(header_h)

	var title_col = VBoxContainer.new()
	title_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_h.add_child(title_col)

	_title_lbl = Label.new()
	_title_lbl.add_theme_font_size_override("font_size", 20)
	_title_lbl.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	_title_lbl.text = "👤 Радмир (Мельник)"
	title_col.add_child(_title_lbl)

	_subtitle_lbl = Label.new()
	_subtitle_lbl.add_theme_font_size_override("font_size", 13)
	_subtitle_lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	_subtitle_lbl.text = "Мельник • Вольный житель Олдерии"
	title_col.add_child(_subtitle_lbl)

	var close_btn = Button.new()
	close_btn.text = "✖"
	close_btn.custom_minimum_size = Vector2(36, 36)
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(close)
	header_h.add_child(close_btn)

	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(700, 470)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(scroll)

	var content_vbox = VBoxContainer.new()
	content_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_vbox.add_theme_constant_override("separation", 14)
	scroll.add_child(content_vbox)

	# --- 1. ФИЗИОЛОГИЧЕСКОЕ СОСТОЯНИЕ (NEEDS & HEALTH) ---
	var needs_panel = PanelContainer.new()
	needs_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.06, 0.07, 0.10, 0.9), Color(0.5, 0.45, 0.25), 1, 6))
	content_vbox.add_child(needs_panel)

	_needs_vbox = VBoxContainer.new()
	_needs_vbox.add_theme_constant_override("separation", 6)
	needs_panel.add_child(_needs_vbox)

	# --- 2. ХАРАКТЕР И АМБИЦИИ (DRIVES & TRAITS) ---
	var drives_panel = PanelContainer.new()
	drives_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.06, 0.07, 0.10, 0.9), Color(0.3, 0.5, 0.6), 1, 6))
	content_vbox.add_child(drives_panel)

	_drives_vbox = VBoxContainer.new()
	_drives_vbox.add_theme_constant_override("separation", 6)
	drives_panel.add_child(_drives_vbox)

	_traits_lbl = RichTextLabel.new()
	_traits_lbl.bbcode_enabled = true
	_traits_lbl.fit_content = true
	_drives_vbox.add_child(_traits_lbl)

	# --- 3. СОЦИАЛЬНАЯ ПАМЯТЬ И ОТНОШЕНИЯ (RELATIONSHIPS) ---
	var rel_panel = PanelContainer.new()
	rel_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.06, 0.07, 0.10, 0.9), Color(0.6, 0.3, 0.3), 1, 6))
	content_vbox.add_child(rel_panel)

	_relations_vbox = VBoxContainer.new()
	_relations_vbox.add_theme_constant_override("separation", 6)
	rel_panel.add_child(_relations_vbox)

func open(target_data: CharacterData, target_node: Node = null) -> void:
	if not _panel or not target_data:
		return
	_current_target_data = target_data
	_current_target_node = target_node
	_refresh_display()
	_panel.visible = true
	_is_open = true

func close() -> void:
	if not _panel:
		return
	_panel.visible = false
	_is_open = false
	if _on_close.is_valid():
		_on_close.call()

func is_open() -> bool:
	return _is_open

func _refresh_display() -> void:
	if not _current_target_data:
		return

	# Header
	var d = _current_target_data
	var title_str = "%s %s" % [d.title_prefix, d.name] if d.title_prefix != "" else d.name
	if d.is_dead:
		title_str += " ☠️ (Погиб)"
	_title_lbl.text = "👤 " + title_str
	_subtitle_lbl.text = "%s • %s • Возраст: %d • Золото: %d 🪙" % [d.current_role, d.faction_id, d.age, d.gold]

	# 1. Needs
	for c in _needs_vbox.get_children():
		c.queue_free()

	var needs_title = Label.new()
	needs_title.text = "🫀 ФИЗИОЛОГИЧЕСКОЕ СОСТОЯНИЕ"
	needs_title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	_needs_vbox.add_child(needs_title)

	var needs_comp: NeedsComponent = _current_target_node.get_node_or_null("NeedsComponent") if _current_target_node else null
	var h_val = needs_comp.hunger if needs_comp else 20.0
	var f_val = needs_comp.fatigue if needs_comp else 15.0
	var s_val = needs_comp.social_need if needs_comp else 30.0
	var safe_val = needs_comp.safety_fear if needs_comp else 0.0
	var hp_val = d.health

	_add_stat_bar(_needs_vbox, "🍞 Голод", h_val, 100.0, Color(0.9, 0.4, 0.3) if h_val > 70 else Color(0.4, 0.8, 0.4))
	_add_stat_bar(_needs_vbox, "😴 Усталость", f_val, 100.0, Color(0.9, 0.6, 0.2) if f_val > 70 else Color(0.4, 0.7, 0.9))
	_add_stat_bar(_needs_vbox, "💬 Общение", s_val, 100.0, Color(0.8, 0.4, 0.8) if s_val > 70 else Color(0.5, 0.8, 0.5))
	_add_stat_bar(_needs_vbox, "🛡️ Страх / Угроза", safe_val, 100.0, Color(0.9, 0.2, 0.2) if safe_val > 50 else Color(0.3, 0.7, 0.4))
	_add_stat_bar(_needs_vbox, "❤️ Здоровье", hp_val, d.max_health, Color(0.2, 0.9, 0.3) if hp_val > 30 else Color(0.9, 0.2, 0.2))

	# 2. Drives & Traits
	for c in _drives_vbox.get_children():
		c.queue_free()

	var drives_title = Label.new()
	drives_title.text = "👑 ХАРАКТЕР И АМБИЦИИ"
	drives_title.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
	_drives_vbox.add_child(drives_title)

	var w_desire = needs_comp.wealth_desire if needs_comp else 50.0
	var a_drive = needs_comp.ambition_drive if needs_comp else 40.0
	_add_stat_bar(_drives_vbox, "💰 Стремление к Богатству", w_desire, 100.0, Color(1.0, 0.8, 0.2))
	_add_stat_bar(_drives_vbox, "👑 Амбиции и Власть", a_drive, 100.0, Color(0.8, 0.4, 1.0))
	_add_stat_bar(_drives_vbox, "⚔️ Воинская Честь", float(d.honor + 100), 200.0, Color(0.4, 0.8, 0.9))

	var traits_str = "[b]Черты характера:[/b] "
	if d.traits.is_empty():
		traits_str += "[color=gray]Обычный характер[/color]"
	else:
		for t in d.traits:
			traits_str += "[color=gold][%s][/color] " % t
	_traits_lbl = RichTextLabel.new()
	_traits_lbl.bbcode_enabled = true
	_traits_lbl.text = traits_str
	_traits_lbl.fit_content = true
	_drives_vbox.add_child(_traits_lbl)

	# 3. Relationships & Memory
	for c in _relations_vbox.get_children():
		c.queue_free()

	var rel_title = Label.new()
	rel_title.text = "🧠 СОЦИАЛЬНАЯ ПАМЯТЬ И ОТНОШЕНИЯ"
	rel_title.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5))
	_relations_vbox.add_child(rel_title)

	var mem_comp: MemoryComponent = _current_target_node.get_node_or_null("MemoryComponent") if _current_target_node else null
	if mem_comp and not mem_comp.opinions.is_empty():
		for char_id in mem_comp.opinions.keys():
			var op = mem_comp.opinions[char_id]
			var icon = "❤️" if op >= 30.0 else ("🙂" if op >= 0 else ("😠" if op >= -40.0 else "💢 ВРАГ"))
			var op_lbl = Label.new()
			op_lbl.text = " • %s: %s (Отношение: %+.0f)" % [char_id, icon, op]
			op_lbl.add_theme_color_override("font_color", Color.LIGHT_GREEN if op >= 0 else Color.SALMON)
			_relations_vbox.add_child(op_lbl)
	else:
		var empty_lbl = Label.new()
		empty_lbl.text = " • Отношения нейтральны, обид нет."
		empty_lbl.add_theme_color_override("font_color", Color.GRAY)
		_relations_vbox.add_child(empty_lbl)

func _add_stat_bar(parent: Control, stat_name: String, current: float, max_val: float, bar_color: Color) -> void:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	parent.add_child(row)

	var lbl = Label.new()
	lbl.text = "%s:" % stat_name
	lbl.custom_minimum_size = Vector2(210, 0)
	lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
	row.add_child(lbl)

	var bar = ProgressBar.new()
	bar.max_value = max_val
	bar.value = current
	bar.custom_minimum_size = Vector2(300, 18)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.show_percentage = false

	var fill_sb = StyleBoxFlat.new()
	fill_sb.bg_color = bar_color
	fill_sb.corner_radius_top_left = 3
	fill_sb.corner_radius_top_right = 3
	fill_sb.corner_radius_bottom_left = 3
	fill_sb.corner_radius_bottom_right = 3
	bar.add_theme_stylebox_override("fill", fill_sb)

	var bg_sb = StyleBoxFlat.new()
	bg_sb.bg_color = Color(0.12, 0.13, 0.18, 0.8)
	bg_sb.corner_radius_top_left = 3
	bg_sb.corner_radius_top_right = 3
	bg_sb.corner_radius_bottom_left = 3
	bg_sb.corner_radius_bottom_right = 3
	bar.add_theme_stylebox_override("background", bg_sb)

	row.add_child(bar)

	var val_lbl = Label.new()
	val_lbl.text = "%.0f / %.0f" % [current, max_val]
	val_lbl.custom_minimum_size = Vector2(80, 0)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(val_lbl)
