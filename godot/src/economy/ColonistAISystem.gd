class_name ColonistAISystem
extends RefCounted

## ИИ ФИЗИЧЕСКОГО ТРУДА, ПСИХОЛОГИИ И РАСПОРЯДКА ДНЯ ПОСЕЛЕНЦЕВ

const CitizenMindSystem = preload("res://src/economy/CitizenMindSystem.gd")

const TILE_SIZE := 48

static func find_job_target(prof_id: String, world_map: Node2D, banner_tile: Vector2i) -> Vector2i:
	if not world_map: return banner_tile
	
	if prof_id == "woodcutter":
		var best_tile := Vector2i(-1, -1)
		var best_dist := 9999.0
		for t_pos in world_map.interactive_nodes.keys():
			if world_map.interactive_nodes[t_pos].get("type") == "tree":
				var d = banner_tile.distance_to(t_pos)
				if d < best_dist and d < 22.0:
					best_dist = d
					best_tile = t_pos
		if best_tile != Vector2i(-1, -1):
			return best_tile
			
	elif prof_id == "farmer":
		for t_pos in world_map.interactive_nodes.keys():
			if world_map.interactive_nodes[t_pos].get("type") == "crop_wheat":
				return t_pos
		for t_pos in world_map.ground_tiles.keys():
			if world_map.ground_tiles[t_pos] == "farmland":
				return t_pos
				
	elif prof_id == "blacksmith":
		for t_pos in world_map.interactive_nodes.keys():
			if world_map.interactive_nodes[t_pos].get("type") in ["carpentry", "chest"]:
				return t_pos
				
	elif prof_id == "baker":
		for t_pos in world_map.interactive_nodes.keys():
			if world_map.interactive_nodes[t_pos].get("type") in ["bakery_oven", "chest"]:
				return t_pos
				
	elif prof_id == "guard":
		var angles = [0.0, 1.57, 3.14, 4.71]
		var a = angles[randi() % angles.size()]
		var r = randf_range(3.0, 6.0)
		return banner_tile + Vector2i(int(cos(a) * r), int(sin(a) * r))
		
	return banner_tile + Vector2i(randi_range(-2, 2), randi_range(-2, 2))

static func process_colonist_step(npc: Dictionary, cur_pos: Vector2, delta: float, world_map: Node2D, banner_tile: Vector2i, hour: int = 12, mood_info: Dictionary = {}, weather: String = "clear") -> Dictionary:
	var prof = npc.get("role_prof", "farmer")
	var state = npc.get("work_state", "idle")
	var work_timer = float(npc.get("work_timer", 0.0))
	var target_tile = npc.get("work_target_tile", Vector2i(-1, -1))
	var new_pos = cur_pos
	var thought_icon = ""
	var did_finish_work := false
	
	var sched = CitizenMindSystem.get_schedule_state(hour)
	var mood_status = mood_info.get("status", "content")
	var speed_mult = float(mood_info.get("speed_mult", 1.0))
	
	# Забастовка при низком настроении
	if mood_status == "striking" and sched == "work":
		thought_icon = "👿"
		return {
			"new_pos": cur_pos,
			"thought_icon": "👿",
			"did_finish_work": false,
			"action_tile": target_tile
		}
		
	# 1. Ночной сон
	if sched == "sleep":
		thought_icon = "💤"
		var bed_target = banner_tile + Vector2i(randi_range(-2, 2), randi_range(1, 3))
		var target_world = Vector2(bed_target.x * TILE_SIZE + TILE_SIZE/2.0, bed_target.y * TILE_SIZE + TILE_SIZE/2.0)
		var dir = (target_world - cur_pos)
		if dir.length() > 15.0:
			new_pos += dir.normalized() * float(npc.get("walk_speed", 45.0)) * delta
		return {
			"new_pos": new_pos,
			"thought_icon": "💤",
			"did_finish_work": false,
			"action_tile": bed_target
		}
		
	# 2. Укрытие от сильного ливня или сбор в таверне
	if (sched == "tavern") or (weather in ["rain", "storm"] and prof != "guard"):
		var tavern_tile = Vector2i(24, 25) + Vector2i(randi_range(-2, 2), randi_range(-2, 2))
		var target_world = Vector2(tavern_tile.x * TILE_SIZE + TILE_SIZE/2.0, tavern_tile.y * TILE_SIZE + TILE_SIZE/2.0)
		var dir = (target_world - cur_pos)
		if dir.length() > 18.0:
			new_pos += dir.normalized() * float(npc.get("walk_speed", 45.0)) * delta
		else:
			npc["drank_ale_today"] = true
			if weather in ["rain", "storm"]:
				var rain_emotes = ["🌧️", "☕", "🔥", "🍵"]
				thought_icon = rain_emotes[randi() % rain_emotes.size()]
			else:
				var t_icons = ["🍺", "🎵", "💬", "😄", "🍖"]
				thought_icon = t_icons[randi() % t_icons.size()]
		return {
			"new_pos": new_pos,
			"thought_icon": thought_icon,
			"did_finish_work": false,
			"action_tile": tavern_tile
		}
		
	# 3. Рабочее время
	if target_tile == Vector2i(-1, -1):
		target_tile = find_job_target(prof, world_map, banner_tile)
		npc["work_target_tile"] = target_tile
		npc["work_state"] = "moving"
		state = "moving"
		
	var target_world = Vector2(target_tile.x * TILE_SIZE + TILE_SIZE/2.0, target_tile.y * TILE_SIZE + TILE_SIZE/2.0)
	
	if state == "moving":
		var dir = (target_world - cur_pos)
		var dist = dir.length()
		if dist <= 12.0:
			npc["work_state"] = "working"
			npc["work_timer"] = randf_range(2.5, 4.5) / maxf(0.5, speed_mult)
		else:
			new_pos += dir.normalized() * float(npc.get("walk_speed", 45.0)) * speed_mult * delta
			
	elif state == "working":
		work_timer -= delta
		npc["work_timer"] = work_timer
		match prof:
			"woodcutter": thought_icon = "🪓"
			"farmer": thought_icon = "🌾"
			"blacksmith": thought_icon = "⚒️"
			"baker": thought_icon = "🍞"
			"hunter": thought_icon = "🍗"
			"guard": thought_icon = "🛡️"
			_: thought_icon = "⚙️"
			
		if work_timer <= 0.0:
			did_finish_work = true
			npc["gold"] = npc.get("gold", 10) + randi_range(1, 3)
			npc["work_target_tile"] = find_job_target(prof, world_map, banner_tile)
			npc["work_state"] = "moving"
			
	return {
		"new_pos": new_pos,
		"thought_icon": thought_icon,
		"did_finish_work": did_finish_work,
		"action_tile": target_tile
	}
