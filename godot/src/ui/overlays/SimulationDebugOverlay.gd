class_name SimulationDebugOverlay
extends PanelContainer

const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")

## SimulationDebugOverlay: Панель мониторинга симуляции королевства (F3 Debug Overlay)
## Визуализирует демографию, запасы складов, темпы производства и активность AI

var _time_lbl: RichTextLabel
var _pop_lbl: RichTextLabel
var _stock_lbl: RichTextLabel
var _events_lbl: RichTextLabel

var is_visible_debug: bool = false

func _init() -> void:
	custom_minimum_size = Vector2(360, 480)
	position = Vector2(16, 60)
	add_theme_stylebox_override("panel", UIHelpersScript.panel_style(Color(0.05, 0.06, 0.08, 0.92), Color(0.3, 0.6, 0.9), 1, 6))
	visible = false

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	add_child(vbox)

	var title = Label.new()
	title.text = "📊 SIMULATION MONITOR (F3)"
	title.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	title.add_theme_font_size_override("font_size", 14)
	vbox.add_child(title)

	_time_lbl = RichTextLabel.new()
	_time_lbl.bbcode_enabled = true
	_time_lbl.fit_content = true
	vbox.add_child(_time_lbl)

	_pop_lbl = RichTextLabel.new()
	_pop_lbl.bbcode_enabled = true
	_pop_lbl.fit_content = true
	vbox.add_child(_pop_lbl)

	_stock_lbl = RichTextLabel.new()
	_stock_lbl.bbcode_enabled = true
	_stock_lbl.fit_content = true
	vbox.add_child(_stock_lbl)

	_events_lbl = RichTextLabel.new()
	_events_lbl.bbcode_enabled = true
	_events_lbl.fit_content = true
	vbox.add_child(_events_lbl)

func toggle() -> void:
	is_visible_debug = not is_visible_debug
	visible = is_visible_debug

func update_metrics(
	day: int, hour: int, minute: int, season: String,
	citizens_count: int, alive_count: int, dead_count: int,
	prof_counts: Dictionary,
	stockpiles: Dictionary,
	contentment: int,
	revolt_active: bool,
	active_raids: int = 0
) -> void:
	if not visible:
		return

	# Time
	_time_lbl.text = "[color=gold]⏳ День %d • %02d:%02d • Сезон: %s[/color]" % [day, hour, minute, season.capitalize()]

	# Demographics
	var pop_text = "[b]👥 Население: %d[/b] (Живы: [color=lightgreen]%d[/color], Погибли: [color=salmon]%d[/color])\n" % [citizens_count, alive_count, dead_count]
	for p in prof_counts.keys():
		pop_text += "  • %s: %d\n" % [p, prof_counts[p]]
	_pop_lbl.text = pop_text

	# Stockpile
	var stock_text = "[b]📦 Запасы поселения:[/b]\n"
	stock_text += "  • Зерно: %d  • Мука: %d  • Хлеб: [color=%s]%d[/color]\n" % [
		stockpiles.get("grain", 0),
		stockpiles.get("flour", 0),
		"salmon" if stockpiles.get("bread", 0) < 10 else "lightgreen",
		stockpiles.get("bread", 0)
	]
	stock_text += "  • Дерево: %d  • Доски: %d\n" % [stockpiles.get("wood", 0), stockpiles.get("plank", 0)]
	stock_text += "  • Железная руда: %d  • Слитки: %d" % [stockpiles.get("iron_ore", 0), stockpiles.get("iron_ingots", 0)]
	_stock_lbl.text = stock_text

	# Unrest / Events
	var status_text = "[b]⚖️ Состояние Королевства:[/b]\n"
	status_text += "  • Довольство жителей: %d%%\n" % contentment
	if revolt_active:
		status_text += "  • [color=red]🔥 АКТИВЕН КРЕСТЬЯНСКИЙ БУНТ![/color]\n"
	if active_raids > 0:
		status_text += "  • [color=salmon]⚔️ Нападение разбойников (волн: %d)![/color]\n" % active_raids
	_events_lbl.text = status_text
