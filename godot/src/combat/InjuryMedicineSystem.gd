class_name InjuryMedicineSystem
extends RefCounted

## СИСТЕМА ТРАВМ И ПОЛЕВОЙ МЕДИЦИНЫ
## Управляет кровотечениями, травмами конечностей и их исцелением

var is_bleeding: bool = false
var is_limping: bool = false
var bleed_accum: float = 0.0

func inflict_bleeding() -> void:
	is_bleeding = true

func inflict_limp() -> void:
	is_limping = true

func update(delta: float, player_data: CharacterData) -> Dictionary:
	if is_bleeding:
		bleed_accum += delta
		if bleed_accum >= 1.0:
			bleed_accum = 0.0
			if player_data:
				player_data.take_damage(3.0)
			return {"tick": true, "dmg": 3.0, "msg": "🩸 Кровотечение: -3 HP! Наложите льняной бинт [ I ]!"}
	return {}

func apply_bandage(player_data: CharacterData) -> Dictionary:
	if not is_bleeding:
		return {"success": false, "msg": "У вас нет активного кровотечения."}
		
	is_bleeding = false
	if player_data:
		player_data.health = min(player_data.max_health, player_data.health + 15.0)
		
	return {
		"success": true,
		"msg": "🩹 Вы туго перевязали рану льняным бинтом! Кровотечение остановлено (+15 HP)!"
	}

func apply_salve(player_data: CharacterData) -> Dictionary:
	if not is_limping:
		return {"success": false, "msg": "У вас нет травм конечностей."}
		
	is_limping = false
	return {
		"success": true,
		"msg": "🧪 Вы втерли целебную травяную мазь! Боль утихла, хромота прошла (скорость восстановлена)!"
	}

func get_speed_multiplier() -> float:
	return 0.70 if is_limping else 1.0

func get_injury_hud_text() -> String:
	var statuses: Array[String] = []
	if is_bleeding: statuses.append("🩸 Кровотечение (-3 HP/с)")
	if is_limping: statuses.append("🦴 Хромота (-30% скор.)")
	return " | ".join(statuses)
