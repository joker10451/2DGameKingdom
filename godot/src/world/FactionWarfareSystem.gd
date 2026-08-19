class_name FactionWarfareSystem
extends RefCounted

## СИСТЕМА ВОЙНЫ ФРАКЦИЙ И ОСАД ПОСЕЛЕНИЯ
## Управляет вторжениями вражеских армий, обороной стен и мирными договорами с контрибуцией

var is_at_war: bool = false
var enemy_faction_name: String = ""

func declare_war(faction_name: String = "Чернолесье") -> Dictionary:
	is_at_war = true
	enemy_faction_name = faction_name
	return {
		"started": true,
		"faction": faction_name,
		"msg": "⚔️ ВОЙНА ОБЪЯВЛЕНА! Вражеская армия фракции «%s» подошла к стенам Олдерии и начала осаду ворот!" % faction_name
	}

func repel_siege_and_sign_peace(player_data: CharacterData, regional_map: RefCounted) -> Dictionary:
	if not is_at_war: return {}
	
	is_at_war = false
	var reparations = 200
	if player_data:
		player_data.gold += reparations
		player_data.renown += 35
		player_data.honor += 20
		
	if regional_map and regional_map.has_method("change_relation"):
		regional_map.change_relation("blackwood", 30)
		
	return {
		"success": true,
		"reparations": reparations,
		"msg": "👑 ОСАДА ОТРАЖЕНА! Вражеский командующий повержен и запросил пощады! Подписан Вечный Мир, выплачена контрибуция в %d золотых (+35 славы, +20 чести)!" % reparations
	}
