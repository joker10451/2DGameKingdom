extends Node

## UIHelpers: чистые статические хелперы оформления (вынесены из GameWorld2D.gd).
## Подключён как autoload в project.godot (UIHelpers="*res://src/ui/UIHelpers.gd").
## ВНИМАНИЕ: class_name НЕ задаём — иначе конфликт с autoload-синглтоном того же имени.
## Не хранит состояния — только строит StyleBoxFlat и стилизует кнопки.

static func panel_style(bg_color: Color = Color(0.10, 0.11, 0.14, 0.94), border_color: Color = Color(0.78, 0.62, 0.28, 1.0), border_w: int = 2, radius: int = 6) -> StyleBoxFlat:
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
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 4
	return sb

static func style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
	var normal = panel_style(Color(0.14, 0.15, 0.20, 0.92), Color(0.65, 0.52, 0.22), 1, 4)
	normal.content_margin_left = 7
	normal.content_margin_right = 7
	normal.content_margin_top = 4
	normal.content_margin_bottom = 4
	var hover = panel_style(Color(0.22, 0.24, 0.32, 0.96), Color(0.95, 0.82, 0.35), 2, 4)
	hover.content_margin_left = 7
	hover.content_margin_right = 7
	hover.content_margin_top = 4
	hover.content_margin_bottom = 4
	var pressed = panel_style(Color(0.08, 0.09, 0.12, 0.96), Color(0.5, 0.4, 0.15), 2, 4)
	pressed.content_margin_left = 7
	pressed.content_margin_right = 7
	pressed.content_margin_top = 4
	pressed.content_margin_bottom = 4
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_color_override("font_color", icon_color)
	btn.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
	btn.add_theme_font_size_override("font_size", 12)
