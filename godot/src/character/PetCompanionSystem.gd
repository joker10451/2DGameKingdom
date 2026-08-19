class_name PetCompanionSystem
extends RefCounted

## СИСТЕМА ПИТОМЦА-КОМПАНЬОНА: ПРЕДАННЫЙ ПЕС И ТЕПЛО ДОМА

const PET_NAMES := [
	"Верный", "Гром", "Барбос", "Дружок", "Бран", "Лютый", "Рекс"
]

static func feed_pet(p: CharacterData, pet_data: Dictionary, food_id: String) -> Dictionary:
	if not p: return {"success": false, "reason": "Нет данных игрока"}
	
	if p.get_item_count(food_id) < 1:
		return {"success": false, "reason": "У вас нет этого угощения"}
		
	p.remove_item(food_id, 1)
	pet_data["is_tamed"] = true
	pet_data["loyalty"] = mini(100, int(pet_data.get("loyalty", 0)) + 35)
	pet_data["hunger"] = 100.0
	pet_data["state"] = "follow"
	
	if pet_data.get("name", "Бродячий пес") == "Бродячий пес":
		pet_data["name"] = "Верный"
		
	return {
		"success": true,
		"message": "Пес с жадностью съел угощение, благодарно лизнул вашу руку и с преданностью завилял хвостом! Теперь он ваш верный друг ❤️"
	}

static func pet_dog(pet_data: Dictionary) -> Dictionary:
	pet_data["loyalty"] = mini(100, int(pet_data.get("loyalty", 0)) + 10)
	var msgs = [
		"Вы ласково потрепали пса за ушком. Он довольно прикрыл глаза и прижался к вашей ноге ❤️",
		"Пес радостно заскулил и завилял хвостом от вашего внимания 🐕",
		"Вы погладили пса по теплой спине. В его глазах сияет безграничная собачья преданность ✨"
	]
	return {
		"success": true,
		"message": msgs[randi() % msgs.size()]
	}

static func give_paw(pet_data: Dictionary) -> Dictionary:
	return {
		"success": true,
		"message": "Пес с гордостью и доверием вложил свою мягкую теплую лапу вам в ладонь 🐾"
	}

static func get_combat_bite_damage(pet_data: Dictionary) -> float:
	var loyalty = float(pet_data.get("loyalty", 50))
	return 10.0 + (loyalty / 100.0) * 8.0 # 10..18 урона
