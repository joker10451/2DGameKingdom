class_name MemoryComponent
extends Node

## MemoryComponent: Социальная и эпизодическая память персонажа
## Хранит отношения, эмоциональный контекст событий, долги и кровные обиды

var char_name: String = "Житель"
var opinions: Dictionary = {} # char_id -> float (-100.0 to 100.0)
var interaction_history: Array[Dictionary] = []
var grudges: Array[Dictionary] = [] # [{char_id, reason, severity, created_hour}]

func _get_event_bus() -> Node:
	if not is_inside_tree():
		if Engine.get_main_loop() and Engine.get_main_loop() is SceneTree:
			return Engine.get_main_loop().root.get_node_or_null("EventBus")
		return null
	return get_node_or_null("/root/EventBus")

func _get_time_manager() -> Node:
	if not is_inside_tree():
		if Engine.get_main_loop() and Engine.get_main_loop() is SceneTree:
			return Engine.get_main_loop().root.get_node_or_null("TimeManager")
		return null
	return get_node_or_null("/root/TimeManager")

func get_opinion(char_id: String) -> float:
	return opinions.get(char_id, 0.0)

func modify_opinion(char_id: String, delta: float, reason: String = "", importance: int = 1) -> void:
	var current = get_opinion(char_id)
	var new_val = clampf(current + delta, -100.0, 100.0)
	opinions[char_id] = new_val
	
	record_event({
		"target_id": char_id,
		"delta": delta,
		"reason": reason,
		"importance": importance,
		"resulting_opinion": new_val
	})
	
	var parent = get_parent()
	var eb = _get_event_bus()
	if eb and eb.has_signal("opinion_changed"):
		eb.opinion_changed.emit(parent, null, delta, new_val)

func add_grudge(char_id: String, reason: String, severity: int) -> void:
	var tm = _get_time_manager()
	grudges.append({
		"char_id": char_id,
		"reason": reason,
		"severity": severity,
		"created_hour": tm.hour if tm else 0
	})
	modify_opinion(char_id, -float(severity * 10), reason, 3)

func has_grudge_against(char_id: String) -> bool:
	for g in grudges:
		if g.get("char_id") == char_id:
			return true
	return get_opinion(char_id) <= -40.0

func get_worst_enemy() -> Dictionary:
	var worst_id = ""
	var min_op = 0.0
	for cid in opinions.keys():
		if opinions[cid] < min_op:
			min_op = opinions[cid]
			worst_id = cid
	return {"char_id": worst_id, "opinion": min_op}

func get_best_friend() -> Dictionary:
	var best_id = ""
	var max_op = 0.0
	for cid in opinions.keys():
		if opinions[cid] > max_op:
			max_op = opinions[cid]
			best_id = cid
	return {"char_id": best_id, "opinion": max_op}

func record_event(event_data: Dictionary, _importance: int = 1) -> void:
	var tm = _get_time_manager()
	event_data["timestamp_hour"] = tm.hour if tm else 0
	interaction_history.append(event_data)
	if interaction_history.size() > 50:
		interaction_history.pop_front()

func decay_grudges() -> void:
	# Медленное остывание обид со временем
	for i in range(grudges.size() - 1, -1, -1):
		grudges[i]["severity"] -= 1
		if grudges[i]["severity"] <= 0:
			grudges.remove_at(i)
