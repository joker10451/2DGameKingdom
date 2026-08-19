class_name AtmosphereVFXSystem
extends RefCounted

## СИСТЕМА АТМОСФЕРНЫХ ЭФФЕКТОВ (VFX)
## Управляет кружащимися на ветру листьями, ночными светлячками и дымом из печных труб

var wind_particles: Array[Dictionary] = []
var fireflies: Array[Dictionary] = []
var smoke_puffs: Array[Dictionary] = []

func init_vfx() -> void:
	wind_particles.clear()
	fireflies.clear()
	smoke_puffs.clear()
	
	# 🍃 Листья на ветру
	for i in range(25):
		wind_particles.append({
			"pos": Vector2(randf_range(0, 50 * 48), randf_range(0, 50 * 48)),
			"speed": randf_range(40.0, 75.0),
			"sway_offset": randf() * 10.0,
			"color": Color(0.35, 0.65, 0.20, 0.85)
		})
		
	# ✨ Светлячки
	for i in range(20):
		fireflies.append({
			"pos": Vector2(randf_range(5 * 48, 45 * 48), randf_range(5 * 48, 45 * 48)),
			"phase": randf() * PI * 2,
			"speed": randf_range(10.0, 20.0)
		})

func update_vfx(delta: float, is_night: bool, chimneys: Array[Vector2]) -> void:
	# 1. Листья на ветру
	for p in wind_particles:
		p["sway_offset"] += delta * 3.0
		p["pos"].x += p["speed"] * delta
		p["pos"].y += sin(p["sway_offset"]) * 18.0 * delta
		if p["pos"].x > 50 * 48:
			p["pos"].x = 0
			p["pos"].y = randf_range(0, 50 * 48)
			
	# 2. Светлячки
	for f in fireflies:
		f["phase"] += delta * 2.5
		f["pos"] += Vector2(cos(f["phase"]) * f["speed"] * delta, sin(f["phase"]) * f["speed"] * delta)
		
	# 3. Дым из труб
	if randf() < 0.3 and chimneys.size() > 0:
		for ch in chimneys:
			smoke_puffs.append({
				"pos": ch + Vector2(randf_range(-3, 3), 0),
				"life": 1.0,
				"max_life": randf_range(2.0, 3.5),
				"size": 4.0
			})
			
	var i = smoke_puffs.size() - 1
	while i >= 0:
		var sm = smoke_puffs[i]
		sm["life"] += delta
		sm["pos"].y -= 22.0 * delta
		sm["pos"].x += sin(sm["life"] * 2.0) * 8.0 * delta
		sm["size"] += delta * 3.5
		if sm["life"] >= sm["max_life"]:
			smoke_puffs.remove_at(i)
		i -= 1

func draw_vfx(ci: CanvasItem, is_night: bool) -> void:
	# Дым из труб
	for sm in smoke_puffs:
		var alpha = 1.0 - (sm["life"] / sm["max_life"])
		ci.draw_circle(sm["pos"], sm["size"], Color(0.85, 0.85, 0.88, alpha * 0.45))
		
	# Листья
	for p in wind_particles:
		ci.draw_circle(p["pos"], 2.5, p["color"])
		
	# Светлячки (ярче в сумерках и ночью)
	if is_night:
		for f in fireflies:
			var pulse = (sin(f["phase"] * 3.0) + 1.0) * 0.5
			ci.draw_circle(f["pos"], 3.0 + pulse * 2.0, Color(0.65, 1.0, 0.35, pulse * 0.9))
