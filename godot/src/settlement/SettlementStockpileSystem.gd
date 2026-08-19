class_name SettlementStockpileSystem
extends RefCounted

## СИСТЕМА СКЛАДОВ, АМБАРОВ И ЛОГИСТИКИ ПОСЕЛЕНИЯ
## Управляет запасами провизии, древесины, металлов и оружия для ополчения

var stockpiles: Dictionary = {
	"bread": 45,        # Буханки хлеба в зерновом амбаре
	"grain": 80,        # Мешки зерна на мельнице
	"timber": 120,      # Строительный дубовый брус
	"iron_ingots": 35,  # Слитки железа в кузнице
	"swords": 12,       # Мечи в арсенале
	"shields": 10,      # Щиты ополчения
	"bows": 8           # Луки стражи
}

func add_resource(res_name: String, amount: int) -> void:
	if not stockpiles.has(res_name):
		stockpiles[res_name] = 0
	stockpiles[res_name] += amount

func consume_daily_food(population: int = 15) -> Dictionary:
	var needed = population
	var consumed = min(stockpiles.get("bread", 0), needed)
	stockpiles["bread"] -= consumed
	
	var is_starving = consumed < needed
	return {
		"consumed": consumed,
		"needed": needed,
		"starving": is_starving,
		"remaining_bread": stockpiles["bread"]
	}

func get_stockpile_text() -> String:
	return """🌾 Зерновой Амбар: %d мешков зерна, %d буханок хлеба
🪵 Лесной Двор: %d дубового бруса
🧱 Склад Металла: %d слитков синего чугуна
⚔️ Арсенал Оружия: %d мечей, %d щитов, %d луков""" % [
		stockpiles["grain"], stockpiles["bread"],
		stockpiles["timber"],
		stockpiles["iron_ingots"],
		stockpiles["swords"], stockpiles["shields"], stockpiles["bows"]
	]
