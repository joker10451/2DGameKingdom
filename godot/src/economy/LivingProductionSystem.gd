class_name LivingProductionSystem
extends RefCounted

## LivingProductionSystem: Замкнутый производственный движок средневекового поселения
## Управляет цепочками трансформации ресурсов (Зерно -> Мука -> Хлеб -> Голод)

const RECIPES := {
	"farmer": {
		"title": "Сбор зерна на полях",
		"workplace_type": "farm_field",
		"inputs": {}, # Не требует сырья, только труд
		"outputs": {"grain": 2},
		"thought_icon": "🌾",
		"xp_skill": "farming",
		"wage": 1
	},
	"miller": {
		"title": "Помол зерна на мельнице",
		"workplace_type": "windmill",
		"inputs": {"grain": 2},
		"outputs": {"flour": 2},
		"thought_icon": "💨",
		"xp_skill": "farming",
		"wage": 2
	},
	"baker": {
		"title": "Выпечка хлеба в печи",
		"workplace_type": "bakery",
		"inputs": {"flour": 2},
		"outputs": {"bread": 2},
		"thought_icon": "🍞",
		"xp_skill": "cooking",
		"wage": 2
	},
	"blacksmith": {
		"title": "Выплавка и ковка железа",
		"workplace_type": "smithy",
		"inputs": {"iron_ore": 2, "wood": 1},
		"outputs": {"iron_ingots": 2},
		"thought_icon": "⚒️",
		"xp_skill": "smithing",
		"wage": 3
	},
	"woodcutter": {
		"title": "Распил бревен на доски",
		"workplace_type": "carpentry",
		"inputs": {"wood": 1},
		"outputs": {"plank": 3},
		"thought_icon": "🪓",
		"xp_skill": "woodcutting",
		"wage": 2
	},
	"hunter": {
		"title": "Охота и разделка дичи",
		"workplace_type": "forest",
		"inputs": {},
		"outputs": {"meat": 2, "leather": 1},
		"thought_icon": "🍗",
		"xp_skill": "hunting",
		"wage": 2
	}
}

static func get_recipe_for_role(role: String) -> Dictionary:
	var role_key = _normalize_role(role)
	return RECIPES.get(role_key, {})

static func execute_work_shift(role: String, stockpiles: Dictionary, worker_data: Object = null) -> Dictionary:
	var role_key = _normalize_role(role)
	if not RECIPES.has(role_key):
		return {"status": "no_recipe", "msg": "Для роли %s нет производственного рецепта" % role}

	var recipe: Dictionary = RECIPES[role_key]
	var inputs: Dictionary = recipe["inputs"]
	var outputs: Dictionary = recipe["outputs"]

	# 1. Проверка наличия всех входных ингредиентов
	for item_id in inputs.keys():
		var req_amt = inputs[item_id]
		var cur_amt = stockpiles.get(item_id, 0)
		if cur_amt < req_amt:
			return {
				"status": "missing_materials",
				"missing_item": item_id,
				"required": req_amt,
				"current": cur_amt,
				"thought_icon": "⏳",
				"msg": "⚠️ %s простаивает: на складе не хватает %s (нужно %d, есть %d)" % [role, item_id, req_amt, cur_amt]
			}

	# 2. Атомарное списание входных ресурсов
	for item_id in inputs.keys():
		stockpiles[item_id] = max(0, stockpiles.get(item_id, 0) - inputs[item_id])

	# 3. Атомарное зачисление готовой продукции
	for item_id in outputs.keys():
		stockpiles[item_id] = stockpiles.get(item_id, 0) + outputs[item_id]

	# 4. Выплата жалованья работнику (если передан CharacterData)
	var wage = recipe.get("wage", 1)
	if worker_data and "gold" in worker_data:
		worker_data.gold += wage

	return {
		"status": "success",
		"role": role,
		"produced": outputs,
		"consumed": inputs,
		"wage_paid": wage,
		"thought_icon": recipe.get("thought_icon", "⚒️"),
		"msg": "⚙️ %s: завершена смена. Произведено: %s, израсходовано: %s" % [role, str(outputs), str(inputs)]
	}

static func _normalize_role(role: String) -> String:
	match role:
		"farmer", "Хлебопашец", "Крестьянин", "Крестьянка", "Фермер":
			return "farmer"
		"miller", "Мельник", "Мельничиха":
			return "miller"
		"baker", "Пекарь", "Пекарша":
			return "baker"
		"blacksmith", "Кузнец", "Кузнечиха":
			return "blacksmith"
		"woodcutter", "Лесоруб", "Лесоруб-Плотник", "Плотник":
			return "woodcutter"
		"hunter", "Охотник", "Охотник-Егерь", "Егерь":
			return "hunter"
		_:
			return role.to_lower()
