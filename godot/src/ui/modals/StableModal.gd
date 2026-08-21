class_name StableModal
extends RefCounted

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## StableModal: фасад "Конюшня и разведение скакунов" (вынесен из GameWorld2D.gd).
## Содержит ТОЛЬКО UI (список пород, карточка, кнопки Купить/Оседлать) + состояние выбора.
## Мутации (покупка через MountSystem, переключение is_mounted) идут через колбэки:
##   on_log(text), on_floating_text(pos, text, color, size), on_spark(pos, color),
##   get_manager() -> GameManager, get_player_pos() -> Vector2,
##   get_is_mounted() -> bool, set_is_mounted(bool),
##   on_buy(breed_id), on_toggle_mount(breed_id).

var _on_log: Callable
var _on_floating_text: Callable
var _on_spark: Callable
var _get_manager: Callable
var _get_player_pos: Callable
var _get_is_mounted: Callable
var _set_is_mounted: Callable
var _on_buy: Callable
var _on_toggle_mount: Callable
var _on_close: Callable

var _selected_breed: String = "horse_bay"
var _panel: PanelContainer
var _list: ItemList
var _info: RichTextLabel
var _is_open := false


func build(canvas: CanvasLayer,
		on_log: Callable, on_floating_text: Callable, on_spark: Callable,
		get_manager: Callable, get_player_pos: Callable,
		get_is_mounted: Callable, set_is_mounted: Callable,
		on_buy: Callable, on_toggle_mount: Callable, on_close: Callable) -> void:
	_on_log = on_log
	_on_floating_text = on_floating_text
	_on_spark = on_spark
	_get_manager = get_manager
	_get_player_pos = get_player_pos
	_get_is_mounted = get_is_mounted
	_set_is_mounted = set_is_mounted
	_on_buy = on_buy
	_on_toggle_mount = on_toggle_mount
	_on_close = on_close
	_build_panel(canvas)


func _build_panel(canvas: CanvasLayer) -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(250, 75)
	_panel.custom_minimum_size = Vector2(780, 500)
	_panel.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
	_panel.visible = false
	canvas.add_child(_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)

	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)

	var title = Label.new()
	title.text = "🐎 КОНЮШНЯ И РАЗВЕДЕНИЕ СКАКУНОВ"
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

	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)

	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 380)
	left_p.add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)

	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(320, 360)
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

	_info = RichTextLabel.new()
	_info.bbcode_enabled = true
	_info.custom_minimum_size = Vector2(380, 300)
	right_p.add_child(_info)

	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)

	var buy_btn = Button.new()
	buy_btn.text = "🪙 Купить Скакуна"
	UIHelpersScript.style_button(buy_btn)
	buy_btn.pressed.connect(_on_buy_pressed)
	act_h.add_child(buy_btn)

	var mount_btn = Button.new()
	mount_btn.text = "🏇 Сесть в седло [ R ]"
	UIHelpersScript.style_button(mount_btn)
	mount_btn.pressed.connect(_on_mount_pressed)
	act_h.add_child(mount_btn)


func open() -> void:
	_is_open = true
	_panel.visible = true
	_selected_breed = "horse_bay"
	refresh()


func close() -> void:
	_is_open = false
	_panel.visible = false


func is_open() -> bool:
	return _is_open


func get_selected_breed() -> String:
	return _selected_breed


func refresh() -> void:
	_list.clear()
	for b_id in MountSystem.HORSE_BREEDS.keys():
		var b = MountSystem.HORSE_BREEDS[b_id]
		_list.add_item("%s %s — %d з." % [b.get("icon", "🐎"), b.get("name", ""), b.get("cost", 40)])
		_list.set_item_metadata(_list.get_item_count() - 1, b_id)

	var gm = _get_manager.call() if _get_manager.is_valid() else null
	var p = gm.player_data if (gm != null) else null
	MountSystem.ensure_mount_data(p)

	var b = MountSystem.HORSE_BREEDS.get(_selected_breed, MountSystem.HORSE_BREEDS["horse_bay"])
	var active_b = p.settlement.get("active_horse", "") if (p != null) else ""
	var has_horse = (active_b != "")

	var mounted = _get_is_mounted.call() if _get_is_mounted.is_valid() else false
	_info.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Стоимость покупки:[/b] [color=gold]%d золотых[/color]
[b]Бонус к скорости:[/b] [color=green]+%d%%[/color]
[b]Здоровье скакуна:[/b] %.0f HP
[b]Таранный урон:[/b] %d урона

[color=lightgray]%s[/color]

---------------------------------------------------------
[b]Текущий статус верховой езды:[/b] %s
[b]Активный конь в стойле:[/b] %s
[color=gold]Нажмите [ R ] во время странствий, чтобы оседлать или спешиться![/color]
""" % [
		b.get("icon", "🐎"), b.get("name", ""),
		b.get("cost", 40),
		int((b.get("speed_mult", 1.70) - 1.0) * 100),
		b.get("max_hp", 120.0),
		b.get("ram_dmg", 12),
		b.get("desc", ""),
		("[color=green]В СЕДЛЕ 🏇[/color]" if mounted else "[color=orange]ПЕШКОМ 🚶[/color]"),
		(active_b if has_horse else "Нет скакуна")
	]


func _on_list_selected(idx: int) -> void:
	var b_id = _list.get_item_metadata(idx)
	if b_id:
		_selected_breed = b_id
		refresh()


func _on_buy_pressed() -> void:
	if _on_buy.is_valid():
		_on_buy.call(_selected_breed)


func _on_mount_pressed() -> void:
	if _on_toggle_mount.is_valid():
		_on_toggle_mount.call(_selected_breed)
	if _is_open:
		refresh()


func _on_close_pressed() -> void:
	if _on_close.is_valid():
		_on_close.call()
