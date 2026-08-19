class_name DungeonBossSystem
extends RefCounted

## БОСС И БЕСТИАРИЙ СКЛЕПА ЗАБЫТЫХ
## Управляет боссом Проклятым Рыцарем Мальгримом, скелетами и легендарными трофеями

var is_boss_defeated: bool = false

func get_boss_malgrim_data() -> Dictionary:
	return {
		"id": "boss_knight_malgrim",
		"name": "💀 Проклятый Рыцарь Мальгрим",
		"role": "Босс Склепа",
		"hp": 250.0,
		"max_hp": 250.0,
		"dmg": 25,
		"pos": Vector2(22 * 48, 22 * 48),
		"is_boss": true,
		"gold": 150,
		"renown": 50,
		"drop_item": "sword_paladin_sun"
	}

func get_dungeon_minions() -> Array[Dictionary]:
	return [
		{
			"id": "skel_1",
			"name": "Скелет-Мечник 💀",
			"role": "Нежить",
			"hp": 45.0,
			"max_hp": 45.0,
			"dmg": 12,
			"pos": Vector2(19 * 48, 5 * 48),
			"gold": 10
		},
		{
			"id": "skel_2",
			"name": "Скелет-Страж 💀",
			"role": "Нежить",
			"hp": 55.0,
			"max_hp": 55.0,
			"dmg": 14,
			"pos": Vector2(5 * 48, 19 * 48),
			"gold": 12
		},
		{
			"id": "spider_1",
			"name": "Пещерный Паук 🕷️",
			"role": "Хищник Склепа",
			"hp": 35.0,
			"max_hp": 35.0,
			"dmg": 10,
			"pos": Vector2(18 * 48, 21 * 48),
			"gold": 5
		}
	]

func on_boss_killed(player_data: CharacterData) -> Dictionary:
	is_boss_defeated = true
	var reward = {
		"gold": 150,
		"renown": 50,
		"items": {
			"sword_paladin_sun": 1,
			"ring_undying": 1,
			"gem_ruby": 3
		},
		"msg": "🏆 ВЫ ОДОЛЕЛИ ПРОКЛЯТОГО РЫЦАРЯ МАЛЬГРИМА! Получен Паладинский Клинок Света 🗡️, Кольцо Бессмертия 💍, +150 золота и +50 славы!"
	}
	
	if player_data:
		player_data.gold += reward["gold"]
		player_data.renown += reward["renown"]
		for it_id in reward["items"].keys():
			player_data.add_item(it_id, reward["items"][it_id])
			
	return reward
