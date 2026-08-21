class_name EconomyFlowOverlay
extends Node2D

## EconomyFlowOverlay: Карта производственных потоков и цепочек поставок (Economy Flow Mode)
## Визуализирует линии движения ресурсов (Ферма -> Мельница -> Пекарня -> Рынок), объемы и узкие места (Bottlenecks)

var is_active: bool = false
var nodes_data: Array[Dictionary] = [] # [{id, name, type, pos, status, item_icon, buffer_count}]
var links_data: Array[Dictionary] = [] # [{from_id, to_id, item_type, color, flow_rate, is_blocked}]

func _ready() -> void:
	z_index = 20
	visible = false

func toggle() -> void:
	is_active = not is_active
	visible = is_active
	queue_redraw()

func set_flow_data(nodes: Array[Dictionary], links: Array[Dictionary]) -> void:
	nodes_data = nodes
	links_data = links
	queue_redraw()

func _draw() -> void:
	if not visible:
		return

	# 1. Отрисовка линий цепочек поставок (Links)
	for link in links_data:
		var from_pos: Vector2 = link.get("from_pos", Vector2.ZERO)
		var to_pos: Vector2 = link.get("to_pos", Vector2.ZERO)
		var col: Color = link.get("color", Color.GOLD)
		var is_blocked: bool = link.get("is_blocked", false)
		var thickness: float = link.get("thickness", 3.0)

		if is_blocked:
			# Пунктирная красная линия при блокировке / нехватке сырья
			_draw_dashed_line(from_pos, to_pos, Color(0.9, 0.2, 0.2, 0.8), thickness)
		else:
			# Светящаяся сплошная линия потока
			draw_line(from_pos, to_pos, Color(col.r, col.g, col.b, 0.3), thickness + 4.0)
			draw_line(from_pos, to_pos, col, thickness)

		# Стрелка направления потока
		var dir = (to_pos - from_pos).normalized()
		var mid = (from_pos + to_pos) * 0.5
		var arrow_p1 = mid - dir * 10 + Vector2(-dir.y, dir.x) * 6
		var arrow_p2 = mid - dir * 10 - Vector2(-dir.y, dir.x) * 6
		draw_colored_polygon([mid, arrow_p1, arrow_p2], col if not is_blocked else Color.RED)

	# 2. Отрисовка узлов производства (Nodes)
	for n in nodes_data:
		var p: Vector2 = n.get("pos", Vector2.ZERO)
		var icon: String = n.get("icon", "⚙️")
		var title: String = n.get("title", "Объект")
		var is_blocked: bool = n.get("is_blocked", false)

		# Фоновый бейдж
		var bg_color = Color(0.1, 0.12, 0.16, 0.9) if not is_blocked else Color(0.4, 0.1, 0.1, 0.9)
		var border_color = Color.GOLD if not is_blocked else Color.SALMON
		draw_circle(p, 18.0, bg_color)
		draw_arc(p, 18.0, 0, TAU, 24, border_color, 2.0)

		# Предупреждение о дефиците
		if is_blocked:
			draw_string(ThemeDB.fallback_font, p + Vector2(-12, -22), "⚠️ НЕТ СЫРЬЯ", HORIZONTAL_ALIGNMENT_CENTER, -1, 11, Color.SALMON)

func _draw_dashed_line(from_pos: Vector2, to_pos: Vector2, color: Color, width: float) -> void:
	var length = from_pos.distance_to(to_pos)
	var dir = (to_pos - from_pos).normalized()
	var dash_len = 10.0
	var gap_len = 6.0
	var cur = 0.0

	while cur < length:
		var start = from_pos + dir * cur
		var end = from_pos + dir * min(cur + dash_len, length)
		draw_line(start, end, color, width)
		cur += dash_len + gap_len
