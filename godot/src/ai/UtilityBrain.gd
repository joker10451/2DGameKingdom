class_name UtilityBrain
extends Node

## Utility AI Мозг персонажа: вычисляет полезность действий с учетом потребностей и социальной памяти

@export var evaluation_interval: float = 1.0
var timer: float = 0.0

var current_action: String = "IDLE"
var current_target: Variant = null
var action_duration: float = 0.0

@onready var character: Node = get_parent()
var needs: NeedsComponent
var memory: MemoryComponent
var char_data: CharacterData

func _ready() -> void:
	needs = character.get_node_or_null("NeedsComponent")
	memory = character.get_node_or_null("MemoryComponent")
	if "data" in character:
		char_data = character.data

func _process(delta: float) -> void:
	if char_data and char_data.is_dead:
		set_process(false)
		current_action = "DEAD"
		return

	if action_duration > 0.0:
		action_duration -= delta
		if action_duration <= 0.0:
			_complete_current_action()
		return
	
	timer += delta
	if timer >= evaluation_interval:
		timer = 0.0
		evaluate_and_act()

func _get_time_manager() -> Node:
	if not is_inside_tree():
		if Engine.get_main_loop() and Engine.get_main_loop() is SceneTree:
			return Engine.get_main_loop().root.get_node_or_null("TimeManager")
		return null
	return get_node_or_null("/root/TimeManager")

func evaluate_and_act() -> void:
	if not needs or not char_data or char_data.is_dead:
		return
	
	var scores = {}
	
	# 1. Потребность в еде
	var hunger_score = pow(needs.hunger / 100.0, 2.0) * 100.0
	scores["EAT"] = hunger_score
	
	# 2. Потребность во сне (усиливается ночью с 22:00 до 06:00)
	var tm = _get_time_manager()
	var is_night: bool = (tm.hour >= 22 or tm.hour < 6) if tm else false
	var sleep_multiplier: float = 1.8 if is_night else 1.0
	scores["SLEEP"] = (needs.fatigue / 100.0) * 80.0 * sleep_multiplier
	
	# 3. Социальная память: реакция на врагов и обидчиков (Memory -> Behavior)
	if memory:
		var worst_enemy = memory.get_worst_enemy()
		if worst_enemy["opinion"] <= -40.0:
			if char_data.current_role in ["Стражник", "Воин", "Бандит"]:
				scores["CONFRONT_OR_ATTACK"] = 75.0 + absf(worst_enemy["opinion"] * 0.3)
			else:
				scores["FLEE_OR_AVOID"] = 70.0 + absf(worst_enemy["opinion"] * 0.3)
				
		var best_friend = memory.get_best_friend()
		if best_friend["opinion"] >= 40.0 and needs.hunger > 50.0:
			scores["SHARE_OR_RECEIVE_FOOD"] = 60.0
	
	# 4. Работа по профессии в рабочее время (08:00 - 18:00)
	var is_work_hours: bool = (tm.hour >= 8 and tm.hour <= 18) if tm else true
	if is_work_hours:
		match char_data.current_role:
			"Крестьянин", "Хлебопашец":
				scores["FARM_WORK"] = 45.0 + (needs.wealth_desire * 0.3)
			"Мельник":
				scores["MILL_WORK"] = 48.0 + (needs.wealth_desire * 0.3)
			"Пекарь":
				scores["BAKE_WORK"] = 50.0 + (needs.wealth_desire * 0.3)
			"Кузнец":
				scores["SMITH_WORK"] = 52.0 + (needs.wealth_desire * 0.3)
			"Торговец":
				scores["TRADE_MARKET"] = 55.0 + (char_data.trading_skill * 0.4)
			"Стражник":
				scores["PATROL_CITY"] = 60.0
			"Бандит":
				scores["HUNT_OR_AMBUSH"] = 40.0 + (needs.wealth_desire * 0.5)
			"Лорд", "Король":
				scores["HOLD_COURT"] = 50.0 + (needs.ambition_drive * 0.5)
	
	# 5. Преступное поведение при сильной нужде
	if (char_data.has_trait("Жадный") or needs.hunger > 65.0) and char_data.current_role != "Стражник":
		var steal_score = (needs.hunger * 0.5) + (needs.wealth_desire * 0.4)
		if char_data.has_trait("Честный"):
			steal_score -= 50.0
		scores["STEAL_RESOURCE"] = maxf(0.0, steal_score)
	
	# 6. Социализация / Таверна (вечером 18:00 - 22:00)
	if tm and tm.hour >= 18 and tm.hour < 22:
		var friend_bonus = 15.0 if (memory and memory.get_best_friend()["opinion"] >= 30.0) else 0.0
		scores["VISIT_TAVERN"] = (needs.social_need * 0.8) + 20.0 + friend_bonus
	
	# Выбираем действие с максимальной полезностью
	var best_action = "IDLE"
	var highest_score = 10.0
	
	for action in scores:
		if scores[action] > highest_score:
			highest_score = scores[action]
			best_action = action
	
	_start_action(best_action)

func _start_action(action_name: String) -> void:
	current_action = action_name
	
	match action_name:
		"EAT":
			action_duration = 3.0
			if char_data.get_item_count("bread") > 0:
				char_data.remove_item("bread", 1)
				needs.eat(35.0)
			elif char_data.get_item_count("meat_pie") > 0:
				char_data.remove_item("meat_pie", 1)
				needs.eat(50.0)
			else:
				needs.hunger += 2.0
		"SLEEP":
			action_duration = 6.0
			needs.sleep(60.0)
		"FLEE_OR_AVOID":
			action_duration = 4.0
			needs.safety_fear = clampf(needs.safety_fear - 20.0, 0.0, 100.0)
		"CONFRONT_OR_ATTACK":
			action_duration = 4.0
		"SHARE_OR_RECEIVE_FOOD":
			action_duration = 3.0
			needs.eat(25.0)
			needs.satisfy_social(20.0)
		"FARM_WORK", "MILL_WORK", "BAKE_WORK", "SMITH_WORK":
			action_duration = 4.0
		"TRADE_MARKET":
			action_duration = 4.0
		"PATROL_CITY":
			action_duration = 5.0
		"HUNT_OR_AMBUSH":
			action_duration = 5.0
		"STEAL_RESOURCE":
			action_duration = 3.0
		"VISIT_TAVERN":
			action_duration = 4.0
			needs.satisfy_social(50.0)
		"HOLD_COURT":
			action_duration = 5.0
			char_data.renown += 2
		"IDLE":
			action_duration = 2.0

func _complete_current_action() -> void:
	current_action = "IDLE"
	action_duration = 0.0
