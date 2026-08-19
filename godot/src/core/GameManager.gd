extends Node

## GameManager: Глобальное состояние игры, реестр жителей и рынка

var player_data: CharacterData
var all_citizens: Array[Node] = []
var local_market: Market

func _ready() -> void:
	# Инициализация рынка
	local_market = load("res://src/economy/Market.gd").new()
	add_child(local_market)
	
	# Создание данных игрока по умолчанию
	player_data = load("res://src/character/CharacterData.gd").new()
	player_data.character_name = "Игрок"
	player_data.current_role = "Крестьянин"
	player_data.gold = 15
	player_data.inventory = {"bread": 2, "water": 1}
	
	print("[GameManager] Симуляция средневекового мира запущена.")

func register_citizen(citizen_node: Node) -> void:
	if not all_citizens.has(citizen_node):
		all_citizens.append(citizen_node)

func unregister_citizen(citizen_node: Node) -> void:
	all_citizens.erase(citizen_node)
