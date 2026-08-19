class_name NPCGenerator
extends RefCounted

## ПРОЦЕДУРНЫЙ ГЕНЕРАТОР ЖИТЕЛЕЙ И AI (в стиле игры KINGDOMS)
## Генерирует уникальных персонажей с личными целями, чертами характера, внешностью и динамическим поведением

const FIRST_NAMES_MALE := [
	"Радомир", "Всеволод", "Бертольд", "Людвиг", "Бран", "Годфри", "Освальд", 
	"Гуннар", "Элрик", "Ивар", "Вацлав", "Добрыня", "Мирослав", "Казимир",
	"Боривой", "Ольгерд", "Святозар", "Ульрих", "Виганд", "Бьорн", "Торвальд",
	"Фолькер", "Ансельм", "Дитрих", "Мстислав", "Ярополк", "Бертран", "Одо"
]

const FIRST_NAMES_FEMALE := [
	"Эльза", "Гвендолин", "Хильда", "Бригитта", "Астрид", "Сигрид", "Рогнеда",
	"Власта", "Любава", "Мирослава", "Берта", "Инга", "Матильда", "Изольда",
	"Ядвига", "Миролюба", "Злата", "Доброгнева", "Грета", "Аделина"
]

const NICKNAMES := [
	"Железнорукий", "Кривой", "Тихоня", "Лисохвост", "Медовар", "Костоправ",
	"Златоуст", "Быстроног", "Громила", "Хмурый", "Бородач", "Свирепый",
	"Клятвопреступник", "Богобоязненный", "Неуловимый", "Остроглаз", "Одноухий",
	"Пьяный Вепрь", "Хитрый Лис", "Седой", "Бесстрашный", "Угрюмый", "Счастливчик"
]

const SURNAMES := [
	"Чернолесский", "Кречет", "Дуболом", "Воронец", "Стальногрив", "Мельник",
	"Коваль", "Болотов", "Рудник", "Светлобор", "Остроумов", "Хмельницкий",
	"Горный", "Речной", "Торговец", "Лесник", "Клинков", "Каменотес"
]

const TRAITS_POOL := [
	"Жадный", "Щедрый", "Трусливый", "Храбрый", "Мстительный", "Честный",
	"Пьяница", "Набожный", "Амбициозный", "Кровожадный", "Болтливый",
	"Подозрительный", "Веселый", "Осторожный", "Трудолюбивый", "Ленивый"
]

const LIFE_GOALS := [
	"Мечтает накопить 100 золотых и выкупить собственный участок земли",
	"Хочет выковать идеальный клинок и прославиться по всему королевству",
	"Собирает деньги, чтобы покинуть эти земли и уехать в столицу",
	"Жаждет отомстить разбойникам за сожженный амбар предков",
	"Мечтает заслужить благородный титул и стать рыцарем лорда",
	"Хочет открыть лучшую пивоварню во всей Олдерии",
	"Копит золото на сватовство к дочери богатого купца",
	"Скрывается от долгов и ростовщиков из Стального Предела",
	"Служит местному храму и ищет древний священный свиток",
	"Мечтает сколотить банду и стать грозой торговых трактов",
	"Просто хочет вырастить богатый урожай и дожить до спокойной старости"
]

const ARCHETYPES := [
	{
		"role": "Крестьянин",
		"models": ["res://assets/characters/Barbarian.glb", "res://assets/characters/Ranger.glb"],
		"weapons_r": ["", "res://assets/characters/axe_1handed.gltf"],
		"weapons_l": [""],
		"gold_min": 5, "gold_max": 25,
		"hp_min": 55, "hp_max": 75,
		"icon": "🌾",
		"work_spots": ["farm", "windmill", "home_b"],
		"combat": 15
	},
	{
		"role": "Торговец",
		"models": ["res://assets/characters/Mage.glb", "res://assets/characters/Rogue.glb"],
		"weapons_r": ["", "res://assets/characters/dagger.gltf"],
		"weapons_l": [""],
		"gold_min": 60, "gold_max": 220,
		"hp_min": 65, "hp_max": 85,
		"icon": "⚖️",
		"work_spots": ["market", "tavern", "home_a"],
		"combat": 20
	},
	{
		"role": "Городской Стражник",
		"models": ["res://assets/characters/Knight.glb"],
		"weapons_r": ["res://assets/characters/sword_1handed.gltf"],
		"weapons_l": ["res://assets/characters/shield_round.gltf", "res://assets/characters/shield_square.gltf"],
		"gold_min": 25, "gold_max": 65,
		"hp_min": 110, "hp_max": 140,
		"icon": "🛡️",
		"work_spots": ["barracks", "castle", "tavern"],
		"combat": 60
	},
	{
		"role": "Кузнец",
		"models": ["res://assets/characters/Barbarian.glb"],
		"weapons_r": ["res://assets/characters/axe_1handed.gltf", "res://assets/characters/axe_2handed.gltf"],
		"weapons_l": [""],
		"gold_min": 40, "gold_max": 110,
		"hp_min": 95, "hp_max": 130,
		"icon": "⚒️",
		"work_spots": ["blacksmith"],
		"combat": 50
	},
	{
		"role": "Наемник",
		"models": ["res://assets/characters/Ranger.glb", "res://assets/characters/Rogue.glb", "res://assets/characters/Barbarian.glb"],
		"weapons_r": ["res://assets/characters/sword_1handed.gltf", "res://assets/characters/bow.gltf"],
		"weapons_l": ["res://assets/characters/shield_round.gltf", ""],
		"gold_min": 30, "gold_max": 90,
		"hp_min": 90, "hp_max": 125,
		"icon": "🏹",
		"work_spots": ["tavern", "barracks"],
		"combat": 65
	},
	{
		"role": "Разбойник",
		"models": ["res://assets/characters/Rogue_Hooded.glb", "res://assets/characters/Rogue.glb"],
		"weapons_r": ["res://assets/characters/dagger.gltf", "res://assets/characters/sword_1handed.gltf"],
		"weapons_l": [""],
		"gold_min": 20, "gold_max": 80,
		"hp_min": 75, "hp_max": 105,
		"icon": "🗡️",
		"work_spots": ["bandit_camp"],
		"combat": 55
	},
	{
		"role": "Разбойник-лучник",
		"models": ["res://assets/characters/Ranger.glb", "res://assets/characters/Rogue_Hooded.glb"],
		"weapons_r": ["res://assets/characters/bow.gltf"],
		"weapons_l": [""],
		"gold_min": 25, "gold_max": 90,
		"hp_min": 65, "hp_max": 90,
		"icon": "🏹",
		"work_spots": ["bandit_camp"],
		"combat": 50,
		"is_ranged": true
	},
	{
		"role": "Дворянин",
		"models": ["res://assets/characters/Knight.glb", "res://assets/characters/Mage.glb"],
		"weapons_r": ["res://assets/characters/sword_2handed.gltf", "res://assets/characters/sword_1handed.gltf"],
		"weapons_l": ["res://assets/characters/shield_badge.gltf"],
		"gold_min": 300, "gold_max": 800,
		"hp_min": 120, "hp_max": 160,
		"icon": "👑",
		"work_spots": ["castle", "church"],
		"combat": 70
	}
]

static func _femalize_surname(s: String) -> String:
	if s.ends_with("ский"):
		return s.substr(0, s.length() - 4) + "ская"
	if s.ends_with("цкий"):
		return s.substr(0, s.length() - 4) + "цкая"
	if s.ends_with("ый"):
		return s.substr(0, s.length() - 2) + "ая"
	if s.ends_with("ой"):
		return s.substr(0, s.length() - 2) + "ая"
	if s.ends_with("ов") or s.ends_with("ев") or s.ends_with("ин") or s.ends_with("ын"):
		return s + "а"
	return s

static func _femalize_nickname(n: String) -> String:
	match n:
		"Железнорукий": return "Железнорукая"
		"Кривой": return "Кривая"
		"Тихоня": return "Тихоня"
		"Лисохвост": return "Лисохвостка"
		"Медовар": return "Медоварка"
		"Костоправ": return "Костоправка"
		"Златоуст": return "Златоустая"
		"Быстроног": return "Быстроногая"
		"Громила": return "Громила"
		"Хмурый": return "Хмурая"
		"Бородач": return "Острокосая"
		"Свирепый": return "Свирепая"
		"Клятвопреступник": return "Клятвопреступница"
		"Богобоязненный": return "Богобоязненная"
		"Неуловимый": return "Неуловимая"
		"Остроглаз": return "Остроглазая"
		"Одноухий": return "Одноухая"
		"Пьяный Вепрь": return "Дикая Волчица"
		"Хитрый Лис": return "Хитрая Лисица"
		"Седой": return "Седая"
		"Бесстрашный": return "Бесстрашная"
		"Угрюмый": return "Угрюмая"
		"Счастливчик": return "Счастливица"
	if n.ends_with("ый") or n.ends_with("ой"):
		return n.substr(0, n.length() - 2) + "ая"
	if n.ends_with("ий"):
		return n.substr(0, n.length() - 2) + "яя"
	return n

static func _femalize_trait(t: String) -> String:
	if t == "Пьяница": return "Пьяница"
	if t.ends_with("ый"):
		return t.substr(0, t.length() - 2) + "ая"
	if t.ends_with("ий"):
		return t.substr(0, t.length() - 2) + "яя"
	return t

static func generate_random_npc(force_role: String = "", home_spot: String = "") -> Dictionary:
	var is_female = randf() < 0.35
	var first_name = FIRST_NAMES_FEMALE.pick_random() if is_female else FIRST_NAMES_MALE.pick_random()
	
	var raw_surname: String = SURNAMES.pick_random()
	var raw_nick: String = NICKNAMES.pick_random()
	
	var final_surname = _femalize_surname(raw_surname) if is_female else raw_surname
	var final_nick = _femalize_nickname(raw_nick) if is_female else raw_nick
	
	# Формирование уникального имени и прозвища с учетом грамматического пола
	var full_name = ""
	var roll = randi() % 3
	if roll == 0:
		full_name = "%s %s" % [first_name, final_surname]
	elif roll == 1:
		full_name = "%s «%s»" % [first_name, final_nick]
	else:
		full_name = "%s %s «%s»" % [first_name, final_surname, final_nick]
	
	# Подбор архетипа
	var arch: Dictionary = {}
	if force_role != "":
		for a in ARCHETYPES:
			if a["role"] == force_role:
				arch = a
				break
	if arch.is_empty():
		arch = ARCHETYPES.pick_random()
	
	# Черты характера (2-3 случайные черты) с согласованием по полу
	var traits: Array[String] = []
	var pool = TRAITS_POOL.duplicate()
	pool.shuffle()
	for i in randi_range(2, 3):
		var raw_t = pool.pop_back()
		traits.append(_femalize_trait(raw_t) if is_female else raw_t)
	
	var home_key = home_spot if home_spot != "" else ["home_a", "home_b", "farm", "tavern", "barracks", "bandit_camp"].pick_random()
	var work_key = arch["work_spots"].pick_random()
	var evening_key = "tavern" if arch["role"] != "Разбойник" else "bandit_camp"
	
	var gold_val = randi_range(arch["gold_min"], arch["gold_max"])
	var hp_val = float(randi_range(arch["hp_min"], arch["hp_max"]))
	var model_path = arch["models"].pick_random()
	var weapon_r = arch["weapons_r"].pick_random()
	var weapon_l = arch["weapons_l"].pick_random()
	var life_goal = LIFE_GOALS.pick_random()
	
	return {
		"name": full_name,
		"gender": "Женский" if is_female else "Мужской",
		"role": arch["role"],
		"thought": arch["icon"],
		"model": model_path,
		"weapon_r": weapon_r,
		"weapon_l": weapon_l,
		"home": home_key,
		"work": work_key,
		"evening": evening_key,
		"gold": gold_val,
		"hp": hp_val,
		"max_hp": hp_val,
		"combat_skill": arch["combat"],
		"traits": traits,
		"goal": life_goal,
		"hunger": randf_range(10.0, 50.0),
		"fatigue": randf_range(10.0, 40.0),
		"reputation_to_player": 0, # -100 (враг) .. +100 (друг)
		"is_dead": false,
		"target": Vector3.ZERO
	}

static func generate_population(count: int = 16) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	
	# Обязательные ключевые роли для функционирования живого поселения:
	var mandatory_roles = [
		{"role": "Кузнец", "home": "blacksmith"},
		{"role": "Торговец", "home": "home_a"},
		{"role": "Городской Стражник", "home": "barracks"},
		{"role": "Городской Стражник", "home": "barracks"},
		{"role": "Дворянин", "home": "castle"},
		{"role": "Наемник", "home": "tavern"},
		{"role": "Разбойник", "home": "bandit_camp"},
		{"role": "Разбойник", "home": "bandit_camp"},
		{"role": "Крестьянин", "home": "home_b"},
		{"role": "Крестьянин", "home": "farm"},
	]
	
	for m in mandatory_roles:
		result.append(generate_random_npc(m["role"], m["home"]))
	
	# Дополняем остальное население случайными странниками, торговцами и крестьянами
	while result.size() < count:
		result.append(generate_random_npc())
	
	return result
