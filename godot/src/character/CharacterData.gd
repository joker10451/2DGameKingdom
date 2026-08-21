class_name CharacterData
extends Resource

## Данные персонажа (игрока или любого жителя)

# Личные данные
@export var id: String = ""
@export var character_name: String = "Безымянный"
@export var title_prefix: String = "" # сэр, лорд, ваше величество, атаман
@export var age: int = 25
@export var gender: String = "Мужской" # "Мужской", "Женский"
@export var current_role: String = "Крестьянин" # Крестьянин, Торговец, Бандит, Стражник, Ремесленник, Лорд, Король
@export var faction_id: String = "free_folk" # free_folk, crown, outlaw_brotherhood, merchants_guild
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var is_dead: bool = false
@export var reputation: int = 0
@export var workplace_id: String = ""

var name: String:
	get: return character_name
	set(val): character_name = val

# Характеристики (1..100)
@export var strength: int = 10       # Физический урон, переносимый вес
@export var agility: int = 10        # Скорость, ловкость, уклонение
@export var intelligence: int = 10   # Скорость обучения, хитрость, управление
@export var charisma: int = 10       # Торговля, убеждение, лояльность подчиненных

# Профессиональные навыки (0..100)
@export var combat_skill: int = 10
@export var crafting_skill: int = 10
@export var trading_skill: int = 10
@export var stealth_skill: int = 10
@export var governance_skill: int = 5

# Черты характера (влияют на Utility AI)
@export var traits: Array[String] = [] # "Жадный", "Амбициозный", "Честный", "Жестокий", "Трусливый", "Храбрый", "Щедрый"

# Финансы и Репутация
@export var gold: int = 10
@export var honor: int = 0      # -100 (отпетый мерзавец) .. +100 (рыцарь чести)
@export var renown: int = 0     # Известность в народе (0..1000)
@export var faction_reputation: Dictionary = {
	"crown": 0,
	"merchants": 0,
	"peasants": 10,
	"outlaws": 0
}

# Феодальные контракты и квесты
@export var active_contracts: Array[Dictionary] = []
@export var completed_contract_ids: Array[String] = []

# Инвентарь: item_id -> count
@export var inventory: Dictionary = {
	"sword_1h": 1,
	"shield_badge": 1,
	"bow": 1,
	"arrows": 30,
	"bread": 4,
	"meat": 2,
	"ale": 2,
	"iron_ore": 5,
	"iron_ingot": 2,
	"grain": 8
}

# Экипированные предметы
@export var equipped_weapon: String = "sword_1h"
@export var equipped_shield: String = "shield_badge"
@export var equipped_armor: String = ""

# Дружина и спутники игрока
@export var party_members: Array[Dictionary] = []

# Навыки мастерства (Soulash 2 Style)
@export var skills: Dictionary = {}
@export var mastery_points: int = 0

# Владения и подконтрольные люди (ID персонажей или зданий)
@export var owned_properties: Array[String] = [] # ["farm_01", "smithy_03", "castle_nord"]
@export var subordinates: Array[String] = []       # ID наемников/слуг/вассалов

# Феодальное Поместье и Батраки
@export var has_estate: bool = false
@export var estate_level: int = 1
@export var estate_workers: Array[String] = []
@export var estate_upgrades: Array[String] = []
@export var estate_storage: Dictionary = {}

# Дворянские титулы и рыцарство
@export var nobility_title: String = "commoner"
@export var nobility_rank: int = 0

# Kingdoms Sandbox: Стартовый путь и Собственное Поселение
@export var origin_role: String = ""
@export var settlement: Dictionary = {}

func ensure_skills() -> void:
	if skills.is_empty():
		skills = SkillSystem.create_default_skills()
	else:
		for s_id in SkillSystem.SKILL_DEFS.keys():
			if not skills.has(s_id):
				var def = SkillSystem.SKILL_DEFS[s_id]
				var p_list: Array[Dictionary] = []
				for p in def["perks"]:
					p_list.append({
						"id": p["id"],
						"name": p["name"],
						"req_level": p["req_level"],
						"desc": p["desc"],
						"unlocked": false
					})
				skills[s_id] = {
					"level": 1,
					"xp": 0.0,
					"perks": p_list
				}

func add_skill_xp(skill_id: String, amount: float) -> Dictionary:
	ensure_skills()
	return SkillSystem.add_skill_xp(skills, skill_id, amount)

func get_skill_level(skill_id: String) -> int:
	ensure_skills()
	return skills.get(skill_id, {}).get("level", 1)

func get_full_display_name() -> String:
	var pfx = ""
	match nobility_title:
		"squire": pfx = "Оруженосец"
		"knight": pfx = "Сэр"
		"baron": pfx = "Барон"
	if pfx != "":
		return "%s %s (%s)" % [pfx, character_name, pfx]
	if title_prefix != "":
		return "%s %s (%s)" % [title_prefix, character_name, current_role]
	return "%s (%s)" % [character_name, current_role]

func has_trait(trait_name: String) -> bool:
	return traits.has(trait_name)

func add_item(item_id: String, amount: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + amount
	if inventory[item_id] <= 0:
		inventory.erase(item_id)

func remove_item(item_id: String, amount: int = 1) -> bool:
	var current: int = inventory.get(item_id, 0)
	if current < amount:
		return false
	inventory[item_id] = current - amount
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	return true

func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

func to_dictionary() -> Dictionary:
	return {
		"character_name": character_name,
		"title_prefix": title_prefix,
		"age": age,
		"gender": gender,
		"current_role": current_role,
		"faction_id": faction_id,
		"strength": strength,
		"agility": agility,
		"intelligence": intelligence,
		"charisma": charisma,
		"combat_skill": combat_skill,
		"crafting_skill": crafting_skill,
		"trading_skill": trading_skill,
		"stealth_skill": stealth_skill,
		"governance_skill": governance_skill,
		"traits": traits.duplicate(),
		"gold": gold,
		"honor": honor,
		"renown": renown,
		"inventory": inventory.duplicate(),
		"owned_properties": owned_properties.duplicate(),
		"subordinates": subordinates.duplicate()
	}

static func from_dictionary(data: Dictionary) -> CharacterData:
	var obj = CharacterData.new()
	for key in data.keys():
		if key in obj:
			obj.set(key, data[key])
	return obj
