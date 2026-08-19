class_name HierarchyManager
extends Node

## Управление феодальной иерархией, титулами и сменой ролей

# Список доступных ролей
const ROLES = {
	"Крестьянин": {
		"tier": 0,
		"req_gold": 0,
		"req_renown": 0,
		"description": "Простой труженик земли. Обеспечивает поселение едой и сырьем."
	},
	"Торговец": {
		"tier": 1,
		"req_gold": 30,
		"req_renown": 10,
		"description": "Спекулирует товарами между поселениями, нанимает охрану."
	},
	"Бандит": {
		"tier": 1,
		"req_gold": 0,
		"req_renown": 5,
		"description": "Живет разбоем, грабит караваны и скрывается от правосудия."
	},
	"Стражник": {
		"tier": 1,
		"req_gold": 10,
		"req_renown": 15,
		"description": "Охраняет городские ворота и карает преступников по закону."
	},
	"Ремесленник": {
		"tier": 1,
		"req_gold": 40,
		"req_renown": 15,
		"description": "Производит инструменты, оружие и броню в собственной мастерской."
	},
	"Лорд": {
		"tier": 2,
		"req_gold": 250,
		"req_renown": 100,
		"description": "Владеет замком и землями, собирает налоги и вершит суд."
	},
	"Король": {
		"tier": 3,
		"req_gold": 1000,
		"req_renown": 500,
		"description": "Повелитель королевства. Ведет войны, жалует титулы и управляет государством."
	}
}

static func can_assume_role(data: CharacterData, target_role: String) -> Dictionary:
	if not ROLES.has(target_role):
		return {"allowed": false, "reason": "Неизвестная роль"}
	
	var req = ROLES[target_role]
	if data.gold < req["req_gold"]:
		return {"allowed": false, "reason": "Недостаточно золота (требуется %d, у вас %d)" % [req["req_gold"], data.gold]}
	if data.renown < req["req_renown"]:
		return {"allowed": false, "reason": "Недостаточно известности (требуется %d, у вас %d)" % [req["req_renown"], data.renown]}
	
	return {"allowed": true, "reason": "Условия выполнены"}

static func change_role(data: CharacterData, new_role: String) -> bool:
	var check = can_assume_role(data, new_role)
	if not check["allowed"]:
		return false
	
	var old_role = data.current_role
	data.current_role = new_role
	
	# Настройка префикса титула
	match new_role:
		"Лорд":
			data.title_prefix = "Лорд"
		"Король":
			data.title_prefix = "Его Величество"
		"Бандит":
			data.title_prefix = "Атаман" if data.renown > 50 else "Разбойник"
		_:
			data.title_prefix = ""
	
	var root = Engine.get_main_loop().root if Engine.get_main_loop() else null
	var eb = root.get_node_or_null("EventBus") if root else null
	if eb:
		eb.character_role_changed.emit(null, old_role, new_role)
	return true
