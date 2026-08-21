class_name NPCRoutineController
extends RefCounted

## NPCRoutineController: Контроллер распорядка дня, умных рабочих мест и живого поведения NPC
## Управляет 24-часовым расписанием, анимациями труда, мыслями, посиделками в таверне и сном

const TILE_SIZE := 48

# Предустановленные ключевые локации деревни Олдерия
const TAVERN_HEARTH := Vector2i(24, 25)
const TAVERN_BED := Vector2i(21, 23)
const SMITHY_ANVIL := Vector2i(35, 24)
const BAKERY_OVEN := Vector2i(22, 25)
const WINDMILL_MILL := Vector2i(15, 52)
const TANNERY_VAT := Vector2i(26, 38)
const ALCHEMY_TABLE := Vector2i(21, 37)
const LORD_MANOR := Vector2i(38, 38)
const TOWN_HALL := Vector2i(23, 21)

const MARKET_STALLS := [
	Vector2i(23, 38), Vector2i(25, 37), Vector2i(27, 39), Vector2i(28, 35)
]

const FARM_PLOTS := [
	Vector2i(18, 48), Vector2i(22, 50), Vector2i(25, 48), Vector2i(20, 53), Vector2i(27, 47), Vector2i(16, 50)
]

const GUARD_PATROL_POINTS := [
	Vector2i(31, 20), # Северные ворота
	Vector2i(31, 35), # Центральная площадь
	Vector2i(31, 48), # Южный тракт
	Vector2i(52, 31)  # Восточный мост
]

const SLEEP_HOUSES := [
	Vector2i(21, 23), # Кровать в таверне
	Vector2i(38, 23), # Дом кузнеца
	Vector2i(22, 37), # Жилой дом у рынка
	Vector2i(38, 37), # Барский дом
	Vector2i(16, 49)  # Хижина фермера
]

## Определение текущей фазы дня по часам
static func get_schedule_phase(hour: int, is_alarm_active: bool, weather: String, role: String) -> String:
	if is_alarm_active:
		if role in ["Городской Стражник", "Наемник", "guard"]:
			return "combat_defense"
		return "panic_flee"
		
	if weather in ["rain", "storm"] and not (role in ["Городской Стражник", "guard"]):
		if hour >= 22 or hour < 6:
			return "sleep"
		return "rain_shelter"

	if hour >= 22 or hour < 6:
		return "sleep"
	elif hour >= 6 and hour < 8:
		return "wake_up"
	elif hour >= 8 and hour < 12:
		return "work_shift_1"
	elif hour >= 12 and hour < 13:
		return "lunch"
	elif hour >= 13 and hour < 18:
		return "work_shift_2"
	else:
		# 18:00 - 22:00
		return "tavern_evening"

## Выбор целевой клетки для конкретного жителя в зависимости от фазы и профессии
static func get_target_tile_for_npc(npc: Dictionary, phase: String, idx: int, world_map: Node2D, banner_tile: Vector2i) -> Vector2i:
	var role: String = npc.get("role", "Крестьянин")
	var role_prof: String = npc.get("role_prof", "")
	
	match phase:
		"combat_defense":
			return GUARD_PATROL_POINTS[idx % GUARD_PATROL_POINTS.size()]
			
		"panic_flee":
			return TOWN_HALL + Vector2i(randi_range(-1, 1), randi_range(-1, 1))
			
		"rain_shelter":
			return TAVERN_HEARTH + Vector2i(randi_range(-2, 2), randi_range(-1, 1))
			
		"sleep":
			if npc.has("home_bed_tile"):
				return npc["home_bed_tile"]
			var b_tile = SLEEP_HOUSES[idx % SLEEP_HOUSES.size()]
			npc["home_bed_tile"] = b_tile
			return b_tile
			
		"wake_up":
			# Утро: выход к колодцу/очагу таверны
			return TAVERN_HEARTH + Vector2i(randi_range(-2, 2), randi_range(0, 2))
			
		"lunch":
			# Обед: столы таверны и костер
			var l_spots = [TAVERN_HEARTH, Vector2i(25, 26), Vector2i(23, 26), Vector2i(24, 24)]
			return l_spots[idx % l_spots.size()]
			
		"tavern_evening":
			# Вечер: таверна у барда
			var t_spots = [
				Vector2i(23, 24), Vector2i(25, 24), Vector2i(24, 25), 
				Vector2i(22, 26), Vector2i(26, 26), Vector2i(23, 27)
			]
			return t_spots[idx % t_spots.size()]
			
		"work_shift_1", "work_shift_2":
			match role:
				"Кузнец":
					return SMITHY_ANVIL
				"Крестьянин":
					if role_prof == "woodcutter":
						var trees = world_map.find_nodes_of_type("tree") if world_map else []
						if trees.size() > 0:
							return world_map.find_adjacent_walkable_tile(trees[idx % trees.size()])
						return Vector2i(14, 18)
					elif role_prof == "baker":
						return BAKERY_OVEN
					elif role_prof == "miller":
						return WINDMILL_MILL
					elif role_prof == "beekeeper":
						return Vector2i(25, 48)
					else:
						return FARM_PLOTS[idx % FARM_PLOTS.size()]
				"Торговец":
					return MARKET_STALLS[idx % MARKET_STALLS.size()]
				"Городской Стражник":
					# Ротация патрулей: смена 1 = север/площадь, смена 2 = юг/мост
					var p_offset = 0 if phase == "work_shift_1" else 2
					return GUARD_PATROL_POINTS[(idx + p_offset) % GUARD_PATROL_POINTS.size()]
				"Лорд", "Дворянин":
					return LORD_MANOR
				"Бард":
					return TAVERN_HEARTH + Vector2i(1, 0)
				"Бандит", "Разбойник", "Разбойник-лучник":
					var b_camps = [Vector2i(8, 12), Vector2i(11, 14), Vector2i(7, 16)]
					return b_camps[idx % b_camps.size()]
				_:
					return FARM_PLOTS[idx % FARM_PLOTS.size()]
					
	return banner_tile

## Главный цикл обновления ИИ жителя за один кадр
static func update_npc_step(
	npc: Dictionary,
	cur_pos: Vector2,
	delta: float,
	world_map: Node2D,
	banner_tile: Vector2i,
	hour: int,
	weather: String,
	is_alarm_active: bool,
	all_npcs: Array[Dictionary],
	all_positions: Array[Vector2],
	npc_idx: int
) -> Dictionary:
	var role = npc.get("role", "Крестьянин")
	var role_prof = npc.get("role_prof", "")
	var is_dead = npc.get("is_dead", false)
	if is_dead:
		return {
			"new_pos": cur_pos,
			"thought_icon": "💀",
			"action_type": "dead",
			"did_produce": {},
			"spark_pos": Vector2.ZERO,
			"anim_dir_row": 2,
			"is_sleeping": false
		}

	var phase = get_schedule_phase(hour, is_alarm_active, weather, role)
	var prev_phase = npc.get("current_phase", "")
	if phase != prev_phase:
		npc["current_phase"] = phase
		npc["target_tile"] = get_target_tile_for_npc(npc, phase, npc_idx, world_map, banner_tile)
		npc["routine_state"] = "traveling"
		npc["work_timer"] = 0.0

	var target_tile: Vector2i = npc.get("target_tile", Vector2i(-1, -1))
	if target_tile == Vector2i(-1, -1):
		target_tile = get_target_tile_for_npc(npc, phase, npc_idx, world_map, banner_tile)
		npc["target_tile"] = target_tile
		npc["routine_state"] = "traveling"

	var target_world = Vector2(target_tile.x * TILE_SIZE + TILE_SIZE/2.0, target_tile.y * TILE_SIZE + TILE_SIZE/2.0)
	var new_pos = cur_pos
	var thought_icon = ""
	var did_produce = {}
	var spark_pos = Vector2.ZERO
	var anim_dir_row = 2
	var is_sleeping = (phase == "sleep")
	var routine_state = npc.get("routine_state", "traveling")

	# 1. Проверка социального общения на ходу (Passing-by chat)
	var social_pause: float = npc.get("social_pause_timer", 0.0) - delta
	npc["social_pause_timer"] = social_pause
	if social_pause > 0.0:
		thought_icon = npc.get("social_thought", "💬")
		return {
			"new_pos": cur_pos,
			"thought_icon": thought_icon,
			"action_type": "chatting",
			"did_produce": {},
			"spark_pos": Vector2.ZERO,
			"anim_dir_row": npc.get("anim_dir_row", 2),
			"is_sleeping": false
		}

	# Шанс поприветствовать прохожего при сближении
	if routine_state == "traveling" and randf() < 0.02:
		for o_i in range(all_positions.size()):
			if o_i != npc_idx and not all_npcs[o_i].get("is_dead", false):
				if cur_pos.distance_to(all_positions[o_i]) < 38.0:
					npc["social_pause_timer"] = randf_range(1.5, 3.0)
					all_npcs[o_i]["social_pause_timer"] = randf_range(1.5, 3.0)
					var greets = ["💬", "👋", "😄", "🍻", "☀️"]
					var g_icon = greets[randi() % greets.size()]
					npc["social_thought"] = g_icon
					all_npcs[o_i]["social_thought"] = g_icon
					break

	# 2. Движение к цели
	var dist_to_target = cur_pos.distance_to(target_world)
	var walk_spd: float = float(npc.get("walk_speed", 44.0))
	if phase == "panic_flee":
		walk_spd *= 1.5

	if dist_to_target > 16.0 and routine_state != "at_spot":
		var move_dir = (target_world - cur_pos).normalized()
		var step_p = cur_pos + move_dir * walk_spd * delta
		var step_tile = Vector2i(int(step_p.x / TILE_SIZE), int(step_p.y / TILE_SIZE))
		
		if world_map == null or world_map.can_walk(step_tile) or dist_to_target < 28.0:
			new_pos = step_p
		else:
			# Огибание препятствий
			var alt_dir = Vector2(-move_dir.y, move_dir.x)
			var alt_p = cur_pos + alt_dir * walk_spd * delta
			new_pos = alt_p

		# Расчет направления анимации спрайта
		if abs(move_dir.x) > abs(move_dir.y):
			anim_dir_row = 3 if move_dir.x > 0 else 1
		else:
			anim_dir_row = 2 if move_dir.y > 0 else 0
		npc["anim_dir_row"] = anim_dir_row

		match phase:
			"sleep": thought_icon = "💤"
			"panic_flee": thought_icon = "🏃‍♂️"
			"rain_shelter": thought_icon = "🌧️"
			"work_shift_1", "work_shift_2":
				match role:
					"Кузнец": thought_icon = "⚒️"
					"Крестьянин": thought_icon = "🌾" if role_prof != "woodcutter" else "🪓"
					"Торговец": thought_icon = "🪙"
					"Городской Стражник": thought_icon = "🛡️"
					"Бард": thought_icon = "🎵"
					_: thought_icon = "👣"
			"lunch": thought_icon = "🍞"
			"tavern_evening": thought_icon = "🍺"
			_: thought_icon = "👣"

	else:
		# 3. Нахождение на точке деятельности (at_spot)
		npc["routine_state"] = "at_spot"
		anim_dir_row = npc.get("anim_dir_row", 2)
		var w_timer: float = npc.get("work_timer", 0.0) - delta
		npc["work_timer"] = w_timer

		match phase:
			"sleep":
				thought_icon = "💤"
				is_sleeping = true

			"wake_up":
				var w_icons = ["☕", "🍞", "☀️", "🙂"]
				thought_icon = w_icons[(hour + npc_idx) % w_icons.size()]

			"lunch":
				var l_icons = ["🍗", "🍞", "🍵", "🍖", "😄"]
				thought_icon = l_icons[(hour + npc_idx) % l_icons.size()]

			"tavern_evening":
				var t_icons = ["🍺", "🎵", "💬", "🍻", "😄", "🎲"]
				thought_icon = t_icons[(int(Time.get_ticks_msec() * 0.001) + npc_idx) % t_icons.size()]

			"panic_flee":
				thought_icon = "😱"

			"combat_defense":
				thought_icon = "⚔️"

			"rain_shelter":
				thought_icon = "🌧️"

			"work_shift_1", "work_shift_2":
				match role:
					"Кузнец":
						thought_icon = "⚒️"
						if w_timer <= 0.0:
							npc["work_timer"] = randf_range(3.0, 5.0)
							spark_pos = cur_pos + Vector2(randf_range(-10, 10), -12)
							did_produce = {"item_id": "iron_ingots", "amount": 1}
							npc["gold"] = npc.get("gold", 10) + 2

					"Крестьянин":
						if role_prof == "woodcutter":
							thought_icon = "🪓"
							if w_timer <= 0.0:
								npc["work_timer"] = randf_range(3.5, 6.0)
								did_produce = {"item_id": "timber", "amount": 2}
								npc["gold"] = npc.get("gold", 10) + 1
						elif role_prof == "baker":
							thought_icon = "🍞"
							if w_timer <= 0.0:
								npc["work_timer"] = randf_range(4.0, 6.0)
								did_produce = {"item_id": "bread", "amount": 2}
								npc["gold"] = npc.get("gold", 10) + 2
						elif role_prof == "miller":
							thought_icon = "💨"
							if w_timer <= 0.0:
								npc["work_timer"] = randf_range(4.0, 7.0)
								did_produce = {"item_id": "flour", "amount": 2}
						else:
							thought_icon = "🌾"
							if w_timer <= 0.0:
								npc["work_timer"] = randf_range(3.0, 5.0)
								did_produce = {"item_id": "grain", "amount": 2}
								npc["gold"] = npc.get("gold", 10) + 1
								# Переход к соседнему участку поля
								npc["target_tile"] = FARM_PLOTS[randi() % FARM_PLOTS.size()]
								npc["routine_state"] = "traveling"

					"Торговец":
						thought_icon = "🪙"
						if w_timer <= 0.0:
							npc["work_timer"] = randf_range(4.0, 8.0)
							npc["gold"] = npc.get("gold", 50) + randi_range(1, 3)

					"Городской Стражник":
						thought_icon = "🛡️"
						if w_timer <= 0.0:
							npc["work_timer"] = randf_range(5.0, 9.0)
							# Переход к следующему патрульному посту
							var next_post = GUARD_PATROL_POINTS[randi() % GUARD_PATROL_POINTS.size()]
							npc["target_tile"] = next_post
							npc["routine_state"] = "traveling"

					"Бард":
						thought_icon = "🎵"

					"Лорд", "Дворянин":
						thought_icon = "👑"

					_:
						thought_icon = "⚙️"

	return {
		"new_pos": new_pos,
		"thought_icon": thought_icon,
		"action_type": routine_state,
		"did_produce": did_produce,
		"spark_pos": spark_pos,
		"anim_dir_row": anim_dir_row,
		"is_sleeping": is_sleeping
	}
