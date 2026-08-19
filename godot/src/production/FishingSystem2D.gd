class_name FishingSystem2D
extends RefCounted

## ИНТЕРАКТИВНАЯ СИСТЕМА РЫБАЛКИ НА РЕКЕ
## Управляет забросом поплавка, поклевками и выуживанием рыбы

var is_fishing: bool = false
var has_nibble: bool = false
var timer: float = 0.0
var nibble_time: float = 0.0
var water_target_pos: Vector2i = Vector2i.ZERO

func start_fishing(water_pos: Vector2i) -> Dictionary:
	is_fishing = true
	has_nibble = false
	timer = 0.0
	nibble_time = randf_range(3.0, 6.5)
	water_target_pos = water_pos
	
	return {
		"started": true,
		"msg": "🎣 Вы забросили леску в реку. Поплавок мерно покачивается на волнах... Ждите поклёвки!"
	}

func update(delta: float) -> Dictionary:
	if not is_fishing:
		return {}
		
	timer += delta
	if not has_nibble and timer >= nibble_time:
		has_nibble = true
		return {
			"nibble": true,
			"msg": "❗ ПОКЛЁВКА! Поплавок резко ушел под воду! Жмите [ E ] или [ Пробел ], чтобы подсечь!"
		}
	return {}

func reel_in(player_data: CharacterData) -> Dictionary:
	if not is_fishing:
		return {"success": false}
		
	is_fishing = false
	
	if not has_nibble:
		return {
			"success": false,
			"msg": "💨 Вы выдернули крючок слишком рано — рыба еще не успела клюнуть."
		}
		
	# Успешная подсечка
	has_nibble = false
	var roll = randf()
	
	if roll < 0.65:
		var fish_id = "fish_trout"
		var fish_name = "🐟 Серебристая Речная Форель"
		if player_data:
			player_data.add_item("steak", 2) # Питательное мясо рыбы
		return {
			"success": true,
			"name": fish_name,
			"msg": "🎣 ПОДСЕЧКА УДАЛАСЬ! Вы вытащили из воды: %s!" % fish_name
		}
	elif roll < 0.88:
		var sturgeon_name = "🐟 Царский Осетр"
		if player_data:
			player_data.gold += 25
			player_data.renown += 5
			player_data.add_item("steak", 3)
		return {
			"success": true,
			"name": sturgeon_name,
			"msg": "👑 РЕДКИЙ УЛОВ! Вы поймали огромного %s! (+25 золота, ценная дичь)!" % sturgeon_name
		}
	else:
		var gold_val = randi_range(15, 35)
		if player_data:
			player_data.gold += gold_val
			player_data.add_item("gem_ruby", 1)
		return {
			"success": true,
			"name": "📦 Затонувший Сундучок",
			"msg": "💎 НЕВЕРОЯТНО! На крючок попался %s со дна реки! Найдено: %d золота и рубин!" % ["📦 Затонувший Сундучок", gold_val]
		}
