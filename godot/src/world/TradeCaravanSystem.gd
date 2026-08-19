class_name TradeCaravanSystem
extends RefCounted

## СИСТЕМА ТОРГОВЫХ КАРАВАНОВ
## Управляет снаряжением, охраной и прибылью купеческих караванов в соседние города

func dispatch_caravan(dest_city_id: String, goods_type: String, player_data: CharacterData, regional_map: RefCounted) -> Dictionary:
	var city_name = "Соседний город"
	if regional_map and regional_map.has_method("get_city"):
		var c = regional_map.get_city(dest_city_id)
		if not c.is_empty():
			city_name = c.get("name", city_name)
			
	# Расчет прибыли
	var base_profit = 85
	if dest_city_id == "ironhold" and goods_type == "grain":
		base_profit = 135 # Премия за дефицит зерна в Стальном Пределе
	elif dest_city_id == "goldvale" and goods_type == "timber":
		base_profit = 110
	elif dest_city_id == "highkeep":
		base_profit = 160
		
	var profit = base_profit + randi_range(-15, 25)
	
	if player_data:
		player_data.gold += profit
		player_data.renown += 10
		
	if regional_map and regional_map.has_method("change_relation"):
		regional_map.change_relation(dest_city_id, 15)
		
	return {
		"success": true,
		"profit": profit,
		"dest_city": city_name,
		"msg": "🐫 КАРАВАН УСПЕШНО ВЕРНУЛСЯ ИЗ %s! Продано товаров на сумму %d золотых (+10 славы, +15 к отношениям с городом)!" % [city_name, profit]
	}
