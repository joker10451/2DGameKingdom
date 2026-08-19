class_name MemoryComponent
extends Node

## MemoryComponent: Социальная память, фиксация обид, долгов и репутации

var char_name: String = "Житель"
var opinions: Dictionary = {} # char_id -> float (-100.0 to 100.0)
var interaction_history: Array[Dictionary] = []
var grudges: Array[Dictionary] = [] # [{char_id, reason, severity, created_hour}]

func _get_event_bus() -> Node:
	return get_node_or_null("/root/EventBus")

func _get_time_manager() -> Node:
	return get_node_or_null("/root/TimeManager")

func get_opinion(char_id: String) -> float:
	return opinions.get(char_id, 0.0)

func modify_opinion(char_id: String, delta: float, reason: String = "") -> void:
	var current = get_opinion(char_id)
	var new_val = clampf(current + delta, -100.0, 100.0)
	opinions[char_id] = new_val
	
	record_event({
		"target_id": char_id,
		"delta": delta,
		"reason": reason,
		"resulting_opinion": new_val
	})
	
	var parent = get_parent()
	var eb = _get_event_bus()
	if eb:
		eb.opinion_changed.emit(parent, null, delta, new_val)

func add_grudge(char_id: String, reason: String, severity: int) -> void:
	var tm = _get_time_manager()
	grudges.append({
		"char_id": char_id,
		"reason": reason,
		"severity": severity,
		"created_hour": tm.hour if tm else 0
	})
	modify_opinion(char_id, -float(severity * 10), reason)

func record_event(event_data: Dictionary) -> void:
	var tm = _get_time_manager()
	event_data["timestamp_hour"] = tm.hour if tm else 0
	interaction_history.append(event_data)
	if interaction_history.size() > 50:
		interaction_history.pop_front()
