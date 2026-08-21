class_name TradeCaravanSystem
extends RefCounted

## СИСТЕМА ТОРГОВЫХ КАРАВАНОВ И ТАКТИЧЕСКИХ ОБОЗОВ
## Управляет перемещением караванов по глобальной карте, засадами и прибылью

# active_caravans: Array of {
#   id: int, dest_city_id: String, city_name: String, goods_type: String, goods_amount: int,
#   escort_cost: int, escort_risk: float, escort_name: String,
#   progress: float (0.0..1.0), total_hours: float, current_hours: float,
#   start_tile: Vector2i, end_tile: Vector2i, current_map_pos: Vector2,
#   is_returning: bool, status: String, base_profit: int
# }
var active_caravans: Array[Dictionary] = []
var _next_caravan_id: int = 1

const CITY_COORDS := {
	"olderia": Vector2i(54, 70),
	"ironhold": Vector2i(64, 25),
	"goldvale": Vector2i(95, 65),
	"blackwood": Vector2i(25, 45),
	"highkeep": Vector2i(64, 64)
}

func dispatch_active_caravan(dest_city_id: String, goods_type: String, goods_amount: int, escort_cost: int, escort_risk: float, escort_name: String, player_data: CharacterData, regional_map: RefCounted) -> Dictionary:
	var city_name = "Соседний полис"
	if regional_map and regional_map.has_method("get_city"):
		var c = regional_map.get_city(dest_city_id)
		if not c.is_empty():
			city_name = c.get("name", city_name)

	# Списание стоимости найма охраны
	if player_data and escort_cost > 0:
		player_data.gold = max(0, player_data.gold - escort_cost)

	var start_coord = CITY_COORDS.get("olderia", Vector2i(54, 70))
	var end_coord = CITY_COORDS.get(dest_city_id, Vector2i(64, 64))

	var base_profit = 100
	if dest_city_id == "ironhold" and (goods_type == "grain" or goods_type == "bread"):
		base_profit = 150
	elif dest_city_id == "goldvale" and (goods_type == "timber" or goods_type == "tools"):
		base_profit = 130
	elif dest_city_id == "blackwood" and (goods_type == "swords" or goods_type == "iron_ingots"):
		base_profit = 120
	elif dest_city_id == "highkeep":
		base_profit = 180

	var caravan_entry = {
		"id": _next_caravan_id,
		"dest_city_id": dest_city_id,
		"city_name": city_name,
		"goods_type": goods_type,
		"goods_amount": goods_amount,
		"escort_cost": escort_cost,
		"escort_risk": escort_risk,
		"escort_name": escort_name,
		"progress": 0.0,
		"total_hours": 24.0, # 1 игровой день на маршрут
		"current_hours": 0.0,
		"start_tile": start_coord,
		"end_tile": end_coord,
		"current_map_pos": Vector2(start_coord.x * 36 + 18, start_coord.y * 36 + 18),
		"is_returning": false,
		"status": "В пути в %s" % city_name,
		"base_profit": base_profit
	}
	_next_caravan_id += 1
	active_caravans.append(caravan_entry)

	return {
		"success": true,
		"caravan": caravan_entry,
		"msg": "🐫 Торговый обоз снаряжен и отправлен в %s! Груз: %s (%d шт.), Охрана: %s." % [city_name, goods_type, goods_amount, escort_name]
	}

func update_caravans(delta_hours: float, player_data: CharacterData, regional_map: RefCounted, diplomacy_sys: RefCounted = null) -> Array[Dictionary]:
	var events: Array[Dictionary] = []
	for i in range(active_caravans.size() - 1, -1, -1):
		var c = active_caravans[i]
		c["current_hours"] += delta_hours
		c["progress"] = clampf(c["current_hours"] / c["total_hours"], 0.0, 1.0)

		# Обновление позиции на карте
		var s_pos = Vector2(c["start_tile"].x * 36 + 18, c["start_tile"].y * 36 + 18)
		var e_pos = Vector2(c["end_tile"].x * 36 + 18, c["end_tile"].y * 36 + 18)
		if not c["is_returning"]:
			c["current_map_pos"] = s_pos.lerp(e_pos, c["progress"])
		else:
			c["current_map_pos"] = e_pos.lerp(s_pos, c["progress"])

		# Проверка засад бандитов на середине пути (progress ~ 0.5)
		if not c.get("ambush_checked", false) and c["progress"] >= 0.5:
			c["ambush_checked"] = true
			if randf() < c["escort_risk"]:
				# Засада!
				if c["escort_risk"] > 0.20:
					# Без достаточной охраны караван теряет часть золота
					c["base_profit"] = int(c["base_profit"] * 0.6)
					events.append({
						"type": "ambush_loss",
						"msg": "⚠️ [color=salmon]КАРАВАН ПОПАЛ В ЗАСАДУ! В Чернолесье разбойники напали на обоз в %s. Часть груза разграблена (прибыль снижена на 40%%)![/color]" % c["city_name"]
					})
				else:
					# Охрана отбила нападение
					events.append({
						"type": "ambush_repelled",
						"msg": "🛡️ [color=lightgreen]Охрана каравана (%s) успешно отбила засаду лесных разбойников на тракте в %s![/color]" % [c["escort_name"], c["city_name"]]
					})

		# Достижение цели
		if c["progress"] >= 1.0:
			if not c["is_returning"]:
				# Прибыли в город назначения, разгрузились, едем назад
				c["is_returning"] = true
				c["progress"] = 0.0
				c["current_hours"] = 0.0
				c["status"] = "Возвращается из %s" % c["city_name"]
				events.append({
					"type": "arrived_destination",
					"msg": "🐫 Торговый обоз успешно прибыл в %s, распродал товары и везет выручку обратно в Олдерию!" % c["city_name"]
				})
			else:
				# Караван вернулся домой в Олдерию!
				var profit = c["base_profit"] + randi_range(-10, 20)
				
				# Бонус от торгового пакта
				if diplomacy_sys and diplomacy_sys.active_treaties.get(c["dest_city_id"] + "_trade", false):
					profit = int(profit * 1.25)

				if player_data:
					player_data.gold += profit
					player_data.renown += 12

				if regional_map and regional_map.has_method("change_relation"):
					regional_map.change_relation(c["dest_city_id"], 15)

				events.append({
					"type": "returned_home",
					"profit": profit,
					"msg": "🎉 [color=gold][b]КАРАВАН ВЕРНУЛСЯ В ОЛДЕРИЮ! Выручка с экспедиции в %s: +%d золотых (+12 Славы, +15 Отношений)![/b][/color]" % [c["city_name"], profit]
				})
				active_caravans.remove_at(i)

	return events
