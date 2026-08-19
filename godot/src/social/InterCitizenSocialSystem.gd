class_name InterCitizenSocialSystem
extends RefCounted

## СИСТЕМА МЕЖЛИЧНОСТНЫХ ОТНОШЕНИЙ И ПОТАСОВОК В ТАВЕРНЕ
## Управляет социализацией горожан, вечерними посиделками и драками в таверне

signal tavern_brawl_started(brawlers: Array)
signal tavern_brawl_resolved(outcome: Dictionary)

var is_brawl_active: bool = false
var brawler_a: Dictionary = {}
var brawler_b: Dictionary = {}

func check_evening_tavern_social(hour: int, npcs: Array) -> Dictionary:
	# Вечерний сбор в таверне (19:00 - 23:00)
	if hour >= 19 and hour <= 23 and not is_brawl_active:
		# 25% шанс потасовки между подвыпившими жителями
		if randf() < 0.25 and npcs.size() >= 2:
			return start_tavern_brawl(npcs[0], npcs[1])
	return {}

func start_tavern_brawl(npc1: Dictionary, npc2: Dictionary) -> Dictionary:
	is_brawl_active = true
	brawler_a = npc1
	brawler_b = npc2
	
	var res = {
		"started": true,
		"npc_a": npc1.get("name", "Житель 1"),
		"npc_b": npc2.get("name", "Житель 2"),
		"msg": "🍻 В ТАВЕРНЕ ВСПЫХНУЛА ДРАКА! %s и %s сцепились из-за пролитого эля! Звон кружек и крики посетителей!" % [npc1.get("name", "Житель 1"), npc2.get("name", "Житель 2")]
	}
	tavern_brawl_started.emit([npc1, npc2])
	return res

func resolve_brawl_buy_ale(player_data: CharacterData) -> Dictionary:
	if not is_brawl_active: return {}
	
	var cost = 15
	if player_data and player_data.gold >= cost:
		player_data.gold -= cost
		player_data.renown += 10
		player_data.honor += 15
		
	is_brawl_active = false
	
	var res = {
		"success": true,
		"msg": "🍺 «ЭЙ, БРОДЯГИ! ВЫПИВКА ЗА СЧЕТ ЛОРДА!» — вы выставили бочонок отборного эля! Драчуны обнялись и подняли тост за ваше здоровье (+15 чести, +10 славы)!"
	}
	tavern_brawl_resolved.emit(res)
	return res

func resolve_brawl_guards() -> Dictionary:
	if not is_brawl_active: return {}
	is_brawl_active = false
	var res = {
		"success": true,
		"msg": "🛡️ «СТРАЖА, РАЗНЯТЬ СКАНДАЛИСТОВ!» — стражники растащили драчунов по углам. В таверне воцарился порядок (+10 к закону)!"
	}
	tavern_brawl_resolved.emit(res)
	return res
