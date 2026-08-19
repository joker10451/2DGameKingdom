class_name WorldEventSystem
extends RefCounted

## СИСТЕМА ДИНАМИЧЕСКИХ ДОРОЖНЫХ СОБЫТИЙ И КАРАВАНОВ
## Управляет купеческими караванами, бродячими менестрелями, штормами и ярмарками

const EVENT_DEFS := {
	"event_caravan": {
		"id": "event_caravan",
		"title": "🐫 Прибытие Заморского Купеческого Каравана",
		"desc": "На рыночной площади расположился караван купца Фарида из южных земель. В лавке появились редкие специи, дамасские клинки и драгоценные камни!",
		"duration_hours": 24,
		"special_items": {
			"damascus_sword": {"name": "Дамасский Меч ⚔️", "cost": 65, "type": "weapon", "dmg": 22},
			"silk_fabric": {"name": "Южный Шелк 🧶", "cost": 25, "type": "material"},
			"gem_ruby": {"name": "Огненный Рубин 💎", "cost": 45, "type": "treasure"}
		}
	},
	"event_minstrel": {
		"id": "event_minstrel",
		"title": "🎭 Бродячие Менестрели на Площади",
		"desc": "В Олдерию прибыла труппа менестрелей! Звуки лютни и старинные баллады разносятся по всей округе, поднимая дух жителей (+30 к настроению).",
		"duration_hours": 18
	},
	"event_storm": {
		"id": "event_storm",
		"title": "⛈️ Грозовой Ливень над Олдерией",
		"desc": "Теплый весенний ливень обильно полил все поля пшеницы. Урожай созреет в два раза быстрее!",
		"duration_hours": 12
	}
}

var current_event: Dictionary = {}
var event_start_tick: int = 0

func trigger_event(event_id: String) -> Dictionary:
	var ev = EVENT_DEFS.get(event_id, {})
	if ev.is_empty(): return {}
	current_event = ev.duplicate(true)
	event_start_tick = Time.get_ticks_msec()
	return current_event

func end_current_event() -> void:
	current_event.clear()

func get_active_event() -> Dictionary:
	return current_event
