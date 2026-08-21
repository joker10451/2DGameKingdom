class_name SettlementDatabase
extends RefCounted

## БАЗА ДАННЫХ KINGDOMS SANDBOX: РОЛИ, РАНГИ ГОРОДОВ И ПРОФЕССИИ

const ORIGINS := {
	"pioneer": {
		"id": "pioneer",
		"name": "Основатель Поселения (Первопроходец)",
		"icon": "🏕️",
		"desc": "Вы пришли в дикие земли Олдерии, чтобы срубить первое дерево, поставить Знамя и заложить великий город.",
		"starting_items": {
			"axe_wood": 1,
			"town_banner": 1,
			"wood": 25,
			"bread": 8
		},
		"starting_gold": 20
	},
	"craftsman": {
		"id": "craftsman",
		"name": "Вольный Ремесленник-Кузнец",
		"icon": "🪓",
		"desc": "Мастер молота и наковальни. Мечтает открыть собственную великую мануфактуру.",
		"starting_items": {
			"sword_1h": 1,
			"iron_ingot": 8,
			"wood": 15,
			"bread": 6
		},
		"starting_gold": 40
	},
	"hunter": {
		"id": "hunter",
		"name": "Лесной Следопыт-Охотник",
		"icon": "🏹",
		"desc": "Знаток лесных троп, повадок диких хищников и выделки шкур.",
		"starting_items": {
			"bow": 1,
			"arrows": 50,
			"meat": 6,
			"leather": 4
		},
		"starting_gold": 25
	},
	"merchant": {
		"id": "merchant",
		"name": "Бродячий Торговец",
		"icon": "⚖️",
		"desc": "Купец со стартовым капиталом, знающий выгодные цены на всех рынках.",
		"starting_items": {
			"bread": 8,
			"ale": 4,
			"iron_ingot": 4
		},
		"starting_gold": 120
	},
	"outlaw": {
		"id": "outlaw",
		"name": "Разбойник-Изгой",
		"icon": "🗡️",
		"desc": "Беглец, живущий разбоем и охотой на караваны в глухих лесах.",
		"starting_items": {
			"sword_1h": 1,
			"meat": 4,
			"ale": 3
		},
		"starting_gold": 45
	}
}

const TIERS := {
	1: {
		"tier": 1,
		"name": "Лесной Лагерь",
		"icon": "🏕️",
		"pop_req": 1,
		"beds_req": 1,
		"desc": "Временная стоянка первопроходцев с костром и первыми навесами."
	},
	2: {
		"tier": 2,
		"name": "Вольный Хутор",
		"icon": "🏡",
		"pop_req": 3,
		"beds_req": 3,
		"desc": "Оседлое фермерское поселение с бревенчатыми избами и засеянными полями."
	},
	3: {
		"tier": 3,
		"name": "Деревня Олдерии",
		"icon": "🏘️",
		"pop_req": 6,
		"beds_req": 6,
		"desc": "Полноценное сельское поселение с кузницей, мельницей, пекарней и верстаками."
	},
	4: {
		"tier": 4,
		"name": "Торговый Посад",
		"icon": "🏰",
		"pop_req": 10,
		"beds_req": 10,
		"desc": "Укрепленный городок с каменными стенами, рыночной площадью и городской стражей."
	},
	5: {
		"tier": 5,
		"name": "Город-Крепость",
		"icon": "👑",
		"pop_req": 16,
		"beds_req": 16,
		"desc": "Столица феодального княжества с мощным каменным замком, гарнизоном и казной."
	}
}

const PROFESSIONS := {
	"farmer": {
		"id": "farmer",
		"name": "Хлебопашец",
		"icon": "🌾",
		"yield_desc": "Выращивает пшеницу и поставляет зерно на мельницу.",
		"daily_income": 6
	},
	"woodcutter": {
		"id": "woodcutter",
		"name": "Лесоруб-Плотник",
		"icon": "🪓",
		"yield_desc": "Заготавливает древесину и пилит обрезные доски.",
		"daily_income": 7
	},
	"blacksmith": {
		"id": "blacksmith",
		"name": "Кузнец",
		"icon": "⚒️",
		"yield_desc": "Плавит слитки и кует инструменты, мечи и подковы.",
		"daily_income": 9
	},
	"baker": {
		"id": "baker",
		"name": "Пекарь",
		"icon": "🍞",
		"yield_desc": "Выпекает сытный деревенский хлеб в печи.",
		"daily_income": 7
	},
	"hunter": {
		"id": "hunter",
		"name": "Охотник-Егерь",
		"icon": "🍗",
		"yield_desc": "Добывает дичь и пушнину в окрестных лесах.",
		"daily_income": 8
	},
	"guard": {
		"id": "guard",
		"name": "Городской Стражник",
		"icon": "🛡️",
		"yield_desc": "Патрулирует границы поселения и защищает жителей от разбойников и волков.",
		"daily_income": 0,
		"daily_wage": 3
	}
}

const TOWN_PROJECTS := {
	"house_peasant": {
		"id": "house_peasant",
		"name": "🏡 Жилая Изба Переселенцев",
		"icon": "🏡",
		"cost": {"wood": 6, "plank": 4},
		"desc": "Уютная бревенчатая изба с 2 спальными кроватями. Привлекает новых бродяг и беженцев в город.",
		"bed_yield": 2,
		"structures": [
			{"rel_pos": Vector2i(0, 0), "type": "wood_floor"},
			{"rel_pos": Vector2i(1, 0), "type": "wood_floor"},
			{"rel_pos": Vector2i(0, 0), "type": "bed"},
			{"rel_pos": Vector2i(1, 0), "type": "bed"},
			{"rel_pos": Vector2i(-1, 0), "type": "wall_wood"},
			{"rel_pos": Vector2i(2, 0), "type": "wall_wood"}
		]
	},
	"smithy_workshop": {
		"id": "smithy_workshop",
		"name": "⚒️ Кузнечная Мастерская",
		"icon": "⚒️",
		"cost": {"wood": 8, "iron_ore": 4},
		"desc": "Кузница с наковальней и верстаком. Позволяет кузнецу ковать мечи и экипировку.",
		"bed_yield": 0,
		"structures": [
			{"rel_pos": Vector2i(0, 0), "type": "wood_floor"},
			{"rel_pos": Vector2i(0, 0), "type": "carpentry"},
			{"rel_pos": Vector2i(1, 0), "type": "chest"}
		]
	},
	"bakery_house": {
		"id": "bakery_house",
		"name": "🍞 Пекарня Поселения",
		"icon": "🍞",
		"cost": {"wood": 6, "plank": 4, "iron_ore": 2},
		"desc": "Деревенская пекарня с каменной печью для выпечки горячего хлеба.",
		"bed_yield": 0,
		"structures": [
			{"rel_pos": Vector2i(0, 0), "type": "wood_floor"},
			{"rel_pos": Vector2i(0, 0), "type": "bakery_oven"},
			{"rel_pos": Vector2i(1, 0), "type": "chest"}
		]
	},
	"guard_tower": {
		"id": "guard_tower",
		"name": "🛡️ Дозорная Башня Стражи",
		"icon": "🛡️",
		"cost": {"wood": 10, "plank": 6},
		"desc": "Укрепленный форпост с частоколом для дозора и защиты поселения от разбойников.",
		"bed_yield": 0,
		"structures": [
			{"rel_pos": Vector2i(0, 0), "type": "wooden_fence"},
			{"rel_pos": Vector2i(1, 0), "type": "wooden_fence"},
			{"rel_pos": Vector2i(0, 1), "type": "wooden_fence"},
			{"rel_pos": Vector2i(1, 1), "type": "wooden_fence"}
		]
	}
}

const CITIZEN_SHOPS := {
	"blacksmith": [
		{"id": "sword_1h", "price": 28},
		{"id": "dagger_iron", "price": 18},
		{"id": "iron_ingot", "price": 8}
	],
	"baker": [
		{"id": "bread", "price": 4},
		{"id": "flour", "price": 2},
		{"id": "wheat", "price": 1}
	],
	"woodcutter": [
		{"id": "wood", "price": 2},
		{"id": "plank", "price": 3},
		{"id": "arrows", "price": 5}
	],
	"hunter": [
		{"id": "meat", "price": 3},
		{"id": "leather", "price": 5},
		{"id": "bow", "price": 35}
	],
	"farmer": [
		{"id": "wheat", "price": 1},
		{"id": "bread", "price": 4}
	],
	"guard": [
		{"id": "shield_wood", "price": 22},
		{"id": "sword_1h", "price": 28}
	]
}

static func get_origin_def(origin_id: String) -> Dictionary:
	return ORIGINS.get(origin_id, ORIGINS["pioneer"])

static func get_tier_def(tier: int) -> Dictionary:
	return TIERS.get(tier, TIERS[1])

static func get_profession_def(prof_id: String) -> Dictionary:
	return PROFESSIONS.get(prof_id, PROFESSIONS["farmer"])

static func get_project_def(proj_id: String) -> Dictionary:
	return TOWN_PROJECTS.get(proj_id, {})

static func get_shop_items(prof_id: String) -> Array:
	return CITIZEN_SHOPS.get(prof_id, CITIZEN_SHOPS["farmer"])

