class_name EstateDatabase
extends RefCounted

## БАЗА ДАННЫХ ПОМЕСТЬЯ, ЗЕМЛЕВЛАДЕНИЯ И РАБОЧИХ

const LAND_DEED_COST := 100 # Стоимость грамоты на землю

const WORKERS := {
	"farmer": {
		"id": "farmer",
		"name": "Хлебопашец",
		"icon": "🌾",
		"hire_cost": 25,
		"daily_wage": 3,
		"yield": {
			"grain": 2,
			"flour": 1
		},
		"desc": "Засевает угодья пшеницей и мелет муку на мельнице. Приносит 2 зерна и 1 мешок муки каждые 3 часа."
	},
	"lumberjack": {
		"id": "lumberjack",
		"name": "Лесоруб-Плотник",
		"icon": "🪓",
		"hire_cost": 30,
		"daily_wage": 3,
		"yield": {
			"wood": 3,
			"plank": 2
		},
		"desc": "Заготавливает строевой лес и распиливает доски. Приносит 3 дубовых бревна и 2 доски каждые 3 часа."
	},
	"miner": {
		"id": "miner",
		"name": "Горнорабочий",
		"icon": "⛏️",
		"hire_cost": 35,
		"daily_wage": 4,
		"yield": {
			"iron_ore": 2,
			"iron_ingot": 1
		},
		"desc": "Разрабатывает рудные жилы и выплавляет слитки. Приносит 2 железной руды и 1 слиток каждые 3 часа."
	},
	"huntsman": {
		"id": "huntsman",
		"name": "Егерь-Охотник",
		"icon": "🍗",
		"hire_cost": 30,
		"daily_wage": 3,
		"yield": {
			"meat": 2,
			"leather": 1
		},
		"desc": "Охотится на лесную дичь и выделывает шкуры. Приносит 2 сырых мяса и 1 дублёную кожу каждые 3 часа."
	}
}

const UPGRADES := {
	"manor_house": {
		"id": "manor_house",
		"name": "Барский Дом",
		"icon": "🏡",
		"cost": {
			"wood": 6,
			"plank": 6,
			"gold": 60
		},
		"desc": "Уютная деревянная усадьба с пуховой периной. Позволяет мгновенно снять всю накопленную усталость и восстановить 100% сил."
	},
	"livestock": {
		"id": "livestock",
		"name": "Курятник и Хлев",
		"icon": "🐔",
		"cost": {
			"wood": 4,
			"plank": 4,
			"gold": 45
		},
		"desc": "Фермерское хозяйство с домашней птицей и овцами. Приносит +15 золотых чистой прибыли каждое утро в 07:00."
	},
	"barn": {
		"id": "barn",
		"name": "Складской Амбар",
		"icon": "📦",
		"cost": {
			"wood": 4,
			"plank": 4,
			"gold": 30
		},
		"desc": "Вместительный амбар для надежного хранения собранного урожая, леса и слитков."
	}
}

static func get_worker_def(worker_id: String) -> Dictionary:
	return WORKERS.get(worker_id, {})

static func get_upgrade_def(upgrade_id: String) -> Dictionary:
	return UPGRADES.get(upgrade_id, {})
