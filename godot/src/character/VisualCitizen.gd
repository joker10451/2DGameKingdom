class_name VisualCitizen
extends CharacterBody2D

## Визуальный персонаж-житель с физическим перемещением и облачками мыслей

@export var data: CharacterData
@export var move_speed: float = 80.0

@onready var needs: NeedsComponent = $NeedsComponent
@onready var memory: MemoryComponent = $MemoryComponent
@onready var brain: UtilityBrain = $UtilityBrain

var target_destination: Vector2 = Vector2.ZERO
var is_moving: bool = false
var current_thought_icon: String = "💭"
var state_label: String = "Отдых"

# Цвета плащей/одежды по ролям
const ROLE_COLORS = {
	"Крестьянин": Color(0.45, 0.65, 0.35), # Зеленоватый лен
	"Торговец": Color(0.85, 0.7, 0.2),     # Золотистый бархат
	"Бандит": Color(0.65, 0.25, 0.25),     # Багровый / кожа
	"Стражник": Color(0.3, 0.45, 0.75),    # Стальной синий
	"Ремесленник": Color(0.6, 0.4, 0.25),  # Коричневый фартук
	"Лорд": Color(0.6, 0.2, 0.7),          # Королевский пурпур
	"Король": Color(0.9, 0.85, 0.1)        # Золотой венец
}

func _ready() -> void:
	if not data:
		data = CharacterData.new()
		data.character_name = "Житель_" + str(randi() % 1000)
	
	target_destination = global_position
	GameManager.register_citizen(self)
	queue_redraw()

func _physics_process(delta: float) -> void:
	# Определение целевой точки по решению Utility AI
	_update_destination_from_action()
	
	# Движение к цели
	if global_position.distance_to(target_destination) > 10.0:
		var dir = (target_destination - global_position).normalized()
		velocity = dir * move_speed
		move_and_slide()
		is_moving = true
	else:
		velocity = Vector2.ZERO
		is_moving = false
	
	queue_redraw()

func _update_destination_from_action() -> void:
	if not brain:
		return
	
	match brain.current_action:
		"EAT":
			current_thought_icon = "🥖"
			state_label = "Ищет еду"
		"SLEEP":
			current_thought_icon = "💤"
			state_label = "Спит"
		"FARM_WORK":
			current_thought_icon = "🌾"
			state_label = "Работает в поле"
		"TRADE_MARKET":
			current_thought_icon = "⚖️"
			state_label = "Торгует на рынке"
		"PATROL_CITY":
			current_thought_icon = "🛡️"
			state_label = "Патрулирует"
		"HUNT_OR_AMBUSH", "STEAL_RESOURCE":
			current_thought_icon = "🗡️"
			state_label = "Замышляет кражу"
		"VISIT_TAVERN":
			current_thought_icon = "🍺"
			state_label = "В таверне"
		"HOLD_COURT":
			current_thought_icon = "👑"
			state_label = "Вершит суд"
		_:
			current_thought_icon = "💭"
			state_label = "Осматривается"

func set_world_destination(pos: Vector2) -> void:
	target_destination = pos

func _draw() -> void:
	# Тень
	draw_circle(Vector2(0, 8), 12, Color(0, 0, 0, 0.3))
	
	# Тело персонажа (одежда по цвету роли)
	var col = ROLE_COLORS.get(data.current_role, Color.GRAY) if data else Color.GRAY
	draw_circle(Vector2(0, 0), 14, col)
	
	# Голова
	draw_circle(Vector2(0, -6), 8, Color(0.95, 0.8, 0.65))
	
	# Облачко мысли над головой
	draw_circle(Vector2(12, -26), 11, Color(1, 1, 1, 0.9))
	draw_circle(Vector2(4, -18), 4, Color(1, 1, 1, 0.8))
	draw_string(ThemeDB.fallback_font, Vector2(6, -21), current_thought_icon, HORIZONTAL_ALIGNMENT_CENTER, -1, 13)
	
	# Имя и роль
	if data:
		var name_str = "%s (%s)" % [data.character_name, data.current_role]
		draw_string(ThemeDB.fallback_font, Vector2(-40, -38), name_str, HORIZONTAL_ALIGNMENT_CENTER, 80, 11, Color.WHITE)
		
		# Полоска сытости / голода (зеленая -> красная)
		if needs:
			var hunger_ratio = 1.0 - (needs.hunger / 100.0)
			draw_rect(Rect2(-15, 14, 30, 4), Color(0.2, 0.2, 0.2))
			draw_rect(Rect2(-15, 14, 30 * hunger_ratio, 4), Color(0.2, 0.8, 0.2).lerp(Color.RED, needs.hunger / 100.0))

func _exit_tree() -> void:
	if GameManager:
		GameManager.unregister_citizen(self)
