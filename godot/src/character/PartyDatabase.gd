class_name PartyDatabase
extends RefCounted

## БАЗА ДАННЫХ СПУТНИКОВ И НАЕМНИКОВ ОЛДЕРИИ

const MERCENARIES: Dictionary = {
	"roland": {
		"id": "roland",
		"name": "Роланд Железнорукий",
		"title": "Меченосец-Ветеран 🗡️",
		"role": "swordsman",
		"icon": "🗡️",
		"texture_id": "companion_swordsman",
		"hp": 95.0,
		"max_hp": 95.0,
		"dmg": 24.0,
		"def": 18.0,
		"attack_range": 48.0,
		"speed": 155.0,
		"hire_cost": 40,
		"daily_wage": 7,
		"weapon": "Стальной Меч",
		"shield": "Рыцарский Щит",
		"desc": "Бывший десятник герцогской стражи. Мастер парирования и глухой обороны. Надежно прикрывает лидера от ударов.",
		"perk_name": "Стальной заслон",
		"perk_desc": "Перехватывает 35% урона, направленного в игрока."
	},
	"edgar": {
		"id": "edgar",
		"name": "Эдгар Меткий Глаз",
		"title": "Лучник-Следопыт 🏹",
		"role": "archer",
		"icon": "🏹",
		"texture_id": "companion_archer",
		"hp": 65.0,
		"max_hp": 65.0,
		"dmg": 22.0,
		"def": 8.0,
		"attack_range": 160.0,
		"speed": 165.0,
		"hire_cost": 35,
		"daily_wage": 6,
		"weapon": "Ясеневый Лук",
		"shield": "Нет",
		"desc": "Лесной следопыт и охотник. Наносит высокий урон с безопасной дистанции стрелами из засады.",
		"perk_name": "Оперенная смерть",
		"perk_desc": "Урон по диким зверям и хищникам увеличен на 30%."
	},
	"bran": {
		"id": "bran",
		"name": "Бран Длинное Копье",
		"title": "Пехотинец-Пикинер 🔱",
		"role": "pikeman",
		"icon": "🔱",
		"texture_id": "companion_pikeman",
		"hp": 80.0,
		"max_hp": 80.0,
		"dmg": 28.0,
		"def": 12.0,
		"attack_range": 68.0,
		"speed": 150.0,
		"hire_cost": 30,
		"daily_wage": 5,
		"weapon": "Боевая Пика",
		"shield": "Пехотный Шлем",
		"desc": "Закаленный в боях пикинер. Длинное древковое оружие позволяет наносить удары через спины союзников.",
		"perk_name": "Сокрушающий выпад",
		"perk_desc": "Шанс 25% оглушить цель при первом ударе."
	},
	"martha": {
		"id": "martha",
		"name": "Марта Полевая",
		"title": "Травница-Лекарь 🌿",
		"role": "healer",
		"icon": "🌿",
		"texture_id": "companion_healer",
		"hp": 55.0,
		"max_hp": 55.0,
		"dmg": 10.0,
		"def": 6.0,
		"attack_range": 50.0,
		"speed": 160.0,
		"hire_cost": 25,
		"daily_wage": 4,
		"weapon": "Травяной Посох",
		"shield": "Сумка с Бальзамами",
		"desc": "Знахарка из предгорий. В пылу сражения лечит раненого игрока и соратников целебными эликсирами.",
		"perk_name": "Полевая перевязка",
		"perk_desc": "Автоматически лечит на +25 HP союзников с критическим здоровьем."
	}
}

static func get_mercenary(id: String) -> Dictionary:
	if MERCENARIES.has(id):
		return MERCENARIES[id].duplicate(true)
	return {}

static func get_all_mercenary_ids() -> Array:
	return MERCENARIES.keys()
