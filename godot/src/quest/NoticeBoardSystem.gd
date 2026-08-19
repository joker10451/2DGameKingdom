class_name NoticeBoardSystem
extends RefCounted

## ДОСКА ОБЪЯВЛЕНИЙ И ГОРОДСКИХ КОНТРАКТОВ (НА ПЛОЩАДИ 25, 29)
## Управляет выдачей контрактов стражи, гильдий и поиском реликвий

var contracts: Array[Dictionary] = []
var active_contract_id: String = ""
var completed_contracts: Array[String] = []

func _init() -> void:
	generate_default_contracts()

func generate_default_contracts() -> void:
	contracts = [
		{
			"id": "contract_wolves",
			"title": "📜 Контракт Стражи: Истребление волчьей стаи",
			"desc": "В северном лесу замечена стая диких волков, пугающая крестьян и скот. Добудьте 4 волчьих шкуры.",
			"issuer": "Капитан Стражи",
			"req_items": {"wolf_pelt": 4},
			"rewards": {"gold": 45, "renown": 15},
			"status": "available"
		},
		{
			"id": "contract_wood_supply",
			"title": "📜 Заказ Гильдии Строителей: Поставка Дубового Бруса",
			"desc": "Для починки моста и частокола требуется 12 дубовых брёвен высокого качества.",
			"issuer": "Главный Плотник",
			"req_items": {"wood": 12},
			"rewards": {"gold": 30, "renown": 10},
			"status": "available"
		},
		{
			"id": "contract_iron_ingots",
			"title": "📜 Военный Заказ: Слитки для Кузни Гарнизона",
			"desc": "Гарнизону замка срочно нужны 6 железных слитков для ковки наконечников копий и стрел.",
			"issuer": "Оружейник Замка",
			"req_items": {"iron_ingot": 6},
			"rewards": {"gold": 50, "renown": 20},
			"status": "available"
		},
		{
			"id": "contract_ale_supply",
			"title": "📜 Праздничный Заказ: Закупка Бочонков Эля",
			"desc": "К дню весеннего равноденствия таверне требуется 6 кружек отборного ячменного эля.",
			"issuer": "Трактирщица",
			"req_items": {"ale": 6},
			"rewards": {"gold": 36, "renown": 8},
			"status": "available"
		}
	]

func get_available_contracts() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for c in contracts:
		if c["status"] == "available":
			list.append(c)
	return list

func accept_contract(contract_id: String) -> bool:
	for c in contracts:
		if c["id"] == contract_id and c["status"] == "available":
			c["status"] = "active"
			active_contract_id = contract_id
			return true
	return false

func can_complete_contract(contract_id: String, player_inventory: Dictionary) -> bool:
	for c in contracts:
		if c["id"] == contract_id and c["status"] == "active":
			for item_id in c["req_items"].keys():
				var req: int = c["req_items"][item_id]
				var cur: int = player_inventory.get(item_id, 0)
				if cur < req:
					return false
			return true
	return false

func complete_contract(contract_id: String, player_data: CharacterData) -> Dictionary:
	if not can_complete_contract(contract_id, player_data.inventory):
		return {}
	
	for c in contracts:
		if c["id"] == contract_id and c["status"] == "active":
			for item_id in c["req_items"].keys():
				player_data.remove_item(item_id, c["req_items"][item_id])
				
			var rew: Dictionary = c["rewards"]
			if rew.has("gold"):
				player_data.gold += rew["gold"]
			if rew.has("renown"):
				player_data.renown += rew["renown"]
				
			c["status"] = "completed"
			completed_contracts.append(contract_id)
			if active_contract_id == contract_id:
				active_contract_id = ""
			return rew
	return {}
