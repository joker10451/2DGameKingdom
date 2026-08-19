class_name DungeonTrapSystem
extends RefCounted

## СИСТЕМА ЛОВУШЕК И САРКОФАГОВ В ПОДЗЕМЕЛЬЕ
## Управляет нажимными плитами с шипами, ядовитыми ловушками и вскрытием гробниц

func check_trap(node_data: Dictionary, player_data: CharacterData) -> Dictionary:
	var t = node_data.get("type", "")
	if t == "trap_spikes":
		var dmg = node_data.get("dmg", 15)
		if player_data:
			player_data.take_damage(dmg)
		return {
			"triggered": true,
			"dmg": dmg,
			"msg": "⚠️ ЩЁЛК! Из каменных плит выскочили стальные шипы! Получено -%d урона!" % dmg
		}
	return {"triggered": false}

func open_sarcophagus(node_data: Dictionary, player_data: CharacterData) -> Dictionary:
	if node_data.get("is_opened", false):
		return {"opened": false, "msg": "⚰️ Этот саркофаг уже вскрыт и пуст."}
		
	node_data["is_opened"] = true
	
	# Шанс сокровищ или пробуждения призрака
	if randf() < 0.70:
		var gold_loot = randi_range(35, 75)
		if player_data:
			player_data.gold += gold_loot
			player_data.renown += 10
			player_data.add_item("gem_ruby", 1)
		return {
			"opened": true,
			"has_loot": true,
			"gold": gold_loot,
			"msg": "⚰️ Вы сдвинули тяжелую каменную плиту саркофага! Найдено: %d золота, древний рубин и позолоченная чаша!" % gold_loot
		}
	else:
		return {
			"opened": true,
			"has_loot": false,
			"spawn_wraith": true,
			"msg": "👻 Из глубин саркофага с леденящим воем поднялся Призрак Древнего Рыцаря!"
		}
