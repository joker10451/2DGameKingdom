class_name EventModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## EventModal: Фасад случайных и сюжетных событий мира Олдерии
## Отображает атмосферное событие с вариантами выбора и требованиями к предметам

var _on_option_chosen: Callable
var _on_close: Callable

var _panel: PanelContainer
var _title_lbl: Label
var _desc_lbl: RichTextLabel
var _options_vbox: VBoxContainer
var _is_open: bool = false

func build(canvas: CanvasLayer, on_option_chosen: Callable, on_close: Callable) -> void:
	_on_option_chosen = on_option_chosen
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(260, 90)
	_panel.custom_minimum_size = Vector2(760, 480)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	_title_lbl = Label.new()
	_title_lbl.add_theme_font_size_override("font_size", 18)
	_title_lbl.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	_title_lbl.text = "📜 СОБЫТИЕ МИРА ОЛДЕРИИ"
	vbox.add_child(_title_lbl)

	var desc_p = PanelContainer.new()
	desc_p.custom_minimum_size = Vector2(730, 160)
	desc_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	vbox.add_child(desc_p)

	_desc_lbl = RichTextLabel.new()
	_desc_lbl.bbcode_enabled = true
	_desc_lbl.custom_minimum_size = Vector2(710, 140)
	_desc_lbl.fit_content = true
	desc_p.add_child(_desc_lbl)

	var opt_title = Label.new()
	opt_title.text = "⚡ Ваше решение:"
	opt_title.add_theme_font_size_override("font_size", 15)
	opt_title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(opt_title)

	_options_vbox = VBoxContainer.new()
	_options_vbox.add_theme_constant_override("separation", 8)
	vbox.add_child(_options_vbox)

func open(ev: Dictionary, p: CharacterData = null) -> void:
	show_event(ev, p)

func show_event(ev: Dictionary, p: CharacterData = null) -> void:
	_is_open = true
	_panel.visible = true
	_title_lbl.text = "📜 %s: %s" % [ev.get("icon", "📜"), ev.get("title", "Событие")]
	_desc_lbl.text = ev.get("desc", "")

	for c in _options_vbox.get_children():
		c.queue_free()

	for opt in ev.get("options", []):
		var btn = Button.new()
		btn.text = opt.get("text", "Продолжить")
		UIHelpersScript.style_button(btn)
		if opt.has("req_item"):
			var has_cnt = p.get_item_count(opt["req_item"]) if p else 0
			if has_cnt < opt.get("req_amount", 1):
				btn.text += " (Нет нужного предмета!)"
				btn.disabled = true
		btn.pressed.connect(func(): _on_btn_pressed(ev, opt))
		_options_vbox.add_child(btn)

func close() -> void:
	_is_open = false
	_panel.visible = false

func is_open() -> bool:
	return _is_open

func _on_btn_pressed(ev: Dictionary, opt: Dictionary) -> void:
	close()
	if _on_option_chosen.is_valid():
		_on_option_chosen.call(ev, opt)
