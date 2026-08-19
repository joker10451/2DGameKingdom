class_name WorldBuilding
extends Area2D

## Интерактивное здание / точка интереса в живом мире

enum BuildingType {
	FARM_FIELD,      # Пшеничное поле / ферма (производство зерна)
	WINDMILL,        # Мельница (переработка зерна в муку)
	BAKERY,          # Пекарня (выпечка хлеба)
	TAVERN,          # Таверна (отдых, еда, эль, общение по вечерам)
	MARKET_STALL,    # Торговый прилавок (рынок)
	GUARD_POST,      # Пост стражи (патрулирование, безопасность)
	BANDIT_CAMP,     # Лесной лагерь разбойников (засады, сбыт краденого)
	MANOR_CASTLE,    # Усадьба лорда (сбор налогов, суд, законы)
	HOME_RESIDENCE   # Жилой дом (сон, личное хранилище)
}

@export var building_type: BuildingType = BuildingType.FARM_FIELD
@export var building_name: String = "Строение"
@export var owner_name: String = "Община"
@export var stock: Dictionary = {} # Хранилище здания: item_id -> count

@onready var interaction_pos: Marker2D = $Marker2D if has_node("Marker2D") else null

func _ready() -> void:
	match building_type:
		BuildingType.FARM_FIELD:
			stock = {"grain": 20}
		BuildingType.BAKERY:
			stock = {"flour": 15, "bread": 10}
		BuildingType.TAVERN:
			stock = {"ale": 30, "bread": 20, "meat": 10}
		BuildingType.MARKET_STALL:
			stock = {"bread": 15, "tools": 5, "grain": 30}
		BuildingType.BANDIT_CAMP:
			stock = {"gold_stolen": 45, "dagger": 3}
		BuildingType.MANOR_CASTLE:
			stock = {"treasury_gold": 250, "swords": 10}

func get_interact_position() -> Vector2:
	if has_node("Marker2D"):
		return $Marker2D.global_position
	return global_position
