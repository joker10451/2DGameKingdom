class_name ContractDatabase
extends RefCounted

## БАЗА ФЕОДАЛЬНЫХ КОНТРАКТОВ И ПОРУЧЕНИЙ ОЛДЕРИИ

static var contracts: Dictionary = {
	"wolf_menace": {
		"id": "wolf_menace",
		"title": "🐺 Волчья напасть в окрестностях",
		"issuer": "Староста Вульфрик",
		"faction": "peasants",
		"category": "hunting",
		"desc": "Хищники из северного леса повадились резать овец. Убейте 3 диких волков в окрестных лесах.",
		"target_type": "wolf",
		"required_count": 3,
		"current_count": 0,
		"rewards": {
			"gold": 45,
			"renown": 5,
			"reputation": {"peasants": 15, "crown": 5},
			"xp": {"swordsmanship": 150.0}
		}
	},
	"bread_for_garrison": {
		"id": "bread_for_garrison",
		"title": "🍞 Поставка хлеба гарнизону",
		"issuer": "Капитан стражи Роланд",
		"faction": "crown",
		"category": "supply",
		"desc": "Гарнизону стражи требуется провизия. Смолите пшеницу на мельнице и испеките в печи 3 буханки хлеба.",
		"target_type": "bread",
		"required_count": 3,
		"current_count": 0,
		"rewards": {
			"gold": 50,
			"renown": 8,
			"reputation": {"crown": 20, "peasants": 5},
			"xp": {"farming": 100.0}
		}
	},
	"leather_for_saddles": {
		"id": "leather_for_saddles",
		"title": "🧥 Выделка кожи для торгового каравана",
		"issuer": "Купец Альдемар",
		"faction": "merchants",
		"category": "supply",
		"desc": "Купцам для упряжи требуются прочные кожи. Добудьте волчьи шкуры и выдубите 3 куска кожи в чане.",
		"target_type": "leather",
		"required_count": 3,
		"current_count": 0,
		"rewards": {
			"gold": 65,
			"renown": 6,
			"reputation": {"merchants": 25},
			"xp": {"woodcutting": 80.0}
		}
	},
	"bridge_planks": {
		"id": "bridge_planks",
		"title": "🪚 Доски для ремонта частокола",
		"issuer": "Плотник Герхард",
		"faction": "peasants",
		"category": "supply",
		"desc": "Частокол у мельницы прогнил. Нарубите бревен в лесу и распилите их на 5 обрезных досок.",
		"target_type": "plank",
		"required_count": 5,
		"current_count": 0,
		"rewards": {
			"gold": 40,
			"renown": 4,
			"reputation": {"peasants": 20},
			"xp": {"woodcutting": 120.0}
		}
	},
	"crypt_skeletons": {
		"id": "crypt_skeletons",
		"title": "💀 Зачистка Склепа Забытых",
		"issuer": "Орден Хранителей",
		"faction": "crown",
		"category": "hunting",
		"desc": "Из древней крипты на северо-западе доносится лязг клинков. Спуститесь в подземелье и уничтожьте 4 скелетов.",
		"target_type": "skeleton",
		"required_count": 4,
		"current_count": 0,
		"rewards": {
			"gold": 80,
			"renown": 15,
			"reputation": {"crown": 30, "peasants": 10},
			"xp": {"swordsmanship": 250.0}
		}
	},
	"northwood_dispatch": {
		"id": "northwood_dispatch",
		"title": "📜 Срочная депеша в Замок Нортвуд",
		"issuer": "Гонец Совета",
		"faction": "crown",
		"category": "delivery",
		"desc": "Доставьте запечатанное донесение коменданту Замка Нортвуд на Глобальной Карте [ M ].",
		"target_type": "loc_castle_northwood",
		"required_count": 1,
		"current_count": 0,
		"rewards": {
			"gold": 55,
			"renown": 10,
			"reputation": {"crown": 25, "merchants": 10},
			"xp": {"athletics": 150.0}
		}
	}
}

static func get_contract(id: String) -> Dictionary:
	if contracts.has(id):
		return contracts[id].duplicate(true)
	return {}

static func get_all_contract_ids() -> Array:
	return contracts.keys()

static func get_faction_name(f_id: String) -> String:
	match f_id:
		"crown": return "👑 Дворянский Дом Нортвуд"
		"merchants": return "⚖️ Лига Купцов Золотой Монеты"
		"peasants": return "🌾 Община Вольных Крестьян"
		"outlaws": return "🦹‍♂️ Лесное Братство"
		_: return "Неизвестная фракция"
