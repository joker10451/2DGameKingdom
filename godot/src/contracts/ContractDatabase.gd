class_name ContractDatabase
extends RefCounted

## БАЗА ФЕОДАЛЬНЫХ КОНТРАКТОВ И ПОРУЧЕНИЙ ОЛДЕРИИ

static var contracts: Dictionary = {
	"bridge_planks": {
		"id": "bridge_planks",
		"tier": 1,
		"req_renown": 0,
		"title": "🪚 Доски для ремонта частокола",
		"issuer": "Плотник Герхард",
		"faction": "peasants",
		"category": "supply",
		"desc": "Частокол у мельницы прогнил. Нарубите бревен в лесу и распилите их на 5 обрезных досок на верстаке.",
		"target_type": "plank",
		"required_count": 5,
		"current_count": 0,
		"rewards": {
			"gold": 40,
			"renown": 5,
			"reputation": {"peasants": 20},
			"xp": {"woodcutting": 120.0, "crafting": 80.0}
		}
	},
	"bread_for_garrison": {
		"id": "bread_for_garrison",
		"tier": 1,
		"req_renown": 0,
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
			"xp": {"farming": 100.0, "crafting": 50.0}
		}
	},
	"wolf_menace": {
		"id": "wolf_menace",
		"tier": 1,
		"req_renown": 5,
		"title": "🐺 Волчья напасть в окрестностях",
		"issuer": "Староста Вульфрик",
		"faction": "peasants",
		"category": "hunting",
		"desc": "Хищники из северного леса повадились резать овец. Убейте 3 диких волков в окрестных лесах.",
		"target_type": "wolf",
		"required_count": 3,
		"current_count": 0,
		"rewards": {
			"gold": 55,
			"renown": 10,
			"reputation": {"peasants": 20, "crown": 5},
			"xp": {"swordsmanship": 150.0, "survival": 100.0}
		}
	},
	"leather_for_saddles": {
		"id": "leather_for_saddles",
		"tier": 2,
		"req_renown": 15,
		"title": "🧥 Выделка кожи для торгового каравана",
		"issuer": "Купец Альдемар",
		"faction": "merchants",
		"category": "supply",
		"desc": "Купцам для упряжи требуются прочные кожи. Добудьте волчьи шкуры и выдубите 3 куска кожи в чане.",
		"target_type": "leather",
		"required_count": 3,
		"current_count": 0,
		"rewards": {
			"gold": 75,
			"renown": 12,
			"reputation": {"merchants": 25},
			"xp": {"crafting": 150.0, "survival": 80.0}
		}
	},
	"northwood_dispatch": {
		"id": "northwood_dispatch",
		"tier": 2,
		"req_renown": 20,
		"title": "📜 Срочная депеша в Замок Нортвуд",
		"issuer": "Гонец Совета",
		"faction": "crown",
		"category": "delivery",
		"desc": "Доставьте запечатанное донесение коменданту Замка Нортвуд на Глобальной Карте [ M ].",
		"target_type": "loc_castle_northwood",
		"required_count": 1,
		"current_count": 0,
		"rewards": {
			"gold": 70,
			"renown": 15,
			"reputation": {"crown": 25, "merchants": 10},
			"xp": {"athletics": 180.0}
		}
	},
	"crypt_skeletons": {
		"id": "crypt_skeletons",
		"tier": 3,
		"req_renown": 30,
		"title": "💀 Зачистка Склепа Забытых",
		"issuer": "Орден Хранителей",
		"faction": "crown",
		"category": "hunting",
		"desc": "Из древней крипты на северо-западе доносится лязг клинков. Спуститесь в подземелье и уничтожьте 4 скелетов.",
		"target_type": "skeleton",
		"required_count": 4,
		"current_count": 0,
		"rewards": {
			"gold": 110,
			"renown": 25,
			"reputation": {"crown": 35, "peasants": 10},
			"xp": {"swordsmanship": 280.0, "shield_defense": 200.0}
		}
	},
	"bandit_boss_bounty": {
		"id": "bandit_boss_bounty",
		"tier": 3,
		"req_renown": 45,
		"title": "👑 Голова Атамана Брана",
		"issuer": "Королевский Маршал",
		"faction": "crown",
		"category": "hunting",
		"desc": "Лесное братство терроризирует тракты Олдерии. Отыщите укрепленный лагерь разбойников в Чернолесье и сразите Атамана Брана!",
		"target_type": "bandit_boss",
		"required_count": 1,
		"current_count": 0,
		"rewards": {
			"gold": 160,
			"renown": 40,
			"reputation": {"crown": 50, "peasants": 30, "merchants": 40},
			"xp": {"swordsmanship": 400.0, "athletics": 250.0}
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
