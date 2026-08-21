extends Node

## UIHelpers: Высококачественное средневековое визуальное оформление (Fantasy Pixel RPG UI)
## Стили: 9-patch свитки (Parchment), кованый камень (Dark Stone), резное дерево (Wood) и золото (Gold)
## Шрифты: Kurale.ttf, Philosopher-Bold.ttf, KellySlab.ttf

static var _tex_cache: Dictionary = {}
static var _font_cache: Dictionary = {}

static func _get_texture(path: String) -> Texture2D:
	if _tex_cache.has(path):
		return _tex_cache[path]
	var abs_p = ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(abs_p):
		var img = Image.load_from_file(abs_p)
		if img and not img.is_empty():
			var itex = ImageTexture.create_from_image(img)
			_tex_cache[path] = itex
			return itex
	if ResourceLoader.exists(path):
		var res = load(path) as Texture2D
		if res:
			_tex_cache[path] = res
			return res
	return null

static func get_font(is_bold: bool = false) -> Font:
	var key = "bold" if is_bold else "regular"
	if _font_cache.has(key):
		return _font_cache[key]
	var p = "res://assets/fonts/Philosopher-Bold.ttf" if is_bold else "res://assets/fonts/Kurale.ttf"
	var abs_p = ProjectSettings.globalize_path(p)
	if FileAccess.file_exists(abs_p):
		var f = FontFile.new()
		f.load_dynamic_font(abs_p)
		_font_cache[key] = f
		return f
	return null

# 1. СТИЛИ ПАНЕЛЕЙ И МОДАЛЬНЫХ ОКОН

static func parchment_panel_style(margin: int = 12) -> StyleBox:
	var tex = _get_texture("res://assets/ui/panel_parchment.png")
	if tex:
		var sb = StyleBoxTexture.new()
		sb.texture = tex
		sb.texture_margin_left = 14
		sb.texture_margin_right = 14
		sb.texture_margin_top = 14
		sb.texture_margin_bottom = 14
		sb.content_margin_left = margin
		sb.content_margin_right = margin
		sb.content_margin_top = margin
		sb.content_margin_bottom = margin
		return sb
	return flat_panel_style(Color(0.85, 0.78, 0.65, 0.96), Color(0.45, 0.30, 0.15), 2, 4)

static func dark_panel_style(margin: int = 10) -> StyleBox:
	var tex = _get_texture("res://assets/ui/panel_dark_stone.png")
	if tex:
		var sb = StyleBoxTexture.new()
		sb.texture = tex
		sb.texture_margin_left = 12
		sb.texture_margin_right = 12
		sb.texture_margin_top = 12
		sb.texture_margin_bottom = 12
		sb.content_margin_left = margin
		sb.content_margin_right = margin
		sb.content_margin_top = margin
		sb.content_margin_bottom = margin
		return sb
	return flat_panel_style(Color(0.10, 0.11, 0.14, 0.94), Color(0.78, 0.62, 0.28), 2, 6)

static func gold_panel_style(margin: int = 10) -> StyleBox:
	var tex = _get_texture("res://assets/ui/panel_gold_frame.png")
	if tex:
		var sb = StyleBoxTexture.new()
		sb.texture = tex
		sb.texture_margin_left = 12
		sb.texture_margin_right = 12
		sb.texture_margin_top = 12
		sb.texture_margin_bottom = 12
		sb.content_margin_left = margin
		sb.content_margin_right = margin
		sb.content_margin_top = margin
		sb.content_margin_bottom = margin
		return sb
	return flat_panel_style(Color(0.18, 0.14, 0.12, 0.96), Color(0.95, 0.82, 0.35), 2, 6)

static func slot_style(selected: bool = false, margin: int = 4) -> StyleBox:
	var p = "res://assets/ui/slot_frame_selected.png" if selected else "res://assets/ui/slot_frame.png"
	var tex = _get_texture(p)
	if tex:
		var sb = StyleBoxTexture.new()
		sb.texture = tex
		sb.texture_margin_left = 6
		sb.texture_margin_right = 6
		sb.texture_margin_top = 6
		sb.texture_margin_bottom = 6
		sb.content_margin_left = margin
		sb.content_margin_right = margin
		sb.content_margin_top = margin
		sb.content_margin_bottom = margin
		return sb
	return flat_panel_style(Color(0.08, 0.07, 0.09, 0.9), Color(0.85, 0.70, 0.25) if selected else Color(0.4, 0.35, 0.3), 1, 3)

static func panel_style(bg_color: Color = Color(0.10, 0.11, 0.14, 0.94), border_color: Color = Color(0.78, 0.62, 0.28, 1.0), border_w: int = 2, radius: int = 6) -> StyleBox:
	if border_w >= 2:
		return dark_panel_style(12)
	elif border_w == 1:
		return gold_panel_style(8)
	return dark_panel_style(8)

static func flat_panel_style(bg_color: Color = Color(0.10, 0.11, 0.14, 0.94), border_color: Color = Color(0.78, 0.62, 0.28, 1.0), border_w: int = 2, radius: int = 6) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = bg_color
	sb.border_color = border_color
	sb.border_width_bottom = border_w
	sb.border_width_top = border_w
	sb.border_width_left = border_w
	sb.border_width_right = border_w
	sb.corner_radius_top_left = radius
	sb.corner_radius_top_right = radius
	sb.corner_radius_bottom_left = radius
	sb.corner_radius_bottom_right = radius
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 3
	return sb

# 2. СТИЛИЗАЦИЯ КНОПОК

static func button_texture_style(state: String = "normal") -> StyleBox:
	var p = "res://assets/ui/btn_wood_%s.png" % state
	var tex = _get_texture(p)
	if tex:
		var sb = StyleBoxTexture.new()
		sb.texture = tex
		sb.texture_margin_left = 8
		sb.texture_margin_right = 8
		sb.texture_margin_top = 6
		sb.texture_margin_bottom = 6
		sb.content_margin_left = 10
		sb.content_margin_right = 10
		sb.content_margin_top = 4
		sb.content_margin_bottom = 4
		return sb
	return flat_panel_style(Color(0.2, 0.15, 0.1), Color(0.8, 0.6, 0.2), 1, 4)

static func style_button(btn: Button, icon_color: Color = Color(0.96, 0.90, 0.72)) -> void:
	btn.add_theme_stylebox_override("normal", button_texture_style("normal"))
	btn.add_theme_stylebox_override("hover", button_texture_style("hover"))
	btn.add_theme_stylebox_override("pressed", button_texture_style("pressed"))
	btn.add_theme_stylebox_override("disabled", button_texture_style("disabled"))
	btn.add_theme_color_override("font_color", icon_color)
	btn.add_theme_color_override("font_hover_color", Color(1.0, 0.98, 0.85))
	btn.add_theme_color_override("font_pressed_color", Color(1.0, 0.85, 0.45))
	btn.add_theme_color_override("font_shadow_color", Color(0.08, 0.05, 0.02, 0.95))
	btn.add_theme_constant_override("shadow_offset_x", 1)
	btn.add_theme_constant_override("shadow_offset_y", 1)
	
	var f = get_font(true)
	if f:
		btn.add_theme_font_override("font", f)
		btn.add_theme_font_size_override("font_size", 13)

static func style_sleek_bar(bar: ProgressBar, fill_type: String = "hp") -> void:
	var f_tex = _get_texture("res://assets/ui/hud_bar_%s_frame.png" % fill_type)
	var fill_tex = _get_texture("res://assets/ui/hud_bar_%s_fill.png" % fill_type)
	
	if f_tex and fill_tex:
		var bg_sb = StyleBoxTexture.new()
		bg_sb.texture = f_tex
		bg_sb.texture_margin_left = 3
		bg_sb.texture_margin_right = 4
		bg_sb.texture_margin_top = 2
		bg_sb.texture_margin_bottom = 2
		bar.add_theme_stylebox_override("background", bg_sb)
		
		var fill_sb = StyleBoxTexture.new()
		fill_sb.texture = fill_tex
		fill_sb.texture_margin_left = 2
		fill_sb.texture_margin_right = 2
		fill_sb.texture_margin_top = 1
		fill_sb.texture_margin_bottom = 1
		fill_sb.content_margin_top = 2
		fill_sb.content_margin_bottom = 2
		fill_sb.content_margin_left = 2
		fill_sb.content_margin_right = 2
		bar.add_theme_stylebox_override("fill", fill_sb)
	else:
		style_progress_bar(bar, fill_type)

static func style_progress_bar(bar: ProgressBar, fill_type: String = "hp") -> void:
	var f_tex = _get_texture("res://assets/ui/bar_frame.png")
	var fill_tex = _get_texture("res://assets/ui/bar_%s_fill.png" % fill_type)
	
	if f_tex and fill_tex:
		var bg_sb = StyleBoxTexture.new()
		bg_sb.texture = f_tex
		bg_sb.texture_margin_left = 6
		bg_sb.texture_margin_right = 6
		bg_sb.texture_margin_top = 4
		bg_sb.texture_margin_bottom = 4
		bar.add_theme_stylebox_override("background", bg_sb)
		
		var fill_sb = StyleBoxTexture.new()
		fill_sb.texture = fill_tex
		fill_sb.texture_margin_left = 4
		fill_sb.texture_margin_right = 4
		fill_sb.texture_margin_top = 2
		fill_sb.texture_margin_bottom = 2
		fill_sb.content_margin_top = 3
		fill_sb.content_margin_bottom = 3
		fill_sb.content_margin_left = 4
		fill_sb.content_margin_right = 4
		bar.add_theme_stylebox_override("fill", fill_sb)
	else:
		var col_map = {
			"hp": [Color(0.85, 0.16, 0.16), Color(0.95, 0.35, 0.35)],
			"stamina": [Color(0.18, 0.72, 0.35), Color(0.35, 0.88, 0.50)],
			"hunger": [Color(0.85, 0.58, 0.18), Color(0.95, 0.72, 0.30)]
		}
		var cols = col_map.get(fill_type, col_map["hp"])
		bar.add_theme_stylebox_override("background", flat_panel_style(Color(0.15, 0.12, 0.10, 0.9), Color(0.3, 0.25, 0.2), 1, 3))
		bar.add_theme_stylebox_override("fill", flat_panel_style(cols[0], cols[1], 1, 3))
