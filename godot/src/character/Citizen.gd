class_name Citizen
extends Node2D

## Персонаж-житель (NPC) с полным набором потребностей, памятью и ИИ

@export var data: CharacterData
@onready var needs: NeedsComponent = $NeedsComponent
@onready var memory: MemoryComponent = $MemoryComponent
@onready var brain: UtilityBrain = $UtilityBrain

func _ready() -> void:
	if not data:
		data = CharacterData.new()
		data.character_name = "Житель_" + str(randi() % 1000)
	
	GameManager.register_citizen(self)

func _exit_tree() -> void:
	if GameManager:
		GameManager.unregister_citizen(self)
