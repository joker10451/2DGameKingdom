class_name RegionalMapSystem
extends RefCounted

## КАРТА РЕГИОНА И СОСЕДНИЕ ГОРОДА-ГОСУДАРСТВА
## Хранит геополитические данные 5 городов королевства

# cities: city_id -> {name: String, ruler: String, icon: String, relation: int, export_item: String, import_item: String, military_strength: int}
var cities: Dictionary = {
	"olderia": {
		"name": "Олдерия (Ваша Вотчина)",
		"ruler": "Лорд-Основатель (Игрок)",
		"icon": "🏰",
		"relation": 100,
		"export_item": "Зерно, Мука, Хлеб",
		"import_item": "Дамасская Сталь, Рубины",
		"military_strength": 45
	},
	"ironhold": {
		"name": "Стальной Предел",
		"ruler": "Герцог Вальдемар Железнорукий",
		"icon": "🛡️",
		"relation": 20,
		"export_item": "Тяжелая Броня, Дамасская Сталь",
		"import_item": "Зерно, Провизия (Дефицит!)",
		"military_strength": 90
	},
	"goldvale": {
		"name": "Золотая Долина",
		"ruler": "Гильдейский Старшина Корнелий",
		"icon": "🌾",
		"relation": 35,
		"export_item": "Шелк, Пряности, Вино",
		"import_item": "Строительный Лес, Оружие",
		"military_strength": 60
	},
	"blackwood": {
		"name": "Чернолесье (Вольный Форпост)",
		"ruler": "Совет Атаманов",
		"icon": "🌲",
		"relation": -15,
		"export_item": "Пушнина, Контрабанда, Наемники",
		"import_item": "Железо, Хлеб",
		"military_strength": 50
	},
	"highkeep": {
		"name": "Вершинный Замок (Столица Короны)",
		"ruler": "Верховный Король Олдерик III",
		"icon": "👑",
		"relation": 10,
		"export_item": "Королевские Грамоты, Золото",
		"import_item": "Феодальная Присяга, Налоги",
		"military_strength": 180
	}
}

func get_city(city_id: String) -> Dictionary:
	return cities.get(city_id, {})

func change_relation(city_id: String, delta: int) -> int:
	if cities.has(city_id):
		cities[city_id]["relation"] = clamp(cities[city_id]["relation"] + delta, -100, 100)
		return cities[city_id]["relation"]
	return 0

func get_regional_summary() -> String:
	var lines: Array[String] = []
	for c_id in ["olderia", "ironhold", "goldvale", "blackwood", "highkeep"]:
		var c = cities[c_id]
		var rel_str = "Союз" if c["relation"] >= 50 else ("Дружба" if c["relation"] >= 20 else ("Нейтралитет" if c["relation"] >= -20 else "Вражда"))
		lines.append("%s [b]%s[/b] (Правитель: %s)\n   Отношения: [color=gold]%d (%s)[/color] | Экспорт: %s | Импорт: %s" % [
			c["icon"], c["name"], c["ruler"], c["relation"], rel_str, c["export_item"], c["import_item"]
		])
	return "\n\n".join(lines)
