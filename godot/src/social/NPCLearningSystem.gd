class_name NPCLearningSystem
extends RefCounted

## ДВИЖОК ОБУЧЕНИЯ, ПОДКРЕПЛЕНИЯ И РОСТА НАВЫКОВ NPC
## Управляет привычками, прокачкой профессий, похвалой, премиями и выговорами

# profiles: npc_id -> {habits: {}, skills: {}, skill_xp: {}, motivation_timer: float}
var profiles: Dictionary = {}

func get_profile(npc_id: String) -> Dictionary:
	if not profiles.has(npc_id):
		profiles[npc_id] = {
			"habits": {
				"diligence": randi_range(40, 65),  # Трудолюбие (0..100)
				"discipline": randi_range(35, 60), # Дисциплина (0..100)
				"bravery": randi_range(30, 55),    # Храбрость (0..100)
				"sobriety": randi_range(50, 75)    # Трезвость (0..100)
			},
			"skills": {
				"farming": 1,
				"smithing": 1,
				"combat": 1,
				"baking": 1
			},
			"skill_xp": {
				"farming": 0,
				"smithing": 0,
				"combat": 0,
				"baking": 0
			},
			"motivation_timer": 0.0 # Секунды ускоренной работы от премии
		}
	return profiles[npc_id]

func praise_npc(npc_id: String, npc_data: Dictionary) -> Dictionary:
	var prof = get_profile(npc_id)
	prof["habits"]["diligence"] = min(100, prof["habits"]["diligence"] + 10)
	prof["habits"]["discipline"] = min(100, prof["habits"]["discipline"] + 5)
	
	var current_rep = npc_data.get("reputation_to_player", 0)
	npc_data["reputation_to_player"] = current_rep + 15
	
	return {
		"success": true,
		"diligence": prof["habits"]["diligence"],
		"msg": "🌟 «Ваша похвала окрыляет меня, милорд! Буду трудиться с удвоенным рвением!» (Трудолюбие: %d%%, +15 к лояльности)" % prof["habits"]["diligence"]
	}

func reward_bonus(npc_id: String, npc_data: Dictionary, player_data: CharacterData) -> Dictionary:
	var cost = 10
	if not player_data or player_data.gold < cost:
		return {"success": false, "msg": "🪙 Недостаточно золота для выдачи премии (нужно 10 золотых)."}
		
	player_data.gold -= cost
	var prof = get_profile(npc_id)
	prof["habits"]["diligence"] = min(100, prof["habits"]["diligence"] + 20)
	prof["motivation_timer"] = 600.0 # 10 минут реального времени (весь игровой день)
	
	var current_rep = npc_data.get("reputation_to_player", 0)
	npc_data["reputation_to_player"] = current_rep + 25
	
	return {
		"success": true,
		"diligence": prof["habits"]["diligence"],
		"msg": "🪙 «Щедрая премия от Лорда! Да благословят вас небеса!» (Трудолюбие: %d%%, бафф «Рабочий Раж» x1.5 скорости работы!)" % prof["habits"]["diligence"]
	}

func reprimand_npc(npc_id: String, npc_data: Dictionary) -> Dictionary:
	var prof = get_profile(npc_id)
	prof["habits"]["discipline"] = min(100, prof["habits"]["discipline"] + 20)
	prof["habits"]["diligence"] = min(100, prof["habits"]["diligence"] + 10)
	
	return {
		"success": true,
		"discipline": prof["habits"]["discipline"],
		"msg": "⚠️ «Простите, милорд! Моя оплошность, сию минуту исправлюсь и вернусь к работе!» (Дисциплина: %d%%, лень подавлена)" % prof["habits"]["discipline"]
	}

func teach_skill(npc_id: String, skill_name: String) -> Dictionary:
	var prof = get_profile(npc_id)
	if not prof["skills"].has(skill_name):
		prof["skills"][skill_name] = 1
		prof["skill_xp"][skill_name] = 0
		
	prof["skill_xp"][skill_name] += 35
	var lvl = prof["skills"][skill_name]
	var xp = prof["skill_xp"][skill_name]
	
	var lvl_up = false
	if xp >= lvl * 50:
		prof["skills"][skill_name] += 1
		prof["skill_xp"][skill_name] -= lvl * 50
		lvl_up = true
		
	var skill_ru = {
		"farming": "Земледелие",
		"smithing": "Кузнечное дело",
		"combat": "Ратное дело",
		"baking": "Кулинария"
	}.get(skill_name, skill_name)
	
	if lvl_up:
		return {
			"success": true,
			"lvl_up": true,
			"new_lvl": prof["skills"][skill_name],
			"msg": "🎓 НОВЫЙ УРОВЕНЬ МАСТЕРСТВА! Житель повысил навык «%s» до %d уровня благодаря вашим урокам!" % [skill_ru, prof["skills"][skill_name]]
		}
	else:
		return {
			"success": true,
			"lvl_up": false,
			"msg": "📖 Вы провели практический урок ремесла «%s» (+35 XP опыта, житель освоил новые приемы)!" % skill_ru
		}

func get_work_speed_multiplier(npc_id: String) -> float:
	var prof = get_profile(npc_id)
	var base = 0.5 + (float(prof["habits"]["diligence"]) / 100.0) * 0.5
	if prof["motivation_timer"] > 0.0:
		base *= 1.5
	return base
