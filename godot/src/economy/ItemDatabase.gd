class_name ItemDatabase
extends RefCounted

## База данных всех предметов, оружия, еды и ресурсов мира Олдерии

const ITEMS := {
	"sword_1h": {
		"name": "Стальной Меч",
		"icon": "🗡️",
		"category": "weapon",
		"desc": "Острый клинок из болотной стали. Урон: 25-35.",
		"value": 35,
		"model_path": "res://assets/characters/sword_1handed.gltf",
		"hand": "right",
		"damage": 30
	},
	"sword_2h": {
		"name": "Двуручный Меч Лорда",
		"icon": "⚔️",
		"category": "weapon",
		"desc": "Тяжелый благородный меч для сокрушительных ударов. Урон: 45-60.",
		"value": 75,
		"model_path": "res://assets/characters/sword_2handed.gltf",
		"hand": "right",
		"damage": 52
	},
	"axe_1h": {
		"name": "Боевой Топор Кузнеца",
		"icon": "🪓",
		"category": "weapon",
		"desc": "Тяжелое рубящее лезвие. Пробивает деревянные щиты. Урон: 28-40.",
		"value": 40,
		"model_path": "res://assets/characters/axe_1handed.gltf",
		"hand": "right",
		"damage": 35
	},
	"dagger": {
		"name": "Бандитский Кинжал",
		"icon": "🗡️",
		"category": "weapon",
		"desc": "Легкий нож для быстрых ударов из тени. Урон: 15-22.",
		"value": 18,
		"model_path": "res://assets/characters/dagger.gltf",
		"hand": "right",
		"damage": 18
	},
	"bow": {
		"name": "Охотничий Лук",
		"icon": "🏹",
		"category": "weapon",
		"desc": "Гибкий ясеневый лук для стрельбы на расстоянии. Урон: 22-30.",
		"value": 45,
		"model_path": "res://assets/characters/bow.gltf",
		"hand": "right",
		"damage": 25
	},
	"shield_badge": {
		"name": "Рыцарский Щит с Гербом",
		"icon": "🛡️",
		"category": "shield",
		"desc": "Прочный дубовый щит с металлическим кантом и гербом. Защита: +35%.",
		"value": 40,
		"model_path": "res://assets/characters/shield_badge.gltf",
		"hand": "left"
	},
	"shield_round": {
		"name": "Круглый Щит Стражи",
		"icon": "🛡️",
		"category": "shield",
		"desc": "Уставной щит городской стражи Олдерии. Защита: +25%.",
		"value": 25,
		"model_path": "res://assets/characters/shield_round.gltf",
		"hand": "left"
	},
	"bread": {
		"name": "Свежий Хлеб",
		"icon": "🥖",
		"category": "food",
		"desc": "Пшеничный сытный каравай. Восстанавливает 30 HP и утоляет голод.",
		"value": 4,
		"heal_hp": 30.0,
		"restore_stamina": 15.0
	},
	"meat": {
		"name": "Сырое Мясо (Дичь)",
		"icon": "🥩",
		"category": "food",
		"desc": "Свежее сырое мясо добытого зверя. Можно съесть сырым (+15 HP), но лучше поджарить на костре [E] или запечь в мясной пирог.",
		"value": 6,
		"heal_hp": 15.0,
		"restore_stamina": 10.0
	},
	"ale": {
		"name": "Кружка Эля",
		"icon": "🍺",
		"category": "food",
		"desc": "Густой трактирный напиток. Восстанавливает 40 выносливости.",
		"value": 5,
		"heal_hp": 10.0,
		"restore_stamina": 50.0
	},
	"potion_health": {
		"name": "Болотный Бальзам Тростянок",
		"icon": "🧪",
		"category": "food",
		"desc": "Целебная настойка из болотных трав. Мгновенно лечит 85 HP.",
		"value": 50,
		"heal_hp": 85.0,
		"restore_stamina": 50.0
	},
	"iron_ore": {
		"name": "Железная Руда",
		"icon": "🪨",
		"category": "resource",
		"desc": "Необработанная руда из шахт Северного Кряжа. Нужна для плавки.",
		"value": 7
	},
	"iron_ingot": {
		"name": "Слиток «Синего Чугуна»",
		"icon": "🧱",
		"category": "resource",
		"desc": "Высококачественный металл, секрет мастеров-Жильников.",
		"value": 22
	},
	"grain": {
		"name": "Мешок Зерна",
		"icon": "🌾",
		"category": "resource",
		"desc": "Собранный урожай пшеницы. Мелется в муку на мельнице.",
		"value": 3
	},
	"wood": {
		"name": "Строительный Лес",
		"icon": "🪵",
		"category": "resource",
		"desc": "Дубовые бревна для строительства и рукоятей оружия.",
		"value": 4
	},
	"steak": {
		"name": "Жареное Мясо",
		"icon": "🍗",
		"category": "food",
		"desc": "Сочный кусок мяса, поджаренный на костре со специями. Восстанавливает 55 HP и 60% сытости.",
		"value": 16,
		"heal_hp": 55.0,
		"restore_stamina": 35.0
	},
	"wolf_pelt": {
		"name": "Шкура Матерого Волка",
		"icon": "🐺",
		"category": "resource",
		"desc": "Густой теплый мех лесного хищника. Высоко ценится на городском рынке.",
		"value": 24
	},
	"dungeon_relic": {
		"name": "Древняя Реликвия Склепа",
		"icon": "🏺",
		"category": "misc",
		"desc": "Покрытая рунами реликвия эпохи Первых Королей. Представляет огромную ценность.",
		"value": 80
	},
	"ancient_gold_coin": {
		"name": "Старинный Золотой Дублон",
		"icon": "🪙",
		"category": "misc",
		"desc": "Чеканная золотая монета древней империи.",
		"value": 15
	},
	"flour": {
		"name": "Мельничная Мука",
		"icon": "🥣",
		"category": "resource",
		"desc": "Свежесмолотая пшеничная мука. Главный ингредиент для выпечки хлеба и пирогов.",
		"value": 5
	},
	"meat_pie": {
		"name": "Сытный Мясной Пирог",
		"icon": "🥧",
		"category": "food",
		"desc": "Ароматный пирог с начинкой из мяса дичи. Восстанавливает 70 HP и 80% сытости.",
		"value": 30,
		"heal_hp": 70.0,
		"restore_stamina": 50.0
	},
	"leather": {
		"name": "Дублёная Кожа",
		"icon": "🧥",
		"category": "resource",
		"desc": "Прочная выделанная кожа для пошива легкой брони, сапог и ремней.",
		"value": 16
	},
	"leather_armor": {
		"name": "Кожаный Доспех Охотника",
		"icon": "🥋",
		"category": "armor",
		"desc": "Легкая и прочная куртка из дубленой кожи. Защита: +14, не сковывает движения.",
		"value": 45
	},
	"leather_boots": {
		"name": "Сапоги Скорохода",
		"icon": "👢",
		"category": "armor",
		"desc": "Мягкие сапоги из волчьей кожи. Увеличивают скорость передвижения на +15%.",
		"value": 38
	},
	"plank": {
		"name": "Обрезная Доска",
		"icon": "🪚",
		"category": "resource",
		"desc": "Ровная строганая доска. Используется для строительства усадьбы и мебели.",
		"value": 4
	},
	"arrows": {
		"name": "Оперенные Стрелы",
		"icon": "🎯",
		"category": "ammo",
		"desc": "Связка деревянных стрел с железным наконечником и гусиным оперением. Необходимы для стрельбы из лука.",
		"value": 2
	},
	"bow_ash": {
		"name": "Ясеневый Длинный Лук",
		"icon": "🏹",
		"category": "weapon",
		"desc": "Тяжелый боевой лук из гибкого ясеня. Наносит 32-44 урона на большой дистанции.",
		"value": 75,
		"model_path": "res://assets/characters/bow.gltf",
		"hand": "right",
		"damage": 38
	},
	"armor_knight": {
		"name": "Рыцарский Гербовый Доспех",
		"icon": "🛡️",
		"category": "armor",
		"desc": "Выкованные королевскими кузнецами стальные латы с геральдическим плащом. Поглощает до 18 урона.",
		"value": 160,
		"model_path": "res://assets/characters/armor_knight.gltf",
		"defense": 18
	},
	"sword_knight": {
		"name": "Благородный Рыцарский Меч",
		"icon": "⚔️",
		"category": "weapon",
		"desc": "Отбалансированный длинный меч из вороненой стали. Наносит 45 урона.",
		"value": 140,
		"model_path": "res://assets/characters/sword_knight.gltf",
		"hand": "right",
		"damage": 45
	},
	"war_horn": {
		"name": "Рыцарский Боевой Рог",
		"icon": "📯",
		"category": "tool",
		"desc": "Серебряный рог с чеканкой. Воодушевляет соратников и созывает городскую стражу на бой.",
		"value": 90
	},
	"town_banner": {
		"name": "Знамя Поселения",
		"icon": "🚩",
		"category": "structure",
		"desc": "Геральдическое полотнище для основания нового поселения с нуля в любой точке мира.",
		"value": 50
	},
	"axe_wood": {
		"name": "Топор Лесоруба",
		"icon": "🪓",
		"category": "weapon",
		"desc": "Удобный топор на ясеневом топорище. Отлично рубит лес и раскалывает щиты.",
		"value": 25,
		"hand": "right",
		"damage": 22
	},
	"hammer_smith": {
		"name": "Кузнечный Молот",
		"icon": "🔨",
		"category": "weapon",
		"desc": "Тяжелый молот из закаленной стали для ковки на наковальне и сокрушения доспехов.",
		"value": 30,
		"hand": "right",
		"damage": 24
	},
	"fishing_rod": {
		"name": "Удочка из Ясеня",
		"icon": "🎣",
		"category": "tool",
		"desc": "Гибкая удочка из ясеня для ловли речной рыбы на водных клетках [E].",
		"value": 20
	},
	"bait": {
		"name": "Наживка для Рыбы",
		"icon": "🪱",
		"category": "material",
		"desc": "Жирные дождевые черви для успешной подсечки рыбы.",
		"value": 2
	},
	"fish_trout": {
		"name": "Речная Форель",
		"icon": "🐟",
		"category": "food",
		"desc": "Свежевыловленная быстрая форель. Восстанавливает 15 HP.",
		"value": 6,
		"hp_restore": 15
	},
	"fish_pike": {
		"name": "Озерная Щука",
		"icon": "🐟",
		"category": "food",
		"desc": "Хищная речная щука. Восстанавливает 20 HP.",
		"value": 8,
		"hp_restore": 20
	},
	"fish_catfish": {
		"name": "Речной Сом",
		"icon": "🐟",
		"category": "food",
		"desc": "Крупный жирный сом. Восстанавливает 30 HP.",
		"value": 12,
		"hp_restore": 30
	},
	"fish_carp": {
		"name": "Зеркальный Карп",
		"icon": "🐟",
		"category": "food",
		"desc": "Сытный прудовой карп. Восстанавливает 18 HP.",
		"value": 6,
		"hp_restore": 18
	},
	"fish_eel": {
		"name": "Речной Угорь",
		"icon": "🐟",
		"category": "food",
		"desc": "Скользкий питательный угорь. Восстанавливает 25 HP.",
		"value": 10,
		"hp_restore": 25
	},
	"fish_soup": {
		"name": "Царская Уха",
		"icon": "🍲",
		"category": "food",
		"desc": "Горячая уха из речной рыбы с травами. Восстанавливает 100% сытости и +40 HP.",
		"value": 18,
		"hp_restore": 40
	},
	"herb_hypericum": {
		"name": "Зверобой",
		"icon": "🌿",
		"category": "material",
		"desc": "Целебная трава для варки зелий исцеления и укрепления духа.",
		"value": 4
	},
	"herb_moonroot": {
		"name": "Лунный Корень",
		"icon": "🌸",
		"category": "material",
		"desc": "Редкий фосфоресцирующий корень для защитных эликсиров каменной кожи.",
		"value": 8
	},
	"herb_belladonna": {
		"name": "Белладонна",
		"icon": "🥀",
		"category": "material",
		"desc": "Ядовитые ягоды и листья для создания смертоносных ядов.",
		"value": 6
	},
	"potion_healing": {
		"name": "Зелье Исцеления",
		"icon": "🧪",
		"category": "potion",
		"desc": "Алхимический настой, мгновенно восстанавливающий +60 HP.",
		"value": 25,
		"hp_restore": 60
	},
	"potion_stoneskin": {
		"name": "Зелье Каменной Кожи",
		"icon": "🧪",
		"category": "potion",
		"desc": "Эликсир, делающий кожу твердой как кремень: +10 к защите (DEF) на 5 минут.",
		"value": 35
	},
	"potion_swiftness": {
		"name": "Эликсир Скорости",
		"icon": "🧪",
		"category": "potion",
		"desc": "Зелье легкости шага: увеличивает скорость бега на +35% на 5 минут.",
		"value": 30
	},
	"poison_vial": {
		"name": "Смертоносный Яд",
		"icon": "☠️",
		"category": "potion",
		"desc": "Яд из белладонны: смазывает клинок и стрелы, нанося +15 токсичного урона.",
		"value": 30
	},
	"honey": {
		"name": "Дикий Мед",
		"icon": "🍯",
		"category": "food",
		"desc": "Сладкий душистый мед с пасеки. Восстанавливает 15 HP и силы.",
		"value": 8,
		"hp_restore": 15
	},
	"beeswax": {
		"name": "Пчелиный Воск",
		"icon": "🕯️",
		"category": "material",
		"desc": "Чистый пчелиный воск для свечей и выделки кожи.",
		"value": 5
	},
	"mead": {
		"name": "Хмельная Медовуха",
		"icon": "🍺",
		"category": "food",
		"desc": "Старославянская медовуха на меду. Снимает усталость и восстанавливает выносливость.",
		"value": 14,
		"hp_restore": 20
	},
	"saddle": {
		"name": "Кожаное Седло",
		"icon": "🏇",
		"category": "tool",
		"desc": "Удобное седло из выделанной кожи для верховой езды.",
		"value": 25
	},
	"lance_tourney": {
		"name": "Рыцарское Турнирное Копье",
		"icon": "🔱",
		"category": "weapon",
		"desc": "Длинное рыцарское ясеневое копье с турнирным наконечником для сшибок.",
		"value": 45,
		"hand": "right",
		"damage": 35
	},
	"trophy_chalice": {
		"name": "Кубок Чемпиона Олдерии",
		"icon": "🏆",
		"category": "valuable",
		"desc": "Золотой инкрустированный кубок победителя Королевского Рыцарского Турнира.",
		"value": 200
	},
	"fish_salmon": {
		"name": "Атлантический Лосось",
		"icon": "🐟",
		"category": "food",
		"desc": "Благородная морская рыба с нежным розовым мясом. Восстанавливает 35 HP.",
		"value": 14,
		"hp_restore": 35
	},
	"fish_tuna": {
		"name": "Морской Тунец",
		"icon": "🐟",
		"category": "food",
		"desc": "Крупная океаническая рыба. Сытная и питательная. Восстанавливает 45 HP.",
		"value": 20,
		"hp_restore": 45
	},
	"pearl": {
		"name": "Морской Жемчуг",
		"icon": "🦪",
		"category": "valuable",
		"desc": "Идеально круглая перламутровая жемчужина со дна океана.",
		"value": 60
	},
	"spices": {
		"name": "Заморские Пряности",
		"icon": "🏺",
		"category": "valuable",
		"desc": "Душистые заморские специи, корица и шафран из далеких южных стран.",
		"value": 50
	},
	"silk": {
		"name": "Имперский Шелк",
		"icon": "🧶",
		"category": "material",
		"desc": "Тончайшая сияющая ткань для знати и королевских одеяний.",
		"value": 70
	},
	"ancient_relic": {
		"name": "Древняя Морская Реликвия",
		"icon": "🗿",
		"category": "valuable",
		"desc": "Таинственный артефакт затонувших морских цивилизаций.",
		"value": 150
	},
	"bandage": {
		"name": "Льняной Бинт",
		"icon": "🩹",
		"category": "medicine",
		"desc": "Стерильная льняная повязка. Мгновенно останавливает кровотечение, лечит травмы конечностей и дает +20 HP.",
		"value": 8,
		"hp_restore": 20
	},
	"herbal_salve": {
		"name": "Травяная Мазь",
		"icon": "🧪",
		"category": "medicine",
		"desc": "Целебная мазь из зверобоя и воска. Снимает боль и хромоту, дает регенерацию +3 HP/сек на 10 сек.",
		"value": 12,
		"hp_restore": 15
	},
	"sword_paladin_sun": {
		"name": "Паладинский Клинок Света 🗡️",
		"icon": "⚔️",
		"category": "weapon",
		"desc": "Легендарный освященный клинок Ордена Солнца. Наносит 28 урона и рассеивает тьму в подземельях.",
		"value": 180,
		"damage": 28
	},
	"ring_undying": {
		"name": "Кольцо Бессмертия 💍",
		"icon": "💍",
		"category": "valuable",
		"desc": "Древнее кольцо с сапфиром душ. Дарует +30 к максимальному здоровью и постоянную регенерацию.",
		"value": 220,
		"max_hp_bonus": 30
	},
	"wheat": {
		"name": "Спелая Пшеница",
		"icon": "🌾",
		"category": "resource",
		"desc": "Спелые золотые колосья пшеницы. Мелются в муку на мельнице.",
		"value": 2
	},
	"seeds_wheat": {
		"name": "Пшеничные Семена",
		"icon": "🌱",
		"category": "resource",
		"desc": "Отборные семена для посева на вспаханной грядке [B].",
		"value": 1
	},
	"shield_wood": {
		"name": "Деревянный Щит",
		"icon": "🛡️",
		"category": "shield",
		"desc": "Простой щит из сосновых досок. Защита: +20%.",
		"value": 20,
		"hand": "left"
	},
	"dagger_iron": {
		"name": "Железный Кинжал",
		"icon": "🗡️",
		"category": "weapon",
		"desc": "Удобный кинжал оруженосца. Урон: 16-24.",
		"value": 22,
		"hand": "right",
		"damage": 20
	},
	"sword_iron": {
		"name": "Железный Меч",
		"icon": "⚔️",
		"category": "weapon",
		"desc": "Надежный кованый меч стражи. Урон: 24-32.",
		"value": 30,
		"hand": "right",
		"damage": 28
	},
	"bow_hunting": {
		"name": "Охотничий Лук",
		"icon": "🏹",
		"category": "weapon",
		"desc": "Гибкий лук для охоты на дичь. Урон: 22-30.",
		"value": 45,
		"hand": "right",
		"damage": 25
	},
	"arrow": {
		"name": "Оперенная Стрела",
		"icon": "🎯",
		"category": "ammo",
		"desc": "Острая стрела с железным наконечником.",
		"value": 2
	},
	"meat_roasted": {
		"name": "Жареное Мясо",
		"icon": "🍗",
		"category": "food",
		"desc": "Ароматный кусок мяса со специями. Восстанавливает 55 HP.",
		"value": 16,
		"heal_hp": 55.0,
		"restore_stamina": 35.0
	},
	"fish": {
		"name": "Речная Рыба",
		"icon": "🐟",
		"category": "food",
		"desc": "Свежая речная рыба. Можно приготовить Царскую Уху на костре.",
		"value": 6,
		"heal_hp": 15.0,
		"restore_stamina": 10.0
	},
	"gem_ruby": {
		"name": "Алый Рубин",
		"icon": "💎",
		"category": "valuable",
		"desc": "Драгоценный сверкающий камень из древней сокровищницы.",
		"value": 75
	},
	"gem_sapphire": {
		"name": "Синий Сапфир",
		"icon": "💎",
		"category": "valuable",
		"desc": "Редкий ограненный сапфир чистейшей воды.",
		"value": 90
	},
	"gem_emerald": {
		"name": "Изумруд",
		"icon": "💎",
		"category": "valuable",
		"desc": "Яркий зеленый самоцвет лесных недр.",
		"value": 85
	},
	"coal": {
		"name": "Древесный Уголь",
		"icon": "🪨",
		"category": "resource",
		"desc": "Жаркий уголь для кузнечного горна.",
		"value": 3
	},
	"gold_ore": {
		"name": "Золотая Руда",
		"icon": "🪨",
		"category": "resource",
		"desc": "Самородки золота из глубоких горных жил.",
		"value": 25
	},
	"gold_ingot": {
		"name": "Золотой Слиток",
		"icon": "🧱",
		"category": "resource",
		"desc": "Чистый золотой слиток высокой пробы.",
		"value": 75
	},
	"apple": {
		"name": "Лесное Яблоко",
		"icon": "🍎",
		"category": "food",
		"desc": "Сочное спелое яблоко. Восстанавливает 10 HP и утоляет жажду.",
		"value": 2,
		"heal_hp": 10.0,
		"restore_stamina": 15.0
	},
	"mushroom": {
		"name": "Лесной Гриб",
		"icon": "🍄",
		"category": "food",
		"desc": "Съедобный боровик из дубовой рощи.",
		"value": 3,
		"heal_hp": 8.0,
		"restore_stamina": 10.0
	},
	"water_flask": {
		"name": "Фляга с Водой",
		"icon": "🍶",
		"category": "food",
		"desc": "Холодная родниковая вода. Восстанавливает выносливость.",
		"value": 4,
		"restore_stamina": 35.0
	},
	"tools": {
		"name": "Набор Инструментов",
		"icon": "🧰",
		"category": "tool",
		"desc": "Железные инструменты для ремесла и ремонта построек.",
		"value": 15
	},
	"sword": {
		"name": "Стальной Меч",
		"icon": "🗡️",
		"category": "weapon",
		"desc": "Острый клинок из болотной стали. Урон: 25-35.",
		"value": 35,
		"hand": "right",
		"damage": 30
	},
	"armor": {
		"name": "Кованый Доспех",
		"icon": "🛡️",
		"category": "armor",
		"desc": "Прочные железные латы для защиты в бою.",
		"value": 80,
		"defense": 12
	}
}

static func get_category_name(cat: String) -> String:
	match cat:
		"weapon": return "Оружие"
		"shield": return "Щит"
		"armor": return "Доспех"
		"food": return "Еда и Напитки"
		"potion": return "Зелье / Алхимия"
		"resource", "material": return "Ресурс / Материал"
		"ammo": return "Боеприпасы"
		"tool": return "Инструмент"
		"structure": return "Строение"
		"valuable": return "Драгоценность"
		"medicine": return "Медицина"
		"misc": return "Разное"
		_: return "Разное"

static func get_item(id: String) -> Dictionary:
	if ITEMS.has(id):
		return ITEMS[id].duplicate(true)
	return {
		"name": id.capitalize(),
		"icon": "📦",
		"category": "misc",
		"desc": "Обычный предмет мира Олдерии.",
		"value": 1
	}
