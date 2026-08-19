class_name ApprenticeshipSystem
extends RefCounted

## ИНСТИТУТ ПОДМАСТЕРЬЕВ И ПЕРЕДАЧИ МАСТЕРСТВА
## Позволяет прикреплять молодых жителей к опытным мастерам

# apprentices: apprentice_id -> {mentor_id: String, craft: String, days_trained: int}
var apprentices: Dictionary = {}

func assign_apprentice(apprentice_id: String, apprentice_name: String, mentor_id: String, mentor_name: String, craft: String) -> Dictionary:
	apprentices[apprentice_id] = {
		"mentor_id": mentor_id,
		"mentor_name": mentor_name,
		"apprentice_name": apprentice_name,
		"craft": craft,
		"days_trained": 0
	}
	
	var craft_ru = {
		"smithing": "Кузнечного дела",
		"farming": "Земледелия",
		"baking": "Пекарского мастерства"
	}.get(craft, craft)
	
	return {
		"success": true,
		"msg": "📜 НАЗНАЧЕН ПОДМАСТЕРЬЕ! %s стал учеником мастера %s по направлению %s!" % [apprentice_name, mentor_name, craft_ru]
	}

func process_daily_mentorship(learning_system: RefCounted) -> Array[String]:
	var reports: Array[String] = []
	if not learning_system: return reports
	
	for app_id in apprentices.keys():
		var data = apprentices[app_id]
		data["days_trained"] += 1
		var res = learning_system.teach_skill(app_id, data["craft"])
		if res.get("lvl_up", false):
			reports.append("🌟 Подмастерье %s достиг нового уровня под руководством мастера %s!" % [data["apprentice_name"], data["mentor_name"]])
			
	return reports
