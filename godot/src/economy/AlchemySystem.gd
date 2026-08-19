class_name AlchemySystem
extends RefCounted

## АЛХИМИЧЕСКАЯ ЛАБОРАТОРИЯ, ТРАВНИЧЕСТВО И ЗЕЛЬЕВАРЕНИЕ

const RECIPES := {
	"potion_healing": {
		"id": "potion_healing",
		"name": "💚 Зелье Исцеления",
		"icon": "🧪",
		"desc": "Мгновенно восстанавливает +60 здоровья (HP).",
		"cost": {"herb_hypericum": 2},
		"result": "potion_healing",
		"yield": 1
	},
	"potion_stoneskin": {
		"id": "potion_stoneskin",
		"name": "🛡️ Зелье Каменной Кожи",
		"icon": "🧪",
		"desc": "Делает кожу несокрушимой: +10 к защите (DEF) на 5 минут.",
		"cost": {"herb_moonroot": 2, "iron_ingot": 1},
		"result": "potion_stoneskin",
		"yield": 1
	},
	"potion_swiftness": {
		"id": "potion_swiftness",
		"name": "⚡ Эликсир Скорости",
		"icon": "🧪",
		"desc": "Увеличивает скорость передвижения на +35% на 5 минут.",
		"cost": {"herb_hypericum": 2, "honey": 1},
		"result": "potion_swiftness",
		"yield": 1
	},
	"poison_vial": {
		"id": "poison_vial",
		"name": "☠️ Смертоносный Яд",
		"icon": "☠️",
		"desc": "Смазывает клинок и наконечники стрел: +15 ядовитого урона.",
		"cost": {"herb_belladonna": 2},
		"result": "poison_vial",
		"yield": 1
	},
	"mead_brew": {
		"id": "mead_brew",
		"name": "🍺 Хмельная Медовуха",
		"icon": "🍺",
		"desc": "Снимает усталость, восстанавливает силы и повышает боевой дух.",
		"cost": {"honey": 2},
		"result": "mead",
		"yield": 2
	}
}

static func craft_recipe(p: CharacterData, recipe_id: String) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных персонажа"}
	var rec = RECIPES.get(recipe_id, {})
	if rec.is_empty():
		return {"success": false, "reason": "Рецепт не найден"}
		
	var cost = rec.get("cost", {})
	for it_id in cost.keys():
		if p.get_item_count(it_id) < cost[it_id]:
			var it = ItemDatabase.get_item(it_id)
			return {"success": false, "reason": "Недостаточно ингредиента: %s (требуется %d шт.)" % [it.get("name", it_id), cost[it_id]]}
			
	# Списание ингредиентов
	for it_id in cost.keys():
		p.remove_item(it_id, cost[it_id])
		
	var res_id = rec.get("result", "potion_healing")
	var amount = rec.get("yield", 1)
	p.inventory[res_id] = p.inventory.get(res_id, 0) + amount
	p.add_skill_xp("survival", 30.0)
	
	return {
		"success": true,
		"name": rec.get("name", ""),
		"yield": amount
	}
