class_name RegionalDiplomacySystem
extends RefCounted

## СИСТЕМА ДИПЛОМАТИИ И ФЕОДАЛЬНЫХ ПАКТОВ
## Управляет торговыми договорами, пактами о ненападении и военными союзами

var active_treaties: Dictionary = {}

func sign_trade_agreement(city_id: String, regional_map: RefCounted) -> Dictionary:
	active_treaties[city_id + "_trade"] = true
	if regional_map and regional_map.has_method("change_relation"):
		regional_map.change_relation(city_id, 25)
		
	return {
		"success": true,
		"type": "trade",
		"msg": "📜 ТОРГОВЫЙ ПАКТ ЗАКЛЮЧЕН! Пошлины снижены, доходы от караванов с этим городом увеличены на 25% (+25 к отношениям)!"
	}

func sign_non_aggression(city_id: String, regional_map: RefCounted) -> Dictionary:
	active_treaties[city_id + "_nap"] = true
	if regional_map and regional_map.has_method("change_relation"):
		regional_map.change_relation(city_id, 35)
		
	return {
		"success": true,
		"type": "nap",
		"msg": "🤝 ПАКТ О НЕНАПАДЕНИИ СКРЕПЛЕН ПЕЧАТЯМИ! Границы в безопасности, угроза вторжения снята (+35 к отношениям)!"
	}

func form_military_alliance(city_id: String, regional_map: RefCounted) -> Dictionary:
	active_treaties[city_id + "_alliance"] = true
	if regional_map and regional_map.has_method("change_relation"):
		regional_map.change_relation(city_id, 50)
		
	return {
		"success": true,
		"type": "alliance",
		"msg": "⚔️ ВОЕННЫЙ СОЮЗ ЗАКЛЮЧЕН! В случае вражеской осады союзный конный полк прибудет на защиту Олдерии (+50 к отношениям)!"
	}
