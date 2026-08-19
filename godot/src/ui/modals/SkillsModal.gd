class_name SkillsModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## SkillsModal: фасад окна "Книга навыков" (вынесен из GameWorld2D.gd).
## Чистый read-only UI: строит профиль героя + список навыков с опытом.
## Не мутирует состояние — только читает player_data и SkillSystem.
##
## Использование из GameWorld2D:
##   skills_modal = SkillsModalScript.new()
##   skills_modal.build(canvas, player_data, SkillSystem, _close_all_modals)

var _panel: PanelContainer
var _char_profile: RichTextLabel
var _skills_vbox: VBoxContainer
var _player = null
var _skill_sys = null
var _on_close: Callable


func build(canvas: CanvasLayer, player_data, skill_sys, on_close: Callable) -> void:
	_player = player_data
	_skill_sys = skill_sys
	_on_close = on_close

	_panel = PanelContainer.new()
	_panel.position = Vector2(180, 55)
	_panel.custom_minimum_size = Vector2(920, 550)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "📜 КНИГА НАВЫКОВ И МАСТЕРСТВА (SOULASH 2 STYLE)"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 16)
	vbox.add_child(hbox)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(300, 430)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	hbox.add_child(left_p)

	_char_profile = RichTextLabel.new()
	_char_profile.bbcode_enabled = true
	_char_profile.custom_minimum_size = Vector2(280, 410)
	left_p.add_child(_char_profile)

	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(right_vbox)

	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(580, 430)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_child(scroll)

	_skills_vbox = VBoxContainer.new()
	_skills_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_skills_vbox.add_theme_constant_override("separation", 8)
	scroll.add_child(_skills_vbox)

	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc] / [K]"
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
	if _player == null:
		return
	_player.ensure_skills()

	# Профиль слева
	_char_profile.text = """[b][color=gold]%s[/color][/b]

[color=gray]Роль:[/color] %s

[color=gray]Фракция:[/color] Вольный народ


[b]⚜️ Характеристики:[/b]

• [color=lightcoral]💪 Сила:[/color] %d (Урон, рубка)

• [color=lightgreen]🦶 Ловкость:[/color] %d (Крит, бег)

• [color=lightblue]🧠 Интеллект:[/color] %d (Кузница, ремесло)

• [color=orange]🗣️ Харизма:[/color] %d (Торговля)


[b]🏆 Репутация и статус:[/b]

• 💰 Золото: [color=gold]%d[/color]

• ⭐ Слава: %d

• ⚜️ Честь: %d


[color=yellow]💡 Навыки растут от реальных действий в мире![/color]""" % [
		_player.character_name,
		_player.current_role,
		_player.strength,
		_player.agility,
		_player.intelligence,
		_player.charisma,
		_player.gold,
		_player.renown,
		_player.honor
	]

	# Список навыков справа
	for c in _skills_vbox.get_children():
		c.queue_free()

	if _skill_sys == null:
		return
	for skill_id in _skill_sys.SKILL_DEFS.keys():
		var def = _skill_sys.SKILL_DEFS[skill_id]
		var s_data = _player.skills.get(skill_id, {})
		var lvl = s_data.get("level", 1)
		var xp = s_data.get("xp", 0.0)
		var req_xp = _skill_sys.get_xp_required(lvl)

		var card = PanelContainer.new()
		card.custom_minimum_size = Vector2(560, 68)
		card.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.12, 0.14, 0.18, 0.9), Color(0.5, 0.42, 0.22), 1, 4))
		_skills_vbox.add_child(card)

		var c_vbox = VBoxContainer.new()
		c_vbox.add_theme_constant_override("separation", 3)
		card.add_child(c_vbox)

		var top_h = HBoxContainer.new()
		c_vbox.add_child(top_h)

		var name_lbl = Label.new()
		name_lbl.text = "%s %s" % [def.get("icon", "⭐"), def.get("name", skill_id)]
		name_lbl.add_theme_font_size_override("font_size", 14)
		name_lbl.add_theme_color_override("font_color", Color(1.0, 0.9, 0.55))
		top_h.add_child(name_lbl)

		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top_h.add_child(spacer)

		var lvl_lbl = Label.new()
		lvl_lbl.text = "Уровень %d" % lvl
		lvl_lbl.add_theme_font_size_override("font_size", 13)
		lvl_lbl.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4))
		top_h.add_child(lvl_lbl)

		var bar = ProgressBar.new()
		bar.custom_minimum_size = Vector2(540, 16)
		bar.value = (xp / req_xp) * 100.0
		bar.show_percentage = false
		var b_bg = UIHelpersScript.panel_style(Color(0.06, 0.07, 0.09, 0.9), Color(0.2, 0.18, 0.12), 1, 2)
		var b_fill = UIHelpersScript.panel_style(Color(0.85, 0.65, 0.18), Color(0.98, 0.82, 0.35), 1, 2)
		bar.add_theme_stylebox_override("background", b_bg)
		bar.add_theme_stylebox_override("fill", b_fill)

		var bar_lbl = Label.new()
		bar_lbl.text = "%.0f / %.0f XP" % [xp, req_xp]
		bar_lbl.position = Vector2(10, -2)
		bar_lbl.add_theme_font_size_override("font_size", 10)
		bar_lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
		bar.add_child(bar_lbl)
		c_vbox.add_child(bar)

		var perk_txt = ""
		for p_item in s_data.get("perks", []):
			if p_item.get("unlocked", false):
				perk_txt += " [color=gold]✨ %s[/color]" % p_item["name"]
			else:
				perk_txt += " [color=gray]🔒 %s (Ур. %d)[/color]" % [p_item["name"], p_item["req_level"]]

		var info_lbl = RichTextLabel.new()
		info_lbl.bbcode_enabled = true
		info_lbl.fit_content = true
		info_lbl.text = "[color=lightgray]%s[/color]%s" % [def.get("desc", ""), perk_txt]
		c_vbox.add_child(info_lbl)


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
