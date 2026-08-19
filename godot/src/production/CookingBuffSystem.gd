class_name CookingBuffSystem
extends RefCounted

## СИСТЕМА КУЛИНАРНЫХ И СТАТУСНЫХ БАФФОВ
## Управляет эффектами от сытных блюд, напитков и заточки оружия

# active_buffs: buff_id -> {name: String, icon: String, remaining_time: float, max_time: float}
var active_buffs: Dictionary = {}

const BUFF_DEFS := {
	"buff_sharpness": {
		"name": "Бритвенная Заточка",
		"icon": "🗡️",
		"dmg_pct": 15,
		"default_duration": 1440.0 # 24 игровых часа
	},
	"buff_meat_pie": {
		"name": "Сытный Мясной Пирог",
		"icon": "🥧",
		"stamina_bonus": 25.0,
		"default_duration": 720.0 # 12 часов
	},
	"buff_fish_stew": {
		"name": "Рыбная Уха",
		"icon": "🍲",
		"hp_regen": 2.0,
		"default_duration": 360.0 # 6 часов
	},
	"buff_honeymead": {
		"name": "Крепкий Медовый Эль",
		"icon": "🍺",
		"dmg_pct": 12,
		"default_duration": 480.0 # 8 часов
	}
}

func apply_buff(buff_id: String, duration: float = -1.0) -> Dictionary:
	var def = BUFF_DEFS.get(buff_id, {})
	if def.is_empty(): return {}
	
	var dur = duration if duration > 0.0 else def["default_duration"]
	active_buffs[buff_id] = {
		"name": def["name"],
		"icon": def["icon"],
		"remaining_time": dur,
		"max_time": dur
	}
	return def

func update(delta: float) -> Array[String]:
	var expired: Array[String] = []
	
	for b_id in active_buffs.keys():
		active_buffs[b_id]["remaining_time"] -= delta
		if active_buffs[b_id]["remaining_time"] <= 0.0:
			expired.append(b_id)
			
	for b_id in expired:
		active_buffs.erase(b_id)
		
	return expired

func get_damage_multiplier() -> float:
	var mult = 1.0
	if active_buffs.has("buff_sharpness"):
		mult += 0.15
	if active_buffs.has("buff_honeymead"):
		mult += 0.12
	return mult

func get_stamina_bonus() -> float:
	if active_buffs.has("buff_meat_pie"):
		return 25.0
	return 0.0

func get_hp_regen() -> float:
	if active_buffs.has("buff_fish_stew"):
		return 2.0
	return 0.0

func get_active_buffs_text() -> String:
	if active_buffs.is_empty():
		return ""
	var parts: Array[String] = []
	for b_id in active_buffs.keys():
		var b = active_buffs[b_id]
		parts.append("%s %s" % [b["icon"], b["name"]])
	return " | ".join(parts)
