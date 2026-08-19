class_name CryptMonstersSystem
extends RefCounted

## БЕСТИАРИЙ НЕЖИТИ И ИИ МОНСТРОВ СКЛЕПА
## Управляет скелетами-мечниками, лучниками и чумными упырями

var monsters: Array[Dictionary] = []

func spawn_monsters() -> void:
	monsters.clear()
	
	# Скелеты в Зале Саркофагов (16, 6)
	_add_monster("skeleton_warrior", "💀 Скелет-Мечник", Vector2(16 * 48, 6 * 48), 45, 12, 35.0)
	_add_monster("skeleton_warrior", "💀 Скелет-Мечник", Vector2(18 * 48, 7 * 48), 45, 12, 35.0)
	
	# Лучники в Тюремных Камерах (6, 16)
	_add_monster("skeleton_archer", "🏹 Скелет-Лучник", Vector2(6 * 48, 16 * 48), 35, 10, 30.0)
	_add_monster("skeleton_archer", "🏹 Скелет-Лучник", Vector2(8 * 48, 18 * 48), 35, 10, 30.0)
	
	# Чумной Упырь в Зале Ловушек (16, 16)
	_add_monster("ghoul", "🧟 Чумной Упырь", Vector2(16 * 48, 16 * 48), 60, 16, 50.0)

func _add_monster(type: String, m_name: String, pos: Vector2, max_hp: int, dmg: int, speed: float) -> void:
	monsters.append({
		"type": type,
		"name": m_name,
		"pos": pos,
		"target_pos": pos,
		"hp": max_hp,
		"max_hp": max_hp,
		"dmg": dmg,
		"speed": speed,
		"attack_cooldown": 0.0,
		"is_dead": false
	})

func update_monsters(delta: float, player_pos: Vector2) -> Array[Dictionary]:
	var attacks: Array[Dictionary] = []
	
	for m in monsters:
		if m["is_dead"]: continue
		
		if m["attack_cooldown"] > 0.0:
			m["attack_cooldown"] -= delta
			
		var dist = m["pos"].distance_to(player_pos)
		
		# Агро-радиус (160 пикселей)
		if dist < 180.0:
			var dir = (player_pos - m["pos"]).normalized()
			
			# Дистанция атаки
			var attack_range = 95.0 if m["type"] == "skeleton_archer" else 35.0
			if dist > attack_range:
				m["pos"] += dir * m["speed"] * delta
			else:
				# Атака
				if m["attack_cooldown"] <= 0.0:
					m["attack_cooldown"] = 1.4
					attacks.append({
						"monster": m["name"],
						"dmg": m["dmg"],
						"type": m["type"]
					})
					
	return attacks

func damage_monster(idx: int, dmg: int) -> Dictionary:
	if idx < 0 or idx >= monsters.size(): return {}
	var m = monsters[idx]
	if m["is_dead"]: return {}
	
	m["hp"] -= dmg
	if m["hp"] <= 0:
		m["hp"] = 0
		m["is_dead"] = true
		return {
			"killed": true,
			"name": m["name"],
			"loot_gold": randi_range(5, 18),
			"loot_item": "bone_arrow" if m["type"] == "skeleton_archer" else "iron_scrap"
		}
	return {"killed": false, "hp": m["hp"], "name": m["name"]}
