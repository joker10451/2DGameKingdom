class_name DialogueModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## DialogueModal: Фасад окна диалогов с жителями и персонажами мира
## Управляет отображением реплик, портретов/статусов и динамических кнопок выбора

var _on_close: Callable

var _panel: PanelContainer
var _title_lbl: Label
var _text_lbl: RichTextLabel
var _options_container: VBoxContainer
var _is_open: bool = false

func build(canvas: CanvasLayer, on_close: Callable) -> void:
	_on_close = on_close
	_build_panel(canvas)

func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(300, 110)
	_panel.custom_minimum_size = Vector2(680, 420)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.11, 0.12, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	var header_h = HBoxContainer.new()
	vbox.add_child(header_h)

	_title_lbl = Label.new()
	_title_lbl.add_theme_font_size_override("font_size", 18)
	_title_lbl.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_h.add_child(_title_lbl)

	var close_btn = Button.new()
	close_btn.text = "✖"
	UIHelpersScript.style_button(close_btn)
	close_btn.pressed.connect(_on_close_pressed)
	header_h.add_child(close_btn)

	var text_p = PanelContainer.new()
	text_p.custom_minimum_size = Vector2(650, 150)
	text_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	vbox.add_child(text_p)

	_text_lbl = RichTextLabel.new()
	_text_lbl.bbcode_enabled = true
	_text_lbl.custom_minimum_size = Vector2(640, 140)
	_text_lbl.fit_content = true
	text_p.add_child(_text_lbl)

	var opt_lbl = Label.new()
	opt_lbl.text = "⚡ Варианты действий:"
	opt_lbl.add_theme_font_size_override("font_size", 14)
	opt_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(opt_lbl)

	_options_container = VBoxContainer.new()
	_options_container.add_theme_constant_override("separation", 6)
	vbox.add_child(_options_container)

func open() -> void:
	_is_open = true
	_panel.visible = true

func close() -> void:
	_is_open = false
	_panel.visible = false

func is_open() -> bool:
	return _is_open

func set_title(title_text: String) -> void:
	_title_lbl.text = title_text

func set_text(bbcode_text: String) -> void:
	_text_lbl.text = bbcode_text

func clear_options() -> void:
	for c in _options_container.get_children():
		c.queue_free()

func add_option(btn_text: String, callback: Callable) -> void:
	var btn = Button.new()
	btn.text = btn_text
	UIHelpersScript.style_button(btn)
	btn.pressed.connect(callback)
	_options_container.add_child(btn)

func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
