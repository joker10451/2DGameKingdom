class_name CitizenMindSystem
extends RefCounted

## ПСИХОЛОГИЯ, НАСТРОЕНИЕ, МЫСЛИ И РАСПОРЯДОК ДНЯ ПОСЕЛЕНЦЕВ

const TRAITS := {
	"workaholic": {
		"id": "workaholic",
		"name": "Трудоголик",
		"icon": "🔨",
		"desc": "Работает на +35% быстрее, получает радость от завершения работы."
	},
	"ale_lover": {
		"id": "ale_lover",
		"name": "Любитель Эля",
		"icon": "🍺",
		"desc": "Каждый вечер спешит в таверну, получает +25 к счастью от эля."
	},
	"miser": {
		"id": "miser",
		"name": "Скупердяй",
		"icon": "🪙",
		"desc": "Копит золото, впадает в ярость при высоких налогах."
	},
	"brave": {
		"id": "brave",
		"name": "Храбрец",
		"icon": "⚔️",
		"desc": "Смело защищает поселение при нападениях разбойников."
	},
	"peaceful": {
		"id": "peaceful",
		"name": "Миролюбивый Садовод",
		"icon": "🌾",
		"desc": "Обожает природу, заботится о садах и пчелах."
	}
}

static func get_schedule_state(hour: int) -> String:
	if hour >= 22 or hour < 6:
		return "sleep"
	elif hour >= 6 and hour < 7:
		return "wake_up"
	elif hour >= 18 and hour < 22:
		return "tavern"
	else:
		return "work"

static func calculate_citizen_mood(c: Dictionary, p: CharacterData, total_beds: int, comfort_info: Dictionary = {}) -> Dictionary:
	var base_mood := 70.0
	var thoughts: Array[String] = []
	
	# 1. Наличие спального места в доме
	var citizens_count = p.settlement.get("citizens", []).size() if p else 1
	if total_beds >= citizens_count:
		base_mood += 15.0
		thoughts.append("🟢 [color=lightgreen]+15 Уютная постель в доме[/color]")
	else:
		base_mood -= 25.0
		thoughts.append("🔴 [color=salmon]-25 Сплю на сырой холодной земле[/color]")
		
	# 2. Сытость
	var hunger = float(c.get("hunger", 90.0))
	if hunger >= 80.0:
		base_mood += 10.0
		thoughts.append("🟢 [color=lightgreen]+10 Вкусная и сытная еда[/color]")
	elif hunger < 30.0:
		base_mood -= 30.0
		thoughts.append("🔴 [color=salmon]-30 Мучительный голод[/color]")
		
	# 3. Налоговая ставка
	var tax_rate = float(p.settlement.get("tax_rate", 0.10)) if p else 0.10
	var trait_id = c.get("trait", "workaholic")
	
	if tax_rate <= 0.05:
		base_mood += 15.0
		thoughts.append("🟢 [color=lightgreen]+15 Справедливый лорд: низкие налоги (5%)[/color]")
	elif tax_rate >= 0.20:
		var tax_pen = 30.0 if trait_id == "miser" else 20.0
		base_mood -= tax_pen
		thoughts.append("🔴 [color=salmon]-%d Грабительские поборы лорда (20%%)[/color]" % int(tax_pen))
		
	# 4. Городской пир
	if p and p.settlement.get("feast_timer", 0.0) > 0.0:
		base_mood += 25.0
		thoughts.append("🟢 [color=gold]+25 Праздничный королевский пир в городе![/color]")
		
	# 5. Вечерний эль в таверне
	if c.get("drank_ale_today", false):
		var ale_bonus = 25.0 if trait_id == "ale_lover" else 15.0
		base_mood += ale_bonus
		thoughts.append("🟢 [color=lightgreen]+%d Душевный вечер с элем в таверне[/color]" % int(ale_bonus))
		
	# 6. Уют и меблировка дома (Interior Comfort)
	if comfort_info.get("mood_bonus", 0.0) > 0.0:
		base_mood += float(comfort_info["mood_bonus"])
		if comfort_info.get("thought", "") != "":
			thoughts.append(comfort_info["thought"])
		
	var final_mood = clampf(base_mood, 0.0, 100.0)
	var status = "content"
	var status_text = "😐 Спокоен"
	var speed_mult = 1.0
	
	if final_mood >= 85.0:
		status = "happy"
		status_text = "😊 Воодушевлен (+35% скорости труда)"
		speed_mult = 1.35
	elif final_mood < 30.0:
		status = "striking"
		status_text = "👿 Бастует (Отказ от работы!)"
		speed_mult = 0.0
	elif final_mood < 55.0:
		status = "unhappy"
		status_text = "🙁 Недоволен"
		speed_mult = 0.85
		
	return {
		"mood": final_mood,
		"status": status,
		"status_text": status_text,
		"thoughts": thoughts,
		"speed_mult": speed_mult
	}
