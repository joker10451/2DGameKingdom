class_name NobilitySystem
extends RefCounted

## СИСТЕМА ДВОРЯНСКИХ ТИТУЛОВ, РЫЦАРСТВА И ФЕОДАЛЬНОЙ ИЕРАРХИИ

const TITLES := {
	"commoner": {
		"id": "commoner",
		"rank": 0,
		"name": "Простолюдин",
		"icon": "🌾",
		"prefix": "Житель",
		"renown_req": 0,
		"honor_req": 0,
		"gold_req": 0,
		"estate_req": 0,
		"desc": "Свободный общинник Олдерии без дворянских привилегий."
	},
	"squire": {
		"id": "squire",
		"rank": 1,
		"name": "Оруженосец",
		"icon": "🛡️",
		"prefix": "Оруженосец",
		"renown_req": 25,
		"honor_req": 15,
		"gold_req": 40,
		"estate_req": 0,
		"reward_items": ["dagger_iron"],
		"bonus_stamina": 10.0,
		"desc": "Служитель знатного дома. Получает +10 к максимальному запасу сил и гербовый кинжал."
	},
	"knight": {
		"id": "knight",
		"rank": 2,
		"name": "Странствующий Рыцарь",
		"icon": "⚔️",
		"prefix": "Сэр",
		"renown_req": 60,
		"honor_req": 40,
		"gold_req": 120,
		"estate_req": 0,
		"reward_items": ["armor_knight", "sword_knight", "war_horn"],
		"bonus_hp": 25.0,
		"desc": "Благородный защитник короны, посвященный мечом в Замке Нортвуд. Получает полный рыцарский доспех, благородный меч и боевой рог."
	},
	"baron": {
		"id": "baron",
		"rank": 3,
		"name": "Барон-Феодал",
		"icon": "👑",
		"prefix": "Барон",
		"renown_req": 120,
		"honor_req": 80,
		"gold_req": 300,
		"estate_req": 2,
		"reward_items": [],
		"estate_income_bonus": 15,
		"desc": "Высокородный феодал и наместник земель. Поместье приносит +15 золотых дополнительного дохода ежедневно."
	}
}

const TITLE_ORDER := ["commoner", "squire", "knight", "baron"]

static func get_title_def(title_id: String) -> Dictionary:
	return TITLES.get(title_id, TITLES["commoner"])

static func get_next_title(current_title: String) -> Dictionary:
	var idx = TITLE_ORDER.find(current_title)
	if idx >= 0 and idx < TITLE_ORDER.size() - 1:
		return TITLES[TITLE_ORDER[idx + 1]]
	return {}

static func can_promote(p: CharacterData) -> Dictionary:
	if not p: return {"can_promote": false, "reason": "Нет данных персонажа"}
	var cur_title = p.get("nobility_title")
	if cur_title == "": cur_title = "commoner"
	
	var next = get_next_title(cur_title)
	if next.is_empty():
		return {"can_promote": false, "reason": "Вы уже достигли высшего дворянского титула Барона!"}
		
	if p.renown < next.get("renown_req", 0):
		return {"can_promote": false, "reason": "Недостаточно Славы (требуется %d, у вас %d)!" % [next["renown_req"], p.renown]}
	if p.honor < next.get("honor_req", 0):
		return {"can_promote": false, "reason": "Недостаточно Чести (требуется %d, у вас %d)!" % [next["honor_req"], p.honor]}
	if p.gold < next.get("gold_req", 0):
		return {"can_promote": false, "reason": "Недостаточно золота для пошлины (требуется %d з., у вас %d з.)!" % [next["gold_req"], p.gold]}
	if next.get("estate_req", 0) > 0 and p.estate_level < next["estate_req"]:
		return {"can_promote": false, "reason": "Требуется поместье уровня %d (у вас %d ур.)!" % [next["estate_req"], p.estate_level]}
		
	return {"can_promote": true, "next_title": next}

static func promote(p: CharacterData) -> Dictionary:
	var check = can_promote(p)
	if not check.get("can_promote", false):
		return {"success": false, "reason": check.get("reason", "Невозможно повысить титул")}
		
	var next = check["next_title"]
	p.gold -= next.get("gold_req", 0)
	p.nobility_title = next["id"]
	p.nobility_rank = next["rank"]
	
	# Выдача наград
	for it_id in next.get("reward_items", []):
		p.add_item(it_id, 1)
		
	return {"success": true, "title": next}
