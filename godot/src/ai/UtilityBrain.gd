class_name UtilityBrain
extends Node

## Utility AI Мозг персонажа: вычисляет полезность действий и выбирает наилучшее

@export var evaluation_interval: float = 1.0 # Проверять решения каждую секунду
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
	if action_duration > 0.0:
		action_duration -= delta
		if action_duration <= 0.0:
			_complete_current_action()
		return
	
	timer += delta
	if timer >= evaluation_interval:
		timer = 0.0
		evaluate_and_act()

func evaluate_and_act() -> void:
	if not needs or not char_data:
		return
	
	var scores = {}
	
	# 1. Потребность в еде
	var hunger_score = pow(needs.hunger / 100.0, 2.0) * 100.0
	scores["EAT"] = hunger_score
	
	# 2. Потребность во сне (усиливается ночью с 22:00 до 06:00)
	var is_night: bool = TimeManager.hour >= 22 or TimeManager.hour < 6 if TimeManager else false
	var sleep_multiplier: float = 1.8 if is_night else 1.0
	scores["SLEEP"] = (needs.fatigue / 100.0) * 80.0 * sleep_multiplier
	
	# 3. Работа по профессии в рабочее время (08:00 - 18:00)
	var is_work_hours: bool = TimeManager.hour >= 8 and TimeManager.hour <= 18 if TimeManager else true
	if is_work_hours:
		match char_data.current_role:
			"Крестьянин":
				scores["FARM_WORK"] = 45.0 + (needs.wealth_desire * 0.3)
			"Торговец":
				scores["TRADE_MARKET"] = 55.0 + (char_data.trading_skill * 0.4)
			"Стражник":
				scores["PATROL_CITY"] = 60.0
			"Бандит":
				scores["HUNT_OR_AMBUSH"] = 40.0 + (needs.wealth_desire * 0.5)
			"Лорд", "Король":
				scores["HOLD_COURT"] = 50.0 + (needs.ambition_drive * 0.5)
	
	# 4. Преступное поведение (если бедствует и есть склонность)
	if (char_data.has_trait("Жадный") or needs.hunger > 60.0) and char_data.current_role != "Стражник":
		var steal_score = (needs.hunger * 0.5) + (needs.wealth_desire * 0.4)
		if char_data.has_trait("Честный"):
			steal_score -= 50.0
		scores["STEAL_RESOURCE"] = maxf(0.0, steal_score)
	
	# 5. Социализация / Таверна (вечером 18:00 - 22:00)
	if TimeManager and TimeManager.hour >= 18 and TimeManager.hour < 22:
		scores["VISIT_TAVERN"] = needs.social_need * 0.8 + 20.0
	
	# Выбираем действие с максимальной полезностью
	var best_action = "IDLE"
	var highest_score = 10.0 # Минимальный порог
	
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
			elif char_data.gold >= 2:
				char_data.gold -= 2
				needs.eat(30.0)
			else:
				# Нет денег и еды -> попытка украсть или голодать
				needs.hunger += 1.0
		"SLEEP":
			action_duration = 6.0
			needs.sleep(60.0)
		"FARM_WORK":
			action_duration = 4.0
			char_data.add_item("grain", 2)
			char_data.gold += 1
		"TRADE_MARKET":
			action_duration = 4.0
			if char_data.get_item_count("grain") >= 2:
				char_data.remove_item("grain", 2)
				char_data.gold += 5
			else:
				char_data.add_item("bread", 2)
		"PATROL_CITY":
			action_duration = 5.0
			char_data.gold += 2 # Жалование стражника
		"HUNT_OR_AMBUSH":
			action_duration = 5.0
			char_data.gold += 4
			char_data.honor -= 2
		"STEAL_RESOURCE":
			action_duration = 3.0
			char_data.add_item("bread", 1)
			char_data.honor -= 5
		"VISIT_TAVERN":
			action_duration = 4.0
			needs.satisfy_social(50.0)
			if char_data.gold >= 1:
				char_data.gold -= 1
		"HOLD_COURT":
			action_duration = 5.0
			char_data.renown += 2
		"IDLE":
			action_duration = 2.0

func _complete_current_action() -> void:
	current_action = "IDLE"
	action_duration = 0.0
