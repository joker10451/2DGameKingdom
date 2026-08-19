class_name PlayerController
extends CharacterBody2D

## Физический контроллер игрока в живом мире

@export var move_speed: float = 140.0
@onready var camera: Camera2D = $Camera2D if has_node("Camera2D") else null

var nearby_npc: VisualCitizen = null
var nearby_building: WorldBuilding = null

func _ready() -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.keycode == KEY_E):
		if nearby_npc:
			_interact_with_npc(nearby_npc)
		elif nearby_building:
			_interact_with_building(nearby_building)

func _interact_with_npc(npc: VisualCitizen) -> void:
	var main_scene = get_tree().current_scene
	if main_scene.has_method("open_dialogue_with_npc"):
		main_scene.open_dialogue_with_npc(npc)

func _interact_with_building(building: WorldBuilding) -> void:
	var main_scene = get_tree().current_scene
	if main_scene.has_method("interact_with_building"):
		main_scene.interact_with_building(building)

func _draw() -> void:
	# Тень
	draw_circle(Vector2(0, 10), 14, Color(0, 0, 0, 0.4))
	
	# Контур выделения игрока (золотое кольцо)
	draw_arc(Vector2(0, 0), 18, 0, TAU, 32, Color(1.0, 0.85, 0.2, 0.8), 2.0)
	
	# Тело игрока
	var p_data = GameManager.player_data if GameManager else null
	var body_color = Color(0.2, 0.6, 0.9) # Синий плащ
	if p_data:
		match p_data.current_role:
			"Лорд", "Король":
				body_color = Color(0.7, 0.1, 0.8)
			"Бандит":
				body_color = Color(0.8, 0.1, 0.1)
			"Торговец":
				body_color = Color(0.9, 0.7, 0.1)
			"Стражник":
				body_color = Color(0.2, 0.3, 0.8)
	
	draw_circle(Vector2(0, 0), 15, body_color)
	draw_circle(Vector2(0, -6), 9, Color(0.95, 0.8, 0.65))
	
	# Подпись над головой
	var name_str = "Вы: %s" % (p_data.get_full_display_name() if p_data else "Игрок")
	draw_string(ThemeDB.fallback_font, Vector2(-50, -32), name_str, HORIZONTAL_ALIGNMENT_CENTER, 100, 12, Color.GOLD)
