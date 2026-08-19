class_name OriginModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## OriginModal: фасад окна "Выбор пути в Олдерии" (вынесен из GameWorld2D.gd).
## Self-contained: строит список путей из SettlementDatabase.ORIGINS,
## кнопка каждого пути вызывает колбэк on_choose(orig_id).

var _on_choose: Callable
var _on_close: Callable
var _panel: PanelContainer
var _is_open := false


func build(canvas: CanvasLayer, on_choose: Callable, on_close: Callable) -> void:
	_on_choose = on_choose
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(240, 70)
	_panel.custom_minimum_size = Vector2(800, 520)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.15, 0.98), Color(0.88, 0.72, 0.30), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	var title = Label.new()
	title.text = "👑 ВЫБОР ВАШЕГО ПУТИ В ОЛДЕРИИ (KINGDOMS ORIGIN)"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)

	var desc = Label.new()
	desc.text = "Кем вы начнете свое путешествие в средневековом мире? Каждый путь дает уникальный стартовый набор и цели."
	desc.add_theme_font_size_override("font_size", 12)
	desc.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
	vbox.add_child(desc)

	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 380)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	var list_v = VBoxContainer.new()
	list_v.add_theme_constant_override("separation", 8)
	scroll.add_child(list_v)

	for o_id in SettlementDatabase.ORIGINS.keys():
		var o = SettlementDatabase.ORIGINS[o_id]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(740, 68)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.text = "%s %s\n%s" % [o.get("icon", "⚔️"), o.get("name", ""), o.get("desc", "")]
		UIHelpersScript.style_button(btn)
		btn.pressed.connect(func():
			if _on_choose.is_valid():
				_on_choose.call(o_id)
		)
		list_v.add_child(btn)


func open() -> void:
	_is_open = true
	_panel.visible = true


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open
