class_name BanditCampSystem
extends RefCounted

## РАЗБОЙНИЧИЙ ЛАГЕРЬ В ЧЕРНОЛЕСЬЕ (НА 8, 8)
## Управляет укрепленной базой бандитов, боссом Атаманом Браном и сокровищницей

var is_cleared: bool = false
var chieftain_alive: bool = true
var camp_center: Vector2i = Vector2i(8, 8)

func spawn_camp_structures(world_map: WorldMap2D) -> void:
	if not world_map: return
	
	# Частокол вокруг лагеря
	for dx in range(-3, 4):
		for dy in range(-3, 4):
			var p = camp_center + Vector2i(dx, dy)
			var is_edge = (abs(dx) == 3 or abs(dy) == 3)
			var is_entrance = (dx == 0 and dy == 3) # Южный вход
			
			if is_edge and not is_entrance:
				world_map.place_structure(p, "wooden_fence")
				
	# Костер бандитов и сундук с сокровищами
	world_map.place_structure(camp_center, "campfire")
	world_map.place_structure(camp_center + Vector2i(1, -1), "chest")

func get_chieftain_data() -> Dictionary:
	return {
		"id": "boss_chieftain_bran",
		"name": "Атаман Бран «Кровавый Топор» 🪓",
		"role": "Главарь Разбойников",
		"hp": 160.0,
		"max_hp": 160.0,
		"dmg": 20,
		"pos": Vector2(camp_center.x * 48, camp_center.y * 48),
		"is_boss": true,
		"gold": 65,
		"drop_item": "damascus_sword"
	}

func unlock_bandit_chest(player_data: CharacterData) -> Dictionary:
	if not player_data: return {}
	
	var reward = {
		"gold": 120,
		"renown": 30,
		"items": {
			"damascus_sword": 1,
			"gem_ruby": 2,
			"silk_fabric": 3
		}
	}
	
	player_data.gold += reward["gold"]
	player_data.renown += reward["renown"]
	for it_id in reward["items"].keys():
		player_data.add_item(it_id, reward["items"][it_id])
		
	is_cleared = true
	return reward
