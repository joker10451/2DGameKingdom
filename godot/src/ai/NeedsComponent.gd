class_name NeedsComponent
extends Node

## NeedsComponent: Система потребностей жителей в духе RimWorld/Sims

# Физиологические потребности: 0 = полностью удовлетворено, 100 = критическое состояние.
@export var hunger: float = 20.0
@export var fatigue: float = 15.0
@export var social_need: float = 30.0
@export var safety_fear: float = 0.0

# Личностные drives. Они не деградируют как физиологические потребности.
@export var wealth_desire: float = 50.0
@export var ambition_drive: float = 40.0

const PHYSIOLOGICAL_NEEDS: Array[String] = ["hunger", "fatigue", "social", "safety"]
const DRIVE_NAMES: Array[String] = ["wealth", "ambition"]

# Здоровье и жизнь
@export var health: float = 100.0
@export var max_health: float = 100.0

# Скорость естественного изменения за 1 игровой час
const HUNGER_PER_HOUR: float = 4.0
const FATIGUE_PER_HOUR: float = 3.5
const SOCIAL_DECAY_PER_HOUR: float = 2.0
const CRITICAL_THRESHOLD: float = 80.0

func _get_event_bus() -> Node:
	return get_node_or_null("/root/EventBus")

func _ready() -> void:
	var eb = _get_event_bus()
	if eb and not eb.hour_passed.is_connected(_on_hour_passed):
		eb.hour_passed.connect(_on_hour_passed)

func _on_hour_passed(_hour: int, _day: int) -> void:
	hunger = clampf(hunger + HUNGER_PER_HOUR, 0.0, 100.0)
	fatigue = clampf(fatigue + FATIGUE_PER_HOUR, 0.0, 100.0)
	social_need = clampf(social_need + SOCIAL_DECAY_PER_HOUR, 0.0, 100.0)

	# Critical events are emitted only for real physiological needs.
	# Wealth/Ambition are personality drives and must not trigger starvation-like events.
	_check_critical("hunger", hunger)
	_check_critical("fatigue", fatigue)
	_check_critical("social", social_need)
	_check_critical("safety", safety_fear)
	
	if hunger >= 90.0:
		health = maxf(0.0, health - 5.0)
		if health <= 0.0:
			var parent = get_parent()
			var eb = _get_event_bus()
			if eb:
				eb.character_died.emit(parent, null)

func eat(food_quality: float = 30.0) -> void:
	hunger = maxf(0.0, hunger - food_quality)

func sleep(rest_amount: float = 50.0) -> void:
	fatigue = maxf(0.0, fatigue - rest_amount)

func satisfy_social(amount: float = 40.0) -> void:
	social_need = maxf(0.0, social_need - amount)

func get_most_urgent_need() -> Dictionary:
	# Backward-compatible aggregate view used by the AI decision layer.
	# Drives are included as motivational weights, but they are not physiological needs.
	var needs_map = {
		"hunger": hunger,
		"fatigue": fatigue,
		"safety": safety_fear,
		"social": social_need,
		"wealth": wealth_desire,
		"ambition": ambition_drive
	}
	var highest_name = "hunger"
	var highest_val = -1.0
	for key in needs_map:
		if needs_map[key] > highest_val:
			highest_val = needs_map[key]
			highest_name = key
	return {"name": highest_name, "value": highest_val, "is_drive": highest_name in DRIVE_NAMES}

func get_most_urgent_physiological_need() -> Dictionary:
	var needs_map = {
		"hunger": hunger,
		"fatigue": fatigue,
		"safety": safety_fear,
		"social": social_need
	}
	var highest_name = "hunger"
	var highest_val = -1.0
	for key in needs_map:
		if needs_map[key] > highest_val:
			highest_val = needs_map[key]
			highest_name = key
	return {"name": highest_name, "value": highest_val}

func get_drives() -> Dictionary:
	return {
		"wealth": wealth_desire,
		"ambition": ambition_drive
	}

func _check_critical(need_name: String, val: float) -> void:
	if val >= CRITICAL_THRESHOLD:
		var eb = _get_event_bus()
		if eb:
			eb.need_critical.emit(get_parent(), need_name, val)
