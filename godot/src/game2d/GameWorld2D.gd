class_name GameWorld2D

extends Node2D



const OverworldMap2D = preload("res://src/world/OverworldMap2D.gd")

const PartyDatabase = preload("res://src/character/PartyDatabase.gd")

const PartyManager = preload("res://src/character/PartyManager.gd")

const EstateDatabase = preload("res://src/economy/EstateDatabase.gd")

const EstateManager = preload("res://src/economy/EstateManager.gd")

const NobilitySystem = preload("res://src/character/NobilitySystem.gd")

const SettlementDatabase = preload("res://src/economy/SettlementDatabase.gd")

const SettlementManager = preload("res://src/economy/SettlementManager.gd")

const ColonistAISystem = preload("res://src/economy/ColonistAISystem.gd")

const FishingSystem = preload("res://src/economy/FishingSystem.gd")

const AlchemySystem = preload("res://src/economy/AlchemySystem.gd")

const GarrisonManager = preload("res://src/character/GarrisonManager.gd")
const MountSystem = preload("res://src/economy/MountSystem.gd")
const NavalSystem = preload("res://src/economy/NavalSystem.gd")
const CitizenMindSystem = preload("res://src/economy/CitizenMindSystem.gd")
const CombatDepthSystem = preload("res://src/character/CombatDepthSystem.gd")
const InteriorSystem = preload("res://src/economy/InteriorSystem.gd")
const PetCompanionSystem = preload("res://src/character/PetCompanionSystem.gd")
const LPCAnimationController2D = preload("res://src/game2d/LPCAnimationController2D.gd")
const AtmosphereSystem = preload("res://src/world/AtmosphereSystem.gd")
const LivingDialogueSystem = preload("res://src/world/LivingDialogueSystem.gd")
const NPCRoutineController = preload("res://src/ai/NPCRoutineController.gd")



## 2D RPG-ПЕСОЧНИЦА В СТИЛЕ SOULASH 2 (Godot 4.x)

## Бесшовный тайловый мир, процедурные NPC, сбор ресурсов (рубка/добыча), строительство и глубокая симуляция



const TILE_SIZE := 48

const PLAYER_SPEED := 220.0

const PLAYER_RUN_SPEED := 380.0



# === НОДЫ МИРА ===

var world_map: WorldMap2D

var camera: Camera2D

const AtmosphereParticles2DScript = preload("res://src/world/AtmosphereParticles2D.gd")
const CitizenQuestSystemScript = preload("res://src/quest/CitizenQuestSystem.gd")
const NoticeBoardSystemScript = preload("res://src/quest/NoticeBoardSystem.gd")
const RaidSystemScript = preload("res://src/combat/RaidSystem.gd")
const AlarmBellSystemScript = preload("res://src/combat/AlarmBellSystem.gd")
const BanditCampSystemScript = preload("res://src/combat/BanditCampSystem.gd")
const DungeonGenerator2DScript = preload("res://src/dungeon/DungeonGenerator2D.gd")
const DungeonTrapSystemScript = preload("res://src/dungeon/DungeonTrapSystem.gd")
const DungeonBossSystemScript = preload("res://src/dungeon/DungeonBossSystem.gd")
const AgricultureSystem2DScript = preload("res://src/production/AgricultureSystem2D.gd")
const FishingSystem2DScript = preload("res://src/production/FishingSystem2D.gd")
const SmithingQualitySystemScript = preload("res://src/production/SmithingQualitySystem.gd")
const CookingBuffSystemScript = preload("res://src/production/CookingBuffSystem.gd")
const SocialMemoryDialogueSystemScript = preload("res://src/social/SocialMemoryDialogueSystem.gd")
const InterCitizenSocialSystemScript = preload("res://src/social/InterCitizenSocialSystem.gd")
const FamilyDynastyDeepeningSystemScript = preload("res://src/social/FamilyDynastyDeepeningSystem.gd")
const NPCLearningSystemScript = preload("res://src/social/NPCLearningSystem.gd")
const ApprenticeshipSystemScript = preload("res://src/social/ApprenticeshipSystem.gd")
const EquipmentSlotSystemScript = preload("res://src/combat/EquipmentSlotSystem.gd")
const CombatTacticsSystemScript = preload("res://src/combat/CombatTacticsSystem.gd")
const InjuryMedicineSystemScript = preload("res://src/combat/InjuryMedicineSystem.gd")
const TownCouncilSystemScript = preload("res://src/settlement/TownCouncilSystem.gd")
const SettlementStockpileSystemScript = preload("res://src/settlement/SettlementStockpileSystem.gd")
const SettlementUnrestSystemScript = preload("res://src/settlement/SettlementUnrestSystem.gd")
const ProceduralAudioSystemScript = preload("res://src/audio/ProceduralAudioSystem.gd")
const JuiceEffectsSystemScript = preload("res://src/audio/JuiceEffectsSystem.gd")
const EnhancedArtGeneratorScript = preload("res://src/world/EnhancedArtGenerator.gd")
const InventoryModalScript = preload("res://src/ui/modals/InventoryModal.gd")
const SkillsModalScript = preload("res://src/ui/modals/SkillsModal.gd")
const TradeModalScript = preload("res://src/ui/modals/TradeModal.gd")
const SmithingModalScript = preload("res://src/ui/modals/SmithingModal.gd")
const ContractsModalScript = preload("res://src/ui/modals/ContractsModal.gd")
const PartyModalScript = preload("res://src/ui/modals/PartyModal.gd")
const EstateModalScript = preload("res://src/ui/modals/EstateModal.gd")
const ConstructionModalScript = preload("res://src/ui/modals/ConstructionModal.gd")
const ChestModalScript = preload("res://src/ui/modals/ChestModal.gd")
const OriginModalScript = preload("res://src/ui/modals/OriginModal.gd")
const CitizenShopModalScript = preload("res://src/ui/modals/CitizenShopModal.gd")
const AlchemyModalScript = preload("res://src/ui/modals/AlchemyModal.gd")
const StableModalScript = preload("res://src/ui/modals/StableModal.gd")
const ShipyardModalScript = preload("res://src/ui/modals/ShipyardModal.gd")
const DogModalScript = preload("res://src/ui/modals/DogModal.gd")
const BardModalScript = preload("res://src/ui/modals/BardModal.gd")
const DialogueModalScript = preload("res://src/ui/modals/DialogueModal.gd")
const EventModalScript = preload("res://src/ui/modals/EventModal.gd")
const SettlementModalScript = preload("res://src/ui/modals/SettlementModal.gd")
const CaravanModalScript = preload("res://src/ui/modals/CaravanModal.gd")
const RegionalDiplomacyModalScript = preload("res://src/ui/modals/RegionalDiplomacyModal.gd")
const TradeCaravanSystemScript = preload("res://src/world/TradeCaravanSystem.gd")
const RegionalDiplomacySystemScript = preload("res://src/world/RegionalDiplomacySystem.gd")
const RegionalMapSystemScript = preload("res://src/world/RegionalMapSystem.gd")
const FaunaSystem2DScript = preload("res://src/world/FaunaSystem2D.gd")
const AtmosphereVFXSystemScript = preload("res://src/world/AtmosphereVFXSystem.gd")
const WorldDecorationsSystemScript = preload("res://src/world/WorldDecorationsSystem.gd")
const FaunaVisualLayerScript = preload("res://src/world/FaunaVisualLayer.gd")
const CryptDungeonGenerator2DScript = preload("res://src/world/CryptDungeonGenerator2D.gd")
const CryptMonstersSystemScript = preload("res://src/world/CryptMonstersSystem.gd")
const CryptBossSystemScript = preload("res://src/world/CryptBossSystem.gd")
const CryptLootSystemScript = preload("res://src/world/CryptLootSystem.gd")

var crypt_dungeon_generator: RefCounted
var crypt_monsters_system: RefCounted
var crypt_boss_system: RefCounted
var crypt_loot_system: RefCounted

var fauna_visual_layer: Node2D

var enhanced_textures: Dictionary = {}
var fauna_system: RefCounted
var atmosphere_vfx_system: RefCounted
var world_decorations_system: RefCounted

var procedural_audio_system: RefCounted
var juice_effects_system: RefCounted

var town_council_system: RefCounted
var settlement_stockpile_system: RefCounted
var settlement_unrest_system: RefCounted

var equipment_slot_system: RefCounted
var combat_tactics_system: RefCounted
var injury_medicine_system: RefCounted

var npc_learning_system: RefCounted
var apprenticeship_system: RefCounted

var social_memory_dialogue_system: RefCounted
var inter_citizen_social_system: RefCounted
var family_dynasty_deepening_system: RefCounted

var agriculture_system: RefCounted
var fishing_system: RefCounted
var smithing_quality_system: RefCounted
var cooking_buff_system: RefCounted
var buffs_hud_label: Label

var dungeon_generator: RefCounted
var dungeon_trap_system: RefCounted
var dungeon_boss_system: RefCounted

var raid_system: RefCounted
var alarm_bell_system: RefCounted
var bandit_camp_system: RefCounted

var citizen_quest_system: RefCounted
var notice_board_system: RefCounted

var day_night_modulate: CanvasModulate
var atmosphere_particles: Node2D

var player_torch: PointLight2D



# === ИГРОК ===
var player_pos := Vector2(25.0 * TILE_SIZE, 27.5 * TILE_SIZE)
var player_sprite: Sprite2D
var player_anim_controller: LPCAnimationController2D
var player_hp: float = 100.0

var player_max_hp: float = 100.0

var player_stamina: float = 100.0

var player_max_stamina: float = 100.0

var player_fatigue: float = 0.0 # Накопленная усталость (ограничивает макс. выносливость)

var player_hunger: float = 100.0 # Сытость (0..100)

var player_max_hunger: float = 100.0

var stamina_regen_delay: float = 0.0

var is_blocking: bool = false

var attack_cooldown: float = 0.0

var is_attacking: bool = false

var torch_enabled: bool = true



# === ЖИТЕЛИ (NPC) ===

var npc_data: Array[Dictionary] = []

var npc_sprites: Array[Sprite2D] = []

var npc_positions: Array[Vector2] = []

var interaction_target: int = -1



# === ДИКАЯ ФАУНА И МОНСТРЫ ===

var wildlife_data: Array[Dictionary] = []

var wildlife_sprites: Array[Sprite2D] = []

var wildlife_positions: Array[Vector2] = []



# === ПОДЗЕМЕЛЬЕ (DUNGEON) ===

var is_in_dungeon: bool = false

var surface_backup_pos: Vector2 = Vector2.ZERO



# === ГЛОБАЛЬНАЯ КАРТА И ПУТЕШЕСТВИЯ [M] ===

var overworld_map: OverworldMap2D

var is_overworld_mode: bool = false

var overworld_player_tile: Vector2i = Vector2i(54, 70) # Стартовая деревня Олдерия

var current_location_id: String = "village_olderia"

var overworld_move_timer: float = 0.0

var env_lights: Array[PointLight2D] = []

var walk_anim_time: float = 0.0
var footstep_timer: float = 0.0
var player_direction_row: int = 2
var player_anim_step: float = 0.0
var last_tavern_social_day: int = -1
var last_food_consumption_day: int = -1



# === СТРОИТЕЛЬСТВО [B] ===

var is_building_mode: bool = false

var selected_build_idx: int = 0

var build_cursor: Sprite2D

var build_panel: PanelContainer

var build_blueprints_list: ItemList

var build_cost_label: Label



var build_catalog := [

	{"id": "wall_wood", "name": "🪵 Деревянная стена", "cost": {"wood": 1}, "desc": "Глухая стена из дубовых бревен."},

	{"id": "wall_stone", "name": "🧱 Каменная стена", "cost": {"iron_ore": 1}, "desc": "Прочная стена из тесаного камня."},

	{"id": "wooden_fence", "name": "🪵 Частокол / Забор", "cost": {"plank": 2}, "desc": "Ограда для защиты построек и загонов."},

	{"id": "door", "name": "🚪 Деревянная дверь", "cost": {"plank": 2}, "desc": "Открывается и закрывается на [E]."},

	{"id": "wood_floor", "name": "🪵 Дощатый пол", "cost": {"plank": 1}, "desc": "Уютный деревянный настил для дома."},

	{"id": "chest", "name": "📦 Сундук для хранения", "cost": {"plank": 3}, "desc": "Хранилище предметов на [E]."},

	{"id": "bed", "name": "🛏️ Кровать", "cost": {"plank": 3, "wood": 2}, "desc": "Отдых, сон до утра и лечение [E]."},

	{"id": "campfire", "name": "🔥 Походный костер", "cost": {"wood": 2}, "desc": "Очаг тепла, света и жарка мяса [E]."},

	{"id": "carpentry", "name": "🪚 Плотницкий верстак", "cost": {"wood": 2, "plank": 2}, "desc": "Верстак для распила бревен на доски [E]."},

	{"id": "bakery_oven", "name": "🍞 Печь пекаря", "cost": {"plank": 3, "iron_ore": 2}, "desc": "Печь для выпечки хлеба и пирогов [E]."},

	{"id": "farmland", "name": "🌾 Пшеничная грядка", "cost": {"wheat": 1}, "desc": "Посев зерна для получения урожая."},

	{"id": "town_banner", "name": "🚩 Знамя Поселения (Основать город)", "cost": {"wood": 4, "gold": 10}, "desc": "Основывает новое поселение в этой точке. Открывает управление городом [T] и привлекает переселенцев."},

	{"id": "alchemy_lab", "name": "🧪 Алхимический Стол", "cost": {"plank": 4, "iron_ingot": 2}, "desc": "Стол для варки целебных настоек, защитных эликсиров и ядов [E]."},

	{"id": "beehive", "name": "🐝 Пчелиный Улей (Пасека)", "cost": {"plank": 4, "wheat": 2}, "desc": "Улей для сбора меда и воска [E] и варки хмельной медовухи."}

]



# Хранилище сундука

var active_chest_tile: Vector2i = Vector2i(-1, -1)

var chest_panel: PanelContainer

var chest_items_list: ItemList

var chest_player_list: ItemList



# === UI / HUD ===

var is_ui_open: bool = false

var time_label: Label

var player_card: RichTextLabel

var health_bar: ProgressBar

var stamina_bar: ProgressBar

var hunger_bar: ProgressBar

var hp_label: Label

var stamina_label: Label

var hunger_label: Label

var hint_label: Label

var log_box: RichTextLabel



# Модальные окна

var dialogue_panel: PanelContainer

var dialogue_title: Label

var dialogue_text: RichTextLabel

var dialogue_options_container: VBoxContainer



var inventory_panel: PanelContainer

var inv_items_list: ItemList

var inv_details_label: RichTextLabel

var selected_inv_item: String = ""

var inventory_modal: RefCounted

var skills_modal: RefCounted

var trade_modal: RefCounted

var smithing_modal: RefCounted

var contracts_modal: RefCounted

var party_modal: RefCounted

var estate_modal: RefCounted

var construction_modal: RefCounted

var chest_modal: RefCounted

var origin_modal: RefCounted

var citizen_shop_modal: RefCounted

var alchemy_modal: RefCounted
var stable_modal: RefCounted
var shipyard_modal: RefCounted
var dog_modal: RefCounted
var bard_modal: RefCounted
var dialogue_modal: RefCounted
var event_modal: RefCounted
var settlement_modal: RefCounted
var caravan_modal: RefCounted
var regional_diplomacy_modal: RefCounted
var trade_caravan_system: RefCounted
var regional_diplomacy_system: RefCounted
var regional_map_system: RefCounted










var trade_panel: PanelContainer

var trade_merchant_list: ItemList

var trade_player_list: ItemList

var trade_gold_label: Label



var smith_panel: PanelContainer

var smith_recipe_list: ItemList

var smith_details_label: RichTextLabel

var selected_recipe_idx: int = -1



var event_panel: PanelContainer

var event_title_lbl: Label

var event_desc_lbl: RichTextLabel

var event_options_vbox: VBoxContainer

var event_timer: float = 300.0
var recent_event_ids: Array[String] = []
var last_season_index: int = 0
var _active_floating_labels: Array[Label] = []
var _log_line_count: int = 0



var skills_panel: PanelContainer

var skills_char_profile: RichTextLabel

var skills_list_vbox: VBoxContainer

var athletics_timer: float = 0.0



# Феодальные контракты и Доска объявлений [Q]

var contracts_panel: PanelContainer

var contracts_list: ItemList

var contracts_detail_label: RichTextLabel

var contracts_action_btn: Button

var contracts_abandon_btn: Button

var contracts_tab_idx: int = 0 # 0: Доступные, 1: Взятые, 2: Фракции

var selected_contract_id: String = ""

var quest_tracker_panel: PanelContainer

var quest_tracker_title: Label

var quest_tracker_desc: Label

var quest_tracker_bar: ProgressBar



# --- ДРУЖИНА И НАЕМНИКИ ---

var party_sprites: Array[Sprite2D] = []

var party_positions: Array[Vector2] = []

var party_order_mode: String = "follow" # "follow", "guard", "attack", "gather"

var party_panel: PanelContainer

var party_list: ItemList

var party_detail_label: RichTextLabel

var party_action_btn: Button

var party_dismiss_btn: Button

var party_tab_idx: int = 0 # 0: Моя дружина, 1: Наемники в таверне

var selected_party_id: String = ""

var party_hud_panel: PanelContainer

var party_hud_box: VBoxContainer

var party_attack_timer: float = 0.0

var last_wage_day: int = -1



# --- ДАЛЬНИЙ БОЙ И СТРЕЛЬБА ИЗ ЛУКА ---

var active_projectiles: Array[Dictionary] = []

var arrow_cooldown: float = 0.0

var enemy_archer_timer: float = 0.0



# --- ФЕОДАЛЬНОЕ ПОМЕСТЬЕ И БАТРАКИ ---

var estate_panel: PanelContainer

var estate_tab_idx: int = 0 # 0: Обзор и склад, 1: Найм рабочих, 2: Улучшения

var estate_info_label: RichTextLabel

var estate_list: ItemList

var estate_action_btn: Button

var estate_take_all_btn: Button

var selected_estate_item_id: String = ""

var last_production_hour: int = -1

var estate_worker_sprites: Array[Sprite2D] = []



# --- ОБОРОНА ДЕРЕВНИ И НАБЕГИ ---

var is_raid_active: bool = false

var raid_wave: int = 0

var raid_wave_enemies: Array[int] = []

var raid_boss_idx: int = -1

var raid_spawn_timer: float = 0.0



# --- KINGDOMS SANDBOX: ПОСЕЛЕНИЕ И МИГРАЦИЯ ---

var settlement_panel: PanelContainer

var settlement_tab_idx: int = 0 # 0: Обзор и Казна, 1: Граждане и Профессии, 2: Законы и Налоги, 3: Проекты Строительства, 4: Гарнизон и Стража

var settlement_info_label: RichTextLabel

var settlement_list: ItemList

var settlement_action_btn: Button

var settlement_tax_btn: Button

var settlement_withdraw_btn: Button

var settlement_recruit_militia_btn: Button

var settlement_recruit_archer_btn: Button

var settlement_recruit_knight_btn: Button

var settlement_dismiss_btn: Button
var settlement_feast_btn: Button

var selected_citizen_id: String = ""

var selected_project_id: String = ""

var selected_garrison_idx: int = -1

var migration_timer: float = 0.0

var origin_panel: PanelContainer

var last_tax_day: int = -1



# Осада разбойничьих фортов

var is_fort_siege_active: bool = false

var active_siege_fort_id: String = ""

var siege_enemies: Array[int] = []

var siege_boss_idx: int = -1

# Боевая глубина: травмы, кровотечения и медицина
var bleeding_timer: float = 0.0
var arm_injury_timer: float = 0.0
var leg_injury_timer: float = 0.0
var bleed_tick_timer: float = 0.0
var regen_salve_timer: float = 0.0

# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false
var is_tourney_active: bool = false
var tourney_round: int = 0
var tourney_enemy_idx: int = -1

# Морская верфь, корабли и экспедиции на острова

# Атмосфера, погода, дым из труб и вечерние окна 🕯️🌧️💨
var current_weather: String = "clear"
var weather_cycle_timer: float = 90.0
var smoke_emit_timer: float = 0.0

# Бродячий Бард в Таверне 🎸🎶🍻

# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary = {
	"is_tamed": false,
	"name": "Бродячий пес",
	"loyalty": 0,
	"state": "stay",
	"hp": 80.0,
	"max_hp": 80.0,
	"hunger": 20.0
}
var dog_pos: Vector2 = Vector2.ZERO
var dog_sprite: Sprite2D

var dog_bark_cooldown: float = 0.0
var dog_thought_timer: float = 0.0
var is_island_expedition_active: bool = false
var active_island_id: String = ""
var island_enemies: Array[int] = []
var island_boss_idx: int = -1



# Лавки горожан

var citizen_shop_panel: PanelContainer

var citizen_shop_list: ItemList

var citizen_shop_info: RichTextLabel

var active_shop_npc_idx: int = -1



# Алхимия и баффы зелий

var alchemy_panel: PanelContainer

var alchemy_list: ItemList

var alchemy_info: RichTextLabel

var selected_alchemy_recipe: String = "potion_healing"

var stoneskin_timer: float = 0.0

var swiftness_timer: float = 0.0

var poison_hits_left: int = 0



func _ready() -> void:

	# 1. Создание тайловой карты

	world_map = WorldMap2D.new()

	world_map.name = "WorldMap"

	add_child(world_map)

	

	# 2. Создание игрока

	_spawn_player()

	

	# 3. Спавн 18 процедурных жителей

	npc_data = NPCGenerator.generate_population(18)

	_spawn_npcs()

	

	# 4. Создание камеры с зумом

	camera = Camera2D.new()

	camera.zoom = Vector2(1.35, 1.35)

	camera.position_smoothing_enabled = true

	camera.position_smoothing_speed = 8.0

	add_child(camera)

	

	# 5. Освещение и День/Ночь (Soulash 2 Lighting)

	day_night_modulate = CanvasModulate.new()

	day_night_modulate.color = Color(1, 1, 1)

	add_child(day_night_modulate)

	

	_spawn_environmental_lights()
	
	# 5.5. Атмосферные частицы (листья, светлячки, искры)
	atmosphere_particles = AtmosphereParticles2DScript.new()
	atmosphere_particles.name = "AtmosphereParticles"
	add_child(atmosphere_particles)
	
	# 5.6. Квесты жителей и Доска Объявлений
	citizen_quest_system = CitizenQuestSystemScript.new()
	notice_board_system = NoticeBoardSystemScript.new()
	
	# 5.7. Военные системы и Оборона Поселения (Этап 2)
	raid_system = RaidSystemScript.new()
	alarm_bell_system = AlarmBellSystemScript.new()
	bandit_camp_system = BanditCampSystemScript.new()
	if world_map:
		bandit_camp_system.spawn_camp_structures(world_map)
	
	# 5.8. Подземелья и Склеп Забытых (Этап 3)
	dungeon_generator = DungeonGenerator2DScript.new()
	dungeon_trap_system = DungeonTrapSystemScript.new()
	dungeon_boss_system = DungeonBossSystemScript.new()
	
	# 5.9. Углубление Производства и Ремесел (Блок №1)
	agriculture_system = AgricultureSystem2DScript.new()
	fishing_system = FishingSystem2DScript.new()
	smithing_quality_system = SmithingQualitySystemScript.new()
	cooking_buff_system = CookingBuffSystemScript.new()
	
	# Начальный посев пшеницы на грядках
	for fx in range(20, 24):
		for fy in range(4, 7):
			agriculture_system.plant_crop(Vector2i(fx, fy), "wheat")
	
	# Точильный станок в кузнице
	if world_map:
		world_map.place_structure(Vector2i(28, 12), "grindstone")
	
	# 5.10. Углубление Социума, Памяти и Семьи (Блок №2)
	social_memory_dialogue_system = SocialMemoryDialogueSystemScript.new()
	inter_citizen_social_system = InterCitizenSocialSystemScript.new()
	family_dynasty_deepening_system = FamilyDynastyDeepeningSystemScript.new()
	
	# 5.11. Система Обучения и Подкрепления NPC
	npc_learning_system = NPCLearningSystemScript.new()
	apprenticeship_system = ApprenticeshipSystemScript.new()
	
	# 5.12. Углубление Боя и Экипировки (Блок №3)
	equipment_slot_system = EquipmentSlotSystemScript.new()
	combat_tactics_system = CombatTacticsSystemScript.new()
	injury_medicine_system = InjuryMedicineSystemScript.new()
	
	# 5.13. Углубление Управления Поселением (Блок №4)
	town_council_system = TownCouncilSystemScript.new()
	settlement_stockpile_system = SettlementStockpileSystemScript.new()
	settlement_unrest_system = SettlementUnrestSystemScript.new()
	
	# Геополитика, Торговые Караваны и Дипломатия
	trade_caravan_system = TradeCaravanSystemScript.new()
	regional_diplomacy_system = RegionalDiplomacySystemScript.new()
	regional_map_system = RegionalMapSystemScript.new()
	if overworld_map:
		overworld_map.caravan_system_ref = trade_caravan_system
	
	# 5.14. Процедурное Аудио и Тактильный Сок (Блок №5)
	procedural_audio_system = ProceduralAudioSystemScript.new()
	procedural_audio_system.init_player(self)
	juice_effects_system = JuiceEffectsSystemScript.new()
	
	# 5.16. Тотальное Визуальное и Атмосферное Преображение
	enhanced_textures = EnhancedArtGeneratorScript.generate_enhanced_textures()
	fauna_system = FaunaSystem2DScript.new()
	fauna_system.init_fauna()
	atmosphere_vfx_system = AtmosphereVFXSystemScript.new()
	atmosphere_vfx_system.init_vfx()
	world_decorations_system = WorldDecorationsSystemScript.new()
	fauna_visual_layer = FaunaVisualLayerScript.new()
	fauna_visual_layer.name = "FaunaVisualLayer"
	add_child(fauna_visual_layer)
	
	# 5.17. Большие Подземелья, Склепы и Босс
	crypt_dungeon_generator = CryptDungeonGenerator2DScript.new()
	crypt_monsters_system = CryptMonstersSystemScript.new()
	crypt_boss_system = CryptBossSystemScript.new()
	crypt_loot_system = CryptLootSystemScript.new()

	

	# 6. Курсор строительства

	_create_build_cursor()

	

	# 7. Полноценный HUD

	_build_ui_hud()

	

	# 8. Спавн дикой фауны (волки, вепри, олени)

	_spawn_wildlife()

	

	# 9. Создание глобальной карты мира Олдерии (Overworld 128x128)

	overworld_map = OverworldMap2D.new()

	overworld_map.name = "OverworldMap"

	overworld_map.visible = false

	add_child(overworld_map)
	overworld_map.caravan_system_ref = trade_caravan_system

	

	# 10. Инициализация дружины

	_sync_party_sprites()

	_update_party_hud()

	

	# 11. Инициализация поместья и рабочих

	_sync_estate_workers()

	

	# 12. Инициализация Kingdoms Sandbox (Поселение и Стартовый Путь)

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if p:

		SettlementManager.ensure_settlement(p)

		if p.origin_role == "":

			get_tree().create_timer(0.15).timeout.connect(_show_origin_modal)

	

	_log("[color=gold]⚔️ 2D Мир Олдерии запущен (Kingdoms Sandbox Edition).[/color]")

	_log("WASD — перемещение | ЛКМ — атака / лук | ПКМ — блок щитом | T — поселение | H — поместье | C — дружина | B — стройка | I — инвентарь")



func _spawn_player() -> void:
	player_sprite = Sprite2D.new()
	var _pwc_path := "res://assets/sprites/player_walk_cycle.png"
	var _pwc_abs := ProjectSettings.globalize_path(_pwc_path)
	if FileAccess.file_exists(_pwc_abs):
		var _pwc_img := Image.new()
		_pwc_img.load(_pwc_abs)
		var _pwc_tex := ImageTexture.create_from_image(_pwc_img)
		player_sprite.texture = _pwc_tex
		player_sprite.hframes = 9
		player_sprite.vframes = 4
		player_sprite.frame = 18
		player_sprite.scale = Vector2(0.85, 0.85)
	else:
		player_sprite.texture = SpriteGenerator2D.get_character_texture("Player", TILE_SIZE)

	player_sprite.position = player_pos
	add_child(player_sprite)

	

	# Мягкая тень под ногами игрока

	var shadow = Sprite2D.new()

	shadow.texture = SpriteGenerator2D.get_shadow_texture(16, 8)

	shadow.position = Vector2(0, 16)

	shadow.z_index = -1

	player_sprite.add_child(shadow)

	

	# Факел игрока — позиционируем ниже ног, чтобы не засвечивать голову
	player_torch = PointLight2D.new()
	player_torch.texture = SpriteGenerator2D.get_light_texture(240, Color(1.0, 0.82, 0.45, 0.95))
	player_torch.energy = 0.55
	player_torch.position = Vector2(0, 22)
	player_torch.enabled = true
	player_sprite.add_child(player_torch)



func _create_fire_particles(pos: Vector2) -> CPUParticles2D:
	var p = CPUParticles2D.new()
	p.position = pos
	p.amount = 8
	p.lifetime = 0.45
	p.direction = Vector2(0, -1)
	p.spread = 15.0
	p.gravity = Vector2(0, -8.0)
	p.initial_velocity_min = 6.0
	p.initial_velocity_max = 16.0
	p.scale_amount_min = 1.5
	p.scale_amount_max = 2.5
	p.color = Color(1.0, 0.70, 0.25, 0.85)
	add_child(p)
	return p


func _spawn_spark_particles(pos: Vector2, col: Color = Color(1.0, 0.85, 0.25)) -> void:
	var p = CPUParticles2D.new()
	p.position = pos
	p.amount = 14
	p.lifetime = 0.4
	p.one_shot = true
	p.explosiveness = 0.9
	p.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	p.spread = 180.0
	p.gravity = Vector2(0, 80.0)
	p.initial_velocity_min = 50.0
	p.initial_velocity_max = 120.0
	p.scale_amount_min = 2.0
	p.scale_amount_max = 4.0
	p.color = col
	add_child(p)
	get_tree().create_timer(0.5).timeout.connect(p.queue_free)


func _spawn_environmental_lights() -> void:
	# Костры и факелы в таверне и кузнице (по центру тайлов)
	var light_spots = [
		Vector2((24 + 0.5) * TILE_SIZE, (25 + 0.5) * TILE_SIZE), # Таверна (Очаг)
		Vector2((39 + 0.5) * TILE_SIZE, (25 + 0.5) * TILE_SIZE), # Кузница (Горн)
		Vector2((23 + 0.5) * TILE_SIZE, (39 + 0.5) * TILE_SIZE), # Рынок
		Vector2((40 + 0.5) * TILE_SIZE, (39 + 0.5) * TILE_SIZE)  # Замок
	]

	

	for s in light_spots:

		var light = PointLight2D.new()

		light.texture = SpriteGenerator2D.get_light_texture(180, Color(1.0, 0.75, 0.35, 0.9))

		light.position = s

		add_child(light)

		env_lights.append(light)

		_create_fire_particles(s)



func _spawn_npcs(loc_type: String = "village") -> void:
	# Очищаем предыдущие спрайты жителей при смене локации
	for s in npc_sprites:
		if is_instance_valid(s):
			s.queue_free()
	npc_sprites.clear()
	npc_positions.clear()
	npc_data = NPCGenerator.generate_population_for_location(loc_type, 14)

	for i in npc_data.size():
		var npc = npc_data[i]
		var role = npc.get("role", "Крестьянин")
		var spot_id = npc.get("work", "tavern")

		var start_tile: Vector2i
		match loc_type:
			"city":
				var city_spots = [Vector2i(31, 12), Vector2i(31, 52), Vector2i(32, 32), Vector2i(20, 38), Vector2i(24, 40), Vector2i(42, 38), Vector2i(30, 16), Vector2i(34, 18), Vector2i(26, 46)]
				start_tile = city_spots[i % city_spots.size()]
			"mine":
				var mine_spots = [Vector2i(22, 44), Vector2i(40, 44), Vector2i(31, 38), Vector2i(31, 20), Vector2i(26, 32), Vector2i(38, 30)]
				start_tile = mine_spots[i % mine_spots.size()]
			"swamp":
				var swamp_spots = [Vector2i(25, 24), Vector2i(34, 28), Vector2i(31, 31), Vector2i(28, 32), Vector2i(36, 30)]
				start_tile = swamp_spots[i % swamp_spots.size()]
			"farms":
				var farm_spots = [Vector2i(28, 18), Vector2i(28, 44), Vector2i(4, 28), Vector2i(18, 18), Vector2i(44, 18), Vector2i(18, 44)]
				start_tile = farm_spots[i % farm_spots.size()]
			"fort":
				var fort_spots = [Vector2i(31, 34), Vector2i(28, 24), Vector2i(22, 36), Vector2i(40, 36), Vector2i(31, 44), Vector2i(32, 44)]
				start_tile = fort_spots[i % fort_spots.size()]
			_:
				match role:
					"Крестьянин":
						var farm_tiles = [Vector2i(18, 48), Vector2i(22, 50), Vector2i(15, 52), Vector2i(25, 48), Vector2i(20, 53), Vector2i(27, 47)]
						start_tile = farm_tiles[i % farm_tiles.size()]
					"Кузнец":
						var smith_tiles = [Vector2i(38, 25), Vector2i(35, 27)]
						start_tile = smith_tiles[i % smith_tiles.size()]
					"Торговец":
						var market_tiles = [Vector2i(23, 38), Vector2i(25, 37), Vector2i(28, 35), Vector2i(27, 39)]
						start_tile = market_tiles[i % market_tiles.size()]
					"Городской Стражник":
						var guard_tiles = [Vector2i(31, 20), Vector2i(31, 35), Vector2i(31, 48), Vector2i(35, 38), Vector2i(28, 28)]
						start_tile = guard_tiles[i % guard_tiles.size()]
					"Лорд", "Священник":
						start_tile = Vector2i(40, 39)
					"Бандит", "Разбойник", "Разбойник-лучник":
						var bandit_tiles = [Vector2i(8, 12), Vector2i(11, 14), Vector2i(7, 16)]
						start_tile = bandit_tiles[i % bandit_tiles.size()]
						if i % 2 == 1:
							npc["role"] = "Разбойник-лучник"
							npc["is_ranged"] = true
					_:
						start_tile = _get_spot_tile(spot_id)

		

		var rand_offset = Vector2(randf_range(-12.0, 12.0), randf_range(-12.0, 12.0))

		var world_p = Vector2(start_tile.x * TILE_SIZE + TILE_SIZE/2.0, start_tile.y * TILE_SIZE + TILE_SIZE/2.0) + rand_offset

		npc_positions.append(world_p)

		

		# Параметры естественного поведения

		npc["home_tile"] = start_tile

		npc["target_pos"] = world_p

		npc["idle_timer"] = randf_range(1.0, 4.0)

		npc["walk_speed"] = randf_range(35.0, 50.0)

		

		var spr = Sprite2D.new()

		var npc_tex_path := _get_npc_sprite_path(role, npc.get("gender", "Мужской"))
		var p_abs := ProjectSettings.globalize_path(npc_tex_path)
		if FileAccess.file_exists(p_abs):
			var img = Image.load_from_file(p_abs)
			if img and not img.is_empty():
				spr.texture = ImageTexture.create_from_image(img)
				spr.hframes = 9
				spr.vframes = 4
				spr.frame = 18
				spr.scale = Vector2(0.85, 0.85)
		elif ResourceLoader.exists(npc_tex_path):
			spr.texture = load(npc_tex_path)
			spr.hframes = 9
			spr.vframes = 4
			spr.frame = 18
			spr.scale = Vector2(0.85, 0.85)
		else:
			spr.texture = SpriteGenerator2D.get_character_texture(npc["role"], TILE_SIZE)
		npc["anim_dir_row"] = 2

		spr.position = world_p

		add_child(spr)

		npc_sprites.append(spr)

		

		# Тень под ногами жителя

		var shadow = Sprite2D.new()

		shadow.texture = SpriteGenerator2D.get_shadow_texture(14, 7)

		shadow.position = Vector2(0, 16)

		shadow.z_index = -1

		spr.add_child(shadow)

		

		# Метка над головой (показывается ТОЛЬКО для активного NPC в фокусе)

		var lbl = Label.new()

		lbl.text = npc["name"]

		lbl.position = Vector2(-60, -26)

		lbl.size = Vector2(120, 16)

		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		lbl.add_theme_font_size_override("font_size", 11)

		lbl.add_theme_color_override("font_color", Color(1.0, 0.95, 0.7))

		lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.98))

		lbl.add_theme_constant_override("shadow_offset_x", 1)

		lbl.add_theme_constant_override("shadow_offset_y", 1)

		lbl.name = "Nameplate"
		lbl.visible = false
		spr.add_child(lbl)

		# Облачко мыслей и занятий NPC (Thought Bubble / Emote)
		var thought_lbl = Label.new()
		thought_lbl.name = "ThoughtBubble"
		thought_lbl.position = Vector2(-20, -42)
		thought_lbl.size = Vector2(40, 18)
		thought_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		thought_lbl.add_theme_font_size_override("font_size", 14)
		thought_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		thought_lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
		thought_lbl.add_theme_constant_override("shadow_offset_x", 1)
		thought_lbl.add_theme_constant_override("shadow_offset_y", 1)
		thought_lbl.text = ""
		spr.add_child(thought_lbl)


func _get_npc_sprite_path(role: String, gender: String = "Мужской") -> String:
	var is_female := (gender == "Женский")
	match role:
		"Крестьянин", "Крестьянка", "Хлебопашец", "Лесоруб", "Лесоруб-Плотник", "Пекарь":
			return "res://assets/sprites/npcs/npc_peasant_female.png" if is_female else "res://assets/sprites/npcs/npc_peasant_male.png"
		"Кузнец", "Кузнечиха":
			return "res://assets/sprites/npcs/npc_blacksmith_female.png" if is_female else "res://assets/sprites/npcs/npc_blacksmith.png"
		"Торговец", "Торговка":
			return "res://assets/sprites/npcs/npc_merchant_female.png" if is_female else "res://assets/sprites/npcs/npc_merchant.png"
		"Городской Стражник", "Стражница", "Наемник", "Воин", "Охотник", "Охотник-Егерь":
			return "res://assets/sprites/npcs/npc_guard_female.png" if is_female else "res://assets/sprites/npcs/npc_guard.png"
		"Бандит", "Разбойник", "Разбойник-лучник", "Разбойница":
			return "res://assets/sprites/npcs/npc_bandit_female.png" if is_female else "res://assets/sprites/npcs/npc_bandit.png"
		"Лорд", "Дворянин", "Староста", "Леди", "Дворянка":
			return "res://assets/sprites/npcs/npc_lord_female.png" if is_female else "res://assets/sprites/npcs/npc_lord.png"
		"Священник", "Монах":
			return "res://assets/sprites/npcs/npc_merchant_female.png" if is_female else "res://assets/sprites/npcs/npc_merchant.png"
		_:
			return "res://assets/sprites/npcs/npc_peasant_female.png" if is_female else "res://assets/sprites/npcs/npc_peasant_male.png"


func _get_spot_tile(spot_name: String) -> Vector2i:

	match spot_name:

		"tavern": return Vector2i(24, 25)

		"blacksmith": return Vector2i(38, 25)

		"market": return Vector2i(23, 38)

		"castle": return Vector2i(39, 38)

		"farm": return Vector2i(18, 50)

		"windmill": return Vector2i(15, 52)

		"home_a": return Vector2i(27, 32)

		"home_b": return Vector2i(33, 42)

		"barracks": return Vector2i(31, 22)

		"forest_camp": return Vector2i(8, 12)

		_: return Vector2i(27, 30)



func _spawn_wildlife() -> void:

	wildlife_data.clear()

	wildlife_positions.clear()

	for s in wildlife_sprites:

		s.queue_free()

	wildlife_sprites.clear()

	

	# Волки в лесной чаще

	var wolf_spawns = [

		Vector2i(9, 13),

		Vector2i(12, 11),

		Vector2i(13, 17),

		Vector2i(7, 19)

	]

	for p in wolf_spawns:

		_create_animal({

			"type": "wolf",

			"name": "Серый волк 🐺",

			"role": "Волк",

			"hp": 45.0,

			"max_hp": 45.0,

			"dmg": 14.0,

			"speed": 110.0,

			"aggro_dist": 135.0,

			"attack_cd": 0.0,

			"is_hostile": true,

			"drops": {"meat": 2, "wolf_pelt": 1}

		}, p)

		

	# Вепри у дубрав

	var boar_spawns = [

		Vector2i(44, 48),

		Vector2i(47, 52)

	]

	for p in boar_spawns:

		_create_animal({

			"type": "boar",

			"name": "Лесной вепрь 🐗",

			"role": "Вепрь",

			"hp": 65.0,

			"max_hp": 65.0,

			"dmg": 18.0,

			"speed": 90.0,

			"aggro_dist": 90.0,

			"attack_cd": 0.0,

			"is_hostile": false,

			"drops": {"meat": 3}

		}, p)



	# Олени на южных лугах

	var deer_spawns = [

		Vector2i(12, 47),

		Vector2i(16, 53)

	]

	for p in deer_spawns:

		_create_animal({

			"type": "deer",

			"name": "Лесной олень 🦌",

			"role": "Олень",

			"hp": 30.0,

			"max_hp": 30.0,

			"dmg": 0.0,

			"speed": 135.0,

			"aggro_dist": 120.0,

			"attack_cd": 0.0,

			"is_hostile": false,

			"flee": true,

			"drops": {"meat": 2}

		}, p)



func _create_animal(data: Dictionary, tile_pos: Vector2i) -> void:

	var world_p = Vector2(tile_pos.x * TILE_SIZE + TILE_SIZE/2.0, tile_pos.y * TILE_SIZE + TILE_SIZE/2.0)

	wildlife_data.append(data)

	wildlife_positions.append(world_p)

	

	var spr = Sprite2D.new()
	var a_type: String = data.get("type", "wolf")
	if a_type in ["skeleton", "skeleton_archer", "boss_malgrim"]:
		var anim = LPCAnimationController2D.new()
		var char_pfx = "boss" if a_type == "boss_malgrim" else ("skel_archer" if a_type == "skeleton_archer" else "skel")
		anim.setup(spr, char_pfx)
		if a_type == "boss_malgrim":
			spr.scale = Vector2(1.25, 1.25)
			spr.modulate = Color(0.9, 0.45, 0.95)
		else:
			spr.scale = Vector2(0.9, 0.9)
		data["anim_ctrl"] = anim
	else:
		spr.texture = SpriteGenerator2D.get_animal_texture(a_type, TILE_SIZE)

	spr.position = world_p
	add_child(spr)
	wildlife_sprites.append(spr)

	

	# Мягкая тень под ногами зверя

	var a_shadow = Sprite2D.new()

	a_shadow.texture = SpriteGenerator2D.get_shadow_texture(15, 8)

	a_shadow.position = Vector2(0, 16)

	a_shadow.z_index = -1

	spr.add_child(a_shadow)

	

	var lbl = Label.new()

	lbl.text = data["name"]

	lbl.position = Vector2(-50, -36)

	lbl.size = Vector2(100, 20)

	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	lbl.add_theme_font_size_override("font_size", 11)

	lbl.add_theme_color_override("font_color", Color(1.0, 0.8, 0.8) if data.get("is_hostile", false) else Color(0.9, 0.9, 0.9))

	lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.98))

	lbl.name = "Nameplate"

	lbl.visible = false

	spr.add_child(lbl)



func _create_build_cursor() -> void:

	build_cursor = Sprite2D.new()

	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)

	for y in range(TILE_SIZE):

		for x in range(TILE_SIZE):

			var is_edge = (x < 2 or x >= TILE_SIZE - 2 or y < 2 or y >= TILE_SIZE - 2)

			img.set_pixel(x, y, Color(0.2, 0.9, 0.3, 0.7) if is_edge else Color(0.2, 0.9, 0.3, 0.2))

	build_cursor.texture = ImageTexture.create_from_image(img)

	build_cursor.visible = false

	add_child(build_cursor)



# =========================================================

# ГЕЙМПЛЕЙНЫЙ ЦИКЛ (Physics & Process)

# =========================================================

func _physics_process(delta: float) -> void:

	if is_overworld_mode:

		overworld_move_timer -= delta

		if overworld_move_timer <= 0.0:

			var step := Vector2i.ZERO

			if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): step.x -= 1

			elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): step.x += 1

			elif Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): step.y -= 1

			elif Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): step.y += 1

			

			if step != Vector2i.ZERO:

				var target_tile = overworld_player_tile + step

				if overworld_map.can_travel(target_tile):

					overworld_player_tile = target_tile

					overworld_map.set_player_tile(overworld_player_tile)

					overworld_move_timer = 0.20 / overworld_map.get_travel_speed_mult(target_tile)

					

					player_pos = Vector2(overworld_player_tile.x * OverworldMap2D.TILE_SIZE + OverworldMap2D.TILE_SIZE/2.0, overworld_player_tile.y * OverworldMap2D.TILE_SIZE + OverworldMap2D.TILE_SIZE/2.0)

					player_sprite.position = player_pos

					

					# Расход времени мира (15 минут за шаг)

					var tm = _get_time_manager()

					if tm:

						tm.minute += 15

						if tm.minute >= 60:

							tm.minute -= 60

							tm.hour += 1

							if tm.hour >= 24:

								tm.hour = 0

								tm.day += 1

					

					# Расход сытости при путешествии

					player_hunger = maxf(0.0, player_hunger - 0.5)

					if player_hunger < 15.0:

						player_hp = maxf(1.0, player_hp - 1.0)

						if randf() < 0.15:

							_log("[color=red]⚠️ Вы истощены от долгого перехода! Подкрепитесь хлебом или стейком.[/color]")

					

					_award_skill_xp("athletics", 1.5)

					_check_overworld_encounters()

					

					var loc = overworld_map.get_location_at(overworld_player_tile)

					if loc.size() > 0:

						_log("[color=gold]📍 Вы подошли к: %s (%s)[/color]" % [loc["name"], loc["desc"]])

						_spawn_floating_text(player_pos, loc["name"], Color(1.0, 0.95, 0.4), 16)

		return

	

	# Постепенный расход сытости

	player_hunger = maxf(0.0, player_hunger - 0.25 * delta)

	

	# Ограничение стамины усталостью (Fatigue)

	var effective_max_stamina = clampf(player_max_stamina - player_fatigue, 25.0, player_max_stamina)

	player_stamina = minf(player_stamina, effective_max_stamina)

	

	if stamina_regen_delay > 0.0:

		stamina_regen_delay -= delta

	else:

		var regen_rate = 7.5

		if player_hunger < 25.0:

			regen_rate = 3.5 # Замедление от голода

		elif player_hunger > 70.0:

			regen_rate = 9.5

		

		if player_stamina < effective_max_stamina:

			player_stamina = minf(effective_max_stamina, player_stamina + regen_rate * delta)

			

	if attack_cooldown > 0.0:

		attack_cooldown -= delta

	

	var input := Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): input.x -= 1

	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): input.x += 1

	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): input.y -= 1

	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): input.y += 1

	var is_moving = input != Vector2.ZERO

	var is_running = Input.is_key_pressed(KEY_SHIFT) and is_moving and player_stamina > 5.0

	

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	var ath_speed_mult = SkillSystem.get_athletics_speed_mult(p.skills) if p else 1.0

	var ath_stamina_cost = SkillSystem.get_athletics_stamina_cost(p.skills) if p else 20.0

	

	if is_running:

		player_stamina = maxf(0.0, player_stamina - ath_stamina_cost * delta)

		stamina_regen_delay = 1.0

		athletics_timer += delta

		if athletics_timer >= 1.0:

			athletics_timer = 0.0

			_award_skill_xp("athletics", 3.5)

	

	if is_moving and not is_blocking:

		var speed = (PLAYER_RUN_SPEED * ath_speed_mult) if is_running else PLAYER_SPEED

		if p and p.get("equipped_armor") == "leather_boots":

			speed *= 1.15 # Бонус +15% скорости от Сапог Скорохода

		if swiftness_timer > 0.0:

			swiftness_timer -= delta

			speed *= 1.35

		if stoneskin_timer > 0.0:

			stoneskin_timer -= delta

		var move_step = input.normalized() * speed * delta

		var new_pos = player_pos + move_step

		

		# Анимация 4-направленной походки из спрайтшита (LPC: 0=Up, 1=Left, 2=Down, 3=Right)
		if abs(input.x) > abs(input.y):
			if input.x < 0: player_direction_row = 1 # Влево
			elif input.x > 0: player_direction_row = 3 # Вправо
		else:
			if input.y > 0: player_direction_row = 2 # Вниз
			elif input.y < 0: player_direction_row = 0 # Вверх

		player_anim_step += delta * (14.0 if is_running else 9.5)
		var cur_step_frame = (int(player_anim_step) % 8) + 1
		if player_sprite.hframes == 9:
			player_sprite.frame = player_direction_row * 9 + cur_step_frame
			player_sprite.flip_h = false

		footstep_timer -= delta
		if footstep_timer <= 0.0:
			footstep_timer = 0.28 if is_running else 0.40
			var cur_t = Vector2i(int(player_pos.x / TILE_SIZE), int(player_pos.y / TILE_SIZE))
			var g_t = world_map.ground_tiles.get(cur_t, "grass") if world_map else "grass"
			if g_t in ["road", "stone_floor"]:
				_play_sfx("sfx_step_stone")
			else:
				_play_sfx("sfx_step_grass")

		# Проверка выхода за край карты на глобальный тракт
		if (player_pos.x <= 16.0 or player_pos.x >= 63.0 * TILE_SIZE - 16.0 or player_pos.y <= 16.0 or player_pos.y >= 63.0 * TILE_SIZE - 16.0):
			_exit_to_overworld()
			return

		# Проверка коллизий с картой по тайлам
		var target_tile = Vector2i(int(new_pos.x / TILE_SIZE), int(new_pos.y / TILE_SIZE))
		if not world_map.can_walk(target_tile):
			# Автоматически распахиваем дверь, если игрок идёт прямо в неё
			if world_map.interactive_nodes.has(target_tile):
				var d_node = world_map.interactive_nodes[target_tile]
				if d_node.get("type") == "door" and not d_node.get("is_open", false):
					world_map.toggle_door(target_tile)
					_play_sfx("sfx_door_open")

		if world_map.can_walk(target_tile):
			player_pos = new_pos
			player_sprite.position = player_pos
		else:
			# Скольжение по осям X и Y
			var test_x = Vector2(new_pos.x, player_pos.y)
			var tile_x = Vector2i(int(test_x.x / TILE_SIZE), int(test_x.y / TILE_SIZE))
			if world_map.can_walk(tile_x):
				player_pos = test_x
				player_sprite.position = player_pos

			var test_y = Vector2(player_pos.x, new_pos.y)
			var tile_y = Vector2i(int(test_y.x / TILE_SIZE), int(test_y.y / TILE_SIZE))
			if world_map.can_walk(tile_y):
				player_pos = test_y
				player_sprite.position = player_pos
	else:
		if is_blocking:
			var m_p = get_global_mouse_position()
			var b_dir = (m_p - player_pos).normalized()
			if abs(b_dir.x) > abs(b_dir.y):
				player_direction_row = 3 if b_dir.x > 0 else 1
			else:
				player_direction_row = 2 if b_dir.y > 0 else 0
		if player_sprite.hframes == 9:
			player_sprite.frame = player_direction_row * 9 # Кадр 0 - стойка покоя
		player_sprite.rotation_degrees = 0.0
		player_sprite.offset.y = 0.0

	

	# 5. Движение и бой дружины

	_update_party_movement_and_combat(delta)

	

	# 6. Физика полета стрел и снарядов

	_update_projectiles(delta)

	

	# 7. Дистанционный ИИ врагов-лучников

	_update_enemy_archers(delta)

	

	# 8. Физический труд и патрулирование поселенцев

	_update_colonists_labor(delta)



func _process(delta: float) -> void:
	if player_anim_controller:
		player_anim_controller.update(delta)

	camera.position = player_pos

	

	# Обновление курсора строительства

	if is_building_mode:

		var m_pos = get_global_mouse_position()

		var grid_pos = Vector2i(int(m_pos.x / TILE_SIZE), int(m_pos.y / TILE_SIZE))

		build_cursor.position = Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE/2.0, grid_pos.y * TILE_SIZE + TILE_SIZE/2.0)

		build_cursor.visible = true

	else:

		build_cursor.visible = false

	

	# Обновление времени и света (День/Ночь)

	var tm = _get_time_manager()

	var hour = tm.hour if tm else 12

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	

	# Автоматическая выработка батраков поместья каждые 3 часа

	if tm and p and p.has_estate and (hour % 3 == 0) and hour != last_production_hour:

		last_production_hour = hour

		var prod_res = EstateManager.produce_labor(p)

		var prod = prod_res.get("produced", {})

		if prod.size() > 0:

			var items_str = ""

			for it_id in prod.keys():

				var it = ItemDatabase.get_item(it_id)

				items_str += "%s %s +%d  " % [it.get("icon", "📦"), it.get("name", it_id), prod[it_id]]

			_log("[color=lightgreen]🌾 Батраки поместья пополнили склад усадьбы: %s[/color]" % items_str)

			_spawn_floating_text(player_pos, "📦 Склад поместья пополнен!", Color(0.4, 0.95, 0.5), 15)

	

	# Выплата ежедневного жалования дружине и расчет поместья в 07:00

	if tm and tm.hour == 7 and tm.day != last_wage_day and p:

		last_wage_day = tm.day

		var res = PartyManager.pay_daily_wages(p)

		if res.get("paid", 0) > 0:

			_log("[color=gold]💰 Выплачено ежедневное жалование дружине: %d золотых.[/color]" % res["paid"])

		if res.get("dismissed", []).size() > 0:

			for d_name in res["dismissed"]:

				_log("[color=red]⚠️ Из-за нехватки золота вас покинул наемник: %s![/color]" % d_name)

			_sync_party_sprites()

			_update_party_hud()

			

		# Финансы поместья

		var est_res = EstateManager.process_daily_estate_finances(p)

		if est_res.get("income", 0) > 0:

			_log("[color=gold]🐔 Доход с хозяйства поместья: +%d золотых.[/color]" % est_res["income"])

		if est_res.get("wages_paid", 0) > 0:

			_log("[color=gold]💰 Выплачено жалование батракам поместья: %d золотых.[/color]" % est_res["wages_paid"])

		if est_res.get("dismissed", []).size() > 0:

			for d_name in est_res["dismissed"]:

				_log("[color=red]⚠️ Из-за нехватки золота поместье покинул рабочий: %s![/color]" % d_name)

			_sync_estate_workers()

		# Потребление еды горожанами и проверка довольства в 07:00
		if tm.day != last_food_consumption_day:
			last_food_consumption_day = tm.day
			var cit_count = p.settlement.get("citizens", []).size() if p.settlement.get("has_town", false) else 5
			var food_res = settlement_stockpile_system.consume_daily_food(cit_count)
			var m = gm.local_market if gm else null
			
			# Если в амбаре не хватило, смотрим запасы рынка
			if food_res.get("starving", false) and m and m.inventory.get("bread", 0) > 0:
				var needed_extra = food_res["needed"] - food_res["consumed"]
				var from_m = mini(m.inventory.get("bread", 0), needed_extra)
				m.inventory["bread"] -= from_m
				food_res["consumed"] += from_m
				if food_res["consumed"] >= food_res["needed"]:
					food_res["starving"] = false
					
			var tax_pct = int(p.settlement.get("tax_rate", 0.10) * 100) if p.settlement.get("has_town", false) else 10
			if food_res.get("starving", false):
				var content = settlement_unrest_system.update_contentment(tax_pct, false, true)
				_log("[color=salmon]⚠️ ГОЛОД В ПОСЕЛЕНИИ! В амбарах и на рынке закончился хлеб (Довольство: %d%%). Жители ропщут![/color]" % content)
				_spawn_floating_text(player_pos, "⚠️ Голод в поселении!", Color.SALMON, 18)
				if settlement_unrest_system.is_revolt_active:
					_log("[color=red]🔥 КРЕСТЬЯНСКИЙ БУНТ! Недовольные жители вышли на площадь с вилами и факелами! Требуют хлеба и снижения налогов![/color]")
			else:
				var content = settlement_unrest_system.update_contentment(tax_pct, true, true)
				if content >= 75:
					_log("[color=lightgreen]🍞 Горожане сыты и довольны (Довольство: %d%%). Труд на полях и в мастерских спорится![/color]" % content)

	# Сбор налогов в казну поселения в 08:00
	if tm and tm.hour == 8 and tm.day != last_tax_day and p and p.settlement.get("has_town", false):
		last_tax_day = tm.day
		var tax_res = SettlementManager.collect_daily_taxes(p)
		if tax_res.get("tax_collected", 0) > 0:
			_log("[color=gold]🏛️ Городская казна пополнена налогами: +%d золотых (Всего в казне: %d з.)[/color]" % [tax_res["tax_collected"], tax_res["current_treasury"]])
			_spawn_floating_text(player_pos, "🏛️ Налоги собраны: +%d з." % tax_res["tax_collected"], Color.GOLD, 16)

	# Вечерний сбор в таверне и потасовки в 20:00
	if tm and tm.hour == 20 and tm.day != last_tavern_social_day and inter_citizen_social_system:
		last_tavern_social_day = tm.day
		var brawl_res = inter_citizen_social_system.check_evening_tavern_social(tm.hour, npc_data)
		if brawl_res.get("started", false):
			_log("[color=gold]🍻 %s[/color]" % brawl_res.get("msg", ""))
			_spawn_floating_text(player_pos, "🍻 Потасовка в таверне!", Color.GOLD, 18)

	# Обновление движения и событий торговых караванов
	if trade_caravan_system and trade_caravan_system.active_caravans.size() > 0:
		var c_events = trade_caravan_system.update_caravans(delta * 0.4, p, regional_map_system, regional_diplomacy_system)
		for ev in c_events:
			_log(ev.get("msg", ""))
			if ev.get("type", "") == "returned_home":
				_spawn_spark_particles(player_pos, Color.GOLD)
				_spawn_floating_text(player_pos, "+%d ЗОЛОТА С КАРАВАНА!" % ev.get("profit", 0), Color.GOLD, 18)
		if is_overworld_mode and overworld_map:
			overworld_map.queue_redraw()

			

	# Сезонные изменения и эффекты природы
	if tm and tm.season_index != last_season_index:
		last_season_index = tm.season_index
		var s_name = tm.get_current_season()
		match s_name:
			"Весна":
				_log("[color=lightgreen]🌸 Наступила Весна! Поля зеленеют, травы и цветы цветут пышным цветом.[/color]")
				_spawn_floating_text(player_pos, "🌸 Наступила Весна!", Color.LIGHT_GREEN, 20)
			"Лето":
				_log("[color=gold]☀️ Наступило Лето! Солнце греет Олдерию, посевы пшеницы наливаются колосом.[/color]")
				_spawn_floating_text(player_pos, "☀️ Наступило Лето!", Color.GOLD, 20)
			"Осень":
				_log("[color=orange]🍂 Наступила Осень! Пора щедрой жатвы (+50% зерна при сборе урожая).[/color]")
				_spawn_floating_text(player_pos, "🍂 Наступила Осень (Сбор урожая x1.5)!", Color.ORANGE, 20)
			"Зима":
				_log("[color=lightblue]❄️ Наступила Зима! Морозы сковали землю. Берегитесь голодных волков в лесах.[/color]")
				_spawn_floating_text(player_pos, "❄️ Наступила Зима!", Color.SKY_BLUE, 20)

	# Kingdoms Sandbox: Миграция поселенцев к Знамени

	if p and p.settlement.get("has_town", false):

		migration_timer += delta

		if migration_timer >= 60.0:

			migration_timer = 0.0

			_check_settler_migration()

	

	# Плавная смена освещения в зависимости от часа

	if is_overworld_mode:

		day_night_modulate.color = Color(1.0, 1.0, 1.0) # На карте мира ВСЕГДА идеальная яркая видимость!

	elif is_in_dungeon:

		day_night_modulate.color = Color(0.06, 0.06, 0.12)

	elif hour >= 21 or hour < 5:

		day_night_modulate.color = Color(0.18, 0.22, 0.38) # Глубокая ночь

	elif hour >= 5 and hour < 8:

		day_night_modulate.color = Color(0.85, 0.70, 0.55) # Рассвет

	elif hour >= 8 and hour < 18:

		day_night_modulate.color = Color(1.0, 1.0, 1.0) # Яркий день

	else:

		day_night_modulate.color = Color(0.85, 0.55, 0.40) # Закат

	

	# 1. Поиск ближайшего живого NPC для разговора

	interaction_target = -1

	var closest_dist := 75.0

	for i in npc_positions.size():

		if npc_data[i].get("is_dead", false):

			continue

		var d = player_pos.distance_to(npc_positions[i])

		if d < closest_dist:

			closest_dist = d

			interaction_target = i



	# 2. Поведение NPC и агрессивных разбойников (только на поверхности)
	if not is_in_dungeon and not is_overworld_mode:
		_update_surface_npcs(delta)

	# 4. Поведение дикой фауны (волки, вепри, олени, скелеты)

	for i in range(wildlife_data.size() - 1, -1, -1):

		var w = wildlife_data[i]

		if w.get("is_dead", false):

			continue

		var w_spr = wildlife_sprites[i]

		var w_pos = wildlife_positions[i]

		var d_p = w_pos.distance_to(player_pos)

		

		if w["attack_cd"] > 0.0:

			w["attack_cd"] -= delta

		

		# Олени убегают при приближении игрока

		if w.get("flee", false):

			if d_p < w["aggro_dist"]:

				var flee_dir = (w_pos - player_pos).normalized()

				var new_w_pos = w_pos + flee_dir * w["speed"] * delta

				var t_w = Vector2i(int(new_w_pos.x / TILE_SIZE), int(new_w_pos.y / TILE_SIZE))

				if world_map.can_walk(t_w):

					w_pos = new_w_pos

					wildlife_positions[i] = w_pos

					w_spr.position = w_pos

					var a_t: float = w.get("anim_t", 0.0) + delta * 12.0

					w["anim_t"] = a_t

					w_spr.offset.y = sin(a_t) * -3.0

					if flee_dir.x != 0: w_spr.flip_h = (flee_dir.x < 0)

			else:

				w_spr.offset.y = sin(Time.get_ticks_msec() * 0.002 + i) * -1.0

		elif w.get("is_hostile", false):
			# Волки, вепри, скелеты и босс
			var anim: LPCAnimationController2D = w.get("anim_ctrl", null)
			if d_p < w["aggro_dist"]:
				var to_player = player_pos - w_pos
				var chase_dir = to_player.normalized()
				if anim:
					anim.set_direction_from_vector(chase_dir)
				
				if w.get("is_ranged", false) and d_p >= 75.0 and d_p <= 300.0:
					# Стрельба скелета-лучника
					if w["attack_cd"] <= 0.0:
						w["attack_cd"] = 1.6
						if anim:
							anim.play(LPCAnimationController2D.AnimState.SLASH)
						_spawn_projectile(w_pos + chase_dir * 14.0, chase_dir, 460.0, w["dmg"], false, 320.0, 0.0, w["name"])
						_spawn_spark_particles(w_pos + chase_dir * 14.0, Color(0.3, 1.0, 0.4))
						_play_sfx("sfx_bow_shot")
						_log("[color=orange]⚠️ %s выпустил стрелу![/color]" % w["name"])
				elif d_p > 34.0:
					# Преследование с плавным скольжением по осям X и Y
					var move_step = chase_dir * w["speed"] * delta
					var new_w_pos = w_pos + move_step
					var t_all = Vector2i(int(new_w_pos.x / TILE_SIZE), int(new_w_pos.y / TILE_SIZE))
					var t_x = Vector2i(int(new_w_pos.x / TILE_SIZE), int(w_pos.y / TILE_SIZE))
					var t_y = Vector2i(int(w_pos.x / TILE_SIZE), int(new_w_pos.y / TILE_SIZE))
					
					if world_map.can_walk(t_all):
						w_pos = new_w_pos
					elif world_map.can_walk(t_x):
						w_pos.x = new_w_pos.x
					elif world_map.can_walk(t_y):
						w_pos.y = new_w_pos.y
						
					wildlife_positions[i] = w_pos
					w_spr.position = w_pos
					
					if anim:
						anim.play(LPCAnimationController2D.AnimState.WALK)
					else:
						var a_t: float = w.get("anim_t", 0.0) + delta * 14.0
						w["anim_t"] = a_t
						w_spr.offset.y = sin(a_t) * -3.5
						if chase_dir.x != 0: w_spr.flip_h = (chase_dir.x < 0)
				else:
					# Ближний бой (дистанция <= 34 px)
					if w["attack_cd"] <= 0.0:
						w["attack_cd"] = 0.95
						_animal_attack_player(w)
					else:
						if anim and not anim.is_locked:
							anim.play(LPCAnimationController2D.AnimState.IDLE)
			else:
				# Охота волков на диких оленей в Чернолесье
				var deer_target_idx := -1
				var best_deer_dist := 160.0
				if ("Волк" in w["name"] or "Хищник" in w["name"]) and not w.get("is_ranged", false):
					for d_i in range(wildlife_data.size()):
						var w_target = wildlife_data[d_i]
						if w_target.get("flee", false) and not w_target.get("is_dead", false):
							var dist_d = w_pos.distance_to(wildlife_positions[d_i])
							if dist_d < best_deer_dist:
								best_deer_dist = dist_d
								deer_target_idx = d_i

				if deer_target_idx >= 0:
					var d_target_pos = wildlife_positions[deer_target_idx]
					var to_deer = (d_target_pos - w_pos).normalized()
					var next_p = w_pos + to_deer * (w["speed"] * 0.75) * delta
					var pt_tile = Vector2i(int(next_p.x / TILE_SIZE), int(next_p.y / TILE_SIZE))
					if world_map.can_walk(pt_tile):
						w_pos = next_p
						wildlife_positions[i] = w_pos
						w_spr.position = w_pos
						if anim:
							anim.set_direction_from_vector(to_deer)
							anim.play(LPCAnimationController2D.AnimState.WALK)
					if best_deer_dist <= 30.0:
						_spawn_spark_particles(d_target_pos, Color.SALMON)
						_spawn_floating_text(d_target_pos, "🐺 Охота", Color.GOLD, 14)
				else:
					# Патрулирование в режиме покоя
					var patrol_t: float = w.get("patrol_timer", 0.0) - delta
					w["patrol_timer"] = patrol_t
					if patrol_t <= 0.0:
						w["patrol_timer"] = randf_range(2.0, 4.5)
						var p_offset = Vector2(randf_range(-60.0, 60.0), randf_range(-60.0, 60.0))
						w["patrol_target"] = w_pos + p_offset
						
					var p_target: Vector2 = w.get("patrol_target", w_pos)
					var to_pt = p_target - w_pos
					if to_pt.length() > 8.0:
						var p_dir = to_pt.normalized()
						var next_p = w_pos + p_dir * (w["speed"] * 0.45) * delta
						var pt_tile = Vector2i(int(next_p.x / TILE_SIZE), int(next_p.y / TILE_SIZE))
						if world_map.can_walk(pt_tile):
							w_pos = next_p
							wildlife_positions[i] = w_pos
							w_spr.position = w_pos
							if anim:
								anim.set_direction_from_vector(p_dir)
								anim.play(LPCAnimationController2D.AnimState.WALK)
						else:
							w["patrol_target"] = w_pos
					else:
						if anim:
							anim.play(LPCAnimationController2D.AnimState.IDLE)
						else:
							w_spr.offset.y = sin(Time.get_ticks_msec() * 0.0025 + i) * 1.5
					
			if anim:
				anim.update(delta)

	

	# Обновление HUD

	if tm:
		var s_icon = "🌱"
		match tm.season_index:
			0: s_icon = "🌱"
			1: s_icon = "☀️"
			2: s_icon = "🍂"
			3: s_icon = "❄️"
		var day_icon = "☀️" if (tm.hour >= 6 and tm.hour < 21) else "🌙"
		time_label.text = "%s %02d:%02d | Дн.%d %s %s" % [day_icon, tm.hour, tm.minute, tm.day, s_icon, tm.SEASONS[tm.season_index]]
	else:
		time_label.text = "☀️ 12:00 | Дн.1 🌱 Весна"

	

	if p:

		var w_name = ItemDatabase.get_item(p.equipped_weapon).get("name", "Кулаки")

		var s_name = ItemDatabase.get_item(p.equipped_shield).get("name", "Нет")

		player_card.text = """[b]%s[/b] | 💰 Золото: [color=gold]%d[/color] | Слава: %d | Честь: %d

[b]Оружие:[/b] %s | [b]Щит:[/b] %s""" % [p.get_full_display_name(), p.gold, p.renown, p.honor, w_name, s_name]

		_update_quest_tracker()

	

	var effective_max_stamina = clampf(player_max_stamina - player_fatigue, 25.0, player_max_stamina)

	if health_bar: health_bar.value = (player_hp / player_max_hp) * 100.0
	if hp_label: hp_label.text = "%.0f / %.0f" % [player_hp, player_max_hp]
	if stamina_bar: stamina_bar.value = (player_stamina / player_max_stamina) * 100.0
	if stamina_label:
		if player_fatigue > 0.0:
			stamina_label.text = "%.0f / %.0f (💤-%.0f)" % [player_stamina, effective_max_stamina, player_fatigue]
		else:
			stamina_label.text = "%.0f / %.0f" % [player_stamina, player_max_stamina]
	if hunger_bar: hunger_bar.value = (player_hunger / player_max_hunger) * 100.0
	if hunger_label: hunger_label.text = "%.0f%%" % player_hunger

	

	if interaction_target >= 0 and not is_ui_open:

		hint_label.text = "[ E ] Поговорить с %s | [ ЛКМ ] Атака / Добыча | [ B ] Постройка" % npc_data[interaction_target]["name"]

		hint_label.visible = true

	else:

		hint_label.visible = false

	

	# Таймер случайных событий

	if not is_ui_open:

		event_timer -= delta

		if event_timer <= 0.0:
			event_timer = randf_range(420.0, 720.0)
			_trigger_random_event()



# =========================================================

# БОЙ, СБОР РЕСУРСОВ И ВСПЛЫВАЮЩИЙ ТЕКСТ (Soulash 2)

# =========================================================

func _spawn_floating_text(pos: Vector2, text: String, color: Color, font_size: int = 14) -> void:
	_active_floating_labels = _active_floating_labels.filter(func(l): return is_instance_valid(l))
	if _active_floating_labels.size() >= 6:
		var oldest = _active_floating_labels.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()

	var lbl = Label.new()
	lbl.text = text
	lbl.position = pos + Vector2(randf_range(-14, 14), -24)
	lbl.add_theme_font_size_override("font_size", font_size)
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.98))
	lbl.add_theme_constant_override("shadow_offset_x", 1)
	lbl.add_theme_constant_override("shadow_offset_y", 1)
	lbl.z_index = 60
	add_child(lbl)
	_active_floating_labels.append(lbl)

	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(lbl, "position:y", lbl.position.y - 38.0, 0.85).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.85).set_ease(Tween.EASE_IN)
	tw.chain().tween_callback(func():
		_active_floating_labels.erase(lbl)
		if is_instance_valid(lbl):
			lbl.queue_free()
	)



func _perform_action_at_cursor(m_pos: Vector2) -> void:

	if is_attacking or attack_cooldown > 0.0 or player_stamina < 8.0:

		return

	

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	var w_id = p.equipped_weapon if p else ""

	var is_bow = w_id in ["bow", "bow_short", "bow_ash", "crossbow"]

	

	# === ВЫСТРЕЛ ИЗ ЛУКА (ДАЛЬНИЙ БОЙ) ===

	if is_bow:

		if not p or p.get_item_count("arrows") <= 0:

			_log("[color=orange]⚠️ У вас закончились стрелы в колчане! Изготовьте их на верстаке плотника [B/E]![/color]")

			_spawn_floating_text(player_pos, "НЕТ СТРЕЛ! 🎯", Color(1.0, 0.6, 0.2), 16)

			return

			

		p.remove_item("arrows", 1)

		is_attacking = true

		attack_cooldown = 0.40

		player_stamina = maxf(0.0, player_stamina - 8.0)

		

		var shoot_dir = (m_pos - player_pos).normalized()

		if shoot_dir == Vector2.ZERO: shoot_dir = Vector2.RIGHT

		

		var base_dmg: float = float(ItemDatabase.get_item(w_id).get("damage", 25))

		var dmg_mult: float = SkillSystem.get_archery_damage_mult(p.skills)

		var range_mult: float = SkillSystem.get_archery_range_mult(p.skills)

		var armor_pen: float = SkillSystem.get_archery_armor_pen(p.skills)

		

		var final_dmg = base_dmg * dmg_mult

		var max_dist = 340.0 * range_mult

		

		_spawn_projectile(player_pos + shoot_dir * 14.0, shoot_dir, 560.0, final_dmg, true, max_dist, armor_pen, "Игрок")
		_spawn_spark_particles(player_pos + shoot_dir * 16.0, Color(0.9, 0.9, 0.95))
		_play_sfx("sfx_bow_shot")
		
		var recoil_tw = create_tween()
		recoil_tw.tween_property(player_sprite, "offset", -shoot_dir * 3.5, 0.06)
		recoil_tw.tween_property(player_sprite, "offset", Vector2.ZERO, 0.10)
		
		_log("[color=cyan]🏹 Вы выпустили стрелу! (Осталось стрел: %d шт.)[/color]" % p.get_item_count("arrows"))

		get_tree().create_timer(0.35).timeout.connect(func(): is_attacking = false)
		return

	# 0. Проверка клика по двери рядом с игроком
	var click_tile = Vector2i(int(m_pos.x / TILE_SIZE), int(m_pos.y / TILE_SIZE))
	if player_pos.distance_to(m_pos) <= 90.0 and world_map.interactive_nodes.has(click_tile):
		var nd = world_map.interactive_nodes[click_tile]
		if nd.get("type") == "door":
			world_map.toggle_door(click_tile)
			_play_sfx("sfx_door_open")
			return

	is_attacking = true
	attack_cooldown = 0.28
	player_stamina -= 12.0

	

	var attack_dir = (m_pos - player_pos).normalized()
	if attack_dir == Vector2.ZERO:
		attack_dir = Vector2.DOWN

	if abs(attack_dir.x) > abs(attack_dir.y):
		player_direction_row = 3 if attack_dir.x > 0 else 1
	else:
		player_direction_row = 2 if attack_dir.y > 0 else 0

	# Взмах клинка / топора и выпад вперед
	_play_sfx("sfx_sword_swing")
	if player_anim_controller:
		player_anim_controller.set_direction_from_vector(attack_dir)
		player_anim_controller.play(LPCAnimationController2D.AnimState.SLASH)
	elif player_sprite and player_sprite.hframes == 9:
		player_sprite.frame = player_direction_row * 9
	_spawn_slash_effect(player_pos + attack_dir * 28.0, attack_dir.angle())
	var lunge_tw = create_tween()

	lunge_tw.tween_property(player_sprite, "offset", attack_dir * 7.0, 0.07)

	lunge_tw.tween_property(player_sprite, "offset", Vector2.ZERO, 0.12)

	

	# 1. Проверка добычи ресурсов в направлении удара (дерево, руда, пшеница)

	var reach_dist = 85.0

	var hit_node = false

	

	for d_step in [30.0, 60.0, 85.0]:

		var check_p = player_pos + attack_dir * d_step

		var check_tile = Vector2i(int(check_p.x / TILE_SIZE), int(check_p.y / TILE_SIZE))

		if world_map.interactive_nodes.has(check_tile):

			var res = world_map.damage_node(check_tile, 1)

			hit_node = true

			var n_type = res.get("type", "tree")

			var skill_key = "woodcutting"

			if n_type.begins_with("ore") or "ore" in n_type:

				skill_key = "mining"

			elif n_type.begins_with("crop") or "wheat" in n_type:

				skill_key = "farming"

			else:

				skill_key = "woodcutting"

				

			_award_skill_xp(skill_key, 15.0)

			var xp_icon = "⛏️" if skill_key == "mining" else ("🌾" if skill_key == "farming" else "🪓")

			_spawn_floating_text(check_p, "+15 XP %s" % xp_icon, Color(0.35, 0.95, 0.35))

			_spawn_spark_particles(check_p, Color(0.9, 0.7, 0.3) if skill_key == "woodcutting" else Color(0.6, 0.85, 1.0))

			

			if skill_key == "mining":
				_play_sfx("sfx_pickaxe")
			elif skill_key == "farming":
				_play_sfx("sfx_harvest")
			else:
				_play_sfx("sfx_chop")

			if res.get("destroyed", false):

				_award_skill_xp(skill_key, 45.0)

				if p and res["item_id"] != "":

					var amt = res["amount"]

	# 2. Проверка удара по врагам и NPC в секторе атаки

	for i in npc_positions.size():

		var to_npc = npc_positions[i] - player_pos

		var dist = to_npc.length()

		if dist <= reach_dist:

			if attack_dir.dot(to_npc.normalized()) > 0.25:

				_hit_npc(i)

				

	# 3. Проверка удара по дикой фауне и монстрам

	for i in wildlife_positions.size():

		var w = wildlife_data[i]

		if w.get("is_dead", false): continue

		var to_anim = wildlife_positions[i] - player_pos

		var dist = to_anim.length()

		if dist <= reach_dist:

			if attack_dir.dot(to_anim.normalized()) > 0.25:

				_hit_wildlife(i)

	

	get_tree().create_timer(0.22).timeout.connect(func(): is_attacking = false)



func _spawn_slash_effect(pos: Vector2, angle: float) -> void:

	var slash = Line2D.new()

	slash.width = 6.0

	slash.default_color = Color(1.0, 0.92, 0.35, 0.9)

	slash.joint_mode = Line2D.LINE_JOINT_ROUND

	slash.begin_cap_mode = Line2D.LINE_CAP_ROUND

	slash.end_cap_mode = Line2D.LINE_CAP_ROUND

	

	for a in range(-45, 55, 18):

		var rad = deg_to_rad(a) + angle

		slash.add_point(pos + Vector2(cos(rad), sin(rad)) * 24.0)

	

	add_child(slash)

	var tw = create_tween()

	tw.tween_property(slash, "modulate:a", 0.0, 0.16)

	tw.tween_callback(slash.queue_free)



func _hit_npc(idx: int) -> void:

	var npc = npc_data[idx]

	if npc.get("is_dead", false):

		return

		

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	var sword_bonus = SkillSystem.get_sword_damage_bonus(p.skills) if p else 0.0

	var crit_chance = SkillSystem.get_crit_chance(p.skills) if p else 0.05

	var is_crit = randf() < crit_chance

	

	var dmg = randi_range(24, 38) + int(sword_bonus)

	if is_crit:

		dmg = int(dmg * 2.0)

		_spawn_floating_text(npc_positions[idx], "💥 КРИТ! -%d" % dmg, Color(1.0, 0.85, 0.15), 18)

		_log("[color=gold][b]💥 КРИТИЧЕСКИЙ УДАР! %s получает %d урона![/b][/color]" % [npc["name"], dmg])

	else:

		_spawn_floating_text(npc_positions[idx], "-%d 🩸" % dmg, Color(1.0, 0.35, 0.35), 15)

		_log("[color=orange]Вы нанесли %d урона персонажу %s![/color]" % [dmg, npc["name"]])

		

	if poison_hits_left > 0:

		poison_hits_left -= 1

		dmg += 15

		_spawn_floating_text(npc_positions[idx], "☠️ ЯД! -15", Color.PURPLE, 16)

		_spawn_spark_particles(npc_positions[idx], Color.PURPLE)

		_log("[color=purple]☠️ Смертоносный яд на клинке нанес +15 урона (осталось ударов: %d)![/color]" % poison_hits_left)

		

	npc["hp"] -= dmg
	_play_sfx("sfx_sword_hit")
	_spawn_spark_particles(npc_positions[idx], Color(1.0, 0.85, 0.2) if is_crit else Color(0.9, 0.25, 0.25))
	_award_skill_xp("swordsmanship", 25.0)

	

	if npc["hp"] <= 0:

		npc["is_dead"] = true

		npc["hp"] = 0

		npc["thought"] = "💀 Мертв"

		

		# Анимация падения тела и обесцвечивание

		var spr = npc_sprites[idx]

		spr.rotation_degrees = 90.0 # Труп падает на землю

		spr.modulate = Color(0.45, 0.45, 0.45, 0.75) # Обесцвеченное тело

		

		# Убираем громоздкий текст над трупом

		var plate = spr.get_node_or_null("Nameplate") as Label

		if plate:

			plate.visible = false

			plate.queue_free()

			

		_spawn_spark_particles(npc_positions[idx], Color(0.85, 0.15, 0.15))

		_award_skill_xp("swordsmanship", 100.0)

		_spawn_floating_text(npc_positions[idx], "💀 УБИТ! +100 XP", Color(1.0, 0.3, 0.3), 16)

		_log("[color=red][b]💀 %s пал замертво![/b] Забрано трофеев: %d золотых.[/color]" % [npc["name"], npc["gold"]])

		

		if p:

			p.gold += npc["gold"]

			if npc["role"] in ["Бандит", "Разбойник"]:

				p.renown += 10

				_log("[color=gold]⭐ Слава увеличена на +10 за уничтожение бандита![/color]")

				var completed_quests = ContractManager.update_progress(p, "hunting", "bandit", 1)

				for cq in completed_quests:

					_log("[color=gold][b]📜 ЦЕЛЬ КОНТРАКТА ВЫПОЛНЕНА: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))

					_spawn_floating_text(player_pos, "📜 Задание выполнено!", Color(1.0, 0.9, 0.2), 18)
			else:
				p.honor -= 25
				_log("[color=red]⚠️ Убийство мирного жителя! Честь снижена на -25.[/color]")
		npc["gold"] = 0
		
		if is_raid_active:
			_check_raid_wave_progress()
		if is_fort_siege_active:
			_check_fort_siege_progress()
		if is_tourney_active:
			_check_tournament_progress()
		if is_island_expedition_active:
			_check_island_expedition_progress()

func _hit_wildlife(idx: int) -> void:
	var w = wildlife_data[idx]
	if w.get("is_dead", false): return
	
	# Вепри и другие животные становятся агрессивными при ударе

	w["is_hostile"] = true

	w["aggro_dist"] = 180.0

	

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	var sword_bonus = SkillSystem.get_sword_damage_bonus(p.skills) if p else 0.0

	var crit_chance = SkillSystem.get_crit_chance(p.skills) if p else 0.05

	var is_crit = randf() < crit_chance

	

	var dmg = randi_range(26, 40) + int(sword_bonus)

	if is_crit:

		dmg = int(dmg * 2.0)

		_spawn_floating_text(wildlife_positions[idx], "💥 КРИТ! -%d" % dmg, Color(1.0, 0.85, 0.15), 18)

		_log("[color=gold][b]💥 КРИТИЧЕСКИЙ УДАР! %s получает %d урона![/b][/color]" % [w["name"], dmg])

	else:

		_spawn_floating_text(wildlife_positions[idx], "-%d 🩸" % dmg, Color(1.0, 0.35, 0.35), 15)

		_log("[color=orange]Вы ранили %s на %d урона![/color]" % [w["name"], dmg])

		

	w["hp"] -= dmg
	_play_sfx("sfx_sword_hit")
	_spawn_spark_particles(wildlife_positions[idx], Color(1.0, 0.85, 0.2) if is_crit else Color(0.9, 0.25, 0.25))
	_award_skill_xp("swordsmanship", 25.0)

	# Анимация вздрагивания и вспышки урона (Flinch & Damage Flash)
	var spr = wildlife_sprites[idx]
	var anim: LPCAnimationController2D = w.get("anim_ctrl", null)
	if anim:
		anim.play(LPCAnimationController2D.AnimState.HURT)
	elif is_instance_valid(spr):
		var hit_dir = (wildlife_positions[idx] - player_pos).normalized()
		var tw = create_tween()
		tw.tween_property(spr, "modulate", Color(2.5, 0.4, 0.4), 0.05)
		tw.tween_property(spr, "offset", hit_dir * 8.0, 0.05)
		tw.tween_property(spr, "modulate", Color.WHITE, 0.12)
		tw.tween_property(spr, "offset", Vector2.ZERO, 0.12)

	if w["hp"] <= 0.0:
		w["is_dead"] = true
		if anim:
			anim.play(LPCAnimationController2D.AnimState.HURT, -1, func(): spr.visible = false)
		elif is_instance_valid(spr):
			var d_tw = create_tween()
			d_tw.set_parallel(true)
			d_tw.tween_property(spr, "scale", Vector2(1.2, 0.1), 0.25)
			d_tw.tween_property(spr, "modulate", Color(0.3, 0.3, 0.3, 0.0), 0.35)
			_spawn_spark_particles(wildlife_positions[idx], Color(0.95, 0.92, 0.85))

		# Убираем текст над павшим зверем
		for child in wildlife_sprites[idx].get_children():
			if child is Label:
				child.visible = false
				child.queue_free()

		_award_skill_xp("swordsmanship", 65.0)
		_spawn_floating_text(wildlife_positions[idx], "+65 XP ⚔️", Color(0.3, 1.0, 0.3), 16)

		# Выдача трофеев охоты и прогресс контрактов
		if p:
			var drops = w.get("drops", {})
			for it_id in drops.keys():
				var count = drops[it_id]
				p.add_item(it_id, count)
				var it = ItemDatabase.get_item(it_id)
				_log("[color=green]🐺 Добыча охотника: %s %s x%d![/color]" % [it.get("icon", "📦"), it.get("name", ""), count])
				_spawn_floating_text(wildlife_positions[idx] + Vector2(0, 16), "+%d %s" % [count, it.get("name", "")], Color(0.95, 0.82, 0.3), 14)

			var w_type = w.get("type", "wolf")
			var completed_quests = ContractManager.update_progress(p, "hunting", w_type, 1)
			for cq in completed_quests:
				_log("[color=gold][b]📜 ЦЕЛЬ КОНТРАКТА ВЫПОЛНЕНА: %s! Сдайте контракт на Доске Объявлений [ E ] или [ Q ].[/b][/color]" % cq.get("title", ""))
				_spawn_floating_text(player_pos, "📜 Задание выполнено!", Color(1.0, 0.9, 0.2), 18)


func _animal_attack_player(animal: Dictionary) -> void:
	var a_idx = wildlife_data.find(animal)
	if a_idx >= 0 and a_idx < wildlife_sprites.size():
		var a_spr = wildlife_sprites[a_idx]
		var anim: LPCAnimationController2D = animal.get("anim_ctrl", null)
		if anim:
			anim.set_direction_from_vector(player_pos - wildlife_positions[a_idx])
			anim.play(LPCAnimationController2D.AnimState.SLASH)
		elif is_instance_valid(a_spr):
			var lunge_dir = (player_pos - wildlife_positions[a_idx]).normalized()
			var a_tw = create_tween()
			a_tw.tween_property(a_spr, "offset", lunge_dir * 12.0, 0.07)
			a_tw.tween_property(a_spr, "offset", Vector2.ZERO, 0.12)
		_spawn_slash_effect(wildlife_positions[a_idx] + (player_pos - wildlife_positions[a_idx]).normalized() * 18.0, (player_pos - wildlife_positions[a_idx]).angle())
		if animal.get("is_boss", false):
			_shake_screen(8.0, 0.3)

	var dmg = randi_range(int(animal["dmg"] * 0.8), int(animal["dmg"] * 1.2))

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	

	if p and p.get("equipped_armor") != "":

		var arm = ItemDatabase.get_item(p.get("equipped_armor"))

		if arm.get("category") == "armor":

			dmg = maxi(2, dmg - 4) # Защита от доспеха

	

	if is_blocking and player_stamina >= 6.0:
		var shield_red = SkillSystem.get_shield_damage_reduction(p.skills) if p else 0.75
		var shield_stamina = SkillSystem.get_shield_stamina_cost(p.skills) if p else 12.0
		var blocked_dmg = int(dmg * (1.0 - shield_red))
		player_stamina = maxf(0.0, player_stamina - shield_stamina)
		stamina_regen_delay = 1.2
		player_hp = maxf(0.0, player_hp - blocked_dmg)
		_play_sfx("sfx_shield_block")
		_spawn_spark_particles(player_pos, Color(0.4, 0.85, 1.0))
		_award_skill_xp("shield_defense", 30.0)
		_spawn_floating_text(player_pos, "🛡️ БЛОК (-%d)" % blocked_dmg, Color(0.4, 0.85, 1.0), 16)
		_log("[color=cyan]🛡️ Вы отразили атаку %s! Получено всего %d урона.[/color]" % [animal["name"], blocked_dmg])
	else:
		player_hp = maxf(0.0, player_hp - dmg)
		stamina_regen_delay = 1.0
		_play_sfx("sfx_sword_hit")
		_spawn_floating_text(player_pos, "-%d ❤️" % dmg, Color(1.0, 0.25, 0.25), 16)
		_log("[color=red]⚠️ %s атаковал вас на %d урона![/color]" % [animal["name"], dmg])
		
	if player_hp <= 0.0:
		_on_player_defeat()


func _bandit_attack_player(idx: int) -> void:
	var npc = npc_data[idx]
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	var dmg = randi_range(14, 24)
	
	if p and p.get("equipped_armor") != "":
		var arm = ItemDatabase.get_item(p.get("equipped_armor"))
		if arm.get("category") == "armor":
			var def_val = arm.get("defense", 5)
			dmg = maxi(3, dmg - def_val) # Защита от доспеха
			
	if stoneskin_timer > 0.0:
		dmg = maxi(2, dmg - 10) # Защита от зелья каменной кожи (+10 DEF)
	
	if is_blocking and player_stamina >= 6.0:
		var red = SkillSystem.get_shield_damage_reduction(p.skills) if p else 0.75
		var st_cost = SkillSystem.get_shield_stamina_cost(p.skills) if p else 12.0
		player_stamina = maxf(0.0, player_stamina - st_cost)
		stamina_regen_delay = 1.2
		dmg = int(dmg * (1.0 - red))
		_play_sfx("sfx_shield_block")
		_spawn_spark_particles(player_pos, Color(0.4, 0.85, 1.0))
		_award_skill_xp("shield_defense", 30.0)
		_spawn_floating_text(player_pos, "🛡️ БЛОК (-%d)" % dmg, Color(0.4, 0.85, 1.0), 16)
	else:
		_play_sfx("sfx_sword_hit")
		_spawn_floating_text(player_pos, "-%d ❤️" % dmg, Color(1.0, 0.25, 0.25), 16)
		_log("[color=red]⚔️ %s нанес вам %d урона![/color]" % [npc["name"], dmg])

	

	player_hp = maxf(0.0, player_hp - dmg)

	attack_cooldown = 1.2

	

	if player_hp <= 0.0:

		_on_player_defeat()



func _on_player_defeat() -> void:
	_log("[color=red][b]💀 ВЫ ПОГИБЛИ В БОЮ![/b][/color]")
	_log("[color=gold]Вас спасли и перенесли в таверну «Пьяный Вепрь». Здоровье восстановлено.[/color]")
	
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p:
		var loss = int(p.gold * 0.2)
		p.gold = maxi(0, p.gold - loss)
		if loss > 0:
			_log("[color=orange]За спасение и услуги лекаря отдано %d золотых.[/color]" % loss)
	
	if is_in_dungeon:
		_toggle_dungeon() # Возвращаемся из подземелья на поверхность

	player_hp = player_max_hp
	player_stamina = player_max_stamina
	player_pos = Vector2(24.5 * TILE_SIZE, 27.5 * TILE_SIZE) # Внутри таверны
	player_sprite.position = player_pos
	camera.position = player_pos
	camera.reset_smoothing()
	_spawn_floating_text(player_pos, "🏥 ВОЗРОЖДЕНИЕ В ТАВЕРНЕ", Color(1.0, 0.85, 0.2), 20)



func _input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if is_building_mode:

				_build_tile_at_mouse()

			elif not is_ui_open:

				_perform_action_at_cursor(get_global_mouse_position())

		elif event.button_index == MOUSE_BUTTON_RIGHT:

			if is_building_mode:

				_toggle_building_mode()

			elif not is_ui_open:

				is_blocking = event.pressed

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:

			camera.zoom = (camera.zoom * 1.1).clamp(Vector2(0.7, 0.7), Vector2(2.5, 2.5))

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			camera.zoom = (camera.zoom * 0.9).clamp(Vector2(0.7, 0.7), Vector2(2.5, 2.5))

			

	if event is InputEventMouseButton and not event.pressed:

		if event.button_index == MOUSE_BUTTON_RIGHT:

			is_blocking = false

	

	if event is InputEventKey and event.pressed:

		if event.keycode == KEY_F:

			torch_enabled = not torch_enabled

			player_torch.enabled = torch_enabled

			_log("Факел: %s" % ("Включен 🔥" if torch_enabled else "Погашен 🌑"))

		elif event.keycode == KEY_M:

			_toggle_overworld_mode()

		elif event.keycode == KEY_B:

			_toggle_building_mode()

		elif event.keycode == KEY_I or event.keycode == KEY_TAB:

			_toggle_inventory()

		elif event.keycode == KEY_K:

			_toggle_skills()

		elif event.keycode == KEY_C or event.keycode == KEY_P:

			_toggle_party_menu()

		elif event.keycode == KEY_H:

			_toggle_estate_menu()

		elif event.keycode == KEY_T:

			_toggle_settlement_menu()

		elif event.keycode == KEY_Q or event.keycode == KEY_J:

			_toggle_contracts_menu()

		elif event.keycode == KEY_F1:

			party_order_mode = "follow"

			_log("[color=gold]🚩 Приказ дружине: Следовать строем за лидером![/color]")

			_spawn_floating_text(player_pos, "🚩 СТРОЙ: СЛЕДОВАНИЕ", Color(0.9, 0.85, 0.3), 16)

			_update_party_hud()

		elif event.keycode == KEY_F2:

			party_order_mode = "guard"

			_log("[color=gold]🛡️ Приказ дружине: Занять круговую оборону![/color]")

			_spawn_floating_text(player_pos, "🛡️ СТРОЙ: ОБОРОНА", Color(0.4, 0.85, 1.0), 16)

			_update_party_hud()

		elif event.keycode == KEY_F3:

			party_order_mode = "attack"

			_log("[color=gold]⚔️ Приказ дружине: Атаковать всех видимых врагов![/color]")

			_spawn_floating_text(player_pos, "⚔️ СТРОЙ: В АТАКУ!", Color(1.0, 0.3, 0.3), 16)

			_update_party_hud()

		elif event.keycode == KEY_F4:

			party_order_mode = "gather"

			_log("[color=gold]🪓 Приказ дружине: Помощь в заготовке леса и руды![/color]")

			_spawn_floating_text(player_pos, "🪓 СТРОЙ: СБОР РЕСУРСОВ", Color(0.5, 0.9, 0.4), 16)

			_update_party_hud()

		elif event.keycode == KEY_E and not is_ui_open:

			_handle_interaction_key()

		elif event.keycode == KEY_ESCAPE:

			if is_building_mode:

				_toggle_building_mode()

			elif is_ui_open:

				_close_all_modals()



func _handle_interaction_key() -> void:

	if is_overworld_mode:

		_enter_overworld_location()

		return

		

	var p_tile = Vector2i(int(player_pos.x / TILE_SIZE), int(player_pos.y / TILE_SIZE))

	

	# 1. Проверяем интерактивную мебель и двери в соседних клетках

	for dy in range(-1, 2):

		for dx in range(-1, 2):

			var t_pos = p_tile + Vector2i(dx, dy)

			if world_map.interactive_nodes.has(t_pos):

				var nd = world_map.interactive_nodes[t_pos]

				if nd["type"] == "town_banner":

					_toggle_settlement_menu()

					return

				elif nd["type"] == "alarm_bell":

					_trigger_alarm_bell()

					return

				elif nd["type"] == "notice_board":

					_open_notice_board_menu()

					return

				elif nd["type"] == "door":
					world_map.toggle_door(t_pos)
					_play_sfx("sfx_door_open")
					return

				elif nd["type"] == "bed":

					_sleep_in_bed()

					return

				elif nd["type"] == "chest":

					_open_chest_menu(t_pos)

					return

				elif nd["type"] == "campfire":

					_cook_at_campfire()

					return

				elif nd["type"] == "cave_entrance" or nd["type"] == "ladder_up":
					_toggle_dungeon()
					return
				elif nd["type"] == "sarcophagus":
					_open_sarcophagus(t_pos)
					return

				elif nd["type"] == "windmill":

					_use_windmill()

					return

				elif nd["type"] == "bakery_oven":

					_open_bakery_menu()

					return

				elif nd["type"] == "tannery":

					_open_tannery_menu()

					return

				elif nd["type"] == "carpentry":

					_use_carpentry_bench()

					return

				elif nd["type"] == "alchemy_lab":

					_open_alchemy_modal()

					return

				elif nd["type"] == "beehive":

					_harvest_beehive(t_pos)

					return

				elif nd["type"] in ["herb_hypericum", "herb_moonroot", "herb_belladonna"]:

					_harvest_herb(t_pos)

					return

	

	# Проверка рыбалки на воде

	if FishingSystem.is_near_water(p_tile, world_map):

		_try_fish()

		return

		

	# 2. Если рядом житель — говорим

	if interaction_target >= 0:

		_open_dialogue(interaction_target)



func _sleep_in_bed() -> void:
	var tm = _get_time_manager()
	if tm:
		tm.hour = 7
		tm.minute = 0
		tm.day += 1

	var bed_tile = Vector2i(player_pos / float(TILE_SIZE))
	var comfort = InteriorSystem.evaluate_room_comfort(bed_tile, world_map)

	player_fatigue = 0.0 # Полностью снимает усталость!
	player_hp = player_max_hp
	player_stamina = player_max_stamina
	player_hunger = maxf(25.0, player_hunger - 25.0)

	var c_name = comfort.get("name", "Простая Лачуга")
	_log("[color=gold]😴 Вы выспались до утра (07:00). Покои: %s (Оценка уюта: %d)[/color]" % [c_name, comfort.get("score", 0)])
	if comfort.get("thought", "") != "":
		_log(comfort["thought"])
	_spawn_floating_text(player_pos, "😴 Отдых: %s" % c_name, Color.GOLD, 16)



func _cook_at_campfire() -> void:

	var gm = _get_game_manager()

	var p = gm.player_data if gm else null

	if not p: return

	

	# Проверка рыбы для Царской Ухи

	var fish_check = FishingSystem.cook_fish_soup(p)

	if fish_check.get("success", false):

		_log("[color=gold][b]🍲 Вы сварили Царскую Уху из речной рыбы на костре! Сытность 100%, +40 HP![/b][/color]")

		_spawn_spark_particles(player_pos, Color.GOLD)

		_spawn_floating_text(player_pos, "+1 Царская Уха 🍲", Color.GOLD, 18)

		return

		

	if p.get_item_count("meat") >= 1:

		p.remove_item("meat", 1)

		p.add_item("steak", 1)

		_log("[color=green]🔥 Вы поджарили сырое мясо на костре (+55 HP Жареное Мясо 🍗)![/color]")

		_spawn_floating_text(player_pos, "+1 Жареное Мясо 🍗", Color(0.95, 0.85, 0.3), 16)

	else:

		_log("[color=orange]🔥 На костре можно пожарить мясо 🍗 или сварить Царскую Уху из 2 речных рыб 🍲![/color]")



func _use_windmill() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	if p.get_item_count("wheat") >= 2:

		p.remove_item("wheat", 2)

		p.add_item("flour", 1)

		_award_skill_xp("farming", 15.0)

		_log("[color=green]💨 Вы перемололи 2 пшеницы в 1 мешок муки 🥣![/color]")

		_spawn_floating_text(player_pos, "+1 Мука 🥣", Color(0.9, 0.95, 0.4), 16)

	else:

		_log("[color=orange]💨 Для помола муки требуется 2 снопа пшеницы 🌾 (соберите на полях)![/color]")



func _use_carpentry_bench() -> void:

	_close_all_modals()

	is_ui_open = true

	dialogue_panel.visible = true

	dialogue_title.text = "🪚 Плотницкий Верстак (Деревообработка и Стрелы)"

	dialogue_text.text = "[b]Рабочее место плотника и лучного мастера.[/b]\nЗдесь можно распилить бревна на доски, оперить стрелы и выстрогать боевые луки."

	

	for c in dialogue_options_container.get_children():

		c.queue_free()

		

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	

	_add_dialogue_btn("🪚 «Распилить бревно на 3 доски» (1 Дерево 🪵)", func():

		if p and p.get_item_count("wood") >= 1:

			p.remove_item("wood", 1)

			p.add_item("plank", 3)

			_award_skill_xp("woodcutting", 15.0)

			_log("[color=green]🪚 Вы распилили 1 бревно на 3 обрезные доски 🪚![/color]")

			_spawn_floating_text(player_pos, "+3 Доски 🪚", Color(0.85, 0.70, 0.35), 16)

			_use_carpentry_bench()

		else:

			_log("[color=red]Требуется хотя бы 1 дубовое бревно 🪵![/color]")

	)

	

	_add_dialogue_btn("🎯 «Изготовить связку стрел x10» (1 Дерево 🪵 + 1 Железная руда ⛏️)", func():

		if p and p.get_item_count("wood") >= 1 and p.get_item_count("iron_ore") >= 1:

			p.remove_item("wood", 1)

			p.remove_item("iron_ore", 1)

			p.add_item("arrows", 10)

			_award_skill_xp("woodcutting", 20.0)

			_award_skill_xp("archery", 15.0)

			_log("[color=green]🎯 Вы изготовили связку из 10 оперенных стрел с железными наконечниками![/color]")

			_spawn_floating_text(player_pos, "+10 Стрел 🎯", Color(0.3, 0.9, 0.95), 16)

			_use_carpentry_bench()

		else:

			_log("[color=red]Недостаточно ресурсов (требуется 1 Дерево 🪵 и 1 Железная руда ⛏️)![/color]")

	)

	

	_add_dialogue_btn("🏹 «Выстрогать Охотничий Лук» (2 Дерева 🪵 + 1 Кожа 🧥)", func():

		if p and p.get_item_count("wood") >= 2 and p.get_item_count("leather") >= 1:

			p.remove_item("wood", 2)

			p.remove_item("leather", 1)

			p.add_item("bow", 1)

			_award_skill_xp("woodcutting", 35.0)

			_award_skill_xp("archery", 25.0)

			_log("[color=gold]🏹 Вы выстрогали упругий Охотничий Лук![/color]")

			_spawn_floating_text(player_pos, "+1 Охотничий Лук 🏹", Color.GOLD, 16)

			_use_carpentry_bench()

		else:

			_log("[color=red]Недостаточно ресурсов (требуется 2 Дерева 🪵 и 1 Дублёная Кожа 🧥)![/color]")

	)

	

	_add_dialogue_btn("🏹 «Вырезать Ясеневый Длинный Лук» (4 Дерева 🪵 + 2 Кожи 🧥)", func():

		if p and p.get_item_count("wood") >= 4 and p.get_item_count("leather") >= 2:

			p.remove_item("wood", 4)

			p.remove_item("leather", 2)

			p.add_item("bow_ash", 1)

			_award_skill_xp("woodcutting", 60.0)

			_award_skill_xp("archery", 45.0)

			_log("[color=gold]🏹 Вы создали шедевральный Ясеневый Длинный Лук![/color]")

			_spawn_floating_text(player_pos, "+1 Длинный Лук 🏹", Color.GOLD, 18)

			_use_carpentry_bench()

		else:

			_log("[color=red]Недостаточно ресурсов (требуется 4 Дерева 🪵 и 2 Дублёных Кожи 🧥)![/color]")

	)



func _open_bakery_menu() -> void:

	_close_all_modals()

	is_ui_open = true

	dialogue_panel.visible = true

	dialogue_title.text = "🍞 Деревенская Печь (Выпечка)"

	dialogue_text.text = "[b]Ароматный жар раскаленной печи.[/b]\nЗдесь можно испечь хлеб и сочные мясные пироги."

	

	for c in dialogue_options_container.get_children():

		c.queue_free()

		

	_add_dialogue_btn("🥖 «Испечь свежий хлеб» (1 Мука 🥣)", func():

		var gm = _get_game_manager()

		var p: CharacterData = gm.player_data if gm else null

		if p and p.get_item_count("flour") >= 1:

			p.remove_item("flour", 1)

			p.add_item("bread", 1)

			_log("[color=green]🥖 Вы испекли пышный золотистый хлеб![/color]")

			_spawn_floating_text(player_pos, "+1 Хлеб 🍞", Color(1.0, 0.85, 0.3), 16)

			_open_bakery_menu()

		else:

			_log("[color=red]Недостаточно муки (требуется 1 мешок муки 🥣 с мельницы)![/color]")

	)

	

	_add_dialogue_btn("🥧 «Испечь сытный мясной пирог» (1 Мука 🥣 + 1 Мясо/Стейк 🥩)", func():

		var gm = _get_game_manager()

		var p: CharacterData = gm.player_data if gm else null

		if p and p.get_item_count("flour") >= 1 and (p.get_item_count("meat") >= 1 or p.get_item_count("steak") >= 1):

			p.remove_item("flour", 1)

			if p.get_item_count("steak") >= 1: p.remove_item("steak", 1)

			else: p.remove_item("meat", 1)

			p.add_item("meat_pie", 1)

			_log("[color=green]🥧 Вы испекли сочный королевский мясной пирог![/color]")

			_spawn_floating_text(player_pos, "+1 Мясной Пирог 🥧", Color(1.0, 0.85, 0.2), 18)

			_open_bakery_menu()

		else:

			_log("[color=red]Требуется 1 мешок муки 🥣 и 1 кусок мяса/стейка 🥩![/color]")

	)



func _open_tannery_menu() -> void:

	_close_all_modals()

	is_ui_open = true

	dialogue_panel.visible = true

	dialogue_title.text = "🧥 Кожевенный Чан и Пошив"

	dialogue_text.text = "[b]Мастерская выделки шкур и пошива легкой экипировки.[/b]"

	

	for c in dialogue_options_container.get_children():

		c.queue_free()

		

	_add_dialogue_btn("🧥 «Выделать шкуру волка в кожу» (1 Шкура 🐺 → 2 Кожи)", func():

		var gm = _get_game_manager()

		var p: CharacterData = gm.player_data if gm else null

		if p and p.get_item_count("wolf_pelt") >= 1:

			p.remove_item("wolf_pelt", 1)

			p.add_item("leather", 2)

			_award_skill_xp("smithing", 20.0)

			_log("[color=green]🧥 Вы выделали волчью шкуру в 2 листа прочной кожи![/color]")

			_spawn_floating_text(player_pos, "+2 Кожа 🧥", Color(0.85, 0.65, 0.35), 16)

			_open_tannery_menu()

		else:

			_log("[color=red]У вас нет волчьих шкур для выделки (добудьте на охоте на волков)![/color]")

	)

	

	_add_dialogue_btn("🥋 «Сшить кожаный доспех охотника» (3 Кожи 🧥)", func():

		var gm = _get_game_manager()

		var p: CharacterData = gm.player_data if gm else null

		if p and p.get_item_count("leather") >= 3:

			p.remove_item("leather", 3)

			p.add_item("leather_armor", 1)

			_award_skill_xp("smithing", 60.0)

			_log("[color=gold]🥋 Вы сшили отличный кожаный доспех охотника![/color]")

			_spawn_floating_text(player_pos, "+1 Кожаный Доспех 🥋", Color(1.0, 0.85, 0.2), 18)

			_open_tannery_menu()

		else:

			_log("[color=red]Недостаточно кожи (требуется 3 листа дубленой кожи 🧥)![/color]")

	)

	

	_add_dialogue_btn("👢 «Сшить сапоги скорохода» (2 Кожи 🧥)", func():

		var gm = _get_game_manager()

		var p: CharacterData = gm.player_data if gm else null

		if p and p.get_item_count("leather") >= 2:

			p.remove_item("leather", 2)

			p.add_item("leather_boots", 1)

			_award_skill_xp("smithing", 45.0)

			_log("[color=gold]👢 Вы сшили мягкие сапоги скорохода (+15% к скорости бега)![/color]")

			_spawn_floating_text(player_pos, "+1 Сапоги Скорохода 👢", Color(1.0, 0.85, 0.2), 18)

			_open_tannery_menu()

		else:
			_log("[color=red]Недостаточно кожи (требуется 2 листа кожи 🧥)![/color]")
	)


func _open_sarcophagus(pos: Vector2i) -> void:
	if not world_map.interactive_nodes.has(pos): return
	var node = world_map.interactive_nodes[pos]
	if node.get("is_opened", false):
		_log("[color=gray]⚰️ Этот древний саркофаг уже вскрыт и пуст.[/color]")
		return
		
	node["is_opened"] = true
	_play_sfx("sfx_door_open")
	_shake_screen(4.0, 0.2)
	
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p:
		p.add_item("dungeon_relic", 1)
		p.add_item("ancient_gold_coin", 5)
		p.gold += 35
		var completed_quests = ContractManager.update_progress(p, "kill", "crypt_clearing", 1)
		for cq in completed_quests:
			_log("[color=gold][b]📜 КОНТРАКТ ВЫПОЛНЕН: %s! Сдайте на доске [ Q ].[/b][/color]" % cq.get("title", ""))
			
	_log("[color=gold][b]⚰️ Вы сдвинули каменную крышку саркофага! Найдено: +1 Древняя Реликвия 👑, +5 Древних монет, +35 Золота 💰![/b][/color]")
	_spawn_floating_text(player_pos, "👑 РЕЛИКВИЯ НАЙДЕНА!", Color(1.0, 0.85, 0.2), 20)


func _toggle_dungeon() -> void:
	if not is_in_dungeon:
		# Спуск в Склеп Забытых
		is_in_dungeon = true
		player_pos = Vector2(8.5 * TILE_SIZE, 8.5 * TILE_SIZE)
		player_sprite.position = player_pos
		camera.position = player_pos
		day_night_modulate.color = Color(0.06, 0.06, 0.12) # Глубокая тьма подземелья
		
		# Скрываем жителей деревни и собаку в подземелье
		for s in npc_sprites:
			if is_instance_valid(s): s.visible = false
		if is_instance_valid(dog_sprite):
			dog_sprite.visible = false

		_generate_dungeon_level()
		_log("[color=red][b]🕳️ Вы спустились в холодный мрак «Склепа Забытых»...[/b][/color]")
		_spawn_floating_text(player_pos, "💀 СКЛЕП ЗАБЫТЫХ", Color(0.95, 0.25, 0.25), 20)
	else:
		# Подъем на поверхность
		is_in_dungeon = false
		player_pos = Vector2(6.5 * TILE_SIZE, 7.5 * TILE_SIZE)
		player_sprite.position = player_pos
		camera.position = player_pos

		# Восстанавливаем поверхность деревни Олдерии
		world_map.generate_world()
		world_map.queue_redraw()
		
		# Возвращаем жителей деревни и собаку
		for s in npc_sprites:
			if is_instance_valid(s): s.visible = true
		if is_instance_valid(dog_sprite):
			dog_sprite.visible = true
			
		_spawn_wildlife()
		_log("[color=gold][b]☀️ Вы поднялись на поверхность деревни Олдерии.[/b][/color]")
		_spawn_floating_text(player_pos, "☀️ ДЕРЕВНЯ ОЛДЕРИИ", Color(1.0, 0.9, 0.3), 20)



func _generate_dungeon_level() -> void:

	# Очищаем поверхность для склепа

	world_map.ground_tiles.clear()

	world_map.structure_tiles.clear()

	world_map.interactive_nodes.clear()

	

	# Заполняем каменным полом и стенами склепа

	for y in range(WorldMap2D.MAP_HEIGHT):

		for x in range(WorldMap2D.MAP_WIDTH):

			var pos = Vector2i(x, y)

			if x >= 5 and x <= 25 and y >= 5 and y <= 25:

				world_map.ground_tiles[pos] = "stone_floor"

				# Стены комнат и коридоров

				if x == 5 or x == 25 or y == 5 or y == 25 or (x == 15 and y != 12 and y != 18) or (y == 15 and x != 10 and x != 20):

					world_map.structure_tiles[pos] = "wall_stone"

			else:

				world_map.ground_tiles[pos] = "dirt"

				world_map.structure_tiles[pos] = "wall_stone"

	

	# Выход из подземелья (лестница наверх)

	# Выход из подземелья (лестница наверх)
	world_map.interactive_nodes[Vector2i(8, 8)] = {
		"type": "ladder_up",
		"name": "🪜 Лестница на Поверхность ☀️",
		"is_furniture": true,
		"hp": 999
	}

	# Древние саркофаги и сундуки с реликвиями
	world_map.interactive_nodes[Vector2i(22, 8)] = {
		"type": "sarcophagus",
		"name": "⚰️ Древний Саркофаг Королей",
		"is_furniture": true,
		"is_opened": false,
		"hp": 999
	}
	world_map.interactive_nodes[Vector2i(22, 20)] = {
		"type": "chest",
		"name": "📦 Золотой Ковчег Склепа",
		"inventory": {"gold_coins": 80, "ancient_gold_coin": 6, "iron_ingot": 4},
		"is_furniture": true,
		"hp": 999
	}

	# Факелы склепа
	world_map.interactive_nodes[Vector2i(10, 6)] = {"type": "campfire", "name": "Факел Склепа 🔥", "hp": 999}
	world_map.interactive_nodes[Vector2i(20, 6)] = {"type": "campfire", "name": "Факел Склепа 🔥", "hp": 999}
	world_map.interactive_nodes[Vector2i(10, 24)] = {"type": "campfire", "name": "Факел Склепа 🔥", "hp": 999}
	world_map.interactive_nodes[Vector2i(20, 24)] = {"type": "campfire", "name": "Факел Склепа 🔥", "hp": 999}

	world_map.queue_redraw()

	# Спавним бестиарий и Босса Склепа
	wildlife_data.clear()
	wildlife_positions.clear()
	for s in wildlife_sprites:
		if is_instance_valid(s):
			s.queue_free()
	wildlife_sprites.clear()

	# 1. Скелеты-стражи
	var skel_spawns = [Vector2i(12, 12), Vector2i(20, 10)]
	for sp in skel_spawns:
		_create_animal({
			"type": "skeleton",
			"name": "Скелет-страж 💀",
			"role": "Скелет",
			"hp": 55.0,
			"max_hp": 55.0,
			"dmg": 15.0,
			"speed": 105.0,
			"aggro_dist": 480.0,
			"attack_cd": 0.0,
			"is_hostile": true,
			"drops": {"ancient_gold_coin": 2, "iron_ore": 2}
		}, sp)

	# 2. Скелет-лучник
	_create_animal({
		"type": "skeleton_archer",
		"name": "Скелет-лучник 🏹",
		"role": "Скелет",
		"hp": 45.0,
		"max_hp": 45.0,
		"dmg": 14.0,
		"speed": 90.0,
		"aggro_dist": 420.0,
		"is_ranged": true,
		"attack_cd": 0.0,
		"is_hostile": true,
		"drops": {"arrows": 14, "ancient_gold_coin": 3}
	}, Vector2i(18, 14))

	# 3. БОСС: Проклятый Рыцарь Мальгрим
	_create_animal({
		"type": "boss_malgrim",
		"name": "💀 Проклятый Рыцарь Мальгрим (БОСС)",
		"role": "Босс",
		"hp": 250.0,
		"max_hp": 250.0,
		"dmg": 26.0,
		"speed": 100.0,
		"aggro_dist": 560.0,
		"attack_cd": 0.0,
		"is_hostile": true,
		"is_boss": true,
		"drops": {"sword_paladin_sun": 1, "dungeon_relic": 2, "gold_coins": 150}
	}, Vector2i(22, 22))



# === ГЛОБАЛЬНАЯ КАРТА И ПУТЕШЕСТВИЯ [M] ===

func _exit_to_overworld() -> void:
	_log("[color=gold]🗺️ Вы вышли за пределы поселения на королевский тракт Олдерии.[/color]")
	_set_overworld_mode(true)


func _toggle_overworld_mode() -> void:
	_set_overworld_mode(not is_overworld_mode)


func _set_overworld_mode(enable: bool) -> void:
	is_overworld_mode = enable
	_close_all_modals()
	
	if is_overworld_mode:
		world_map.visible = false
		overworld_map.visible = true
		overworld_map.set_player_tile(overworld_player_tile)
		camera.zoom = Vector2(0.95, 0.95)
		
		# Отключаем локальный свет, факел и NPC
		player_torch.enabled = false
		for l in env_lights: l.enabled = false
		for s in npc_sprites:
			if is_instance_valid(s): s.visible = false
		for s in wildlife_sprites:
			if is_instance_valid(s): s.visible = false
			
		player_pos = Vector2(overworld_player_tile.x * OverworldMap2D.TILE_SIZE + OverworldMap2D.TILE_SIZE/2.0, overworld_player_tile.y * OverworldMap2D.TILE_SIZE + OverworldMap2D.TILE_SIZE/2.0)
		if player_sprite: player_sprite.position = player_pos
		if camera:
			camera.position = player_pos
			camera.reset_smoothing()
			
		_log("[color=gold]🗺️ Вы вышли на глобальную карту Олдерии. WASD — путешествие | [ E ] — войти в локацию | [ M ] — закрыть[/color]")
		_spawn_floating_text(player_pos, "🗺️ КАРТА ОЛДЕРИИ", Color(1.0, 0.9, 0.4), 18)
	else:
		overworld_map.visible = false
		world_map.visible = true
		camera.zoom = Vector2(1.35, 1.35)
		
		# Включаем локальный свет и жителей
		player_torch.enabled = torch_enabled
		for l in env_lights: l.enabled = true
		for s in npc_sprites:
			if is_instance_valid(s): s.visible = true
		for s in wildlife_sprites:
			if is_instance_valid(s): s.visible = true
			
		_log("[color=gold]🏡 Локальная зона: %s[/color]" % current_location_id)


func _check_overworld_encounters() -> void:
	if randf() < 0.045:
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		var r = randf()
		if r < 0.35:
			_log("[color=red]⚠️ На тракте из засады выскочила шайка разбойников![/color]")
			_spawn_floating_text(player_pos, "⚔️ ЗАСАДА РАЗБОЙНИКОВ!", Color(1.0, 0.25, 0.25), 18)
			var dmg = randi_range(10, 18)
			player_hp = maxf(10.0, player_hp - dmg)
			_award_skill_xp("swordsmanship", 40.0)
			_play_sfx("sfx_hit")
		elif r < 0.70:
			_log("[color=cyan]🛡️ Вы встретили конный патруль королевской стражи! «Спокойной дороги, путник!» (+15 Здоровья)[/color]")
			player_hp = minf(player_max_hp, player_hp + 15.0)
			_spawn_floating_text(player_pos, "🛡️ Патруль Стражи (+15 HP)", Color(0.4, 0.9, 1.0), 16)
		else:
			_log("[color=green]🤝 Вы встретили бродячего купца. Он поделился провизией (+1 Свежий Хлеб)![/color]")
			if p: p.add_item("bread", 1)
			_spawn_floating_text(player_pos, "+1 Хлеб 🍞", Color(0.3, 1.0, 0.3), 16)


func _enter_overworld_location() -> void:
	var loc = overworld_map.get_location_at(overworld_player_tile)
	if loc.size() > 0:
		current_location_id = loc["id"]
		var loc_type = loc.get("type", "village")
		
		# 1. Перестраиваем карту под выбранный биом
		world_map.generate_world(loc_type, current_location_id)
		
		# 2. Переспавниваем жителей для данной зоны
		_spawn_npcs(loc_type)
		
		# 3. Переходим в локальный режим
		_set_overworld_mode(false)
		
		# 4. Позиционируем игрока у южного въезда
		player_pos = Vector2(31.5 * TILE_SIZE, 58.0 * TILE_SIZE)
		if player_sprite: player_sprite.position = player_pos
		if camera:
			camera.position = player_pos
			camera.reset_smoothing()
			
		_log("[color=gold][b]🏰 Вы вошли в локацию: %s![/b][/color]" % loc["name"])
		_spawn_floating_text(player_pos, "ВХОД: " + loc["name"], Color(1.0, 0.9, 0.3), 20)
		
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		if p:
			var completed_quests = ContractManager.update_progress(p, "delivery", loc["id"], 1)
			for cq in completed_quests:
				_log("[color=gold][b]📜 КУРЬЕРСКОЕ ПОРУЧЕНИЕ ВЫПОЛНЕНО: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))
				_spawn_floating_text(player_pos, "📜 Депеша доставлена!", Color(1.0, 0.9, 0.2), 18)
	else:
		_log("Здесь дикая равнина. Разбейте лагерь или двигайтесь к поселениям на карте.")



func _hire_caravan_travel(dest_tile: Vector2i, loc_id: String, loc_name: String) -> void:

	var gm = _get_game_manager()

	var p = gm.player_data if gm else null

	if not p or p.gold < 25:

		_log("[color=red]У вас недостаточно золота для найма места в караване (требуется 25 з.)![/color]")

		return

		

	p.gold -= 25

	var tm = _get_time_manager()

	if tm:

		tm.hour = (tm.hour + 6) % 24

		if tm.hour < 6: tm.day += 1

		

	overworld_player_tile = dest_tile

	current_location_id = loc_id

	_close_all_modals()

	_log("[color=gold][b]🐎 Вы успешно доехали с торговым караваном в %s![/b][/color]" % loc_name)

	_spawn_floating_text(player_pos, "🐎 КАРАВАН: " + loc_name, Color(1.0, 0.85, 0.2), 18)

	

	if p:

		var completed_quests = ContractManager.update_progress(p, "delivery", loc_id, 1)

		for cq in completed_quests:

			_log("[color=gold][b]📜 КУРЬЕРСКОЕ ПОРУЧЕНИЕ ВЫПОЛНЕНО: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))

			_spawn_floating_text(player_pos, "📜 Депеша доставлена!", Color(1.0, 0.9, 0.2), 18)



func _toggle_building_mode() -> void:
	if construction_modal == null:
		return
	if construction_modal.is_open():
		construction_modal.close()
		is_ui_open = false
		is_building_mode = false
		_log("Режим строительства выключен.")
	else:
		_close_all_modals()
		is_ui_open = true
		is_building_mode = true
		construction_modal.open()



func _build_tile_at_mouse() -> void:

	var bp = build_catalog[selected_build_idx]

	var m_pos = get_global_mouse_position()

	var grid_pos = Vector2i(int(m_pos.x / TILE_SIZE), int(m_pos.y / TILE_SIZE))

	

	var gm = _get_game_manager()

	var p = gm.player_data if gm else null

	if not p: return

	

	# Проверка стоимости

	for req_id in bp["cost"].keys():

		if p.get_item_count(req_id) < bp["cost"][req_id]:

			_log("[color=red]Недостаточно материалов для постройки: %s![/color]" % bp["name"])

			return

	

	# Размещение структуры

	if world_map.place_structure(grid_pos, bp["id"]):

		for req_id in bp["cost"].keys():

			if req_id == "gold":

				p.gold -= bp["cost"][req_id]

			else:

				p.remove_item(req_id, bp["cost"][req_id])

		p.renown += 2

		_log("[color=green]🎉 Вы построили: %s на клетке (%d, %d)![/color]" % [bp["name"], grid_pos.x, grid_pos.y])

		

		if bp["id"] == "town_banner":

			SettlementManager.found_settlement(p, "Новый Оксфорд", grid_pos)

			_log("[color=gold][b]🚩 ЗНАМЯ ПОСЕЛЕНИЯ ВОДРУЖЕНО! Вы основали собственное поселение! Откройте меню города [ T ].[/b][/color]")

			var b_pos = Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE/2.0, grid_pos.y * TILE_SIZE + TILE_SIZE/2.0)

			_spawn_spark_particles(b_pos, Color.GOLD)

			_spawn_floating_text(b_pos, "🚩 ПОСЕЛЕНИЕ ОСНОВАНО!", Color.GOLD, 22)

	else:

		_log("[color=red]Клетка занята или не подходит для постройки![/color]")



# =========================================================

# HUD И МОДАЛЬНЫЕ ОКНА (Soulash 2 Medieval UI)

# =========================================================

func _make_medieval_panel_style(bg_color: Color = Color(0.10, 0.11, 0.14, 0.94), border_color: Color = Color(0.78, 0.62, 0.28, 1.0), border_w: int = 2, radius: int = 6) -> StyleBox:
	# Делегирует в autoload UIHelpers (чистый статический хелпер оформления).
	return UIHelpers.panel_style(bg_color, border_color, border_w, radius)



func _style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
	# Делегирует в autoload UIHelpers.
	UIHelpers.style_button(btn, icon_color)



func _build_ui_hud() -> void:

	var canvas = CanvasLayer.new()

	canvas.name = "HUD2D"

	add_child(canvas)

	

	# Верхняя панель (Деревянно-золотая рамка)
	var top_panel = PanelContainer.new()
	top_panel.position = Vector2(16, 10)
	top_panel.custom_minimum_size = Vector2(1248, 40)
	top_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(6))
	canvas.add_child(top_panel)

	var top_bar = HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 6)
	top_panel.add_child(top_bar)

	time_label = Label.new()
	time_label.text = "🕒 12:00 | Весна, 1-й год"
	time_label.add_theme_font_size_override("font_size", 13)
	time_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.75))
	var med_font = UIHelpers.get_font(true)
	if med_font:
		time_label.add_theme_font_override("font", med_font)
	top_bar.add_child(time_label)

	var sep = VSeparator.new()
	top_bar.add_child(sep)

	var inv_btn = Button.new()
	inv_btn.text = "🎒 Инвентарь [I]"
	_style_button(inv_btn)
	inv_btn.pressed.connect(_toggle_inventory)
	top_bar.add_child(inv_btn)

	var skill_btn = Button.new()
	skill_btn.text = "📖 Навыки [K]"
	_style_button(skill_btn)
	skill_btn.pressed.connect(_toggle_skills)
	top_bar.add_child(skill_btn)

	var quest_btn = Button.new()
	quest_btn.text = "📜 Задания [Q]"
	_style_button(quest_btn)
	quest_btn.pressed.connect(_toggle_contracts_menu)
	top_bar.add_child(quest_btn)

	var market_btn = Button.new()
	market_btn.text = "⚖️ Рынок"
	_style_button(market_btn)
	market_btn.pressed.connect(_open_market_trade)
	top_bar.add_child(market_btn)

	var smith_btn = Button.new()
	smith_btn.text = "⚒️ Кузница"
	_style_button(smith_btn)
	smith_btn.pressed.connect(_open_smithing_menu)
	top_bar.add_child(smith_btn)

	var build_btn = Button.new()
	build_btn.text = "🔨 Стройка [B]"
	_style_button(build_btn)
	build_btn.pressed.connect(_toggle_building_mode)
	top_bar.add_child(build_btn)

	var map_btn = Button.new()
	map_btn.text = "🗺️ Карта [M]"
	_style_button(map_btn)
	map_btn.pressed.connect(_toggle_overworld_mode)
	top_bar.add_child(map_btn)

	var caravan_btn = Button.new()
	caravan_btn.text = "🐫 Обозы"
	_style_button(caravan_btn)
	caravan_btn.pressed.connect(_open_caravan_modal)
	top_bar.add_child(caravan_btn)

	var diplomacy_btn = Button.new()
	diplomacy_btn.text = "👑 Дипломатия"
	_style_button(diplomacy_btn)
	diplomacy_btn.pressed.connect(_open_diplomacy_modal)
	top_bar.add_child(diplomacy_btn)

	var party_btn = Button.new()
	party_btn.text = "👥 Дружина [C]"
	_style_button(party_btn)
	party_btn.pressed.connect(_toggle_party_menu)
	top_bar.add_child(party_btn)

	var estate_btn = Button.new()
	estate_btn.text = "🏰 Поместье [H]"
	_style_button(estate_btn)
	estate_btn.pressed.connect(_toggle_estate_menu)
	top_bar.add_child(estate_btn)

	var settlement_btn = Button.new()
	settlement_btn.text = "🏛️ Поселение [T]"
	_style_button(settlement_btn)
	settlement_btn.pressed.connect(_toggle_settlement_menu)
	top_bar.add_child(settlement_btn)

	# Здоровье, выносливость и сытость (Элегантный плавающий HUD с королевским медальоном)
	var stats_hud = HBoxContainer.new()
	stats_hud.position = Vector2(16, 56)
	stats_hud.add_theme_constant_override("separation", 10)
	canvas.add_child(stats_hud)

	# Королевский золотой медальон герба слева
	var crest_rect = TextureRect.new()
	crest_rect.texture = UIHelpers._get_texture("res://assets/ui/hud_crest.png")
	crest_rect.custom_minimum_size = Vector2(48, 48)
	crest_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	stats_hud.add_child(crest_rect)

	# Блок тонких золоченых полосок
	var bars_box = VBoxContainer.new()
	bars_box.add_theme_constant_override("separation", 4)
	bars_box.alignment = BoxContainer.ALIGNMENT_CENTER
	stats_hud.add_child(bars_box)

	var med_f = UIHelpers.get_font(true)

	# 1. Полоска здоровья (Рубиновый кристалл)
	var hp_row = HBoxContainer.new()
	hp_row.add_theme_constant_override("separation", 6)
	hp_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	bars_box.add_child(hp_row)

	var hp_icon = TextureRect.new()
	hp_icon.texture = UIHelpers._get_texture("res://assets/ui/icon_heart.png")
	hp_icon.custom_minimum_size = Vector2(16, 16)
	hp_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hp_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hp_row.add_child(hp_icon)

	health_bar = ProgressBar.new()
	health_bar.custom_minimum_size = Vector2(180, 14)
	health_bar.value = 100.0
	health_bar.show_percentage = false
	health_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	UIHelpers.style_sleek_bar(health_bar, "hp")
	hp_row.add_child(health_bar)

	hp_label = Label.new()
	hp_label.text = "100 / 100"
	hp_label.add_theme_font_size_override("font_size", 11)
	hp_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.92))
	hp_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	hp_label.add_theme_constant_override("shadow_offset_x", 1)
	hp_label.add_theme_constant_override("shadow_offset_y", 1)
	hp_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if med_f: hp_label.add_theme_font_override("font", med_f)
	hp_row.add_child(hp_label)

	# 2. Полоска выносливости (Изумрудная энергия)
	var st_row = HBoxContainer.new()
	st_row.add_theme_constant_override("separation", 6)
	st_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	bars_box.add_child(st_row)

	var st_icon = TextureRect.new()
	st_icon.texture = UIHelpers._get_texture("res://assets/ui/icon_stamina.png")
	st_icon.custom_minimum_size = Vector2(16, 16)
	st_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	st_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	st_row.add_child(st_icon)

	stamina_bar = ProgressBar.new()
	stamina_bar.custom_minimum_size = Vector2(180, 14)
	stamina_bar.value = 100.0
	stamina_bar.show_percentage = false
	stamina_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	UIHelpers.style_sleek_bar(stamina_bar, "stamina")
	st_row.add_child(stamina_bar)

	stamina_label = Label.new()
	stamina_label.text = "100 / 100"
	stamina_label.add_theme_font_size_override("font_size", 11)
	stamina_label.add_theme_color_override("font_color", Color(0.88, 1.0, 0.90))
	stamina_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	stamina_label.add_theme_constant_override("shadow_offset_x", 1)
	stamina_label.add_theme_constant_override("shadow_offset_y", 1)
	stamina_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if med_f: stamina_label.add_theme_font_override("font", med_f)
	st_row.add_child(stamina_label)

	# 3. Полоска сытости (Янтарный мед/хлеб)
	var hu_row = HBoxContainer.new()
	hu_row.add_theme_constant_override("separation", 6)
	hu_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	bars_box.add_child(hu_row)

	var hu_icon = TextureRect.new()
	hu_icon.texture = UIHelpers._get_texture("res://assets/ui/icon_bread.png")
	hu_icon.custom_minimum_size = Vector2(16, 16)
	hu_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hu_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hu_row.add_child(hu_icon)

	hunger_bar = ProgressBar.new()
	hunger_bar.custom_minimum_size = Vector2(180, 14)
	hunger_bar.value = 100.0
	hunger_bar.show_percentage = false
	hunger_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	UIHelpers.style_sleek_bar(hunger_bar, "hunger")
	hu_row.add_child(hunger_bar)

	hunger_label = Label.new()
	hunger_label.text = "100%"
	hunger_label.add_theme_font_size_override("font_size", 11)
	hunger_label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.75))
	hunger_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	hunger_label.add_theme_constant_override("shadow_offset_x", 1)
	hunger_label.add_theme_constant_override("shadow_offset_y", 1)
	hunger_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if med_f: hunger_label.add_theme_font_override("font", med_f)
	hu_row.add_child(hunger_label)

	# HUD дружины (Слева под характеристиками игрока)
	party_hud_panel = PanelContainer.new()
	party_hud_panel.position = Vector2(16, 158)
	party_hud_panel.custom_minimum_size = Vector2(260, 0)
	party_hud_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(8))
	canvas.add_child(party_hud_panel)

	party_hud_box = VBoxContainer.new()
	party_hud_box.add_theme_constant_override("separation", 4)
	party_hud_panel.add_child(party_hud_box)
	party_hud_panel.visible = false

	# Верхний правый угол: Компактный HUD-трекер активного контракта
	quest_tracker_panel = PanelContainer.new()
	quest_tracker_panel.position = Vector2(936, 58)
	quest_tracker_panel.custom_minimum_size = Vector2(328, 64)
	quest_tracker_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(8))
	canvas.add_child(quest_tracker_panel)

	var q_box = VBoxContainer.new()
	q_box.add_theme_constant_override("separation", 2)
	quest_tracker_panel.add_child(q_box)

	quest_tracker_title = Label.new()
	quest_tracker_title.text = "📜 Задание: Нет активных"
	quest_tracker_title.add_theme_font_size_override("font_size", 12)
	quest_tracker_title.add_theme_color_override("font_color", Color(1.0, 0.90, 0.55))
	quest_tracker_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	quest_tracker_title.custom_minimum_size = Vector2(304, 16)
	q_box.add_child(quest_tracker_title)

	quest_tracker_desc = Label.new()
	quest_tracker_desc.text = "Доска Заказов на площади [E] или меню [Q]"
	quest_tracker_desc.add_theme_font_size_override("font_size", 11)
	quest_tracker_desc.add_theme_color_override("font_color", Color(0.80, 0.82, 0.86))
	quest_tracker_desc.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	quest_tracker_desc.custom_minimum_size = Vector2(304, 15)
	q_box.add_child(quest_tracker_desc)

	quest_tracker_bar = ProgressBar.new()
	quest_tracker_bar.custom_minimum_size = Vector2(304, 10)
	quest_tracker_bar.show_percentage = false
	UIHelpers.style_progress_bar(quest_tracker_bar, "hunger")
	q_box.add_child(quest_tracker_bar)

	# Нижняя панель
	var bot_bar = HBoxContainer.new()
	bot_bar.position = Vector2(16, 566)
	bot_bar.custom_minimum_size = Vector2(1248, 138)
	bot_bar.add_theme_constant_override("separation", 16)
	canvas.add_child(bot_bar)

	var p_panel = PanelContainer.new()
	p_panel.custom_minimum_size = Vector2(440, 134)
	p_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(12))
	bot_bar.add_child(p_panel)

	player_card = RichTextLabel.new()
	player_card.bbcode_enabled = true
	player_card.fit_content = true
	var cur_f = UIHelpers.get_font(false)
	if cur_f: player_card.add_theme_font_override("normal_font", cur_f)
	p_panel.add_child(player_card)

	var log_panel = PanelContainer.new()
	log_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(12))
	bot_bar.add_child(log_panel)

	log_box = RichTextLabel.new()
	log_box.bbcode_enabled = true
	log_box.scroll_following = true
	if cur_f: log_box.add_theme_font_override("normal_font", cur_f)
	log_panel.add_child(log_box)

	# Интерактивная контекстная подсказка
	var hint_panel = PanelContainer.new()
	hint_panel.position = Vector2(340, 516)
	hint_panel.custom_minimum_size = Vector2(600, 38)
	hint_panel.add_theme_stylebox_override("panel", UIHelpers.dark_panel_style(6))

	canvas.add_child(hint_panel)

	

	hint_label = Label.new()

	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	hint_label.add_theme_font_size_override("font_size", 14)

	hint_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.45))

	hint_panel.add_child(hint_label)

	hint_panel.visible = false

	hint_label.item_rect_changed.connect(func(): hint_panel.visible = hint_label.visible)

	

	# Модальные окна

	_build_dialogue_modal(canvas)
	_build_event_modal(canvas)

	# Инвентарь вынесен в ui/modals/InventoryModal.gd (RefCounted-фасад).
	var _gm = _get_game_manager()
	var _pd = _gm.player_data if _gm else null
	inventory_modal = InventoryModalScript.new()
	inventory_modal.build(
		canvas,
		_pd,
		ItemDatabase,
		_apply_inventory_use_effects,  # on_use_effects(item_id)
		_on_inventory_equip_effects,   # on_equip_effects(item_id, item)
		_close_all_modals             # on_close
	)
	inventory_modal.item_selected.connect(_on_inv_item_selected)

	# Навыки вынесены в ui/modals/SkillsModal.gd (read-only фасад).
	skills_modal = SkillsModalScript.new()
	skills_modal.build(canvas, _pd, SkillSystem, _close_all_modals)

	# Контракты (фасад ui/modals/ContractsModal.gd; _build_contracts_modal -> pass).
	contracts_modal = ContractsModalScript.new()
	contracts_modal.build(
		canvas,
		_get_game_manager,
		_log,
		_spawn_floating_text,
		_spawn_spark_particles,
		_on_contract_action_pressed,
		_on_contract_abandon_pressed,
		_close_all_modals
	)

	# Дружина вынесена в ui/modals/PartyModal.gd (фасад; мутации через PartyManager+колбэки HUD).
	party_modal = PartyModalScript.new()
	party_modal.build(
		canvas,
		_get_game_manager,
		_log,
		_spawn_floating_text,
		_spawn_spark_particles,
		_on_party_action_pressed,  # on_action (hire)
		_on_party_dismiss_pressed, # on_dismiss
		_close_all_modals         # on_close
	)

	# Рынок вынесен в ui/modals/TradeModal.gd (фасад, мутации через local_market).
	trade_modal = TradeModalScript.new()
	trade_modal.build(canvas, _get_game_manager, _log, _close_all_modals)

	# Кузница вынесена в ui/modals/SmithingModal.gd (фасад, мутации через player_data).
	smithing_modal = SmithingModalScript.new()
	smithing_modal.build(canvas, smith_recipes, _get_game_manager, _log, _award_skill_xp, _close_all_modals)

	# Поместье вынесено в ui/modals/EstateModal.gd (фасад; мутации через EstateManager+колбэки HUD).
	estate_modal = EstateModalScript.new()
	estate_modal.build(
		canvas,
		_get_game_manager,
		_log,
		_spawn_floating_text,
		_spawn_spark_particles,
		_on_estate_action_pressed, # on_action (buy_deed/rest/hire/build)
		_on_estate_take_all_pressed, # on_take_all
		_close_all_modals          # on_close
	)

	_build_construction_modal(canvas)


	# Строительство вынесено в ui/modals/ConstructionModal.gd (фасад, self-contained).
	construction_modal = ConstructionModalScript.new()
	construction_modal.build(
		canvas,
		build_catalog,
		_log,
		_on_start_construction_placement,
		_close_all_modals
	)

	# Сундук вынесен в ui/modals/ChestModal.gd (фасад; мутации world_map+p через колбэки).
	chest_modal = ChestModalScript.new()
	chest_modal.build(
		canvas,
		_on_take_item_from_chest,  # on_take(item_id)
		_on_store_item_to_chest,   # on_store(item_id)
		_close_all_modals          # on_close
	)

	_build_settlement_modal(canvas)
	# Vybor puti vynesen v ui/modals/OriginModal.gd (fasade).
	origin_modal = OriginModalScript.new()
	origin_modal.build(
		canvas,
		_choose_origin,   # on_choose(orig_id)
		_close_all_modals  # on_close
	)

	# Lavka zhitelya vynesena v ui/modals/CitizenShopModal.gd (fasade).
	citizen_shop_modal = CitizenShopModalScript.new()
	citizen_shop_modal.build(
		canvas,
		_buy_citizen_shop_item,    # on_buy(item_id, price)
		_on_citizen_shop_item_selected,  # on_select(meta)
		_close_all_modals           # on_close
	)

	# Alhimiya vynesena v ui/modals/AlchemyModal.gd (fasade).
	alchemy_modal = AlchemyModalScript.new()
	alchemy_modal.build(
		canvas,
		_craft_selected_alchemy,  # on_craft()
		_close_all_modals         # on_close
	)

	# Konushnya vynesena v ui/modals/StableModal.gd (fasade).
	stable_modal = StableModalScript.new()
	stable_modal.build(
		canvas,
		_log,                    # on_log(text)
		_spawn_floating_text,    # on_floating_text(pos, text, color, size)
		_spawn_spark_particles,  # on_spark(pos, color)
		_get_game_manager,       # get_manager()
		_get_player_pos,         # get_player_pos()
		_get_is_mounted,         # get_is_mounted()
		_set_is_mounted,         # set_is_mounted(bool)
		_buy_selected_horse,     # on_buy(breed_id)
		_toggle_mount,           # on_toggle_mount(breed_id)
		_close_all_modals,       # on_close
	)

	# Morskaya verf vynesena v ui/modals/ShipyardModal.gd (fasade).
	shipyard_modal = ShipyardModalScript.new()
	shipyard_modal.build(
		canvas,
		_log,                    # on_log(text)
		_spawn_floating_text,    # on_floating_text(pos, text, color, size)
		_spawn_spark_particles,  # on_spark(pos, color)
		_get_game_manager,       # get_manager()
		_get_player_pos,         # get_player_pos()
		_buy_selected_ship,      # on_build(ship_type_id)
		_sail_sea_fishing,       # on_fish()
		_close_all_modals        # on_close
	)

	# Pes-kompanon vynesen v ui/modals/DogModal.gd (fasade).
	dog_modal = DogModalScript.new()
	dog_modal.build(
		canvas,
		_log,                    # on_log(text)
		_spawn_floating_text,    # on_floating_text(pos, text, color, size)
		_spawn_spark_particles,  # on_spark(pos, color)
		_get_dog_data,           # get_dog_data()
		_feed_dog_food,          # on_feed()
		_pet_dog_companion,      # on_pet()
		_dog_give_paw_action,    # on_paw()
		_toggle_dog_stay,        # on_toggle_stay()
		_rename_dog_prompt,      # on_rename()
		_close_all_modals        # on_close
	)

	# Bard vynesen v ui/modals/BardModal.gd (fasade).
	bard_modal = BardModalScript.new()
	bard_modal.build(
		canvas,
		_log,                    # on_log(text)
		_spawn_floating_text,    # on_floating_text(pos, text, color, size)
		_spawn_spark_particles,  # on_spark(pos, color)
		_get_game_manager,       # get_manager()
		_get_bard_pos,           # get_bard_pos()
		_play_selected_ballad,   # on_play(ballad_id)
		_close_all_modals        # on_close
	)

	# Караваны (CaravanModal.gd)
	caravan_modal = CaravanModalScript.new()
	caravan_modal.build(
		canvas,
		_dispatch_trade_caravan,
		_close_all_modals
	)

	# Региональная дипломатия (RegionalDiplomacyModal.gd)
	regional_diplomacy_modal = RegionalDiplomacyModalScript.new()
	regional_diplomacy_modal.build(
		canvas,
		_sign_diplomatic_treaty,
		_send_diplomatic_gift,
		_close_all_modals
	)

	# Диалоги с жителями (DialogueModal.gd)
	dialogue_modal = DialogueModalScript.new()
	dialogue_modal.build(canvas, _close_all_modals)

	# Случайные события (EventModal.gd)
	event_modal = EventModalScript.new()
	event_modal.build(canvas, _on_event_option_chosen, _close_all_modals)

	# Ратуша и поселение (SettlementModal.gd)
	settlement_modal = SettlementModalScript.new()
	settlement_modal.build(canvas, _on_settlement_action_dispatched, _close_all_modals)


func _build_dialogue_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: vybor vyneseno v ui/modals/DialogueModal.gd.
	pass



func _open_dialogue(idx: int, tab: String = "main") -> void:
	var npc = npc_data[idx]
	if npc.get("is_dead", false):
		_log("[color=gray]💀 Вы осмотрели останки %s. Жизнь покинула это тело.[/color]" % npc["name"])
		return

	if tab == "main":
		_close_all_modals()
		is_ui_open = true
		if dialogue_modal: dialogue_modal.open()

	var d_title = "Разговор: %s (%s)" % [npc["name"], npc["role"]]
	if dialogue_modal: dialogue_modal.set_title(d_title)
	var traits_str = ", ".join(npc.get("traits", []))
	var goal_str = npc.get("goal", "Жить своей жизнью")

	if tab == "main":
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		var tm = _get_time_manager()
		var hour = tm.hour if tm else 12
		var weather = "clear"
		var rep = npc.get("reputation_to_player", 0)
		var rep_str = "[color=lightgreen]Дружелюбное (+%d)[/color]" % rep if rep >= 20 else ("[color=salmon]Настороженное (%d)[/color]" % rep if rep <= -15 else "[color=gold]Нейтральное (%d)[/color]" % rep)

		var is_starving = false
		if settlement_stockpile_system:
			is_starving = (settlement_stockpile_system.stockpiles.get("bread", 0) <= 0 and (gm.local_market == null or gm.local_market.inventory.get("bread", 0) <= 0))
		var is_revolt = settlement_unrest_system.is_revolt_active if settlement_unrest_system else false
		var world_ctx = {
			"is_starving": is_starving,
			"peasant_revolt": is_revolt
		}

		var living_data = LivingDialogueSystem.get_dialogue_content(npc, p, weather, hour, world_ctx)
		var text_body = living_data.get("text", "Приветствую тебя в Олдерии, путник!")
		var full_body = """%s

[color=gray]🛡️ Отношение: %s | 🎯 Цель: %s[/color]""" % [text_body, rep_str, goal_str]
		if dialogue_modal: dialogue_modal.set_text(full_body)

	if dialogue_modal:
		dialogue_modal.clear_options()

	match tab:
		"main":
			# 1. Основное действие по профессии
			if npc["role"] == "Торговец" or npc["work"] == "market" or npc["work"] == "tavern":
				_add_dialogue_btn("⚖️ «Открыть торговлю» (Купить / Продать)", _open_market_trade)
				_add_dialogue_btn("🐫 «Снарядить торговый обоз...»", _open_caravan_modal)
				_add_dialogue_btn("👑 «Карта Региона и Дипломатия...»", _open_diplomacy_modal)
			elif npc["role"] == "Кузнец" or npc["work"] == "blacksmith":
				_add_dialogue_btn("⚒️ «Использовать кузницу» (Крафт)", _open_smithing_menu)
			elif npc["role"] == "Лорд" or npc["role"] == "Староста":
				_add_dialogue_btn("👑 «Карта Региона и Феодальные Союзы»", _open_diplomacy_modal)
				_add_dialogue_btn("📜 «Прошение о Дворянском Титуле»", func():
					_request_nobility_audience(npc)
				)
			elif npc.has("role_prof") or npc["role"] in ["Хлебопашец", "Лесоруб", "Лесоруб-Плотник", "Пекарь", "Охотник", "Охотник-Егерь"]:
				_add_dialogue_btn("🛒 «Лавка жителя» (Товары)", func():
					_open_citizen_shop(idx)
				)

			# 2. Квесты
			if citizen_quest_system:
				var gm_p = _get_game_manager()
				var p_ren = gm_p.player_data.renown if (gm_p and gm_p.player_data) else 0
				var cur_rep = npc.get("reputation_to_player", 0)
				var avail_q = citizen_quest_system.get_available_quest_for_npc(npc["role"], npc["name"], cur_rep, p_ren)
				if not avail_q.is_empty():
					_add_dialogue_btn("📜 «Поручение: %s»" % avail_q["title"], func():
						_show_quest_offer(avail_q, npc)
					)
				var active_q = citizen_quest_system.get_active_quest_for_npc(npc["role"], npc["name"])
				if not active_q.is_empty():
					var gm_q = _get_game_manager()
					var p_q = gm_q.player_data if gm_q else null
					var can_c = citizen_quest_system.can_complete_quest(active_q["id"], p_q.inventory if p_q else {})
					var st = " (Готово! ✅)" if can_c else " (В процессе...)"
					_add_dialogue_btn("🎁 «Сдать поручение»%s" % st, func():
						_try_complete_quest(active_q, npc)
					)

			# 3. Категория: Поговорить
			_add_dialogue_btn("🗣️ «Поговорить...» (Слухи, Мнение, Предыстория)", func():
				_open_dialogue(idx, "talk")
			)

			# 4. Категория: Отношения и управление
			_add_dialogue_btn("👑 «Отношения и управление...» (Премия, Обучение, Найм)", func():
				_open_dialogue(idx, "manage")
			)

			# 5. Завершить
			_add_dialogue_btn("🚪 «Завершить разговор»", _close_all_modals)

		"talk":
			if social_memory_dialogue_system:
				_add_dialogue_btn("🗣️ «Что нового слышно в Олдерии?» (Слухи)", func():
					var goss = social_memory_dialogue_system.get_gossip_topic(npc, {})
					dialogue_text.text = "[b]%s[/b]\n\n%s" % [goss["title"], goss["text"]]
				)
				_add_dialogue_btn("🏰 «Как тебе живется в деревне?» (Мнение)", func():
					var op = social_memory_dialogue_system.get_village_opinion(npc, 10)
					dialogue_text.text = "[b]%s[/b]\n\n%s" % [op["title"], op["text"]]
				)
				_add_dialogue_btn("📜 «Расскажи о себе» (Предыстория)", func():
					var bio = social_memory_dialogue_system.get_character_backstory(npc)
					dialogue_text.text = "[b]%s[/b]\n\n%s" % [bio["title"], bio["text"]]
				)
			_add_dialogue_btn("⬅️ «Назад»", func():
				_open_dialogue(idx, "main")
			)

		"manage":
			var n_id = npc.get("name", "npc_0")
			if npc_learning_system:
				_add_dialogue_btn("🌟 «Похвалить за усердие» (+Трудолюбие, +Лояльность)", func():
					_praise_current_npc(n_id, npc)
				)
				_add_dialogue_btn("🪙 «Выдать премию (10 з.)» (Бафф x1.5 скорости)", func():
					_reward_current_npc_bonus(n_id, npc)
				)
				_add_dialogue_btn("⚠️ «Сделать строгий выговор» (+Дисциплина)", func():
					_reprimand_current_npc(n_id, npc)
				)
				_add_dialogue_btn("📖 «Провести урок ремесла» (+35 XP опыта)", func():
					_teach_current_npc_lesson(n_id, npc)
				)

			_add_dialogue_btn("🎁 «Подарить 15 золотых на цель жизни» (+35 отн.)", func():
				var gm = _get_game_manager()
				var p = gm.player_data if gm else null
				if p and p.gold >= 15:
					p.gold -= 15
					npc["gold"] += 15
					npc["reputation_to_player"] = npc.get("reputation_to_player", 0) + 35
					p.honor += 8
					_log("[color=green]%s горячо благодарит вас![/color]" % npc["name"])
					_open_dialogue(idx, "manage")
				else:
					_log("[color=red]Недостаточно золота (нужно 15 з.)![/color]")
			)

			_add_dialogue_btn("🌾 «Нанять батраком в поместье» (30 з.)", func():
				var gm = _get_game_manager()
				var p = gm.player_data if gm else null
				if p:
					if p.gold >= 30 or npc.get("reputation_to_player", 0) >= 30:
						if p.gold >= 30: p.gold -= 30
						npc["role"] = "Батрак"
						npc["thought"] = "🌾"
						p.renown += 5
						_log("[color=gold]🎉 %s теперь работает на ваших землях![/color]" % npc["name"])
						_close_all_modals()
					else:
						_log("[color=red]Нужно 30 золотых или отношение +30![/color]")
			)

			_add_dialogue_btn("⬅️ «Назад»", func():
				_open_dialogue(idx, "main")
			)

		"caravan":
			_add_dialogue_btn("🐎 «Караван в Столицу» (25 з., 6 ч. пути)", func():
				_hire_caravan_travel(Vector2i(64, 64), "capital_olderia", "Венец Олдерии (Столица)")
			)
			_add_dialogue_btn("🐎 «Караван в Шахты Жильников» (25 з., 6 ч. пути)", func():
				_hire_caravan_travel(Vector2i(64, 25), "mines_zhilnik", "Кряж Жильников (Шахты)")
			)
			_add_dialogue_btn("⬅️ «Назад»", func():
				_open_dialogue(idx, "main")
			)




func _add_dialogue_btn(txt: String, cb: Callable) -> void:
	if dialogue_modal:
		dialogue_modal.add_option(txt, cb)



# --- ИНВЕНТАРЬ ---

func _build_inventory_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI инвентаря вынесен в ui/modals/InventoryModal.gd.
	# Создание/построение происходит в _build_ui_hud() через inventory_modal.build().
	pass


func _toggle_inventory() -> void:
	if inventory_modal == null:
		return
	if inventory_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		inventory_modal.open()


func _refresh_inventory_list() -> void:
	if inventory_modal:
		inventory_modal.refresh()


func _on_inv_item_selected(item_id: String) -> void:
	# InventoryModal.item_selected передаёт item_id напрямую.
	selected_inv_item = item_id


func _on_inventory_equip_effects(item_id: String, it: Dictionary) -> void:
	# Экипировка уже записана в player_data внутри фасада; здесь только лог.
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p:
		return
	if it.get("category") == "weapon":
		_log("[color=green]⚔️ Вы экипировали оружие: %s[/color]" % it.get("name", ""))
	elif it.get("category") == "shield":
		_log("[color=green]🛡️ Вы экипировали щит: %s[/color]" % it.get("name", ""))
	elif it.get("category") == "armor":
		_log("[color=green]🥋 Вы экипировали доспех: %s[/color]" % it.get("name", ""))


func _apply_inventory_use_effects(item_id: String) -> void:
	# Эффекты использования предметов (состояние игрока — здесь, единственный источник правды).
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p:
		return
	var it = ItemDatabase.get_item(item_id)
	if it.get("category") == "food" or it.get("category") == "potion":
		p.remove_item(item_id, 1)
		var heal = float(it.get("hp_restore", it.get("heal_hp", 20.0)))
		var stam = float(it.get("restore_stamina", it.get("heal_stamina", 30.0)))
		player_hp = minf(player_max_hp, player_hp + heal)
		player_stamina = minf(player_max_stamina, player_stamina + stam)
		player_hunger = maxf(0.0, player_hunger - (heal * 0.9))

		if item_id == "potion_stoneskin":
			stoneskin_timer = 300.0
			_log("[color=cyan]🛡️ Вы выпили Зелье Каменной Кожи! Ваша защита увеличена на +10 DEF на 5 минут![/color]")
			_spawn_spark_particles(player_pos, Color.CYAN)
			_spawn_floating_text(player_pos, "🛡️ КАМЕННАЯ КОЖА +10 DEF", Color.CYAN, 18)
		elif item_id == "potion_swiftness":
			swiftness_timer = 300.0
			_log("[color=yellow]⚡ Вы выпили Эликсир Скорости! Скорость бега увеличена на +35% на 5 минут![/color]")
			_spawn_spark_particles(player_pos, Color.YELLOW)
			_spawn_floating_text(player_pos, "⚡ СКОРОСТЬ +35%", Color.YELLOW, 18)
		elif item_id == "poison_vial":
			poison_hits_left = 10
			_log("[color=purple]☠️ Вы смазали оружие смертоносным ядом! Следующие 10 ударов нанесут +15 токсичного урона![/color]")
			_spawn_spark_particles(player_pos, Color.PURPLE)
			_spawn_floating_text(player_pos, "☠️ ЯД НА КЛИНКЕ +15", Color.PURPLE, 18)
		elif item_id == "mead":
			player_fatigue = maxf(0.0, player_fatigue - 50.0)
			_log("[color=gold]🍺 Вы испили хмельной медовухи! Усталость снижена на 50%, силы восстановлены![/color]")
			_spawn_floating_text(player_pos, "🍺 МЕДОВУХА (-50% Усталости)", Color.GOLD, 16)
		elif item_id == "fish_soup":
			player_hunger = 0.0
			_log("[color=green]🍲 Вы отведали Царской Ухи! Голод полностью утолен, силы на максимуме![/color]")
			_spawn_floating_text(player_pos, "🍲 ЦАРСКАЯ УХА (100% Сытости)", Color.GREEN, 18)
		else:
			_log("[color=green]Вы употребили %s (+%.0f HP, +%.0f Выносливости, утоление голода)![/color]" % [it.get("name", ""), heal, stam])
			_spawn_floating_text(player_pos, "+%.0f HP ❤️" % heal, Color(0.3, 1.0, 0.3), 16)



func _build_trade_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: рынок вынесен в ui/modals/TradeModal.gd.
	# Создание происходит в _build_ui_hud() через trade_modal.build().
	pass


func _open_market_trade() -> void:
	if trade_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	trade_modal.open()


func _refresh_trade_window() -> void:
	if trade_modal:
		trade_modal.refresh()


func _on_buy_market_item() -> void:
	if trade_modal:
		trade_modal._on_buy_pressed()


func _on_sell_market_item() -> void:
	if trade_modal:
		trade_modal._on_sell_pressed()



# --- КУЗНИЦА ---

var smith_recipes := [

	{ "result_id": "iron_ingot", "name": "Выплавка: Слиток Синего Чугуна", "req": {"iron_ore": 2}, "desc": "Переплавка 2 единиц руды в слиток." },

	{ "result_id": "sword_1h", "name": "Ковка: Стальной Меч", "req": {"iron_ingot": 3, "wood": 1}, "desc": "Острый клинок. Требует: 3 Слитка, 1 Дерево." },

	{ "result_id": "shield_badge", "name": "Ковка: Рыцарский Щит", "req": {"iron_ingot": 2, "wood": 3}, "desc": "Дубовый щит. Требует: 2 Слитка, 3 Дерева." }

]



func _build_smithing_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: кузница вынесена в ui/modals/SmithingModal.gd.
	# Создание происходит в _build_ui_hud() через smithing_modal.build().
	pass


func _open_smithing_menu() -> void:
	if smithing_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	smithing_modal.open()


func _on_recipe_selected(_idx: int) -> void:
	# Выбор рецепта теперь внутри SmithingModal (item_selected сигнал).
	pass


func _on_craft_recipe_pressed() -> void:
	if smithing_modal:
		smithing_modal._on_craft_pressed()



# --- СОБЫТИЯ ---

func _build_event_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI sobytij vyneseno v ui/modals/EventModal.gd.
	pass


func _trigger_random_event(force_id: String = "") -> void:
	var ev: Dictionary
	if force_id != "":
		ev = EventSystem.get_event_by_id(force_id)
	else:
		ev = EventSystem.get_random_event_excluding(recent_event_ids)
		recent_event_ids.append(ev.get("id", ""))
		if recent_event_ids.size() > 5:
			recent_event_ids.pop_front()

	_close_all_modals()
	is_ui_open = true
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if event_modal:
		event_modal.show_event(ev, p)


func _on_event_option_chosen(_ev: Dictionary, opt: Dictionary) -> void:
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p:
		if opt.has("item_take") and opt["item_take"] != "":
			p.remove_item(opt["item_take"], opt.get("req_amount", 1))
		if opt.has("item_give") and opt["item_give"] != "":
			p.add_item(opt["item_give"], opt.get("item_give_amt", 1))
		if opt.has("gold"): p.gold += opt["gold"]
		if opt.has("honor"): p.honor += opt["honor"]
		if opt.has("renown"): p.renown += opt["renown"]
		if opt.has("hp_change"): player_hp = clampf(player_hp + opt["hp_change"], 1.0, player_max_hp)
		if opt.has("stamina_change"):
			if opt["stamina_change"] < 0:
				var f_add = absf(opt["stamina_change"])
				player_fatigue = clampf(player_fatigue + f_add, 0.0, 70.0)
				player_stamina = minf(player_stamina, player_max_stamina - player_fatigue)

	var outcome_text = opt.get("outcome", "Вы приняли решение.")
	_log("[color=gold]📜 %s[/color]" % outcome_text)
	_spawn_floating_text(player_pos, "📜 Событие завершено", Color.GOLD, 16)
	if is_instance_valid(event_panel):
		event_panel.visible = false
	is_ui_open = false
	event_timer = randf_range(420.0, 720.0)

func _build_construction_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: stroitelstvo vyneseno v ui/modals/ConstructionModal.gd.
	# Sozdanie v _build_ui_hud() cherez construction_modal.build().
	pass


func _refresh_build_panel() -> void:
	# Vybor teper vnutri ConstructionModal; monolit hranit selected_build_idx.
	pass


func _on_build_item_selected(_idx: int) -> void:
	# Vybor v spiske teper vnutri ConstructionModal (item_selected signal).
	pass


func _on_start_construction_placement() -> void:
	if construction_modal == null:
		return
	selected_build_idx = construction_modal.get_selected_idx()
	construction_modal.close()
	is_ui_open = false
	_log("[color=yellow]Режим размещения: Кликните ЛКМ по свободной клетке земли для постройки![/color]")

func _build_chest_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: sunduk vynesen v ui/modals/ChestModal.gd.
	# Sozdanie v _build_ui_hud() cherez chest_modal.build().
	pass


func _open_chest_menu(tile_pos: Vector2i) -> void:
	if chest_modal == null:
		return
	active_chest_tile = tile_pos
	_close_all_modals()
	is_ui_open = true
	chest_modal.open(tile_pos)
	_refresh_chest_window()


func _refresh_chest_window() -> void:
	if chest_modal == null:
		return
	if not world_map.interactive_nodes.has(active_chest_tile):
		return
	var chest_data = world_map.interactive_nodes[active_chest_tile]
	var c_inv: Dictionary = chest_data.get("inventory", {})
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	chest_modal.set_chest_items(c_inv)
	if p:
		chest_modal.set_player_items(p.inventory)


func _on_take_item_from_chest(_item_id_override: String = "") -> void:
	var item_id = _item_id_override if _item_id_override != "" else (chest_modal.get_selected_chest_id() if chest_modal else "")
	if item_id == "":
		return
	if world_map.interactive_nodes.has(active_chest_tile):
		var c_inv = world_map.interactive_nodes[active_chest_tile]["inventory"]
		if c_inv.has(item_id) and c_inv[item_id] > 0:
			c_inv[item_id] -= 1
			if c_inv[item_id] <= 0:
				c_inv.erase(item_id)
			var gm = _get_game_manager()
			var p = gm.player_data if gm else null
			if p: p.add_item(item_id, 1)
			_refresh_chest_window()


func _on_store_item_to_chest(_item_id_override: String = "") -> void:
	var item_id = _item_id_override if _item_id_override != "" else (chest_modal.get_selected_player_id() if chest_modal else "")
	if item_id == "":
		return
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p and p.get_item_count(item_id) >= 1:
		p.remove_item(item_id, 1)
		if world_map.interactive_nodes.has(active_chest_tile):
			var c_inv = world_map.interactive_nodes[active_chest_tile]["inventory"]
			c_inv[item_id] = c_inv.get(item_id, 0) + 1
		_refresh_chest_window()


func _close_all_modals() -> void:

	is_ui_open = false

	if dialogue_panel: dialogue_panel.visible = false

	if inventory_panel: inventory_panel.visible = false

	if skills_panel: skills_panel.visible = false

	if trade_panel: trade_panel.visible = false
	if inventory_modal: inventory_modal.close()
	if skills_modal: skills_modal.close()
	if trade_modal: trade_modal.close()
	if smithing_modal: smithing_modal.close()
	if contracts_modal: contracts_modal.close()
	if party_modal: party_modal.close()
	if estate_modal: estate_modal.close()
	if construction_modal: construction_modal.close()
	if chest_modal: chest_modal.close()
	if origin_modal: origin_modal.close()
	if citizen_shop_modal: citizen_shop_modal.close()
	if caravan_modal: caravan_modal.close()
	if regional_diplomacy_modal: regional_diplomacy_modal.close()
	if dialogue_modal: dialogue_modal.close()
	if event_modal: event_modal.close()
	if settlement_modal: settlement_modal.close()

	if party_panel: party_panel.visible = false

	if event_panel: event_panel.visible = false

	if build_panel: build_panel.visible = false

	if chest_panel: chest_panel.visible = false

	if contracts_panel: contracts_panel.visible = false

	if party_panel: party_panel.visible = false

	if estate_panel: estate_panel.visible = false

	if settlement_panel: settlement_panel.visible = false

	if origin_panel: origin_panel.visible = false

	if citizen_shop_panel: citizen_shop_panel.visible = false

	if alchemy_panel: alchemy_panel.visible = false
	if stable_modal: stable_modal.close()
	if shipyard_modal: shipyard_modal.close()
	if dog_modal: dog_modal.close()
	if bard_modal: bard_modal.close()



func _award_skill_xp(skill_id: String, amount: float) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	var res = p.add_skill_xp(skill_id, amount)

	if res.get("leveled_up", false):

		_log("[color=gold][b]🎉 НАВЫК ПОВЫШЕН: %s %s достиг %d уровня![/b][/color]" % [res.get("icon", "⭐"), res.get("skill_name", skill_id), res.get("new_level", 1)])

		if skills_panel and skills_panel.visible:

			_refresh_skills_window()



# --- КНИГА НАВЫКОВ И МАСТЕРСТВА [K] ---

func _build_skills_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI навыков вынесен в ui/modals/SkillsModal.gd.
	# Создание происходит в _build_ui_hud() через skills_modal.build().
	pass


func _toggle_skills() -> void:
	if skills_modal == null:
		return
	if skills_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		skills_modal.open()


func _refresh_skills_window() -> void:
	if skills_modal:
		skills_modal.refresh()



func _log(msg: String) -> void:
	if log_box:
		log_box.append_text(msg + "\n")
		_log_line_count += 1
		if _log_line_count > 150:
			var parsed = log_box.get_parsed_text()
			var lines = parsed.split("\n")
			log_box.clear()
			_log_line_count = 0
			var start_idx = maxi(0, lines.size() - 80)
			for i in range(start_idx, lines.size()):
				if lines[i] != "":
					log_box.append_text(lines[i] + "\n")
					_log_line_count += 1



func _get_game_manager() -> Node:
	return get_node_or_null("/root/GameManager")

func _get_dog_data() -> Dictionary:
	return dog_data

func _get_bard_pos() -> Vector2:
	return Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE)


func _get_player_pos() -> Vector2:
	return player_pos

func _get_is_mounted() -> bool:
	return is_mounted

func _set_is_mounted(v: bool) -> void:
	is_mounted = v




func _get_time_manager() -> Node:
	return get_node_or_null("/root/TimeManager")



# =========================================================

func _build_contracts_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: контракты вынесены в ui/modals/ContractsModal.gd.
	# Создание происходит в _build_ui_hud() через contracts_modal.build().
	pass


func _toggle_contracts_menu() -> void:
	if contracts_modal == null:
		return
	if contracts_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		contracts_modal.open()




func _open_notice_board_menu() -> void:
	if contracts_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	contracts_modal.open()
	_log("[color=gold]📜 Вы подошли к Доске Объявлений Олдерии.[/color]")




func _refresh_contracts_window() -> void:
	if contracts_modal:
		contracts_modal.refresh()

# --- Мёртвый код контрактов удалён: рендер/факции/_get_rep_tier_name/_on_contract_selected
#     перенесены в ui/modals/ContractsModal.gd (фасад). ---

func _on_contract_action_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or contracts_modal == null or contracts_modal.get_selected_id() == "":
		return
	var tab_idx = contracts_modal.get_tab_idx()
	var sel_id = contracts_modal.get_selected_id()
	if tab_idx == 0:
		var ok = ContractManager.accept_contract(p, sel_id)
		if ok:
			var c = ContractDatabase.get_contract(sel_id)
			_log("[color=gold][b]📜 ВЗЯТ КОНТРАКТ: %s![/b][/color]" % c.get("title", ""))
			_spawn_floating_text(player_pos, "📜 Новый контракт!", Color(1.0, 0.85, 0.2), 16)
			contracts_modal.refresh()
	elif tab_idx == 1:
		var res = ContractManager.claim_reward(p, sel_id)
		if not res.is_empty():
			var c = res.get("contract", {})
			_log("[color=gold][b]🎉 КОНТРАКТ СДАН: %s![/b] Получено: +%d золота, +%d славы.[/color]" % [c.get("title", ""), res.get("gold", 0), res.get("renown", 0)])
			_spawn_spark_particles(player_pos, Color.GOLD)
			_spawn_floating_text(player_pos, "+%d Золота 💰" % res.get("gold", 0), Color.GOLD, 18)
			contracts_modal.refresh()


func _on_contract_abandon_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or contracts_modal == null or contracts_modal.get_selected_id() == "":
		return
	var sel_id = contracts_modal.get_selected_id()
	ContractManager.abandon_contract(p, sel_id)
	_log("[color=gray]Вы отказались от выполнения контракта.[/color]")
	contracts_modal.refresh()





func _update_quest_tracker() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return

	if citizen_quest_system:
		var cq = citizen_quest_system.get_current_primary_quest()
		if not cq.is_empty():
			var can_c = citizen_quest_system.can_complete_quest(cq["id"], p.inventory)
			quest_tracker_title.text = "%s %s" % ["✅" if can_c else "📜", cq["title"]]
			if can_c:
				quest_tracker_desc.text = "✅ Цель выполнена! Сдайте жителю [ E ]"
				quest_tracker_bar.value = 100.0
			else:
				var first_req = cq["req_items"].keys()[0]
				var req_cnt: int = cq["req_items"][first_req]
				var cur_cnt: int = p.get_item_count(first_req)
				var it_name = ItemDatabase.get_item(first_req).get("name", first_req)
				quest_tracker_desc.text = "🎯 %s: %d / %d" % [it_name, cur_cnt, req_cnt]
				quest_tracker_bar.value = (float(cur_cnt) / float(req_cnt)) * 100.0
			return

	ContractManager.ensure_player_contracts(p)

	if p.active_contracts.size() == 0:

		quest_tracker_title.text = "📜 Задание: Нет активных"

		quest_tracker_desc.text = "Доска Заказов на площади [E] или меню [Q]"

		quest_tracker_bar.value = 0.0

	else:

		var c = p.active_contracts[0]

		var cur = c.get("current_count", 0)

		var req = c.get("required_count", 1)

		var is_ready = cur >= req

		

		quest_tracker_title.text = "%s %s" % ["✅" if is_ready else "📜", c.get("title", "Задание")]

		if is_ready:

			quest_tracker_desc.text = "✅ Цель выполнена! Сдайте заказ [ Q ]"

		else:

			var tgt_str = ""

			match c.get("category", ""):

				"hunting": tgt_str = "Истребить: %s" % c.get("target_type", "")

				"supply": tgt_str = "Сдать: %s" % ItemDatabase.get_item(c.get("target_type", "")).get("name", "")

				"delivery": tgt_str = "Доставка в замок"

				_: tgt_str = "Цель"

			quest_tracker_desc.text = "🎯 %s: %d / %d" % [tgt_str, cur, req]

		quest_tracker_bar.value = (float(cur) / float(req)) * 100.0



# =========================================================

# ДРУЖИНА, НАЕМНИКИ И СПУТНИКИ [ C ]

# =========================================================

func _sync_party_sprites() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	PartyManager.ensure_player_party(p)

	

	# Очищаем старые спрайты

	for s in party_sprites:

		if is_instance_valid(s):

			s.queue_free()

	party_sprites.clear()

	party_positions.clear()

	

	# Создаем спрайты для каждого активного соратника

	for i in range(p.party_members.size()):

		var m = p.party_members[i]

		var spr = Sprite2D.new()

		spr.texture = SpriteGenerator2D.get_character_texture(m.get("texture_id", "companion_swordsman"), TILE_SIZE)

		

		var init_pos = player_pos + Vector2(-32.0 * (i + 1), 0.0)

		spr.position = init_pos

		party_positions.append(init_pos)

		

		# Мягкая тень

		var shadow = Sprite2D.new()

		shadow.texture = SpriteGenerator2D.get_shadow_texture(16, 8)

		shadow.position = Vector2(0, 16)

		shadow.z_index = -1

		spr.add_child(shadow)

		

		add_child(spr)

		party_sprites.append(spr)



func _update_party_movement_and_combat(delta: float) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p or p.party_members.size() == 0: return

	

	# Если количество спрайтов не совпадает с данными, синхронизируем

	if party_sprites.size() != p.party_members.size():

		_sync_party_sprites()

		_update_party_hud()

		return

		

	# 1. Движение спутников в строю

	var offsets = [

		Vector2(-36, -24),

		Vector2(-36, 24),

		Vector2(-58, 0)

	]

	

	for i in range(party_sprites.size()):

		if i >= p.party_members.size(): break

		var spr = party_sprites[i]

		var cur_pos = party_positions[i]

		var m = p.party_members[i]

		

		var target_pos = player_pos + offsets[i % offsets.size()]

		if party_order_mode == "guard":

			# Круговая оборона

			var angle = (float(i) / float(party_sprites.size())) * TAU

			target_pos = player_pos + Vector2(cos(angle), sin(angle)) * 44.0

			

		var dist = cur_pos.distance_to(target_pos)

		if dist > 380.0:

			# Слишком отстали — мгновенный рывок к лидеру

			cur_pos = target_pos

			party_positions[i] = cur_pos

			spr.position = cur_pos

		elif dist > 8.0:

			var spd: float = m.get("speed", 150.0)

			var dir = (target_pos - cur_pos).normalized()

			cur_pos += dir * spd * delta

			party_positions[i] = cur_pos

			spr.position = cur_pos

			

			# Анимация шага

			spr.offset.y = sin(Time.get_ticks_msec() * 0.012 + i * 2.0) * -3.0

			spr.rotation_degrees = sin(Time.get_ticks_msec() * 0.012 + i * 2.0) * 3.5

			if dir.x != 0:

				spr.flip_h = (dir.x < 0)

		else:

			spr.offset.y = sin(Time.get_ticks_msec() * 0.003 + i) * -1.0

			spr.rotation_degrees = lerpf(spr.rotation_degrees, 0.0, delta * 10.0)

			

	# 2. Боевой ИИ дружины (каждые 0.8 сек)

	party_attack_timer += delta

	if party_attack_timer >= 0.8:

		party_attack_timer = 0.0

		

		for i in range(p.party_members.size()):

			var m = p.party_members[i]

			var comp_pos = party_positions[i] if i < party_positions.size() else player_pos

			var role = m.get("role", "swordsman")

			

			# 🌿 Лекарь (Марта): проверка здоровья лидера

			if role == "healer":

				if player_hp < (player_max_hp * 0.65):

					player_hp = minf(player_max_hp, player_hp + 25.0)

					_spawn_spark_particles(player_pos, Color(0.4, 1.0, 0.5))

					_spawn_floating_text(player_pos, "+25 HP 🌿", Color(0.3, 1.0, 0.4), 18)

					_log("[color=green]🌿 %s перевязала раны командира (+25 HP)![/color]" % m["name"])

					break

			

			# 🏹 Лучник (Эдгар): дистанционный огонь по врагам

			elif role == "archer":

				var target_idx = -1

				var min_d := 200.0

				for w_i in range(wildlife_data.size()):

					if wildlife_data[w_i].get("is_dead", false): continue

					if not wildlife_data[w_i].get("is_hostile", false): continue

					var d = comp_pos.distance_to(wildlife_positions[w_i])

					if d < min_d:

						min_d = d

						target_idx = w_i

						

				if target_idx != -1:

					var w = wildlife_data[target_idx]

					var d_val = randi_range(18, 26)

					w["hp"] -= d_val

					_spawn_spark_particles(wildlife_positions[target_idx], Color.ORANGE)

					_spawn_floating_text(wildlife_positions[target_idx], "🏹 -%d" % d_val, Color(1.0, 0.8, 0.2), 16)

					_log("[color=lightgreen]🏹 %s поразил стрелой %s на %d урона![/color]" % [m["name"], w["name"], d_val])

					

					if w["hp"] <= 0.0:

						_hit_wildlife(target_idx) # Добивание

						

			# 🗡️ Меченосец (Роланд) / 🔱 Пикинер (Бран): ближний бой

			elif role in ["swordsman", "pikeman"]:

				for w_i in range(wildlife_data.size()):

					if wildlife_data[w_i].get("is_dead", false): continue

					if not wildlife_data[w_i].get("is_hostile", false): continue

					var d = comp_pos.distance_to(wildlife_positions[w_i])

					if d < (m.get("attack_range", 55.0) + 20.0):

						var w = wildlife_data[w_i]

						var d_val = randi_range(int(m["dmg"] * 0.85), int(m["dmg"] * 1.15))

						w["hp"] -= d_val

						_spawn_spark_particles(wildlife_positions[w_i], Color.GOLD)
func _build_party_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: дружина вынесена в ui/modals/PartyModal.gd.
	# Создание происходит в _build_ui_hud() через party_modal.build().
	pass


func _toggle_party_menu() -> void:
	if party_modal == null:
		return
	if party_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		party_modal.open()


func _refresh_party_window() -> void:
	if party_modal:
		party_modal.refresh()


func _render_party_member_details(_m: Dictionary, _is_hired: bool) -> void:
	# Рендер теперь внутри PartyModal.
	pass


func _on_party_selected(_idx: int) -> void:
	# Выбор в списке теперь внутри PartyModal (item_selected сигнал).
	pass


func _on_party_action_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or party_modal == null or party_modal.get_selected_id() == "":
		return
	var tab_idx = party_modal.get_tab_idx()
	var sel_id = party_modal.get_selected_id()
	if tab_idx == 1:
		var res = PartyManager.hire_mercenary(p, sel_id)
		if res.get("success", false):
			var m = res["mercenary"]
			_log("[color=gold][b]🎉 В ДРУЖИНУ ПРИНЯТ: %s %s![/b][/color]" % [m.get("icon", "⚔️"), m.get("name", "")])
			_spawn_spark_particles(player_pos, Color.GOLD)
			_spawn_floating_text(player_pos, "👥 Новый соратник: " + m.get("name", ""), Color.GOLD, 18)
			_sync_party_sprites()
			_update_party_hud()
			party_modal.refresh()
		else:
			_log("[color=red]%s[/color]" % res.get("reason", "Ошибка найма!"))


func _on_party_dismiss_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or party_modal == null or party_modal.get_selected_id() == "":
		return
	var sel_id = party_modal.get_selected_id()
	var ok = PartyManager.dismiss_mercenary(p, sel_id)
	if ok:
		_log("[color=gray]Вы распустили наемника из своего отряда.[/color]")
		_sync_party_sprites()
		_update_party_hud()
		party_modal.refresh()





func _update_party_hud() -> void:

	if not party_hud_panel or not party_hud_box: return

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	PartyManager.ensure_player_party(p)

	

	for child in party_hud_box.get_children():

		child.queue_free()

		

	if p.party_members.size() == 0:

		party_hud_panel.visible = false

		return

		

	party_hud_panel.visible = true

	

	# Заголовок со строем

	var order_lbl = Label.new()

	var order_str = "Следование"

	match party_order_mode:

		"guard": order_str = "Оборона"

		"attack": order_str = "В атаку!"

		"gather": order_str = "Сбор"

	order_lbl.text = "👥 Дружина (%d/3) | %s" % [p.party_members.size(), order_str]

	order_lbl.add_theme_font_size_override("font_size", 11)

	order_lbl.add_theme_color_override("font_color", Color(1.0, 0.90, 0.55))

	party_hud_box.add_child(order_lbl)

	

	for m in p.party_members:

		var row = HBoxContainer.new()

		row.add_theme_constant_override("separation", 6)

		party_hud_box.add_child(row)

		

		var name_lbl = Label.new()

		name_lbl.text = "%s %s" % [m.get("icon", "⚔️"), m.get("name", "Боец").split(" ")[0]]

		name_lbl.add_theme_font_size_override("font_size", 11)

		name_lbl.custom_minimum_size = Vector2(100, 14)

		row.add_child(name_lbl)

		

		var p_bar = ProgressBar.new()

		p_bar.custom_minimum_size = Vector2(120, 10)

		p_bar.show_percentage = false

		p_bar.value = (float(m.get("hp", 80.0)) / float(m.get("max_hp", 80.0))) * 100.0

		var pb_bg = _make_medieval_panel_style(Color(0.20, 0.05, 0.05, 0.9), Color(0.4, 0.1, 0.1), 1, 2)

		var pb_fill = _make_medieval_panel_style(Color(0.85, 0.20, 0.20), Color(0.95, 0.40, 0.40), 1, 2)

		p_bar.add_theme_stylebox_override("background", pb_bg)

		p_bar.add_theme_stylebox_override("fill", pb_fill)

		row.add_child(p_bar)



# =========================================================

# ДАЛЬНИЙ БОЙ, СТРЕЛЬБА ИЗ ЛУКА И БАЛЛИСТИКА СТРЕЛ 🏹

# =========================================================

func _spawn_projectile(start_pos: Vector2, dir: Vector2, speed: float, damage: float, is_player: bool, max_dist: float, pen: float, shooter: String) -> void:

	var spr = Sprite2D.new()

	spr.texture = SpriteGenerator2D.get_projectile_texture("arrow", 24)

	spr.position = start_pos

	spr.rotation = dir.angle()

	spr.z_index = 45

	add_child(spr)

	

	active_projectiles.append({

		"node": spr,

		"pos": start_pos,

		"vel": dir * speed,

		"speed": speed,

		"damage": damage,

		"is_player_shot": is_player,

		"distance_left": max_dist,

		"penetration": pen,

		"shooter_name": shooter

	})



func _update_projectiles(delta: float) -> void:

	var to_remove: Array[int] = []

	

	for i in range(active_projectiles.size()):

		var pr = active_projectiles[i]

		var spr: Sprite2D = pr["node"]

		if not is_instance_valid(spr):

			to_remove.append(i)

			continue

			

		var step = pr["vel"] * delta

		pr["pos"] += step

		spr.position = pr["pos"]

		spr.rotation = pr["vel"].angle()

		pr["distance_left"] -= (pr["speed"] * delta)

		

		var hit := false

		

		# 1. Если стрелу выпустил игрок

		if pr["is_player_shot"]:

			# Попадание по диким зверям (волки, вепри, олени)

			for w_i in range(wildlife_data.size()):

				var w = wildlife_data[w_i]

				if w.get("is_dead", false): continue

				var d = pr["pos"].distance_to(wildlife_positions[w_i])

				if d <= 26.0:
					hit = true
					var d_val = int(pr["damage"] * randf_range(0.9, 1.15))
					w["hp"] -= d_val
					_spawn_spark_particles(wildlife_positions[w_i], Color(1.0, 0.4, 0.2))
					_spawn_floating_text(wildlife_positions[w_i], "🎯 -%d" % d_val, Color(1.0, 0.85, 0.2), 16)
					_play_sfx("sword_hit")
					_award_skill_xp("archery", 20.0)
					_log("[color=green]🎯 Точное попадание стрелы в %s на %d урона![/color]" % [w["name"], d_val])
					
					if w["hp"] <= 0.0:
						_hit_wildlife(w_i)
					break
			
			# Попадание по разбойникам в лесном лагере
			if not hit:
				for n_i in range(npc_data.size()):
					var npc = npc_data[n_i]
					if npc.get("is_dead", false): continue
					var is_enemy = (npc.get("role", "") in ["Разбойник", "Разбойник-лучник", "Бандит"])
					if not is_enemy: continue
					
					var d = pr["pos"].distance_to(npc_positions[n_i])
					if d <= 26.0:
						hit = true
						var def_val = float(npc.get("defense", 8)) * (1.0 - pr.get("penetration", 0.0))
						var d_val = int(maxf(6.0, (pr["damage"] - def_val) * randf_range(0.9, 1.15)))
						npc["hp"] -= d_val
						_spawn_spark_particles(npc_positions[n_i], Color(1.0, 0.3, 0.3))
						_spawn_floating_text(npc_positions[n_i], "🎯 -%d" % d_val, Color(1.0, 0.9, 0.2), 16)
						_play_sfx("sword_hit")
						_award_skill_xp("archery", 25.0)
						_log("[color=green]🎯 Стрела пробила защиту %s на %d урона![/color]" % [npc["name"], d_val])
						
						if npc["hp"] <= 0.0:
							_hit_npc(n_i)
						break
						
		# 2. Если стрелу выпустил вражеский лучник в игрока
		else:
			var d = pr["pos"].distance_to(player_pos)
			if d <= 24.0:
				hit = true
				if is_blocking:
					# Блок щитом на ПКМ
					player_stamina = maxf(0.0, player_stamina - 8.0)
					_award_skill_xp("shield_defense", 15.0)
					_spawn_spark_particles(player_pos, Color.GOLD)
					_spawn_floating_text(player_pos, "🛡️ СТРЕЛА ОТБИТА!", Color.YELLOW, 16)
					_play_sfx("shield_block")
					_log("[color=gold]🛡️ Вы выставили щит и заблокировали летящую стрелу со звоном металла![/color]")
				else:
					_play_sfx("sword_hit")

					# Урон по игроку с учетом брони

					var gm = _get_game_manager()

					var p: CharacterData = gm.player_data if gm else null

					var armor_mitigation: float = 0.0

					if p and p.equipped_armor == "leather_armor":

						armor_mitigation = 4.0

					var actual_dmg = maxf(6.0, pr["damage"] - armor_mitigation)

					player_hp = maxf(0.0, player_hp - actual_dmg)

					_spawn_spark_particles(player_pos, Color.RED)

					_spawn_floating_text(player_pos, "🏹 -%.0f HP" % actual_dmg, Color.RED, 18)

					_log("[color=red]💥 Вражеская стрела вонзилась в вас на %.0f урона![/color]" % actual_dmg)

					if player_hp <= 0.0:

						_on_player_defeat()

						

		if hit or pr["distance_left"] <= 0.0:

			spr.queue_free()

			to_remove.append(i)

			

	# Удаляем отработавшие снаряды

	to_remove.reverse()

	for idx in to_remove:

		active_projectiles.remove_at(idx)



func _update_enemy_archers(delta: float) -> void:
	if is_in_dungeon or is_overworld_mode:
		return
	enemy_archer_timer += delta

	var can_shoot = enemy_archer_timer >= 1.75

	if can_shoot:

		enemy_archer_timer = 0.0

		

	for i in range(npc_data.size()):

		var npc = npc_data[i]

		if npc.get("is_dead", false): continue

		if not npc.get("is_ranged", false) and npc.get("role", "") != "Разбойник-лучник": continue

		

		var archer_pos = npc_positions[i]

		var dist = archer_pos.distance_to(player_pos)

		

		# Кайтинг: если игрок подошел слишком близко (< 110px), лучник отступает

		if dist < 110.0 and dist > 5.0:

			var flee_dir = (archer_pos - player_pos).normalized()

			var test_pos = archer_pos + flee_dir * 55.0 * delta

			var tile_pos = Vector2i(int(test_pos.x / TILE_SIZE), int(test_pos.y / TILE_SIZE))

			if world_map.can_walk(tile_pos):

				npc_positions[i] = test_pos

				npc_sprites[i].position = test_pos

				npc_sprites[i].flip_h = (flee_dir.x < 0)

				

		# Стрельба на дистанции (100..280px)

		if dist >= 90.0 and dist <= 290.0 and can_shoot:

			var shoot_dir = (player_pos - archer_pos).normalized()

			_spawn_projectile(archer_pos + shoot_dir * 14.0, shoot_dir, 460.0, 18.0, false, 320.0, 0.0, npc["name"])
			_spawn_spark_particles(archer_pos + shoot_dir * 14.0, Color.ORANGE)
			_play_sfx("sfx_bow_shot")
			_log("[color=orange]⚠️ %s натянул тетиву и выстрелил в вас стрелой![/color]" % npc["name"])



# =========================================================

# ФЕОДАЛЬНОЕ ПОМЕСТЬЕ, ЗЕМЛЕВЛАДЕНИЕ И БАТРАКИ [ H ]

# =========================================================

func _sync_estate_workers() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	EstateManager.ensure_player_estate(p)

	

	for s in estate_worker_sprites:

		if is_instance_valid(s):

			s.queue_free()

	estate_worker_sprites.clear()

	

	if not p.has_estate: return

	

	# Спавним рабочих на землях поместья на востоке (38, 12)

	var base_tile = Vector2i(38, 12)

	var worker_offsets = [

		Vector2(-24, -16),

		Vector2(24, -16),

		Vector2(-24, 20),

		Vector2(24, 20)

	]

	

	for i in range(p.estate_workers.size()):

		var w_type = p.estate_workers[i]

		var spr = Sprite2D.new()

		var tex_role = "peasant"

		match w_type:

			"farmer": tex_role = "peasant"

			"lumberjack": tex_role = "peasant"

			"miner": tex_role = "blacksmith"

			"huntsman": tex_role = "companion_archer"

		spr.texture = SpriteGenerator2D.get_character_texture(tex_role, TILE_SIZE)

		

		var w_pos = Vector2(base_tile.x * TILE_SIZE + TILE_SIZE/2.0, base_tile.y * TILE_SIZE + TILE_SIZE/2.0) + worker_offsets[i % worker_offsets.size()]

		spr.position = w_pos

		

		var shadow = Sprite2D.new()

		shadow.texture = SpriteGenerator2D.get_shadow_texture(14, 7)
		shadow.position = Vector2(0, 16)
		shadow.z_index = -1
		spr.add_child(shadow)
		add_child(spr)
		estate_worker_sprites.append(spr)

func _build_estate_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: pomestye vyneseno v ui/modals/EstateModal.gd.
	pass

func _toggle_estate_menu() -> void:
	if estate_modal == null:
		return
	if estate_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		estate_modal.open()

func _refresh_estate_window() -> void:
	if estate_modal:
		estate_modal.refresh()

func _render_worker_details(_w: Dictionary) -> void:
	pass

func _render_upgrade_details(_u: Dictionary, _is_built: bool) -> void:
	pass

func _on_estate_item_selected(_idx: int) -> void:
	pass

func _on_estate_action_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or estate_modal == null:
		return
	var tab_idx = estate_modal.get_tab_idx()
	var sel_id = estate_modal.get_selected_id()

	if not p.has_estate:
		var res = EstateManager.buy_land_deed(p)
		if res.get("success", false):
			_log("[color=gold][b]🎉 ПОЗДРАВЛЯЕМ! Вы выкупили Грамоту на Землю и стали владельцем Феодального Поместья![/b][/color]")
			_spawn_spark_particles(player_pos, Color.GOLD)
			_spawn_floating_text(player_pos, "🏰 ВЛАДЕЛЕЦ ПОМЕСТЬЯ!", Color.GOLD, 20)
			_sync_estate_workers()
			estate_modal.refresh()
		else:
			_log("[color=red]%s[/color]" % res.get("reason", "Ошибка покупки!"))
		return

	if tab_idx == 0:
		if p.estate_upgrades.has("manor_house"):
			player_fatigue = 0.0
			player_stamina = player_max_stamina
			player_hp = player_max_hp
			_spawn_spark_particles(player_pos, Color(0.4, 0.9, 1.0))
			_spawn_floating_text(player_pos, "💤 Идеальный отдых! (Усталость 0%)", Color.CYAN, 18)
			_log("[color=cyan]🏡 Вы сладко выспались в Барском Доме. Все силы и здоровье полностью восстановлены![/color]")
			_close_all_modals()
	elif tab_idx == 1:
		var res = EstateManager.hire_worker(p, sel_id)
		if res.get("success", false):
			var w = res["worker"]
			_log("[color=gold]👨‍🌾 В поместье нанят новый работник: %s %s![/color]" % [w.get("icon", "👨‍🌾"), w.get("name", "")])
			_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)
			_sync_estate_workers()
			estate_modal.refresh()
		else:
			_log("[color=red]%s[/color]" % res.get("reason", "Ошибка найма!"))
	elif tab_idx == 2:
		var res = EstateManager.build_upgrade(p, sel_id)
		if res.get("success", false):
			var u = res["upgrade"]
			_log("[color=gold]🎉 В вашей усадьбе возведено: %s %s![/color]" % [u.get("icon", "🏡"), u.get("name", "")])
			_spawn_spark_particles(player_pos, Color.GOLD)
			_spawn_floating_text(player_pos, "🏡 Построено: " + u.get("name", ""), Color.GOLD, 18)
			estate_modal.refresh()
		else:
			_log("[color=red]%s[/color]" % res.get("reason", "Ошибка постройки!"))

func _on_estate_take_all_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p == null or estate_modal == null:
		return

	var taken = EstateManager.take_all_from_storage(p)
	if taken.size() > 0:
		var items_str = ""
		for it_id in taken.keys():
			var it = ItemDatabase.get_item(it_id)
			items_str += "%s %s x%d  " % [it.get("icon", "📦"), it.get("name", it_id), taken[it_id]]
		_log("[color=green]📦 Вы забрали со склада поместья: %s[/color]" % items_str)
		_spawn_floating_text(player_pos, "📦 Ресурсы получены!", Color(0.3, 0.9, 0.4), 16)
		estate_modal.refresh()
	else:
		_log("[color=gray]На складе поместья пока ничего нет.[/color]")

func _request_nobility_audience(lord_npc: Dictionary) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return

	var cur_def = NobilitySystem.get_title_def(p.nobility_title)
	var next_def = NobilitySystem.get_next_title(p.nobility_title)

	if dialogue_modal:
		dialogue_modal.set_title("👑 Аудиенция в Замке: %s" % lord_npc["name"])
		if next_def.is_empty():
			dialogue_modal.set_text("""[b]«Приветствую тебя, милорд Барон!»[/b]

Вы уже носите высший дворянский титул Барона Олдерии. Корона гордится вашей доблестью и верной службой!""")
			dialogue_modal.clear_options()
			_add_dialogue_btn("«Благодарю, милорд»", _close_all_modals)
			return

		var check = NobilitySystem.can_promote(p)
		var can_p: bool = check.get("can_promote", false)

		dialogue_modal.set_text("""[b]«Ты просишь о пожаловании дворянского звания?»[/b]

Ваш текущий титул: [color=gold]%s %s[/color]
Следующее звание: [color=cyan]%s %s[/color]

[b]📜 Требования короны для возведения в ранг:[/b]
 • Слава: %d / [color=gold]%d[/color]
 • Честь: %d / [color=lightblue]%d[/color]
 • Пошлина: %d / [color=yellow]%d золотых[/color]
 • Поместье: %d / [color=orange]%d ур.[/color]

[color=lightgray]%s[/color]""" % [
			cur_def.get("icon", "🌾"), cur_def.get("name", "Простолюдин"),
			next_def.get("icon", "⚔️"), next_def.get("name", ""),
			p.renown, next_def.get("renown_req", 0),
			p.honor, next_def.get("honor_req", 0),
			p.gold, next_def.get("gold_req", 0),
			p.estate_level, next_def.get("estate_req", 0),
			next_def.get("desc", "")
		])

		dialogue_modal.clear_options()
		if can_p:
			_add_dialogue_btn("⚔️ «Преклонить колено и принять титул: %s»" % next_def.get("name", ""), func():
				var res = NobilitySystem.promote(p)
				if res.get("success", false):
					var title = res["title"]
					_log("[color=gold][b]👑 ЦЕРЕМОНИЯ ПОСВЯЩЕНИЯ: Лорд коснулся клинком ваших плеч и провозгласил вас: %s %s![/b][/color]" % [title.get("icon", ""), title.get("name", "")])
					_spawn_spark_particles(player_pos, Color.GOLD)
					_spawn_floating_text(player_pos, "👑 ТИТУЛ: " + title.get("name", "").to_upper(), Color.GOLD, 22)
					if title["id"] == "knight":
						p.equipped_armor = "armor_knight"
						p.equipped_weapon = "sword_knight"
						_log("[color=cyan]🛡️ Вам вручены Королевские Рыцарские Латы, Благородный Меч и Боевой Рог Ополчения![/color]")
					_close_all_modals()
				else:
					_log("[color=red]%s[/color]" % res.get("reason", "Ошибка посвящения!"))
			)
		else:
			_add_dialogue_btn("«Я вернусь, когда заслужу достаточно славы и чести»", _close_all_modals)

func _trigger_alarm_bell() -> void:
	if is_raid_active:
		_log("[color=orange]🔔 Тревожный набат уже звучит! Отразите текущую волну нападающих![/color]")
		_spawn_floating_text(player_pos, "🔔 НАБАТ УЖЕ ЗВУЧИТ!", Color.ORANGE, 16)
		return

	_log("[color=red][b]🔔 БУМ! БУМ! БУМ! Зазвучал Тревожный Колокол Олдерии![/b][/color]")
	_log("[color=gold]К деревне приближается крупная шайка лесных разбойников! Стража и жители готовятся к обороне![/color]")
	_spawn_spark_particles(player_pos, Color.RED)
	_spawn_floating_text(player_pos, "🔔 ТРЕВОЖНЫЙ НАБАТ!", Color.RED, 22)

	if alarm_bell_system:
		alarm_bell_system.ring_bell(npc_data)
	_start_village_raid()


# =========================================================
# УПРАВЛЕНИЕ ПОСЕЛЕНИЕМ [ T ]
# =========================================================
# УПРАВЛЕНИЕ ПОСЕЛЕНИЕМ [ T ] 🏛️🚩
# =========================================================

func _build_settlement_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI poseleniya vyneseno v ui/modals/SettlementModal.gd.
	pass

func _toggle_settlement_menu() -> void:
	if settlement_modal and settlement_modal.is_open():
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		if settlement_modal:
			settlement_modal.open(p, settlement_stockpile_system, settlement_unrest_system, town_council_system)

func _refresh_settlement_window() -> void:
	# DEPRECATED: obnovlenie teper vnutri SettlementModal.
	pass

func _on_settlement_action_dispatched(action_name: String, param: Variant) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return

	match action_name:
		"withdraw_treasury":
			var amt = int(param)
			var taken = SettlementManager.withdraw_treasury(p, amt)
			if taken > 0:
				_log("[color=green]💰 Вы забрали из казны поселения: %d золотых.[/color]" % taken)
				_spawn_spark_particles(player_pos, Color.GOLD)
		"deposit_treasury":
			var amt = int(param)
			if SettlementManager.deposit_treasury(p, amt):
				_log("[color=gold]🪙 Вы пополнили городскую казну на %d золотых.[/color]" % amt)
				_spawn_spark_particles(player_pos, Color.GOLD)
			else:
				_log("[color=red]У вас недостаточно золота![/color]")
		"give_bonus":
			var c_idx = int(param)
			var citizens = p.settlement.get("citizens", [])
			if c_idx >= 0 and c_idx < citizens.size() and p.gold >= 10:
				p.gold -= 10
				citizens[c_idx]["gold"] = citizens[c_idx].get("gold", 10) + 10
				citizens[c_idx]["mood"] = clamp(citizens[c_idx].get("mood", 80) + 15, 0, 100)
				_log("[color=lightgreen]🎁 Вы выдали премию жителю %s (+10 золотых, +15%% к настроению)![/color]" % citizens[c_idx]["name"])
				_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)
		"toggle_tax":
			var cur_rate = p.settlement.get("tax_rate", 0.10)
			var new_rate = 0.05 if cur_rate >= 0.20 else (cur_rate + 0.05)
			p.settlement["tax_rate"] = new_rate
			_log("[color=gold]📜 Ставка городского налога изменена на %d%%.[/color]" % int(new_rate * 100))
		"build_project":
			var proj_id = str(param)
			var banner_pos = p.settlement.get("banner_tile", Vector2i(23, 21))
			var offset = Vector2i(randi_range(-4, 4), randi_range(-4, 4))
			var res = SettlementManager.build_project(p, proj_id, banner_pos + offset, world_map)
			if res.get("success", false):
				_log("[color=gold][b]🏗️ СТРОИТЕЛЬСТВО: Жители успешно возвели объект: %s![/b][/color]" % res.get("name", ""))
				_spawn_spark_particles(player_pos, Color.GOLD)
				_spawn_floating_text(player_pos, "🏗️ " + res.get("name", ""), Color.GOLD, 20)
			else:
				_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка стройки"))
		"hire_guard":
			if p.gold < 50:
				_log("[color=salmon]Недостаточно золота для найма стражника (50 з.)![/color]")
				return
			p.gold -= 50
			_log("[color=lightgreen]🛡️ В городской гарнизон нанят новый стражник ворот![/color]")
			_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)

func _start_village_raid() -> void:
	is_raid_active = true

	raid_wave = 1

	raid_wave_enemies.clear()

	_spawn_raid_wave(1)



func _spawn_raid_wave(wave_num: int) -> void:

	raid_wave = wave_num

	raid_wave_enemies.clear()

	

	_log("[color=red][b]⚔️ НАБЕГ НА ДЕРЕВНЮ: ВОЛНА %d / 3![/b][/color]" % wave_num)

	_spawn_floating_text(player_pos, "⚔️ НАБЕГ: ВОЛНА %d/3" % wave_num, Color.RED, 20)

	

	var spawn_points: Array[Vector2i] = []

	var enemies_info: Array[Dictionary] = []

	

	if wave_num == 1:

		# Волна 1: 3 легких разведчика с севера

		spawn_points = [Vector2i(23, 6), Vector2i(21, 7), Vector2i(25, 7)]

		for sp in spawn_points:

			enemies_info.append({

				"name": "Разбойник-разведчик",

				"role": "Разбойник",

				"hp": 55.0,

				"max_hp": 55.0,

				"defense": 4,

				"gold": randi_range(6, 14),

				"is_ranged": false

			})

	elif wave_num == 2:

		# Волна 2: 2 мечника со щитами + 2 лучника с запада

		spawn_points = [Vector2i(5, 23), Vector2i(5, 26), Vector2i(4, 24), Vector2i(4, 25)]

		enemies_info.append({"name": "Бандит со щитом", "role": "Бандит", "hp": 85.0, "max_hp": 85.0, "defense": 10, "gold": 15, "is_ranged": false})

		enemies_info.append({"name": "Бандит со щитом", "role": "Бандит", "hp": 85.0, "max_hp": 85.0, "defense": 10, "gold": 15, "is_ranged": false})

		enemies_info.append({"name": "Разбойник-лучник", "role": "Разбойник-лучник", "hp": 60.0, "max_hp": 60.0, "defense": 5, "gold": 18, "is_ranged": true})

		enemies_info.append({"name": "Разбойник-лучник", "role": "Разбойник-лучник", "hp": 60.0, "max_hp": 60.0, "defense": 5, "gold": 18, "is_ranged": true})

	elif wave_num == 3:

		# Волна 3: Босс Аттила Железный Клык + 2 телохранителя с юга

		spawn_points = [Vector2i(23, 58), Vector2i(21, 59), Vector2i(25, 59)]

		enemies_info.append({"name": "Аттила Железный Клык", "role": "Бандит", "hp": 250.0, "max_hp": 250.0, "defense": 14, "gold": 75, "is_boss": true, "is_ranged": false})

		enemies_info.append({"name": "Ветеран-телохранитель", "role": "Бандит", "hp": 110.0, "max_hp": 110.0, "defense": 12, "gold": 25, "is_ranged": false})

		enemies_info.append({"name": "Ветеран-телохранитель", "role": "Бандит", "hp": 110.0, "max_hp": 110.0, "defense": 12, "gold": 25, "is_ranged": false})

		

	for i in range(spawn_points.size()):

		var sp = spawn_points[i]

		var einfo = enemies_info[i]

		var w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)

		

		var npc_entry = {

			"id": "raider_%d_%d" % [wave_num, i],

			"name": einfo["name"],

			"role": einfo["role"],

			"hp": einfo["hp"],

			"max_hp": einfo["max_hp"],

			"defense": einfo.get("defense", 6),

			"gold": einfo.get("gold", 10),

			"home_tile": sp,

			"target_pos": player_pos,

			"idle_timer": 0.0,

			"walk_speed": 55.0,

			"is_dead": false,

			"is_hostile": true,

			"is_ranged": einfo.get("is_ranged", false),

			"shoot_cooldown": randf_range(1.5, 3.0),

			"traits": ["Жестокий", "Грабитель"]

		}

		

		npc_data.append(npc_entry)

		npc_positions.append(w_pos)

		var new_idx = npc_data.size() - 1

		raid_wave_enemies.append(new_idx)

		

		if einfo.get("is_boss", false):

			raid_boss_idx = new_idx

			

		var spr = Sprite2D.new()

		spr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)

		spr.position = w_pos

		add_child(spr)

		npc_sprites.append(spr)

		

		_spawn_spark_particles(w_pos, Color.RED)



func _check_raid_wave_progress() -> void:

	if not is_raid_active: return

	

	var alive_count := 0

	for idx in raid_wave_enemies:

		if idx < npc_data.size() and not npc_data[idx].get("is_dead", false):

			alive_count += 1

			

	if alive_count == 0:

		if raid_wave < 3:

			_log("[color=green]🎉 Волна %d успешно отбита! Готовьтесь к следующей волне через 3 секунды...[/color]" % raid_wave)

			_spawn_floating_text(player_pos, "ВОЛНА %d ОТБИТА!" % raid_wave, Color.GREEN, 18)

			get_tree().create_timer(3.0).timeout.connect(func():

				if is_raid_active:

					_spawn_raid_wave(raid_wave + 1)

			)

		else:

			_on_raid_victory()



func _on_raid_victory() -> void:

	is_raid_active = false

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if p:

		p.gold += 80

		p.renown += 25

		p.honor += 20

		

	_log("[color=gold][b]🏆 ПОБЕДА! Главарь разбойников Аттила и его шайка повержены![/b][/color]")

	_log("[color=yellow]Королевская награда от Лорда: +80 золотых, +25 Славы, +20 Чести![/color]")

	_spawn_spark_particles(player_pos, Color.GOLD)

	_spawn_floating_text(player_pos, "🏆 ПОБЕДА! НАБЕГ ОТБИТ! +80 ЗОЛОТА", Color.GOLD, 22)



# =========================================================

# ФИЗИЧЕСКИЙ ТРУД ЖИТЕЛЕЙ (COLONIST LABOR SIMULATION) 🌾🪓⚒️

# =========================================================

func _update_colonists_labor(delta: float) -> void:
	if is_in_dungeon or is_overworld_mode: return
	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p or not p.settlement.get("has_town", false): return

	

	var banner_tile = p.settlement.get("banner_tile", Vector2i(23, 21))

	for n_i in range(npc_data.size()):

		var npc = npc_data[n_i]

		if not npc.has("role_prof"): continue

		if npc.get("is_dead", false): continue

		

		var cur_pos = npc_positions[n_i]

		var step_res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile)

		npc_positions[n_i] = step_res["new_pos"]

		if n_i < npc_sprites.size() and is_instance_valid(npc_sprites[n_i]):

			npc_sprites[n_i].position = step_res["new_pos"]

			

		if step_res.get("did_finish_work", false):
			var act_tile = step_res["action_tile"]
			var act_world = Vector2(act_tile.x * TILE_SIZE + TILE_SIZE/2.0, act_tile.y * TILE_SIZE + TILE_SIZE/2.0)
			_spawn_spark_particles(act_world, Color(0.9, 0.8, 0.3))
			
			var prof = npc.get("role_prof", "farmer")
			var prod_label = ""
			var m = gm.local_market if gm else null
			
			match prof:
				"farmer":
					if m: m.inventory["grain"] = m.inventory.get("grain", 0) + 2
					if settlement_stockpile_system: settlement_stockpile_system.add_resource("grain", 2)
					prod_label = "🌾 +2 Зерна"
				"baker":
					var has_grain = (m and m.inventory.get("grain", 0) >= 1) or (settlement_stockpile_system and settlement_stockpile_system.stockpiles.get("grain", 0) >= 1)
					if has_grain:
						if m and m.inventory.get("grain", 0) >= 1: m.inventory["grain"] -= 1
						elif settlement_stockpile_system: settlement_stockpile_system.stockpiles["grain"] = max(0, settlement_stockpile_system.stockpiles.get("grain", 0) - 1)
						if m: m.inventory["bread"] = m.inventory.get("bread", 0) + 2
						if settlement_stockpile_system: settlement_stockpile_system.add_resource("bread", 2)
						prod_label = "🍞 +2 Хлеба"
					else:
						prod_label = "«Нет зерна для печи!»"
				"woodcutter":
					if m: m.inventory["wood"] = m.inventory.get("wood", 0) + 2
					if settlement_stockpile_system: settlement_stockpile_system.add_resource("timber", 2)
					prod_label = "🪵 +2 Леса"
				"blacksmith":
					var has_ore = (m and m.inventory.get("iron_ore", 0) >= 1)
					if has_ore:
						if m: m.inventory["iron_ore"] -= 1
						if m: m.inventory["iron_ingot"] = m.inventory.get("iron_ingot", 0) + 1
						if m: m.inventory["tools"] = m.inventory.get("tools", 0) + 1
						if settlement_stockpile_system: settlement_stockpile_system.add_resource("iron_ingots", 1)
						prod_label = "⚒️ Сковал инструменты"
					else:
						prod_label = "«Нужна руда для ковки!»"
				"hunter":
					if m: m.inventory["meat"] = m.inventory.get("meat", 0) + 2
					if m: m.inventory["wolf_pelt"] = m.inventory.get("wolf_pelt", 0) + 1
					prod_label = "🍗 +2 Мяса"
				"guard":
					prod_label = "🛡️ Дозор спокоен"
					
			if prod_label != "":
				_spawn_floating_text(act_world, prod_label, Color(0.9, 0.8, 0.3), 14)

func _build_origin_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: vybor puti vynesen v ui/modals/OriginModal.gd.
	# Sozdanie v _build_ui_hud() cherez origin_modal.build().
	pass


func _show_origin_modal() -> void:
	if origin_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	origin_modal.open()



func _choose_origin(orig_id: String) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	var o_def = SettlementDatabase.get_origin_def(orig_id)

	p.origin_role = orig_id

	p.character_name = "Герой"

	p.current_role = o_def.get("name", "Странник").split(" ")[0]
	p.gold = o_def.get("starting_gold", 25)

	# Выдача предметов
	p.inventory.clear()
	for it_id in o_def.get("starting_items", {}).keys():
		if it_id == "gold": continue
		p.inventory[it_id] = o_def["starting_items"][it_id]

		

	_log("[color=gold][b]🎭 ВЫ ВЫБРАЛИ ПУТЬ: %s %s![/b][/color]" % [o_def.get("icon", ""), o_def.get("name", "")])

	_log("[color=cyan]Вам выдано стартовое снаряжение и припасы. Ваша судьба — в ваших руках![/color]")

	_spawn_spark_particles(player_pos, Color.GOLD)

	_spawn_floating_text(player_pos, "ПУТЬ: " + o_def.get("name", "").to_upper(), Color.GOLD, 20)

	_close_all_modals()



func _check_settler_migration() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p or not p.settlement.get("has_town", false): return

	

	# Подсчет свободных кроватей

	var total_beds := 0

	for pos in world_map.interactive_nodes.keys():

		if world_map.interactive_nodes[pos].get("type") == "bed":

			total_beds += 1

			

	var current_pop = p.settlement.get("citizens", []).size()

	if total_beds <= current_pop:

		return # Нет свободных спальных мест

		

	# Спавним нового переселенца

	var rand_names = ["Рагнар", "Томас", "Берта", "Эльза", "Годфрид", "Хельга", "Бруно", "Агнесса"]

	var prof_keys = SettlementDatabase.PROFESSIONS.keys()

	var chosen_prof = prof_keys[randi() % prof_keys.size()]

	var c_name = rand_names[randi() % rand_names.size()]

	

	var new_citizen = {

		"id": "colonist_%d" % Time.get_ticks_msec(),

		"name": c_name,

		"profession": chosen_prof,

		"gold": randi_range(5, 18),

		"hunger": 100

	}

	

	SettlementManager.add_citizen(p, new_citizen)

	var p_def = SettlementDatabase.get_profession_def(chosen_prof)

	

	# Спавним физического NPC в мире

	var spawn_tile = Vector2i(23, 3)

	var w_pos = Vector2(spawn_tile.x * TILE_SIZE + TILE_SIZE/2.0, spawn_tile.y * TILE_SIZE + TILE_SIZE/2.0)

	

	var npc_entry = {

		"id": new_citizen["id"],

		"name": c_name,

		"role": p_def.get("name", "Житель"),

		"role_prof": chosen_prof,

		"hp": 80.0,

		"max_hp": 80.0,

		"gold": new_citizen["gold"],

		"home_tile": spawn_tile,

		"target_pos": player_pos,

		"idle_timer": 2.0,

		"walk_speed": 45.0,

		"is_dead": false,

		"is_hostile": false,

		"work_state": "idle",

		"work_timer": 0.0,

		"work_target_tile": Vector2i(-1, -1),

		"traits": ["Трудолюбивый", "Честный"]

	}

	npc_data.append(npc_entry)

	npc_positions.append(w_pos)

	

	var spr = Sprite2D.new()

	spr.texture = SpriteGenerator2D.get_character_texture("peasant", TILE_SIZE)

	spr.position = w_pos

	add_child(spr)

	npc_sprites.append(spr)

	

	p.renown += 5

	_log("[color=lightgreen][b]🚶‍♂️ МИГРАЦИЯ: В ваш город прибыл переселенец %s и занял свободную кровать! Профессия: %s %s.[/b][/color]" % [c_name, p_def.get("icon", ""), p_def.get("name", "")])

	_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)

	_spawn_floating_text(player_pos, "+1 ЖИТЕЛЬ: " + c_name, Color.LIGHT_GREEN, 18)

	

	# Проверка повышения ранга поселения

	var tier_check = SettlementManager.update_tier_progress(p, total_beds)

	if tier_check.get("leveled_up", false):

		var t_def = tier_check["tier_def"]

		_log("[color=gold][b]🎉 ПОЗДРАВЛЯЕМ! Ваше поселение выросло до нового ранга: %s %s![/b][/color]" % [t_def.get("icon", ""), t_def.get("name", "")])

		_spawn_spark_particles(player_pos, Color.GOLD)
func _build_citizen_shop_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: lavka vynesena v ui/modals/CitizenShopModal.gd.
	# Sozdanie v _build_ui_hud() cherez citizen_shop_modal.build().
	pass


func _open_citizen_shop(npc_idx: int) -> void:
	if citizen_shop_modal == null:
		return
	active_shop_npc_idx = npc_idx
	_close_all_modals()
	is_ui_open = true
	citizen_shop_modal.open(npc_idx)
	_refresh_citizen_shop()


func _refresh_citizen_shop() -> void:
	if citizen_shop_modal == null:
		return
	if active_shop_npc_idx < 0 or active_shop_npc_idx >= npc_data.size():
		return
	var npc = npc_data[active_shop_npc_idx]
	var prof = npc.get("role_prof", "")
	if prof == "":
		match npc.get("role", ""):
			"Кузнец": prof = "blacksmith"
			"Хлебопашец": prof = "farmer"
			"Лесоруб", "Лесоруб-Плотник": prof = "woodcutter"
			"Пекарь": prof = "baker"
			"Охотник", "Охотник-Егерь": prof = "hunter"
			"Городской Стражник": prof = "guard"
			_: prof = "farmer"
	var raw_shop_items = SettlementDatabase.get_shop_items(prof)
	var gm = _get_game_manager()
	var m = gm.local_market if gm else null
	var rep = npc.get("reputation_to_player", 0)
	var rep_mult = 0.80 if rep >= 25 else (1.30 if rep <= -15 else 1.0)
	
	var dynamic_shop_items: Array = []
	for item_entry in raw_shop_items:
		var it_id = item_entry["id"]
		var base_p = item_entry["price"]
		var m_price = m.get_current_price(it_id) if m else float(base_p)
		var final_price = int(max(1, ceil(m_price * rep_mult)))
		dynamic_shop_items.append({
			"id": it_id,
			"price": final_price
		})
	citizen_shop_modal.set_items(dynamic_shop_items, npc["name"], npc["role"], npc.get("gold", 10))


func _on_citizen_shop_item_selected(_meta: Variant = null) -> void:
	# Vybor v spiske teper vnutri CitizenShopModal (show_detail).
	pass





func _buy_citizen_shop_item(item_id: String, price: int) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	if p.gold < price:

		_log("[color=red]У вас недостаточно золота для покупки (%d з.)![/color]" % price)

		return

		

	p.gold -= price

	p.inventory[item_id] = p.inventory.get(item_id, 0) + 1

	

	if active_shop_npc_idx >= 0 and active_shop_npc_idx < npc_data.size():

		npc_data[active_shop_npc_idx]["gold"] = npc_data[active_shop_npc_idx].get("gold", 10) + price

		

	var it = ItemDatabase.get_item(item_id)

	_log("[color=green]🛍️ Вы купили %s %s за %d золотых у горожанина![/color]" % [it.get("icon", "📦"), it.get("name", item_id), price])

	_spawn_spark_particles(player_pos, Color.GOLD)

	_spawn_floating_text(player_pos, "+1 " + it.get("name", ""), Color.LIGHT_GREEN, 16)

	_refresh_citizen_shop()


# =========================================================
# ГЛОБАЛЬНЫЕ ТОРГОВЫЕ КАРАВАНЫ И ДИПЛОМАТИЯ 🐫👑
# =========================================================

func _open_caravan_modal() -> void:
	if caravan_modal == null: return
	_close_all_modals()
	is_ui_open = true
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	var stocks = settlement_stockpile_system.stockpiles if settlement_stockpile_system else {}
	caravan_modal.open(p, regional_map_system, stocks)

func _dispatch_trade_caravan(dest_city_id: String, goods_type: String, goods_amount: int, escort_cost: int, escort_risk: float, escort_name: String) -> void:
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return

	# Проверка и списание товаров со склада
	if settlement_stockpile_system and settlement_stockpile_system.stockpiles.has(goods_type):
		var cur_amt = settlement_stockpile_system.stockpiles[goods_type]
		if cur_amt < goods_amount:
			_log("[color=salmon]⚠️ На складе поселения недостаточно товара %s для отправки обоза (требуется %d шт., есть %d шт.)![/color]" % [goods_type, goods_amount, cur_amt])
			return
		settlement_stockpile_system.stockpiles[goods_type] = max(0, cur_amt - goods_amount)

	var res = trade_caravan_system.dispatch_active_caravan(dest_city_id, goods_type, goods_amount, escort_cost, escort_risk, escort_name, p, regional_map_system)
	_log("[color=gold]%s[/color]" % res.get("msg", ""))
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🐫 КАРАВАН ОТПРАВЛЕН В ПУТЬ!", Color.GOLD, 18)
	_close_all_modals()
	if is_overworld_mode and overworld_map:
		overworld_map.queue_redraw()

func _open_diplomacy_modal() -> void:
	if regional_diplomacy_modal == null: return
	_close_all_modals()
	is_ui_open = true
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	regional_diplomacy_modal.open(p, regional_map_system, regional_diplomacy_system)

func _sign_diplomatic_treaty(city_id: String, treaty_type: String) -> void:
	var res = {}
	match treaty_type:
		"trade":
			res = regional_diplomacy_system.sign_trade_agreement(city_id, regional_map_system)
		"nap":
			res = regional_diplomacy_system.sign_non_aggression(city_id, regional_map_system)
		"alliance":
			res = regional_diplomacy_system.form_military_alliance(city_id, regional_map_system)
	if res.get("success", false):
		_log("[color=lightgreen][b]%s[/b][/color]" % res.get("msg", ""))
		_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)
		_spawn_floating_text(player_pos, "📜 ТРАКТАТ ПОДПИСАН!", Color.LIGHT_GREEN, 18)

func _send_diplomatic_gift(city_id: String) -> void:
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p or p.gold < 60:
		_log("[color=salmon]Недостаточно золота для отправки даров правителю (требуется 60 з.)![/color]")
		return
	p.gold -= 60
	if regional_map_system:
		var new_rel = regional_map_system.change_relation(city_id, 20)
		var c = regional_map_system.get_city(city_id)
		_log("[color=gold]🎁 Дары успешно доставлены правителю %s (%s). Отношения возросли до %d![/color]" % [c.get("ruler", ""), c.get("name", city_id), new_rel])
		_spawn_spark_particles(player_pos, Color.GOLD)
		_spawn_floating_text(player_pos, "+20 Отношений!", Color.GOLD, 16)


# =========================================================

# РЕЧНАЯ РЫБАЛКА, ТРАВНИЧЕСТВО И ПАСЕКА 🎣🌿🐝

# =========================================================

func _try_fish() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	var res = FishingSystem.catch_fish(p)

	if res.get("success", false):

		var f_name = res.get("fish_name", "Рыба")

		var f_icon = res.get("fish_icon", "🐟")

		_log("[color=lightblue]🎣 [b]УДАЧНАЯ ПОДСЕЧКА![/b] Вы выудили из реки: %s %s![/color]" % [f_icon, f_name])

		if res.get("used_bait", false):

			_log("[color=gray](Использована наживка 🪱)[/color]")

		_spawn_spark_particles(player_pos, Color.CYAN)

		_spawn_floating_text(player_pos, "🎣 +1 " + f_name, Color.CYAN, 18)

	else:

		_log("[color=orange]🎣 %s[/color]" % res.get("reason", "Рыба сорвалась с крючка"))



func _harvest_beehive(t_pos: Vector2i) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	p.inventory["honey"] = p.inventory.get("honey", 0) + 2

	p.inventory["beeswax"] = p.inventory.get("beeswax", 0) + 1

	p.add_skill_xp("farming", 20.0)

	

	_log("[color=gold]🐝 Вы собрали урожай с пчелиного улья: +2 Дикого Меда 🍯, +1 Пчелиный Воск 🕯️![/color]")

	_spawn_spark_particles(player_pos, Color.GOLD)

	_spawn_floating_text(player_pos, "🐝 +2 МЕД, +1 ВОСК", Color.GOLD, 16)



func _harvest_herb(t_pos: Vector2i) -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	if not world_map.interactive_nodes.has(t_pos): return

	var nd = world_map.interactive_nodes[t_pos]

	var h_id = nd.get("item_yield", "herb_hypericum")

	var count = nd.get("yield_count", 1)

	

	p.inventory[h_id] = p.inventory.get(h_id, 0) + count

	p.add_skill_xp("survival", 20.0)

	

	var it = ItemDatabase.get_item(h_id)

	_log("[color=lightgreen]🌿 Вы бережно срезали %s x%d![/color]" % [it.get("name", h_id), count])

	_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)

	_spawn_floating_text(player_pos, "+%d %s" % [count, it.get("name", "")], Color.LIGHT_GREEN, 16)

	

	# Убираем траву с карты

	world_map.interactive_nodes.erase(t_pos)

	world_map.queue_redraw()

func _build_alchemy_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: alhimiya vynesena v ui/modals/AlchemyModal.gd.
	# Sozdanie v _build_ui_hud() cherez alchemy_modal.build().
	pass


func _open_alchemy_modal() -> void:
	if alchemy_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	alchemy_modal.open()
	selected_alchemy_recipe = "potion_healing"
	_refresh_alchemy_modal()


func _refresh_alchemy_modal() -> void:
	if alchemy_modal == null:
		return
	alchemy_modal.set_recipes(AlchemySystem.RECIPES.keys())
	var rec = AlchemySystem.RECIPES.get(selected_alchemy_recipe, AlchemySystem.RECIPES["potion_healing"])
	alchemy_modal.show_detail(rec)


func _craft_selected_alchemy() -> void:

	var gm = _get_game_manager()

	var p: CharacterData = gm.player_data if gm else null

	if not p: return

	

	var res = AlchemySystem.craft_recipe(p, selected_alchemy_recipe)

	if res.get("success", false):

		_log("[color=green][b]⚗️ АЛХИМИЯ: Вы успешно сварили %s x%d![/b][/color]" % [res.get("name", ""), res.get("yield", 1)])

		_spawn_spark_particles(player_pos, Color.CYAN)

		_spawn_floating_text(player_pos, "⚗️ " + res.get("name", ""), Color.CYAN, 18)

		_refresh_alchemy_modal()

	else:

		_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка алхимической варки"))





# =========================================================
# ОСАДА РАЗБОЙНИЧЬИХ ФОРТОВ И ВОЙНА ЗА ТЕРРИТОРИИ 🏰⚔️🚩
# =========================================================
func _start_fort_siege(fort_id: String) -> void:
	_close_all_modals()
	if is_overworld_mode:
		_toggle_overworld_mode()
		
	is_fort_siege_active = true
	active_siege_fort_id = fort_id
	siege_enemies.clear()
	
	var fort_info = {
		"name": "Чернолесный Форт",
		"enemy_count": 8,
		"gold_reward": 180,
		"captives": 2,
		"has_boss": false
	}
	
	if fort_id == "fort_red_gorge":
		fort_info = {
			"name": "Крепость Красного Ущелья",
			"enemy_count": 12,
			"gold_reward": 320,
			"captives": 3,
			"has_boss": true
		}
	elif fort_id == "fort_smugglers":
		fort_info = {
			"name": "Лагерь Контрабандистов",
			"enemy_count": 5,
			"gold_reward": 120,
			"captives": 2,
			"has_boss": false
		}
		
	_log("[color=red][b]⚔️ НАЧАЛАСЬ ОСАДА: «%s»![/b][/color]" % fort_info["name"])
	_log("[color=gold]Ваша дружина и городской гарнизон идут на штурм укреплений разбойников![/color]")
	_spawn_spark_particles(player_pos, Color.RED)
	_spawn_floating_text(player_pos, "⚔️ ШТУРМ: " + fort_info["name"].to_upper(), Color.RED, 22)
	
	# Размещаем частоколы и ворота форта на севере карты
	for x in range(18, 30):
		world_map.structure_tiles[Vector2i(x, 10)] = "wall_wood"
		world_map.structure_tiles[Vector2i(x, 18)] = "wall_wood"
	for y in range(10, 19):
		world_map.structure_tiles[Vector2i(18, y)] = "wall_wood"
		world_map.structure_tiles[Vector2i(29, y)] = "wall_wood"
		
	# Открытый проход ворот
	world_map.structure_tiles.erase(Vector2i(23, 18))
	world_map.structure_tiles.erase(Vector2i(24, 18))
	world_map.queue_redraw()
	
	# Спавним врагов форта
	for e_i in range(fort_info["enemy_count"]):
		var sp = Vector2i(randi_range(19, 28), randi_range(11, 16))
		var w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)
		var is_b = (fort_info.get("has_boss", false) and e_i == 0)
		var is_rng = (e_i % 2 == 1)
		
		var npc_entry = {
			"id": "fort_enemy_%d" % e_i,
			"name": ("Атаман Гримвульф" if is_b else ("Разбойник-Снайпер" if is_rng else "Головорез Форта")),
			"role": "Бандит",
			"hp": (300.0 if is_b else 80.0),
			"max_hp": (300.0 if is_b else 80.0),
			"defense": (14 if is_b else 8),
			"gold": (50 if is_b else 12),
			"home_tile": sp,
			"target_pos": player_pos,
			"idle_timer": 0.0,
			"walk_speed": 50.0,
			"is_dead": false,
			"is_hostile": true,
			"is_ranged": is_rng,
			"shoot_cooldown": randf_range(1.5, 3.0),
			"is_boss": is_b,
			"traits": ["Жестокий", "Защитник Форта"]
		}
		
		npc_data.append(npc_entry)
		npc_positions.append(w_pos)
		var n_idx = npc_data.size() - 1
		siege_enemies.append(n_idx)
		if is_b: siege_boss_idx = n_idx
		
		var spr = Sprite2D.new()
		spr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)
		spr.position = w_pos
		add_child(spr)
		npc_sprites.append(spr)
		
	# Телепортируем игрока на исходную позицию штурма
	player_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_fort_siege_progress() -> void:
	if not is_fort_siege_active: return
	
	var alive_count := 0
	for idx in siege_enemies:
		if idx < npc_data.size() and not npc_data[idx].get("is_dead", false):
			alive_count += 1
			
	if alive_count == 0:
		_on_fort_siege_victory()

func _on_fort_siege_victory() -> void:
	is_fort_siege_active = false
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	var gold_gain = 220
	var freed_count = 2
	if active_siege_fort_id == "fort_red_gorge":
		gold_gain = 350
		freed_count = 3
	elif active_siege_fort_id == "fort_smugglers":
		gold_gain = 140
		freed_count = 2
		
	p.settlement["treasury"] = int(p.settlement.get("treasury", 0)) + gold_gain
	p.renown += 50
	p.honor += 30
	
	# Освобождение пленников и присоединение к поселению
	var freed_names = ["Освальд", "Гертруда", "Виллем", "Бьянка"]
	for k in range(freed_count):
		var fn = freed_names[randi() % freed_names.size()]
		var citizen = {
			"id": "freed_%d" % (Time.get_ticks_msec() + k),
			"name": fn,
			"profession": "farmer",
			"gold": 15,
			"hunger": 100
		}
		SettlementManager.add_citizen(p, citizen)
		
	_log("[color=gold][b]🏆 ПОБЕДА! Вражеский форт полностью пал под натиском вашей армии![/b][/color]")
	_log("[color=yellow]💰 Казна вашего города пополнена на +%d золотых![/color]" % gold_gain)
	_log("[color=lightgreen]👥 Вы освободили %d пленных, и они благодарно присоединились к вашему поселению![/color]" % freed_count)
	_log("[color=cyan]👑 Ваша Слава во всем королевстве возросла (+50 Славы, +30 Чести)![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ФОРТ ЗАХВАЧЕН! +%d ЗОЛОТА В КАЗНУ" % gold_gain, Color.GOLD, 22)


# =========================================================
# КОНЮШНИ, ВЕРХОВАЯ ЕЗДА И РЫЦАРСКИЕ ТУРНИРЫ 🐎🏇🏆
# =========================================================
# КОНЮШНИ, ВЕРХОВАЯ ЕЗДА И РЫЦАРСКИЕ ТУРНИРЫ (UI вынесено в StableModal.gd)
# =========================================================

func _build_stable_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI вынесено в ui/modals/StableModal.gd.
	# Создание в _build_ui_hud() через stable_modal.build().
	pass


func _open_stable_modal() -> void:
	if stable_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	stable_modal.open()


func _refresh_stable_modal() -> void:
	if stable_modal == null:
		return
	stable_modal.refresh()


func _on_stable_item_selected(_idx: int) -> void:
	# выбор обрабатывается внутри StableModal (on_list_selected).
	pass


func _buy_selected_horse() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	var breed = stable_modal.get_selected_breed() if (stable_modal != null and stable_modal.has_method("get_selected_breed")) else "horse_bay"
	var res = MountSystem.buy_horse(p, breed)
	if res.get("success", false):
		_log("[color=gold][b]🐎 ПОКУПКА: Вы приобрели скакуна: %s %s![/b][/color]" % [res.get("icon", "🐎"), res.get("name", "")])
		_spawn_spark_particles(player_pos, Color.GOLD)
		_spawn_floating_text(player_pos, "🐎 " + res.get("name", ""), Color.GOLD, 18)
		_refresh_stable_modal()
	else:
		_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка покупки"))


func _toggle_mount() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	MountSystem.ensure_mount_data(p)
	var active_b = p.settlement.get("active_horse", "")
	if active_b == "":
		_log("[color=orange]🐎 У вас нет скакуна в стойле. Приобретите лошадь в Конюшне [E]![/color]")
		_spawn_floating_text(player_pos, "НЕТ СКАКУНА 🐎", Color.ORANGE, 16)
		return
	is_mounted = not is_mounted
	var h_def = MountSystem.HORSE_BREEDS.get(active_b, {})
	if is_mounted:
		_log("[color=green][b]🏇 Вы оседлали своего скакуна (%s)! Скорость бега увеличена на +%d%%![/b][/color]" % [h_def.get("name", "Конь"), int((h_def.get("speed_mult", 1.70) - 1.0) * 100)])
		_spawn_spark_particles(player_pos, Color.GREEN)
		_spawn_floating_text(player_pos, "В СЕДЛЕ 🏇 (+%d%%)" % int((h_def.get("speed_mult", 1.70) - 1.0) * 100), Color.GREEN, 18)
	else:
		_log("[color=yellow]🚶‍♂️ Вы спешились со скакуна.[/color]")
		_spawn_floating_text(player_pos, "СПЕШИЛСЯ 🚶‍♂️", Color.YELLOW, 16)

# =========================================================
# КОРОЛЕВСКИЙ РЫЦАРСКИЙ ТУРНИР В СТОЛИЦЕ 🏆👑⚔️
# =========================================================
func _start_royal_tournament(round_num: int) -> void:
	_close_all_modals()
	if is_overworld_mode:
		_toggle_overworld_mode()
		
	is_tourney_active = true
	tourney_round = round_num
	
	var r_names = [
		"Раунд 1: Поединок на мечах (Рыцарь Южных Долов)",
		"Раунд 2: Конная сшибка на копьях (Джостинг)",
		"Гран-Финал: Битва с Чемпионом Сэром Годфридом Черным Грифоном"
	]
	var r_name = r_names[round_num - 1]
	
	_log("[color=gold][b]🏆 КОРОЛЕВСКИЙ ТУРНИР ОЛДЕРИИ: %s![/b][/color]" % r_name)
	_log("[color=yellow]Трибуны ликуют! Докажите свое рыцарское мастерство на Арене Столицы![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ТУРНИР: РАУНД %d / 3" % round_num, Color.GOLD, 22)
	
	# Спавним противника на Арене (севернее игрока)
	var e_pos = Vector2(23.5 * TILE_SIZE, 14.0 * TILE_SIZE)
	var enemy_hp = 100.0 if round_num == 1 else (160.0 if round_num == 2 else 280.0)
	var enemy_def = 8 if round_num == 1 else (12 if round_num == 2 else 16)
	var enemy_name = "Рыцарь Южных Долов" if round_num == 1 else ("Турнирный Копейщик" if round_num == 2 else "Сэр Годфрид Черный Грифон")
	
	var npc_entry = {
		"id": "tourney_champion_%d" % round_num,
		"name": enemy_name,
		"role": "Рыцарь",
		"hp": enemy_hp,
		"max_hp": enemy_hp,
		"defense": enemy_def,
		"gold": 50,
		"home_tile": Vector2i(23, 14),
		"target_pos": player_pos,
		"idle_timer": 0.0,
		"walk_speed": 60.0,
		"is_dead": false,
		"is_hostile": true,
		"is_ranged": false,
		"is_boss": (round_num == 3),
		"traits": ["Благородный", "Чемпион Арены"]
	}
	
	npc_data.append(npc_entry)
	npc_positions.append(e_pos)
	tourney_enemy_idx = npc_data.size() - 1
	
	var spr = Sprite2D.new()
	spr.texture = SpriteGenerator2D.get_character_texture("knight", TILE_SIZE)
	spr.position = e_pos
	add_child(spr)
	npc_sprites.append(spr)
	
	player_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_tournament_progress() -> void:
	if not is_tourney_active: return
	if tourney_enemy_idx < 0 or tourney_enemy_idx >= npc_data.size(): return
	
	if npc_data[tourney_enemy_idx].get("is_dead", false):
		if tourney_round < 3:
			_log("[color=green]🎉 Раунд %d выигран! Следующий противник выходит на арену...[/color]" % tourney_round)
			_spawn_floating_text(player_pos, "РАУНД %d ПРОЙДЕН!" % tourney_round, Color.GREEN, 18)
			get_tree().create_timer(3.0).timeout.connect(func():
				if is_tourney_active:
					_start_royal_tournament(tourney_round + 1)
			)
		else:
			_on_tournament_victory()

func _on_tournament_victory() -> void:
	is_tourney_active = false
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	p.gold += 250
	p.renown += 60
	p.honor += 40
	p.inventory["trophy_chalice"] = p.inventory.get("trophy_chalice", 0) + 1
	p.inventory["lance_tourney"] = p.inventory.get("lance_tourney", 0) + 1
	
	_log("[color=gold][b]🏆 ВЕЛИКАЯ ПОБЕДА! ВЫ СТАЛИ ЧЕМПИОНОМ КОРОЛЕВСКОГО ТУРНИРА ОЛДЕРИИ![/b][/color]")
	_log("[color=yellow]Вам вручен Золотой Кубок Чемпиона 🏆, Турнирное Копье 🔱 и 250 золотых монет![/color]")
	_log("[color=cyan]👑 Ваша Слава взлетела до небес (+60 Славы, +40 Чести)![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ЧЕМПИОН ТУРНИРА! +250 ЗОЛОТА", Color.GOLD, 24)


# =========================================================
# МОРСКАЯ ВЕРФЬ, СУДОСТРОЕНИЕ И ЭКСПЕДИЦИИ НА ОСТРОВА ⛵🌴🗿
# =========================================================
# МОРСКАЯ ВЕРФЬ (UI вынесено в ShipyardModal.gd)
# =========================================================

func _build_shipyard_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI вынесено в ui/modals/ShipyardModal.gd.
	# Создание в _build_ui_hud() через shipyard_modal.build().
	pass


func _open_shipyard_modal() -> void:
	if shipyard_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	shipyard_modal.open()


func _refresh_shipyard_modal() -> void:
	if shipyard_modal == null:
		return
	shipyard_modal.refresh()


func _on_shipyard_item_selected(_idx: int) -> void:
	# выбор обрабатывается внутри ShipyardModal (on_list_selected).
	pass


func _buy_selected_ship() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	var t = shipyard_modal.get_selected_type() if (shipyard_modal != null and shipyard_modal.has_method("get_selected_type")) else "ship_longboat"
	var res = NavalSystem.build_ship(p, t)
	if res.get("success", false):
		_log("[color=gold][b]⛵ СУДОСТРОЕНИЕ: Со стапелей верфи спущен новый корабль: %s %s![/b][/color]" % [res.get("icon", "⛵"), res.get("name", "")])
		_spawn_spark_particles(player_pos, Color.CYAN)
		_spawn_floating_text(player_pos, "⛵ " + res.get("name", ""), Color.CYAN, 18)
		_refresh_shipyard_modal()
	else:
		_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка постройки судна"))


func _sail_sea_fishing() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	var res = NavalSystem.go_sea_fishing(p)
	if res.get("success", false):
		_log("[color=lightblue]🌊 [b]МОРСКОЙ ПРОМЫСЕЛ:[/b] Ваш корабль вернулся из открытого моря с богатым уловом: %s %s x%d![/color]" % [res.get("icon", "🐟"), res.get("name", ""), res.get("count", 1)])
		_spawn_spark_particles(player_pos, Color.CYAN)
		_spawn_floating_text(player_pos, "+%d %s" % [res.get("count", 1), res.get("name", "")], Color.CYAN, 18)
		_refresh_shipyard_modal()
	else:
		_log("[color=orange]⚓ %s[/color]" % res.get("reason", "Нет корабля"))

func _start_island_expedition(island_id: String) -> void:
	_close_all_modals()
	if is_overworld_mode:
		_toggle_overworld_mode()
		
	is_island_expedition_active = true
	active_island_id = island_id
	island_enemies.clear()
	
	var island_name = "Остров Пиратских Бухт" if island_id == "island_isle_of_coves" else "Затонувший Храм Морей"
	var is_temple = (island_id == "island_ancient_temple")
	var enemy_count = 12 if is_temple else 8
	
	_log("[color=gold][b]🌴 МОРСКАЯ ЭКСПЕДИЦИЯ: Высадка на «%s»![/b][/color]" % island_name)
	_log("[color=yellow]Корабль бросил якорь в лагуне! Дружина десантируется на неизведанный берег![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🌴 ЭКСПЕДИЦИЯ: " + island_name.to_upper(), Color.GOLD, 22)
	
	# Спавним пиратов и морских корсаров
	for i in range(enemy_count):
		var sp = Vector2i(randi_range(18, 28), randi_range(10, 17))
		var w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)
		var is_boss = (is_temple and i == 0)
		
		var npc_entry = {
			"id": "pirate_%d" % i,
			"name": ("Капитан Черная Борода" if is_boss else "Морской Корсар"),
			"role": "Бандит",
			"hp": (320.0 if is_boss else 85.0),
			"max_hp": (320.0 if is_boss else 85.0),
			"defense": (15 if is_boss else 8),
			"gold": (70 if is_boss else 18),
			"home_tile": sp,
			"target_pos": player_pos,
			"idle_timer": 0.0,
			"walk_speed": 52.0,
			"is_dead": false,
			"is_hostile": true,
			"is_ranged": (i % 2 == 1),
			"shoot_cooldown": randf_range(1.5, 3.0),
			"is_boss": is_boss,
			"traits": ["Морской Разбойник", "Головорез"]
		}
		
		npc_data.append(npc_entry)
		npc_positions.append(w_pos)
		var n_idx = npc_data.size() - 1
		island_enemies.append(n_idx)
		if is_boss: island_boss_idx = n_idx
		
		var spr = Sprite2D.new()
		spr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)
		spr.position = w_pos
		add_child(spr)
		npc_sprites.append(spr)
		
	player_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_island_expedition_progress() -> void:
	if not is_island_expedition_active: return
	
	var alive_count := 0
	for idx in island_enemies:
		if idx < npc_data.size() and not npc_data[idx].get("is_dead", false):
			alive_count += 1
			
	if alive_count == 0:
		_on_island_expedition_victory()

func _on_island_expedition_victory() -> void:
	is_island_expedition_active = false
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	var gold_gain = 380 if active_island_id == "island_isle_of_coves" else 550
	p.settlement["treasury"] = int(p.settlement.get("treasury", 0)) + gold_gain
	p.renown += 60
	p.honor += 40
	p.inventory["pearl"] = p.inventory.get("pearl", 0) + 2
	p.inventory["silk"] = p.inventory.get("silk", 0) + 3
	p.inventory["spices"] = p.inventory.get("spices", 0) + 2
	if active_island_id == "island_ancient_temple":
		p.inventory["ancient_relic"] = p.inventory.get("ancient_relic", 0) + 1
		
	_log("[color=gold][b]🏆 ВЕЛИКИЙ ТРИУМФ! Остров полностью зачищен от пиратов![/b][/color]")
	_log("[color=yellow]💰 Сундуки корсаров разграблены: +%d золотых в казну города![/color]" % gold_gain)
	_log("[color=lightgreen]🦪 Добыты заморские сокровища: +2 Жемчуга, +3 Имперского Шелка, +2 Пряностей![/color]")
	_log("[color=cyan]👑 Королевская Слава (+60 Славы, +40 Чести)![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ОСТРОВ ЗАХВАЧЕН! +%d ЗОЛОТА В КАЗНУ" % gold_gain, Color.GOLD, 24)


func _on_host_feast_pressed() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	var res = SettlementManager.host_feast(p)
	if res.get("success", false):
		_log("[color=gold][b]🍖 ПИР ПОСЕЛЕНИЯ: %s[/b][/color]" % res.get("message", ""))
		_spawn_spark_particles(player_pos, Color.GOLD)
		_spawn_floating_text(player_pos, "🍖 КОРОЛЕВСКИЙ ПИР! (100% MOOD)", Color.GOLD, 22)
		_refresh_settlement_window()
	else:
		_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка"))


func _repair_structure(t_pos: Vector2i, type_name: String) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	if p.get_item_count("plank") < 1 and p.get_item_count("wood") < 1 and p.get_item_count("stone") < 1:
		_log("[color=orange]🔨 Для починки и укрепления структуры нужна 1 доска или камень.[/color]")
		_spawn_floating_text(player_pos, "НУЖНЫ МАТЕРИАЛЫ 🪵", Color.ORANGE, 16)
		return
		
	if p.get_item_count("plank") >= 1:
		p.remove_item("plank", 1)
	elif p.get_item_count("wood") >= 1:
		p.remove_item("wood", 1)
	else:
		p.remove_item("stone", 1)
		
	p.add_skill_xp("crafting", 25.0)
	_log("[color=green][b]🔨 РЕМОНТ: Укрепление «%s» успешно отремонтировано и укреплено![/b][/color]" % type_name)
	_spawn_spark_particles(Vector2(t_pos.x * TILE_SIZE + TILE_SIZE/2.0, t_pos.y * TILE_SIZE + TILE_SIZE/2.0), Color.GREEN)
	_spawn_floating_text(Vector2(t_pos.x * TILE_SIZE + TILE_SIZE/2.0, t_pos.y * TILE_SIZE + TILE_SIZE/2.0), "🔨 ОТРЕМОНТИРОВАНО!", Color.GREEN, 18)


# =========================================================
# ПРЕДАННЫЙ ПЕС-КОМПАНЬОН И ТЕПЛО ДОМА 🐕❤️🐾🔥
# =========================================================
# ПРЕДАННЫЙ ПЕС (UI вынесено в DogModal.gd)
# =========================================================

func _build_dog_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI вынесено в ui/modals/DogModal.gd.
	# Создание в _build_ui_hud() через dog_modal.build().
	pass


func _open_dog_modal() -> void:
	if dog_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	dog_modal.open()


func _refresh_dog_modal() -> void:
	if dog_modal == null:
		return
	dog_modal.refresh()


func _feed_dog_food(food_pref: String = "meat_cooked") -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	var chosen_food = ""
	for f_id in ["meat_cooked", "meat_raw", "fish_trout", "fish_salmon", "fish_soup", "bread"]:
		if p.get_item_count(f_id) > 0:
			chosen_food = f_id
			break
	if chosen_food == "":
		_log("[color=orange]🍖 У вас нет еды для пса (нужно жареное мясо, рыба, уха или хлеб).[/color]")
		_refresh_dog_modal()
		return
	var res = PetCompanionSystem.feed_pet(p, dog_data, chosen_food)
	if res.get("success", false):
		_log("[color=gold][b]❤️ %s[/b][/color]" % res.get("message", ""))
		_spawn_spark_particles(dog_pos, Color.GOLD)
		_spawn_floating_text(dog_pos, "❤️ ДОВЕРИЕ И ДРУЖБА!", Color.GOLD, 20)
	_refresh_dog_modal()


func _pet_dog_companion() -> void:
	var res = PetCompanionSystem.pet_dog(dog_data)
	_log("[color=lightgreen]🐾 %s[/color]" % res.get("message", ""))
	_spawn_floating_text(dog_pos, "❤️ *довольно сопит*", Color(1.0, 0.8, 0.9), 16)
	_spawn_spark_particles(dog_pos, Color.PINK)
	_refresh_dog_modal()


func _dog_give_paw_action() -> void:
	var res = PetCompanionSystem.give_paw(dog_data)
	_log("[color=gold]🐾 %s[/color]" % res.get("message", ""))
	_spawn_floating_text(dog_pos, "🐾 ДАЛ ЛАПУ!", Color.GOLD, 16)
	_refresh_dog_modal()


func _toggle_dog_stay() -> void:
	if not dog_data.get("is_tamed", false):
		_feed_dog_food("meat_cooked")
		return
	var cur_st = dog_data.get("state", "follow")
	if cur_st == "follow":
		dog_data["state"] = "stay"
		_log("[color=yellow]🛑 Вы велели псу оставаться на месте и охранять.[/color]")
		_spawn_floating_text(dog_pos, "🛑 ОХРАНЯТЬ", Color.YELLOW, 16)
	else:
		dog_data["state"] = "follow"
		_log("[color=green]🚶‍♂️ Пес радостно вскочил и бежит за вами![/color]")
		_spawn_floating_text(dog_pos, "🚶‍♂️ ЗА МНОЙ!", Color.GREEN, 16)
	_refresh_dog_modal()


func _rename_dog_prompt() -> void:
	var names = PetCompanionSystem.PET_NAMES
	var cur_name = dog_data.get("name", "Верный")
	var n_idx = (names.find(cur_name) + 1) % names.size()
	dog_data["name"] = names[n_idx]
	_log("[color=gold]🏷️ Вы назвали своего друга: [b]%s[/b]![/color]" % dog_data["name"])
	_spawn_floating_text(dog_pos, "🐕 " + dog_data["name"], Color.GOLD, 18)
	_refresh_dog_modal()

# =========================================================
# АТМОСФЕРА, ПОГОДА, ДЫМ ИЗ ТРУБ И ВЕЧЕРНИЕ ОКНА 🕯️🌧️💨
# =========================================================
func _process_weather_and_atmosphere(delta: float) -> void:
	weather_cycle_timer -= delta
	smoke_emit_timer -= delta
	
	# 1. Цикл погоды
	if weather_cycle_timer <= 0.0:
		weather_cycle_timer = randf_range(80.0, 150.0)
		var prev_w = current_weather
		var w_list = AtmosphereSystem.WEATHERS
		current_weather = w_list[randi() % w_list.size()]
		
		if current_weather != prev_w:
			if current_weather == "rain":
				_log("[color=lightblue]🌧️ [b]ПОГОДА:[/b] Начался теплый летний дождь. Посевы пшеницы наливаются силой (+50% к росту)![/color]")
				_spawn_floating_text(player_pos, "🌧️ ТЕПЛЫЙ ДОЖДЬ", Color.LIGHT_BLUE, 18)
			elif current_weather == "storm":
				_log("[color=cyan]⛈️ [b]ПОГОДА:[/b] Надвинулась гроза с далекими раскатами грома![/color]")
				_spawn_floating_text(player_pos, "⛈️ ГРОЗА", Color.CYAN, 18)
			elif current_weather == "fog":
				_log("[color=lightgray]🌫️ [b]ПОГОДА:[/b] Над рекой и лугами стелется утренний туман.[/color]")
				_spawn_floating_text(player_pos, "🌫️ ТУМАН", Color.LIGHT_GRAY, 18)
			else:
				_log("[color=gold]☀️ [b]ПОГОДА:[/b] Непогода утихла. Выглянуло ласковое солнце.[/color]")
				_spawn_floating_text(player_pos, "☀️ СОЛНЕЧНО", Color.GOLD, 18)
	
	# 2. Клубы дыма над печными трубами и каминами
	if smoke_emit_timer <= 0.0:
		smoke_emit_timer = 0.9
		var chimneys = AtmosphereSystem.get_chimney_nodes(world_map)
		for c_pos in chimneys:
			_spawn_spark_particles(c_pos + Vector2(randf_range(-3, 3), -6), Color(0.88, 0.90, 0.95, 0.6))


# =========================================================
# БРОДЯЧИЙ БАРД В ТАВЕРНЕ И БАЛЛАДЫ 🎸🎶🍻
# =========================================================
# БРОДЯЧИЙ БАРД (UI вынесено в BardModal.gd)
# =========================================================

func _build_bard_modal(_canvas: CanvasLayer) -> void:
	# DEPRECATED: UI вынесено в ui/modals/BardModal.gd.
	# Создание в _build_ui_hud() через bard_modal.build().
	pass


func _open_bard_modal() -> void:
	if bard_modal == null:
		return
	_close_all_modals()
	is_ui_open = true
	bard_modal.open()


func _refresh_bard_modal() -> void:
	if bard_modal == null:
		return
	bard_modal.refresh()


func _on_ballad_selected(_idx: int) -> void:
	# выбор обрабатывается внутри BardModal (on_list_selected).
	pass


func _play_selected_ballad() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	var bid = bard_modal.get_selected_id() if (bard_modal != null and bard_modal.has_method("get_selected_id")) else "king_ballad"
	if p.gold < 5:
		_log("[color=orange]🪙 У вас недостаточно золота для заказа баллады (нужно 5 з.).[/color]")
		return
	p.gold -= 5
	var b = LivingDialogueSystem.BALLADS.get(bid, LivingDialogueSystem.BALLADS["king_ballad"])
	_log("[color=gold][b]🎶 БАРД ЗАИГРАЛ: %s![/b][/color]" % b.get("title", ""))
	for l in b.get("lines", []):
		_log("[color=yellow]  🎸 [i]%s[/i][/color]" % l)
	_log("[color=green][b]🍻 ЗАСТОЛЬЕ: Вся таверна ликует, чокается кружками эля и поет хором (+30 Mood)![/b][/color]")
	var citizens: Array = p.settlement.get("citizens", [])
	for c in citizens:
		c["drank_ale_today"] = true
		c["hunger"] = 100.0
	_spawn_spark_particles(Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE), Color.GOLD)
	_spawn_floating_text(Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE), "🎶 ПЕСНЬ БАРДА! 🍻 ЧОКНУЛИСЬ ЭЛЕМ!", Color.GOLD, 20)
	_refresh_bard_modal()

# =========================================================
# КВЕСТЫ ЖИТЕЛЕЙ И ДОСКА ОБЪЯВЛЕНИЙ
# =========================================================
func _show_quest_offer(q: Dictionary, npc: Dictionary) -> void:
	dialogue_title.text = "Поручение: %s" % q["title"]
	var req_text = ""
	for it in q["req_items"].keys():
		var it_def = ItemDatabase.get_item(it)
		req_text += "\n- %s: %d шт." % [it_def.get("name", it), q["req_items"][it]]
		
	var rew_text = "\n💰 Золото: %d з." % q["rewards"].get("gold", 0)
	if q["rewards"].has("items"):
		for it in q["rewards"]["items"].keys():
			var it_def = ItemDatabase.get_item(it)
			rew_text += "\n🎁 Награда: %s (%d шт.)" % [it_def.get("name", it), q["rewards"]["items"][it]]
			
	dialogue_text.text = """[b]«%s»[/b]

%s

[color=gold]📦 Требуется принести:[/color]%s

[color=lightblue]✨ Награда за выполнение:[/color]%s""" % [npc["name"], q["desc"], req_text, rew_text]

	for c in dialogue_options_container.get_children():
		c.queue_free()
		
	_add_dialogue_btn("✅ «Я берусь за это дело!» (Принять квест)", func():
		citizen_quest_system.accept_quest(q["id"])
		_log("[color=gold]📜 Вы взяли квест: %s от %s![/color]" % [q["title"], npc["name"]])
		_update_active_quest_tracker()
		_close_all_modals()
	)
	_add_dialogue_btn("❌ «Сейчас у меня нет на это времени» (Отказаться)", func():
		_close_all_modals()
	)

func _try_complete_quest(q: Dictionary, npc: Dictionary) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	if not citizen_quest_system.can_complete_quest(q["id"], p.inventory):
		_log("[color=red]❌ У вас еще нет всех необходимых предметов для поручения: %s![/color]" % q["title"])
		_close_all_modals()
		return
		
	var rews = citizen_quest_system.complete_quest(q["id"], p)
	npc["reputation_to_player"] = npc.get("reputation_to_player", 0) + 20
	
	_log("[color=gold]🎉 ВЫ ВЫПОЛНИЛИ КВЕСТ: %s! Получено +%d золота, +%d славы![/color]" % [q["title"], rews.get("gold", 0), rews.get("renown", 0)])
	_update_active_quest_tracker()
	_close_all_modals()

func _update_active_quest_tracker() -> void:
	if not quest_tracker_title or not quest_tracker_desc: return
	if citizen_quest_system:
		var q = citizen_quest_system.get_current_primary_quest()
		if not q.is_empty():
			quest_tracker_title.text = "📜 " + q["title"]
			quest_tracker_desc.text = q["desc"]
			return
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p and p.active_contracts.size() > 0:
		var c = p.active_contracts[0]
		var prog = "%d / %d" % [c.get("current_count", 0), c.get("required_count", 1)]
		var is_ready = c.get("current_count", 0) >= c.get("required_count", 1) or c.get("is_ready_to_turn_in", false)
		var status = "✅ Готово к сдаче!" if is_ready else "В процессе (%s)" % prog
		quest_tracker_title.text = "%s [%s]" % [c.get("title", "Контракт"), status]
		quest_tracker_desc.text = c.get("desc", "")
		return
	quest_tracker_title.text = "📜 Задание: Нет активных"
	quest_tracker_desc.text = "Доска Заказов на площади [E] или меню [Q]"

# =========================================================
# ВОЕННЫЕ СИСТЕМЫ, ТРЕВОЖНЫЙ КОЛОКОЛ И РЕЙДЫ
# =========================================================
func _ring_alarm_bell() -> void:
	if not alarm_bell_system: return
	var res = alarm_bell_system.ring_bell(npc_data)
	var col = "red" if res["active"] else "green"
	_log("[color=%s]%s[/color]" % [col, res["msg"]])
	
func _trigger_bandit_raid() -> void:
	if not raid_system: return
	var raid_info = raid_system.start_raid(Vector2i(6, 6))
	_log("[color=red]%s[/color]" % raid_info["message"])

# =========================================================
# ПОДЗЕМЕЛЬЕ: СКЛЕП ЗАБЫТЫХ И БОСС МАЛЬГРИМ (ЭТАП 3)
# =========================================================
func _enter_dungeon() -> void:
	is_in_dungeon = true
	_close_all_modals()
	
	if day_night_modulate:
		day_night_modulate.color = Color(0.06, 0.07, 0.12) # Глубокая тьма подземелья
		
	if player_torch:
		player_torch.enabled = true
		player_torch.energy = 1.4
		player_torch.texture_scale = 1.8
		
	player_pos = Vector2(5 * 48, 5 * 48)
	
	_log("[color=purple][b]🕳️ ВЫ СПУСТИЛИСЬ В СКЛЕП ЗАБЫТЫХ![/b][/color]")
	_log("[color=gray]Каменные своды окутаны вековой тьмой. Зажгите факел и остерегайтесь нажимных плит с шипами![/color]")
	_spawn_floating_text(player_pos, "🕳️ СКЛЕП ЗАБЫТЫХ", Color.PURPLE, 22)
	
func _exit_dungeon() -> void:
	is_in_dungeon = false
	_close_all_modals()
	
	player_pos = Vector2(6 * 48, 7 * 48) # Рядом со входом на поверхности
	
	_log("[color=gold][b]☀️ ВЫ ВЕРНУЛИСЬ НА ПОВЕРХНОСТЬ В ОКРЕСТНОСТИ ОЛДЕРИИ.[/b][/color]")
	_spawn_floating_text(player_pos, "☀️ ПОВЕРХНОСТЬ", Color.GOLD, 20)

# =========================================================
# УГЛУБЛЕНИЕ ПРОИЗВОДСТВА: ПОЛИВ, РЫБАЛКА, ЗАТОЧКА, БАФФЫ
# =========================================================
func _water_farm_tile(pos: Vector2i) -> void:
	if not agriculture_system: return
	if agriculture_system.water_tile(pos):
		_log("[color=lightblue]💧 Вы полили грядку чистой водой из лейки! Рост пшеницы ускорился в 2.5 раза![/color]")
		_spawn_floating_text(Vector2(pos.x * 48, pos.y * 48), "💧 ПОЛИТО!", Color.CYAN, 16)
		
func _harvest_farm_tile(pos: Vector2i) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not agriculture_system or not p: return
	var res = agriculture_system.harvest_crop(pos, p)
	if res.get("success", false):
		_log("[color=gold]%s[/color]" % res["msg"])
		_spawn_floating_text(Vector2(pos.x * 48, pos.y * 48), "+%d Пшеницы 🌾" % res["yield"], Color.GOLD, 18)
	else:
		_log("[color=gray]%s[/color]" % res.get("msg", ""))

func _use_grindstone() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not smithing_quality_system or not cooking_buff_system or not p: return
	var res = smithing_quality_system.sharpen_weapon(p)
	cooking_buff_system.apply_buff("buff_sharpness")
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "✨ ЗАТОЧЕНО! +15% УРОНА", Color.GOLD, 18)
	_update_buffs_hud()

func _eat_hearty_pie() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not cooking_buff_system or not p: return
	cooking_buff_system.apply_buff("buff_meat_pie")
	_log("[color=gold]🥧 ВЫ СЪЕЛИ СЫТНЫЙ МЯСНОЙ ПИРОГ! Получен бафф: +25 к максимальной выносливости на 12 часов![/color]")
	_spawn_floating_text(player_pos, "🥧 СЫТНЫЙ ПИРОГ: +25 СТАМИНЫ", Color.GOLD, 18)
	_update_buffs_hud()

func _update_buffs_hud() -> void:
	if not buffs_hud_label or not cooking_buff_system: return
	buffs_hud_label.text = cooking_buff_system.get_active_buffs_text()

# =========================================================
# УГЛУБЛЕНИЕ СОЦИУМА: ТАВЕРНА, ДРАКИ И СЕМЕЙНЫЙ БЫТ
# =========================================================
func _trigger_tavern_brawl() -> void:
	if not inter_citizen_social_system or npc_data.size() < 2: return
	var res = inter_citizen_social_system.start_tavern_brawl(npc_data[0], npc_data[1])
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(Vector2(25 * 48, 23 * 48), "🥊 ДРАКА В ТАВЕРНЕ!", Color.RED, 20)

func _resolve_tavern_brawl_ale() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not inter_citizen_social_system or not p: return
	var res = inter_citizen_social_system.resolve_brawl_buy_ale(p)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🍺 ТОСТ ЗА ЛОРДА! +15 ЧЕСТИ", Color.GOLD, 18)

func _get_spouse_home_lunch() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not family_dynasty_deepening_system or not p: return
	var tm = _get_time_manager()
	var cur_day = tm.day if tm and "day" in tm else 1
	var res = family_dynasty_deepening_system.get_spouse_lunch(p, cur_day)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🍲 ДОМАШНИЙ ОБЕД: 100% СЫТОСТЬ", Color.GOLD, 18)

func _train_family_heir(train_type: String = "combat") -> void:
	if not family_dynasty_deepening_system: return
	var res = {}
	if train_type == "combat":
		res = family_dynasty_deepening_system.train_heir_combat()
	else:
		res = family_dynasty_deepening_system.train_heir_stewardship()
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "⚔️ ОБУЧЕНИЕ НАСЛЕДНИКА", Color.GOLD, 18)

# =========================================================
# СИСТЕМА ОБУЧЕНИЯ, ПОДКРЕПЛЕНИЯ И НАСТАВНИЧЕСТВА NPC
# =========================================================
func _praise_current_npc(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var res = npc_learning_system.praise_npc(npc_id, npc)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🌟 ПОХВАЛА! +ТРУДОЛЮБИЕ", Color.GOLD, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _reward_current_npc_bonus(npc_id: String, npc: Dictionary) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not npc_learning_system or not p: return
	var res = npc_learning_system.reward_bonus(npc_id, npc, p)
	if res.get("success", false):
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_spawn_floating_text(player_pos, "🪙 ПРЕМИЯ! x1.5 СКОРОСТЬ", Color.GOLD, 18)
	else:
		_log("[color=orange]%s[/color]" % res.get("msg", ""))
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _reprimand_current_npc(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var res = npc_learning_system.reprimand_npc(npc_id, npc)
	_log("[color=orange]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "⚠️ ВЫГОВОР! +ДИСЦИПЛИНА", Color.ORANGE, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _teach_current_npc_lesson(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var role = npc.get("role", "")
	var craft = "farming"
	if role == "Кузнец": craft = "smithing"
	elif role in ["Пекарь", "Трактирщица"]: craft = "baking"
	elif role in ["Городской Стражник", "Охотник"]: craft = "combat"
	
	var res = npc_learning_system.teach_skill(npc_id, craft)
	_log("[color=lightblue]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "📖 УРОК РЕМЕСЛА: +35 XP", Color.CYAN, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]

# =========================================================
# УГЛУБЛЕНИЕ БОЯ, 8 СЛОТОВ ЭКИПИРОВКИ И ТРАВМЫ
# =========================================================
func _perform_dodge_roll() -> void:
	if not combat_tactics_system: return
	var input_vec = Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_vec.y -= 1
	if Input.is_key_pressed(KEY_S): input_vec.y += 1
	if Input.is_key_pressed(KEY_A): input_vec.x -= 1
	if Input.is_key_pressed(KEY_D): input_vec.x += 1
	
	var res = combat_tactics_system.start_dodge_roll(input_vec, player_stamina)
	if res.get("success", false):
		player_stamina = maxf(0.0, player_stamina - res["stamina_cost"])
		_play_sfx("dodge_roll")
		_spawn_floating_text(player_pos, "💨 КУВЫРОК!", Color.WHITE, 16)

func _use_bandage() -> void:
	if not injury_medicine_system: return
	var res = injury_medicine_system.apply_bandage(null)
	player_hp = minf(player_max_hp, player_hp + 15.0)
	_play_sfx("bandage")
	_log("[color=gold]%s[/color]" % res.get("msg", "Рана перевязана."))
	_spawn_floating_text(player_pos, "🩹 ПЕРЕВЯЗКА: +15 HP", Color.LIGHT_GREEN, 18)

func _use_salve() -> void:
	if not injury_medicine_system: return
	var res = injury_medicine_system.apply_salve(null)
	_play_sfx("bandage")
	_log("[color=gold]%s[/color]" % res.get("msg", "Мазь нанесена."))
	_spawn_floating_text(player_pos, "🧪 ЦЕЛЕБНАЯ МАЗЬ", Color.LIGHT_GREEN, 18)

# =========================================================
# УГЛУБЛЕНИЕ УПРАВЛЕНИЯ: СОВЕТ ПОСЕЛЕНИЯ, СКЛАДЫ И БУНТЫ
# =========================================================
func _appoint_council_official(office_id: String, npc_name: String) -> void:
	if not town_council_system: return
	var res = town_council_system.appoint_official(office_id, npc_name)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "👑 НАЗНАЧЕН СОВЕТНИК", Color.GOLD, 18)

func _trigger_peasant_revolt_event() -> void:
	if not settlement_unrest_system: return
	var res = settlement_unrest_system.trigger_peasant_revolt()
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(Vector2(25 * 48, 29 * 48), "🔥 КРЕСТЬЯНСКИЙ БУНТ!", Color.RED, 22)

func _resolve_peasant_revolt_feast() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not settlement_unrest_system or not p: return
	var res = settlement_unrest_system.resolve_revolt_feast(p)
	_log("[color=gold][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🎉 ВСЕНАРОДНЫЙ ПРАЗДНИК!", Color.GOLD, 20)

func _resolve_peasant_revolt_grain() -> void:
	if not settlement_unrest_system or not settlement_stockpile_system: return
	var res = settlement_unrest_system.resolve_revolt_grain(settlement_stockpile_system)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🥖 РАЗДАЧА ХЛЕБА: +30 ДОВОЛЬСТВА", Color.GOLD, 18)

# =========================================================
# ПРОЦЕДУРНОЕ АУДИО И ТАКТИЛЬНЫЙ СОК (GAME JUICE)
# =========================================================
func _play_sfx(sfx_name: String) -> void:
	if procedural_audio_system:
		procedural_audio_system.play_sfx(sfx_name)

func _shake_screen(intensity: float = 6.0, duration: float = 0.2) -> void:
	if juice_effects_system:
		juice_effects_system.trigger_shake(intensity, duration)



# =========================================================
# БОЛЬШИЕ ПОДЗЕМЕЛЬЯ, СКЛЕПЫ И БОСС (DUNGEON CRAWLING)
# =========================================================
func _enter_crypt_dungeon() -> void:
	if not crypt_dungeon_generator or not crypt_monsters_system: return
	is_in_dungeon = true
	crypt_dungeon_generator.generate_crypt()
	crypt_monsters_system.spawn_monsters()
	player_pos = Vector2(6 * 48, 6 * 48)
	_play_sfx("door_open")
	_log("[color=darkred][b]🕳️ ВЫ СПУСТИЛИСЬ В СКЛЕП ЗАБЫТЫХ! Повсюду веет могильным холодом, впереди слышен скрежет костей...[/b][/color]")
	_spawn_floating_text(player_pos, "🕳️ СКЛЕП ЗАБЫТЫХ", Color.RED, 22)

func _exit_crypt_dungeon() -> void:
	is_in_dungeon = false
	player_pos = Vector2(6 * 48, 6 * 48)
	_play_sfx("door_open")
	_log("[color=lightgreen][b]☀️ ВЫ ПОДНЯЛИСЬ НА ПОВЕРХНОСТЬ В ОЛДЕРИЮ![/b][/color]")

func _trigger_boss_fight() -> void:
	if not crypt_boss_system: return
	var res = crypt_boss_system.activate_boss()
	_shake_screen(12.0, 0.5)
	_play_sfx("sword_hit")
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(player_pos, "👑 БОСС: МАЛГОР!", Color.RED, 24)

func _strike_boss_malgor(dmg: int = 120) -> void:
	if not crypt_boss_system: return
	_play_sfx("sword_hit")
	_shake_screen(8.0, 0.3)
	var res = crypt_boss_system.take_damage(dmg)
	if res.get("killed", false):
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_play_sfx("level_up")
		_spawn_floating_text(player_pos, "🏆 БОСС ПОВЕРЖЕН!", Color.GOLD, 24)
	else:
		_log("[color=orange]⚔️ Удар по Малгору! Осталось HP: %d (Фаза %d)[/color]" % [res["hp"], res["phase"]])

func _loot_crypt_boss_chest() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not crypt_loot_system or not p: return
	var res = crypt_loot_system.open_royal_chest(p)
	if res.get("success", false):
		_play_sfx("coins")
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_spawn_floating_text(player_pos, "👑 ЛЕГЕНДАРНЫЙ ЛУТ!", Color.GOLD, 22)
	else:
		_log("[color=orange]%s[/color]" % res.get("msg", ""))



func _update_surface_npcs(delta: float) -> void:
	var tm = _get_time_manager()
	var hour = tm.hour if tm else 12
	var cur_weather = current_weather
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	var banner_pos = p.settlement.get("banner_tile", Vector2i(23, 21)) if p else Vector2i(23, 21)

	for i in npc_data.size():
		var npc = npc_data[i]
		if npc.get("is_dead", false):
			continue
		var spr = npc_sprites[i]
		var cur_p = npc_positions[i]
		var role = npc.get("role", "Крестьянин")

		if role in ["Бандит", "Разбойник", "Разбойник-лучник"]:
			var d_p = cur_p.distance_to(player_pos)
			if d_p < 140.0 and d_p > 45.0:
				var dir = (player_pos - cur_p).normalized()
				cur_p += dir * 100.0 * delta
				npc_positions[i] = cur_p
				spr.position = cur_p
				npc["thought"] = "⚔️"
			elif d_p <= 45.0 and attack_cooldown <= 0.0:
				_bandit_attack_player(i)
		elif role in ["Городской Стражник", "guard"]:
			# Стражник ищет бандитов поблизости
			var target_bandit_idx := -1
			var best_b_dist := 180.0
			for b_i in npc_data.size():
				if npc_data[b_i]["role"] in ["Бандит", "Разбойник", "Разбойник-лучник"] and not npc_data[b_i].get("is_dead", false):
					var d_b = cur_p.distance_to(npc_positions[b_i])
					if d_b < best_b_dist:
						best_b_dist = d_b
						target_bandit_idx = b_i
			
			if target_bandit_idx >= 0:
				var b_pos = npc_positions[target_bandit_idx]
				var dir_b = (b_pos - cur_p).normalized()
				if best_b_dist > 40.0:
					cur_p += dir_b * 90.0 * delta
					npc_positions[i] = cur_p
					spr.position = cur_p
					npc["thought"] = "⚔️"
				else:
					# Удар стражника по бандиту
					_spawn_spark_particles(b_pos, Color.WHITE)
					_spawn_floating_text(b_pos, "-25", Color.SALMON, 16)
					var b_hp = npc_data[target_bandit_idx].get("hp", 60) - 25
					npc_data[target_bandit_idx]["hp"] = b_hp
					if b_hp <= 0:
						npc_data[target_bandit_idx]["is_dead"] = true
						npc_sprites[target_bandit_idx].visible = false
						_log("[color=lightgreen]🛡️ Стражник %s сразил разбойника на подступах к деревне![/color]" % npc["name"])
						_spawn_floating_text(b_pos, "💀 СРАЖЕН", Color.GOLD, 18)
			else:
				# Патрулирование по распорядку дня NPCRoutineController
				var step_res = NPCRoutineController.update_npc_step(
					npc, cur_p, delta, world_map, banner_pos, hour, cur_weather,
					is_raid_active, npc_data, npc_positions, i
				)
				npc_positions[i] = step_res["new_pos"]
				cur_p = step_res["new_pos"]
				spr.position = cur_p
				var tb = spr.get_node_or_null("ThoughtBubble") as Label
				if tb:
					tb.text = step_res["thought_icon"]
				
				# Анимация шагов
				var w_time: float = npc.get("anim_t", 0.0) + delta * 8.0
				npc["anim_t"] = w_time
				if spr.hframes == 9:
					var dir_row = step_res["anim_dir_row"]
					var is_moving = (step_res["action_type"] == "traveling")
					var step_col = ((int(w_time) % 8) + 1) if is_moving else 0
					spr.frame = dir_row * 9 + step_col
		else:
			# Все остальные мирные жители и ремесленники
			var step_res = NPCRoutineController.update_npc_step(
				npc, cur_p, delta, world_map, banner_pos, hour, cur_weather,
				is_raid_active, npc_data, npc_positions, i
			)
			npc_positions[i] = step_res["new_pos"]
			cur_p = step_res["new_pos"]
			spr.position = cur_p

			# Облачко мыслей
			var tb = spr.get_node_or_null("ThoughtBubble") as Label
			if tb:
				tb.text = step_res["thought_icon"]

			# Сон (затемнение и прозрачность в постели)
			if step_res["is_sleeping"]:
				spr.modulate = Color(0.65, 0.70, 0.90, 0.70)
			else:
				spr.modulate = Color(1.0, 1.0, 1.0, 1.0)

			# Искры/эффекты работы
			if step_res["spark_pos"] != Vector2.ZERO:
				_spawn_spark_particles(step_res["spark_pos"], Color.GOLD)

			# Пополнение запасов поселения
			if step_res["did_produce"].size() > 0:
				var prod = step_res["did_produce"]
				if settlement_stockpile_system:
					settlement_stockpile_system.add_resource(prod["item_id"], prod["amount"])

			# Анимация шагов и направления
			var w_time: float = npc.get("anim_t", 0.0) + delta * 7.5
			npc["anim_t"] = w_time
			if spr.hframes == 9:
				var dir_row = step_res["anim_dir_row"]
				var is_moving = (step_res["action_type"] == "traveling")
				var step_col = ((int(w_time) % 8) + 1) if is_moving else 0
				spr.frame = dir_row * 9 + step_col
			else:
				if step_res["action_type"] == "traveling":
					spr.offset.y = sin(w_time) * -2.5
					spr.rotation_degrees = sin(w_time) * 3.5
				else:
					spr.rotation_degrees = lerpf(spr.rotation_degrees, 0.0, delta * 8.0)
					spr.offset.y = 0.0

		var plate = spr.get_node_or_null("Nameplate") as Label
		if plate:
			plate.visible = (i == interaction_target)
			if plate.visible:
				var nick = (" «" + npc["nickname"] + "»") if npc.get("nickname", "") != "" else ""
				plate.text = "%s%s" % [npc["name"], nick]

	# Мягкое отталкивание живых NPC друг от друга
	for i in npc_positions.size():
		if npc_data[i].get("is_dead", false): continue
		for j in range(i + 1, npc_positions.size()):
			if npc_data[j].get("is_dead", false): continue
			var diff = npc_positions[i] - npc_positions[j]
			var d = diff.length()
			if d < 28.0 and d > 0.01:
				var push = diff.normalized() * (28.0 - d) * 3.5 * delta
				npc_positions[i] += push
				npc_positions[j] -= push
				npc_sprites[i].position = npc_positions[i]
				npc_sprites[j].position = npc_positions[j]
