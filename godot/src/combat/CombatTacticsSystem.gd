class_name CombatTacticsSystem
extends RefCounted

## ТАКТИЧЕСКИЕ ПРИЕМЫ БОЯ: КУВЫРОК, ТОЛЧОК ЩИТОМ И ПАРИРОВАНИЕ
## Управляет кадрами неуязвимости, оглушением и контратаками

var is_rolling: bool = false
var roll_timer: float = 0.0
var roll_dir: Vector2 = Vector2.ZERO

var parry_active_timer: float = 0.0
var has_guaranteed_crit: bool = false

func start_dodge_roll(input_dir: Vector2, stamina_available: float) -> Dictionary:
	if is_rolling or stamina_available < 15.0:
		return {"success": false}
		
	is_rolling = true
	roll_timer = 0.35 # 0.35 секунды кувырка
	roll_dir = input_dir.normalized() if input_dir.length() > 0.1 else Vector2.DOWN
	
	return {
		"success": true,
		"stamina_cost": 15.0,
		"msg": "💨 КУВЫРОК! Кадры неуязвимости активны!"
	}

func update(delta: float) -> void:
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0.0:
			is_rolling = false
			
	if parry_active_timer > 0.0:
		parry_active_timer -= delta

func trigger_shield_bash(enemy: Dictionary) -> Dictionary:
	return {
		"success": true,
		"stun_duration": 1.2,
		"dmg": 10,
		"msg": "🛡️ УДАР ЩИТОМ! Враг отброшен и оглушен на 1.2 секунды!"
	}

func trigger_perfect_parry() -> Dictionary:
	has_guaranteed_crit = true
	return {
		"success": true,
		"msg": "⚔️ ИДЕАЛЬНОЕ ПАРИРОВАНИЕ! Атака отражена, следующая контратака нанесет 100% КРИТИЧЕСКИЙ УРОН!"
	}
