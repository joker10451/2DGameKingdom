class_name CitizenQuestSystem
extends RefCounted

## СИСТЕМА ПЕРСОНАЛЬНЫХ КВЕСТОВ И ПОРУЧЕНИЙ ГОРОЖАН
## Управляет выдачей сюжетных и процедурных заданий от жителей Олдерии

const QUEST_DEFS := {
	"quest_farmer_harvest": {
		"id": "quest_farmer_harvest",
		"giver_role": "Крестьянин",
		"giver_name": "Радмир",
		"title": "🌾 Жатва до Дождей",
		"desc": "Фермер Радмир не успевает убрать пшеницу на полях до наступления дождей. Помогите собрать 8 снопов пшеницы.",
		"type": "gather",
		"req_reputation": 0,
		"req_renown": 0,
		"req_items": {"wheat": 8},
		"rewards": {
			"gold": 20,
			"items": {"bread": 5},
			"renown": 6,
			"reputation": 20
		}
	},
	"quest_smith_ore": {
		"id": "quest_smith_ore",
		"giver_role": "Кузнец",
		"giver_name": "Вульфрик",
		"title": "⚒️ Жажда Стали",
		"desc": "Кузнец Вульфрик истратил все запасы железа на подковы для стражи. Принесите ему 5 кусков железной руды из лесных жил.",
		"type": "gather",
		"req_reputation": 0,
		"req_renown": 0,
		"req_items": {"iron_ore": 5},
		"rewards": {
			"gold": 30,
			"items": {"sword_iron": 1},
			"renown": 10,
			"reputation": 20
		}
	},
	"quest_herbalist_cure": {
		"id": "quest_herbalist_cure",
		"giver_role": "Знахарка",
		"giver_name": "Хильда",
		"title": "🌿 Снадобье от Хвори",
		"desc": "Знахарка Хильда варит целебный бальзам для крестьян. Ей нужны 3 цветка белладонны и 2 лунных корня.",
		"type": "gather",
		"req_reputation": 5,
		"req_renown": 5,
		"req_items": {"herb_belladonna": 3, "herb_moonroot": 2},
		"rewards": {
			"gold": 25,
			"items": {"potion_health": 3},
			"renown": 10,
			"reputation": 25
		}
	},
	"quest_tavern_feast": {
		"id": "quest_tavern_feast",
		"giver_role": "Трактирщица",
		"giver_name": "Доброгнева",
		"title": "🍺 Запасы к Празднику",
		"desc": "В таверну прибывают странники, запасы на исходе! Принесите трактирщице 4 буханки хлеба и 3 кружки доброго эля.",
		"type": "gather",
		"req_reputation": 10,
		"req_renown": 10,
		"req_items": {"bread": 4, "ale": 3},
		"rewards": {
			"gold": 40,
			"items": {"meat_roasted": 4},
			"renown": 15,
			"reputation": 30
		}
	},
	"quest_hunter_pelts": {
		"id": "quest_hunter_pelts",
		"giver_role": "Охотник",
		"giver_name": "Эйнар",
		"title": "🐺 Волчья Угроза",
		"desc": "Серая волчья стая бродит у опушки Чернолесья. Охотник Эйнар просит принести 3 волчьи шкуры для пошива теплых плащей.",
		"type": "gather",
		"req_reputation": 10,
		"req_renown": 15,
		"req_items": {"wolf_pelt": 3},
		"rewards": {
			"gold": 45,
			"items": {"bow_hunting": 1, "arrow": 25},
			"renown": 18,
			"reputation": 25
		}
	}
}

var active_quests: Dictionary = {} # quest_id -> {status: "active", progress: {}}
var completed_quests: Array[String] = []

func get_quest_def(quest_id: String) -> Dictionary:
	return QUEST_DEFS.get(quest_id, {})

func get_available_quest_for_npc(npc_role: String, npc_name: String, npc_rep: int = 0, player_renown: int = 0) -> Dictionary:
	for q_id in QUEST_DEFS.keys():
		if completed_quests.has(q_id) or active_quests.has(q_id):
			continue
		var q = QUEST_DEFS[q_id]
		if q["giver_role"] == npc_role or q["giver_name"] in npc_name or npc_role in q["giver_role"]:
			if npc_rep >= q.get("req_reputation", 0) and player_renown >= q.get("req_renown", 0):
				return q
	return {}

func get_active_quest_for_npc(npc_role: String, npc_name: String) -> Dictionary:
	for q_id in active_quests.keys():
		var q = QUEST_DEFS.get(q_id, {})
		if q.is_empty(): continue
		if q["giver_role"] == npc_role or q["giver_name"] in npc_name or npc_role in q["giver_role"]:
			return q
	return {}

func accept_quest(quest_id: String) -> bool:
	if not QUEST_DEFS.has(quest_id) or active_quests.has(quest_id):
		return false
	active_quests[quest_id] = {
		"status": "active",
		"accepted_time": Time.get_ticks_msec()
	}
	return true

func can_complete_quest(quest_id: String, player_inventory: Dictionary) -> bool:
	if not active_quests.has(quest_id):
		return false
	var q = QUEST_DEFS.get(quest_id, {})
	if q.is_empty(): return false
	
	for item_id in q["req_items"].keys():
		var req_amt: int = q["req_items"][item_id]
		var cur_amt: int = player_inventory.get(item_id, 0)
		if cur_amt < req_amt:
			return false
	return true

func complete_quest(quest_id: String, player_data: CharacterData) -> Dictionary:
	if not can_complete_quest(quest_id, player_data.inventory):
		return {}
	
	var q = QUEST_DEFS[quest_id]
	
	# Изъятие требуемых предметов
	for item_id in q["req_items"].keys():
		var req_amt: int = q["req_items"][item_id]
		player_data.remove_item(item_id, req_amt)
		
	# Выдача наград
	var rewards: Dictionary = q["rewards"]
	if rewards.has("gold"):
		player_data.gold += rewards["gold"]
	if rewards.has("renown"):
		player_data.renown += rewards["renown"]
	if rewards.has("items"):
		for it_id in rewards["items"].keys():
			player_data.add_item(it_id, rewards["items"][it_id])
			
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	
	return rewards

func get_current_primary_quest() -> Dictionary:
	if active_quests.is_empty():
		return {}
	var first_id = active_quests.keys()[0]
	return QUEST_DEFS.get(first_id, {})
