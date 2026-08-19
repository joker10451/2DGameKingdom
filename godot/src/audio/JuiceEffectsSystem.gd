class_name JuiceEffectsSystem
extends RefCounted

## СИСТЕМА ТАКТИЛЬНОГО СОКА И ТРЯСКИ КАМЕРЫ (GAME JUICE)
## Управляет экранной тряской при ударах, вспышками и визуальным откликом

var shake_intensity: float = 0.0
var shake_timer: float = 0.0

func trigger_shake(intensity: float = 8.0, duration: float = 0.25) -> void:
	shake_intensity = intensity
	shake_timer = duration

func update(delta: float) -> Vector2:
	if shake_timer > 0.0:
		shake_timer -= delta
		var offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_intensity = lerpf(shake_intensity, 0.0, delta * 10.0)
		return offset
	return Vector2.ZERO
