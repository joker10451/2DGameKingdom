class_name CryptBossSystem
extends RefCounted

## СИСТЕМА БОССА: КОРОЛЬ НЕЖИТИ МАЛГОР
## Управляет фазами боя, суперударами и анимациями повелителя склепа

var boss_name: String = "👑 Король Нежити Малгор"
var max_hp: int = 350
var current_hp: int = 350
var pos: Vector2 = Vector2(22 * 48, 22 * 48)
var phase: int = 1
var is_active: bool = false
var is_defeated: bool = false
var attack_timer: float = 0.0

func activate_boss() -> Dictionary:
	is_active = true
	current_hp = max_hp
	phase = 1
	is_defeated = false
	return {
		"name": boss_name,
		"max_hp": max_hp,
		"msg": "👑 ВОССТАЛ КОРОЛЬ НЕЖИТИ МАЛГОР! «Кто посмел потревожить мой вечный сон?! Твоя плоть испепелится в прах!»"
	}

func update_boss(delta: float, player_pos: Vector2) -> Dictionary:
	if not is_active or is_defeated: return {}
	
	attack_timer -= delta
	var dist = pos.distance_to(player_pos)
	
	# Движение к игроку
	if dist > 55.0:
		var dir = (player_pos - pos).normalized()
		var speed = 40.0 if phase < 3 else 60.0 # В 3 фазе быстрее!
		pos += dir * speed * delta
		
	# Атаки по таймеру
	if attack_timer <= 0.0 and dist <= 75.0:
		attack_timer = 2.0 if phase == 1 else 1.5
		
		if phase == 1:
			return {
				"attack_type": "cleave",
				"dmg": 22,
				"msg": "⚔️ МАЛГОР НАНОСИТ РУБЯЩИЙ КЛИВ ТЕМНЫМ КЛИНКОМ! (22 урона!)"
			}
		elif phase == 2:
			return {
				"attack_type": "summon",
				"dmg": 18,
				"msg": "💀 МАЛГОР ПРИЗЫВАЕТ ПРИСЛУЖНИКОВ ИЗ САДКОФАГОВ!"
			}
		elif phase == 3:
			return {
				"attack_type": "dark_wave",
				"dmg": 30,
				"msg": "🔥 ВЗРЫВ НЕКРОТИЧЕСКОЙ БЕЗДНЫ! Малгор обрушивает темную волну (30 урона)!"
			}
			
	return {}

func take_damage(dmg: int) -> Dictionary:
	if not is_active or is_defeated: return {}
	
	current_hp = max(0, current_hp - dmg)
	
	# Проверка смены фаз
	if current_hp <= 115 and phase < 3:
		phase = 3
	elif current_hp <= 230 and phase < 2:
		phase = 2
		
	if current_hp <= 0:
		is_defeated = true
		is_active = false
		return {
			"killed": true,
			"msg": "🏆 ВЫ СОКРУШИЛИ КОРОЛЯ НЕЖИТИ МАЛГОРА! Тьма рассеялась, Королевский Сундук открыт!"
		}
		
	return {"killed": false, "hp": current_hp, "phase": phase}
