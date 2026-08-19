class_name AlarmBellSystem
extends RefCounted

## ТРЕВОЖНЫЙ КОЛОКОЛ ОБОРОНЫ ОЛДЕРИИ (НА 23, 21)
## Управляет эвакуацией крестьян в укрытия и созывом стражи на баррикады

signal alarm_toggled(is_active: bool)

var is_alarm_active: bool = false
const SHELTER_POS := Vector2i(38, 38) # Каменная Усадьба Лорда
const RALLY_POS := Vector2i(25, 27)   # Главные Ворота / Баррикады

func ring_bell(citizens_data: Array) -> Dictionary:
	is_alarm_active = not is_alarm_active
	
	for c in citizens_data:
		var role = c.get("role", "")
		if is_alarm_active:
			if role in ["Городской Стражник", "Наемник", "Дружинник"]:
				# Стражники бегут на баррикады
				c["target"] = Vector2(RALLY_POS.x * 48, RALLY_POS.y * 48)
				c["thought"] = "🛡️ К оружию! Защитить ворота!"
			else:
				# Мирные жители бегут в укрытие
				c["target"] = Vector2(SHELTER_POS.x * 48, SHELTER_POS.y * 48)
				c["thought"] = "😱 Тревога! Бежать в каменную усадьбу!"
		else:
			# Отбой тревоги
			c["thought"] = "🕊️ Опасность миновала. Возвращаюсь к делам."
			
	alarm_toggled.emit(is_alarm_active)
	
	if is_alarm_active:
		return {
			"active": true,
			"msg": "🔔 БОЕВАЯ ТРЕВОГА! Колокол звенит на всю округу! Крестьяне бегут в укрытие, стража заняла позиции у ворот!"
		}
	else:
		return {
			"active": false,
			"msg": "🕊️ ОТБОЙ ТРЕВОГИ! Жители возвращаются к мирному труду."
		}
