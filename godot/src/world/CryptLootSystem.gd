class_name CryptLootSystem
extends RefCounted

## СИСТЕМА ДРЕВНИХ СОКРОВИЩ И НАГРАД СКЛЕПА
## Выдает легендарное оружие, перстни и королевское золото за победу над боссом

var is_looted: bool = false

func open_royal_chest(player_data: CharacterData) -> Dictionary:
	if is_looted:
		return {"success": false, "msg": "Королевский сундук уже опустошен."}
		
	is_looted = true
	var gold_reward = 250
	
	if player_data:
		player_data.gold += gold_reward
		player_data.renown += 50
		player_data.honor += 30
		if not player_data.inventory.has("sword_dark_blade"):
			player_data.inventory["sword_dark_blade"] = 1
		if not player_data.inventory.has("ring_ancient_kings"):
			player_data.inventory["ring_ancient_kings"] = 1
			
	return {
		"success": true,
		"gold": gold_reward,
		"items": ["⚔️ Клинок Вечной Тьмы (+32 Урона)", "💍 Перстень Древних Королей (+40 HP)"],
		"msg": "👑 ВЫ ОТКРЫЛИ КОРОЛЕВСКИЙ СУНДУК МАЛГОРА! Получено: %d золота, Клинок Вечной Тьмы, Перстень Королей (+50 славы, +30 чести)!" % gold_reward
	}
