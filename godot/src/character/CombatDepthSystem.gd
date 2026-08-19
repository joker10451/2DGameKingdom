class_name CombatDepthSystem
extends RefCounted

## БОЕВАЯ ГЛУБИНА, ТРАВМЫ, КРОВОТЕЧЕНИЯ И УМНЫЙ ИИ ВРАГОВ

static func check_injury_on_hit(damage: float, is_critical: bool) -> Dictionary:
	var res = {
		"caused_bleeding": false,
		"caused_arm_injury": false,
		"caused_leg_injury": false
	}
	
	var bleed_chance = 0.75 if is_critical else 0.25
	var arm_chance = 0.40 if is_critical else 0.15
	var leg_chance = 0.40 if is_critical else 0.15
	
	if randf() < bleed_chance and damage >= 8.0:
		res["caused_bleeding"] = true
	if randf() < arm_chance and damage >= 12.0:
		res["caused_arm_injury"] = true
	if randf() < leg_chance and damage >= 12.0:
		res["caused_leg_injury"] = true
		
	return res

static func check_enemy_shield_block(enemy: Dictionary) -> Dictionary:
	var role = enemy.get("role", "")
	var is_boss = enemy.get("is_boss", false)
	
	# Проверка наличия щита / защитной стойки
	if role in ["Рыцарь", "Стражник", "Латник", "Бандит"] or is_boss:
		var block_chance = 0.45 if is_boss else 0.30
		if randf() < block_chance:
			return {
				"blocked": true,
				"dmg_reduction": 0.70 # блокирует 70% урона
			}
			
	return {"blocked": false, "dmg_reduction": 0.0}

static func check_enemy_panic(enemy: Dictionary) -> bool:
	if enemy.get("is_boss", false): return false
	if enemy.get("is_panicked", false): return true
	
	var hp = float(enemy.get("hp", 100.0))
	var max_hp = float(enemy.get("max_hp", 100.0))
	
	if (hp / max_hp) < 0.25:
		if randf() < 0.70:
			enemy["is_panicked"] = true
			return true
			
	return false
