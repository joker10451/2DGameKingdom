class_name AtmosphereParticles2D
extends Node2D

## АТМОСФЕРНЫЕ ЧАСТИЦЫ ЖИВОГО МИРА (SOULASH 2 / STARDEW VALLEY STYLE)
## Управляет листопадом, светлячками, искрами кузницы и дымом из печей

var leaves_emitter: CPUParticles2D
var fireflies_emitter: CPUParticles2D
var sparks_emitters: Array[CPUParticles2D] = []

func _ready() -> void:
	_create_falling_leaves()
	_create_dusk_fireflies()

func _create_falling_leaves() -> void:
	leaves_emitter = CPUParticles2D.new()
	leaves_emitter.name = "FallingLeaves"
	leaves_emitter.amount = 45
	leaves_emitter.lifetime = 6.0
	leaves_emitter.preprocess = 3.0
	leaves_emitter.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	leaves_emitter.emission_rect_extents = Vector2(1500, 1500)
	leaves_emitter.position = Vector2(1500, 1500)
	leaves_emitter.direction = Vector2(0.8, 1.0)
	leaves_emitter.spread = 25.0
	leaves_emitter.gravity = Vector2(12, 18)
	leaves_emitter.initial_velocity_min = 15.0
	leaves_emitter.initial_velocity_max = 35.0
	leaves_emitter.angular_velocity_min = -60.0
	leaves_emitter.angular_velocity_max = 60.0
	leaves_emitter.scale_amount_min = 2.0
	leaves_emitter.scale_amount_max = 4.0
	leaves_emitter.color = Color(0.65, 0.75, 0.25, 0.85) # Золотисто-зеленые дубовые листья
	add_child(leaves_emitter)

func _create_dusk_fireflies() -> void:
	fireflies_emitter = CPUParticles2D.new()
	fireflies_emitter.name = "DuskFireflies"
	fireflies_emitter.amount = 35
	fireflies_emitter.lifetime = 4.5
	fireflies_emitter.preprocess = 2.0
	fireflies_emitter.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	fireflies_emitter.emission_rect_extents = Vector2(1500, 1500)
	fireflies_emitter.position = Vector2(1500, 1500)
	fireflies_emitter.direction = Vector2(0, 0)
	fireflies_emitter.spread = 180.0
	fireflies_emitter.gravity = Vector2(0, -2) # Медленно парят вверх
	fireflies_emitter.initial_velocity_min = 4.0
	fireflies_emitter.initial_velocity_max = 12.0
	fireflies_emitter.scale_amount_min = 2.5
	fireflies_emitter.scale_amount_max = 5.0
	fireflies_emitter.color = Color(0.85, 1.0, 0.35, 0.9) # Неоновый желто-зеленый свет
	fireflies_emitter.emitting = true
	add_child(fireflies_emitter)

func update_time_of_day(hour: int) -> void:
	var is_night_or_dusk = (hour >= 18 or hour < 6)
	if fireflies_emitter:
		fireflies_emitter.emitting = is_night_or_dusk
		
	# Осенью/днем листья летят активнее
	if leaves_emitter:
		leaves_emitter.amount = 60 if (hour >= 8 and hour <= 17) else 25

func create_forge_sparks(pos: Vector2) -> CPUParticles2D:
	var sp = CPUParticles2D.new()
	sp.name = "ForgeSparks"
	sp.position = pos
	sp.amount = 18
	sp.lifetime = 1.2
	sp.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINT
	sp.direction = Vector2(0, -1)
	sp.spread = 45.0
	sp.gravity = Vector2(0, 40)
	sp.initial_velocity_min = 35.0
	sp.initial_velocity_max = 75.0
	sp.scale_amount_min = 1.5
	sp.scale_amount_max = 3.0
	sp.color = Color(1.0, 0.70, 0.20, 0.95)
	add_child(sp)
	sparks_emitters.append(sp)
	return sp
