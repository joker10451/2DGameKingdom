class_name AtmosphereSystem
extends RefCounted

## СИСТЕМА АТМОСФЕРЫ, ТЕПЛОГО СВЕТА, ДЫМА ИЗ ТРУБ И ПОГОДЫ

const WEATHERS := ["clear", "clear", "rain", "fog", "storm"]

static func get_chimney_nodes(world_map: Node2D) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	if not world_map or not ("interactive_nodes" in world_map): return positions
	
	for t_pos in world_map.interactive_nodes.keys():
		var node = world_map.interactive_nodes[t_pos]
		var t = node.get("type", "")
		if t in ["bakery_oven", "fireplace", "campfire", "tannery", "alchemy_lab"]:
			positions.append(Vector2(t_pos.x * 48 + 24, t_pos.y * 48 + 12))
			
	return positions

static func get_night_window_tiles(world_map: Node2D) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	if not world_map or not ("interactive_nodes" in world_map): return positions
	
	for t_pos in world_map.interactive_nodes.keys():
		var node = world_map.interactive_nodes[t_pos]
		var t = node.get("type", "")
		if t in ["bed", "chair_oak", "fireplace"]:
			# Окно на стене рядом
			positions.append(Vector2(t_pos.x * 48 + 24, t_pos.y * 48 - 18))
			
	return positions

static func get_fire_flicker() -> float:
	var t = Time.get_ticks_msec() * 0.007
	return 0.85 + sin(t) * 0.10 + cos(t * 1.7) * 0.05
