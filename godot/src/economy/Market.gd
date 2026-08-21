class_name Market
extends Node

## Динамический рынок с ценообразованием на основе спроса и предложения

# Базовые цены товаров
var base_prices: Dictionary = {
	"grain": 2.0,
	"wheat": 2.0,
	"bread": 4.0,
	"flour": 4.0,
	"meat": 7.0,
	"ale": 5.0,
	"wood": 3.0,
	"plank": 4.0,
	"iron_ore": 6.0,
	"iron_ingot": 22.0,
	"tools": 15.0,
	"sword_1h": 35.0,
	"dagger_iron": 20.0,
	"shield_badge": 35.0,
	"shield_wood": 20.0,
	"bow": 35.0,
	"arrows": 2.0,
	"leather": 16.0,
	"wolf_pelt": 24.0,
	"armor": 80.0
}

# Текущий запас на рынке (Supply)
var inventory: Dictionary = {
	"grain": 100,
	"wheat": 60,
	"bread": 40,
	"flour": 30,
	"meat": 20,
	"ale": 30,
	"wood": 80,
	"plank": 40,
	"iron_ore": 30,
	"iron_ingot": 15,
	"tools": 15,
	"sword_1h": 5,
	"dagger_iron": 8,
	"shield_badge": 6,
	"shield_wood": 10,
	"bow": 6,
	"arrows": 60,
	"leather": 20,
	"wolf_pelt": 12,
	"armor": 2
}

# Спрос (Demand) - целевой желаемый объем запасов
var target_demand: Dictionary = {
	"grain": 100,
	"wheat": 60,
	"bread": 50,
	"flour": 30,
	"meat": 25,
	"ale": 35,
	"wood": 60,
	"plank": 40,
	"iron_ore": 25,
	"iron_ingot": 15,
	"tools": 10,
	"sword_1h": 5,
	"dagger_iron": 8,
	"shield_badge": 6,
	"shield_wood": 10,
	"bow": 6,
	"arrows": 60,
	"leather": 20,
	"wolf_pelt": 12,
	"armor": 2
}

func get_current_price(item_id: String) -> float:
	var base = base_prices.get(item_id, float(ItemDatabase.get_item(item_id).get("value", 5)))
	var supply = float(inventory.get(item_id, 10))
	var demand = float(target_demand.get(item_id, 10))
	
	# Формула ценообразования: при дефиците цена растет, при избытке падает
	var ratio = demand / maxf(1.0, supply)
	var multiplier = clampf(pow(ratio, 0.7), 0.3, 3.5)
	return snappedf(base * multiplier, 0.1)

func buy_from_market(buyer_data: CharacterData, item_id: String, amount: int = 1) -> bool:
	var current_stock = inventory.get(item_id, 0)
	if current_stock < amount:
		return false
	
	var price_per_unit = get_current_price(item_id)
	var total_cost = int(ceil(price_per_unit * amount))
	
	if buyer_data.gold < total_cost:
		return false
	
	buyer_data.gold -= total_cost
	buyer_data.add_item(item_id, amount)
	inventory[item_id] = current_stock - amount
	
	var root = Engine.get_main_loop().root if Engine.get_main_loop() else null
	var eb = root.get_node_or_null("EventBus") if root else null
	if eb:
		eb.transaction_completed.emit(null, null, item_id, amount, float(total_cost))
	return true

func sell_to_market(seller_data: CharacterData, item_id: String, amount: int = 1) -> bool:
	if seller_data.get_item_count(item_id) < amount:
		return false
	
	var price_per_unit = get_current_price(item_id)
	var total_payout = int(floor(price_per_unit * 0.8 * amount)) # 20% маржа рынка
	
	if not seller_data.remove_item(item_id, amount):
		return false
	
	seller_data.gold += total_payout
	inventory[item_id] = inventory.get(item_id, 0) + amount
	
	var root2 = Engine.get_main_loop().root if Engine.get_main_loop() else null
	var eb2 = root2.get_node_or_null("EventBus") if root2 else null
	if eb2:
		eb2.transaction_completed.emit(null, null, item_id, amount, float(total_payout))
	return true
