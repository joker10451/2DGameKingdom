class_name SkillSystem
extends RefCounted

## БЕСКЛАССОВАЯ СИСТЕМА НАВЫКОВ МАСТЕРСТВА (Soulash 2 / Kenshi Style)
## Отвечает за 7 практических дисциплин, расчет опыта, формулы уровней и перки.

const SKILL_DEFS := {
	"woodcutting": {
		"name": "Лесоруб",
		"icon": "🪓",
		"desc": "Мастерство валки леса. Увеличивает урон по деревьям и шанс добыть удвоенное количество бревен.",
		"stat_governor": "strength",
		"perks": [
			{"id": "wood_5", "name": "Крепкий топор", "req_level": 5, "desc": "Рубка деревьев расходует на 30% меньше сил.", "unlocked": false},
			{"id": "wood_10", "name": "Лесной исполин", "req_level": 10, "desc": "Шанс 30% добыть редкую смолу при срубе дуба.", "unlocked": false}
		]
	},
	"mining": {
		"name": "Горное дело",
		"icon": "⛏️",
		"desc": "Искусство дробления породы. Повышает урон по рудным жилам и шанс найти золотые/серебряные самородки.",
		"stat_governor": "strength",
		"perks": [
			{"id": "mine_5", "name": "Точный скол", "req_level": 5, "desc": "+25% к добыче железной руды из жилы.", "unlocked": false},
			{"id": "mine_10", "name": "Золотая жила", "req_level": 10, "desc": "Шанс 20% найти ценный самородок при раскалывании жилы.", "unlocked": false}
		]
	},
	"swordsmanship": {
		"name": "Фехтование",
		"icon": "⚔️",
		"desc": "Владение мечом и клинковым оружием. Увеличивает физический урон и шанс критического удара (x2 урон).",
		"stat_governor": "agility",
		"perks": [
			{"id": "sword_5", "name": "Глубокий порез", "req_level": 5, "desc": "Критические удары накладывают кровотечение.", "unlocked": false},
			{"id": "sword_10", "name": "Вихрь клинка", "req_level": 10, "desc": "Радиус атаки увеличивается до 110px.", "unlocked": false}
		]
	},
	"shield_defense": {
		"name": "Мастерство щита",
		"icon": "🛡️",
		"desc": "Искусство глухой обороны. Увеличивает процент блокируемого урона и снижает расход выносливости.",
		"stat_governor": "strength",
		"perks": [
			{"id": "shield_5", "name": "Стальная стена", "req_level": 5, "desc": "Блокирование расходует всего 6 ед. выносливости.", "unlocked": false},
			{"id": "shield_10", "name": "Оглушающий блок", "req_level": 10, "desc": "Отраженный щитом удар ошеломляет врага.", "unlocked": false}
		]
	},
	"smithing": {
		"name": "Кузнечное дело",
		"icon": "🔨",
		"desc": "Ковка оружия и брони в горне. Снижает затраты металла и открывает рецепты элитной экипировки.",
		"stat_governor": "intelligence",
		"perks": [
			{"id": "smith_5", "name": "Мастер горна", "req_level": 5, "desc": "Шанс 25% сберечь 1 слиток при ковке предметов.", "unlocked": false},
			{"id": "smith_10", "name": "Легендарная закалка", "req_level": 10, "desc": "Выкованное оружие наносит на 20% больше урона.", "unlocked": false}
		]
	},
	"farming": {
		"name": "Земледелие",
		"icon": "🌾",
		"desc": "Обработка земли и сбор урожая. Повышает отдачу от посевов и питательность выпекаемого хлеба.",
		"stat_governor": "intelligence",
		"perks": [
			{"id": "farm_5", "name": "Щедрое поле", "req_level": 5, "desc": "Сбор пшеницы дает удвоенный урожай зерна.", "unlocked": false},
			{"id": "farm_10", "name": "Пекарь Олдерии", "req_level": 10, "desc": "Свежий хлеб восстанавливает на 50% больше сытости.", "unlocked": false}
		]
	},
	"athletics": {
		"name": "Атлетика",
		"icon": "🏃‍♂️",
		"desc": "Физическая выносливость и подвижность. Повышает скорость спринта и снижает расход дыхания.",
		"stat_governor": "agility",
		"perks": [
			{"id": "ath_5", "name": "Второе дыхание", "req_level": 5, "desc": "Выносливость восстанавливается на 25% быстрее.", "unlocked": false},
			{"id": "ath_10", "name": "Неутомимый путник", "req_level": 10, "desc": "Усталость от бега накапливается в 2 раза медленнее.", "unlocked": false}
		]
	},
	"archery": {
		"name": "Стрельба из лука",
		"icon": "🏹",
		"desc": "Искусство стрельбы из луков и арбалетов. Повышает дальность полета стрел, пробитие брони и урон.",
		"stat_governor": "agility",
		"perks": [
			{"id": "arch_5", "name": "Орлиный глаз", "req_level": 5, "desc": "+25% к дальности полета стрелы и шанс критического выстрела.", "unlocked": false},
			{"id": "arch_10", "name": "Бронебойный наконечник", "req_level": 10, "desc": "Стрелы игнорируют 50% защиты цели.", "unlocked": false}
		]
	},
	"survival": {
		"name": "Выживание",
		"icon": "🏕️",
		"desc": "Искусство жизни в дикой природе. Рыбалка, сбор редких трав, разведение костров и верховая езда.",
		"stat_governor": "strength",
		"perks": [
			{"id": "surv_5", "name": "Следопыт", "req_level": 5, "desc": "Находите редкие травы и дары природы в 2 раза чаще.", "unlocked": false},
			{"id": "surv_10", "name": "Лесной мудрец", "req_level": 10, "desc": "Рыба клюет без наживки, а кони скачут быстрее.", "unlocked": false}
		]
	},
	"crafting": {
		"name": "Ремесло",
		"icon": "🧵",
		"desc": "Общее мастерство изготовления вещей, кораблестроения и алхимии. Снижает расход материалов.",
		"stat_governor": "intelligence",
		"perks": [
			{"id": "craft_5", "name": "Бережливый мастер", "req_level": 5, "desc": "15% шанс сохранить ингредиенты при крафте.", "unlocked": false},
			{"id": "craft_10", "name": "Мастер на все руки", "req_level": 10, "desc": "Все сложные рецепты требуют на 1 ресурс меньше.", "unlocked": false}
		]
	}
}

## Создание структуры навыков по умолчанию для персонажа
static func create_default_skills() -> Dictionary:
	var result := {}
	for skill_id in SKILL_DEFS.keys():
		var def = SKILL_DEFS[skill_id]
		var p_list: Array[Dictionary] = []
		for p in def["perks"]:
			p_list.append({
				"id": p["id"],
				"name": p["name"],
				"req_level": p["req_level"],
				"desc": p["desc"],
				"unlocked": false
			})
		result[skill_id] = {
			"level": 1,
			"xp": 0.0,
			"perks": p_list
		}
	return result

## Необходимый опыт для перехода с текущего уровня на следующий
static func get_xp_required(level: int) -> float:
	return float(int(60.0 * pow(float(level), 1.28)))

## Добавление опыта навыку с расчетом повышения уровня
static func add_skill_xp(skills: Dictionary, skill_id: String, amount: float) -> Dictionary:
	if not skills.has(skill_id):
		return {"leveled_up": false}
	
	var data: Dictionary = skills[skill_id]
	data["xp"] = data.get("xp", 0.0) + amount
	var cur_lvl: int = data.get("level", 1)
	var xp_req: float = get_xp_required(cur_lvl)
	var leveled_up: bool = false
	var old_lvl: int = cur_lvl
	
	while data["xp"] >= xp_req and cur_lvl < 100:
		data["xp"] -= xp_req
		cur_lvl += 1
		data["level"] = cur_lvl
		leveled_up = true
		xp_req = get_xp_required(cur_lvl)
		
		# Автоматически проверяем перки
		if data.has("perks"):
			for p in data["perks"]:
				if cur_lvl >= p["req_level"]:
					p["unlocked"] = true
	
	var def = SKILL_DEFS.get(skill_id, {})
	return {
		"leveled_up": leveled_up,
		"old_level": old_lvl,
		"new_level": cur_lvl,
		"skill_id": skill_id,
		"skill_name": def.get("name", skill_id),
		"icon": def.get("icon", "⭐")
	}

## Расчет модификаторов от навыков
static func get_woodcutting_mult(skills: Dictionary) -> float:
	var lvl = skills.get("woodcutting", {}).get("level", 1)
	return 1.0 + float(lvl - 1) * 0.06

static func get_wood_double_chance(skills: Dictionary) -> float:
	var lvl = skills.get("woodcutting", {}).get("level", 1)
	return clampf(float(lvl) * 0.015, 0.0, 0.5)

static func get_mining_mult(skills: Dictionary) -> float:
	var lvl = skills.get("mining", {}).get("level", 1)
	return 1.0 + float(lvl - 1) * 0.06

static func get_mining_gem_chance(skills: Dictionary) -> float:
	var lvl = skills.get("mining", {}).get("level", 1)
	return clampf(float(lvl) * 0.01, 0.0, 0.4)

static func get_sword_damage_bonus(skills: Dictionary) -> float:
	var lvl = skills.get("swordsmanship", {}).get("level", 1)
	return float(lvl - 1) * 1.8

static func get_crit_chance(skills: Dictionary) -> float:
	var lvl = skills.get("swordsmanship", {}).get("level", 1)
	return clampf(0.05 + float(lvl) * 0.007, 0.05, 0.50)

static func get_shield_damage_reduction(skills: Dictionary) -> float:
	var lvl = skills.get("shield_defense", {}).get("level", 1)
	return clampf(0.75 + float(lvl) * 0.002, 0.75, 0.92)

static func get_shield_stamina_cost(skills: Dictionary) -> float:
	var lvl = skills.get("shield_defense", {}).get("level", 1)
	var has_perk5 = is_perk_unlocked(skills, "shield_defense", "shield_5")
	if has_perk5: return 6.0
	return maxf(6.0, 12.0 - float(lvl) * 0.1)

static func get_athletics_speed_mult(skills: Dictionary) -> float:
	var lvl = skills.get("athletics", {}).get("level", 1)
	return 1.0 + float(lvl - 1) * 0.005

static func get_athletics_stamina_cost(skills: Dictionary) -> float:
	var lvl = skills.get("athletics", {}).get("level", 1)
	return maxf(10.0, 20.0 - float(lvl) * 0.15)

static func get_archery_damage_mult(skills: Dictionary) -> float:
	var lvl = skills.get("archery", {}).get("level", 1)
	return 1.0 + float(lvl - 1) * 0.05

static func get_archery_range_mult(skills: Dictionary) -> float:
	var lvl = skills.get("archery", {}).get("level", 1)
	var has_eye = is_perk_unlocked(skills, "archery", "arch_5")
	return (1.25 if has_eye else 1.0) + float(lvl - 1) * 0.02

static func get_archery_armor_pen(skills: Dictionary) -> float:
	var has_pen = is_perk_unlocked(skills, "archery", "arch_10")
	return 0.5 if has_pen else 0.0

static func is_perk_unlocked(skills: Dictionary, skill_id: String, perk_id: String) -> bool:
	if not skills.has(skill_id): return false
	var perks = skills[skill_id].get("perks", [])
	for p in perks:
		if p["id"] == perk_id:
			return p.get("unlocked", false)
	return false
