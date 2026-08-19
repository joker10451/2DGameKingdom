class_name AgricultureSystem2D
extends RefCounted

## МНОГОСТАДИЙНАЯ СИСТЕМА ЗЕМЛЕДЕЛИЯ И ИРРИГАЦИИ
## Управляет 4 стадиями роста культур, поливом лейкой и сбором урожая

# crop_data: Vector2i -> {crop_type: "wheat", stage: 0..3, is_watered: bool, growth_progress: float}
var crops: Dictionary = {}

const STAGE_SEEDS := 0
const STAGE_SPROUT := 1
const STAGE_GROWING := 2
const STAGE_MATURE := 3

func plant_crop(pos: Vector2i, crop_type: String = "wheat") -> bool:
	if crops.has(pos):
		return false
	crops[pos] = {
		"crop_type": crop_type,
		"stage": STAGE_SEEDS,
		"is_watered": false,
		"growth_progress": 0.0
	}
	return true

func water_tile(pos: Vector2i) -> bool:
	if crops.has(pos):
		crops[pos]["is_watered"] = true
		return true
	return false

func process_growth(delta_time: float) -> Array[Vector2i]:
	var updated_tiles: Array[Vector2i] = []
	
	for pos in crops.keys():
		var c = crops[pos]
		if c["stage"] >= STAGE_MATURE:
			continue
			
		# Политые культуры растут в 2.5 раза быстрее
		var speed_mult = 2.5 if c["is_watered"] else 1.0
		c["growth_progress"] += delta_time * 0.15 * speed_mult
		
		var new_stage = int(c["growth_progress"])
		if new_stage > c["stage"]:
			c["stage"] = min(new_stage, STAGE_MATURE)
			updated_tiles.append(pos)
			
	return updated_tiles

func harvest_crop(pos: Vector2i, player_data: CharacterData) -> Dictionary:
	if not crops.has(pos):
		return {}
		
	var c = crops[pos]
	if c["stage"] < STAGE_MATURE:
		return {"success": false, "msg": "🌾 Пшеница еще не созрела! Дождитесь золотых колосьев."}
		
	var yield_amt = randi_range(2, 4)
	var seeds_amt = 1 if randf() < 0.60 else 0
	
	if player_data:
		player_data.add_item("grain", yield_amt)
		if seeds_amt > 0:
			player_data.add_item("seeds_wheat", seeds_amt)
			
	crops.erase(pos)
	
	return {
		"success": true,
		"yield": yield_amt,
		"seeds": seeds_amt,
		"msg": "🌾 УРОЖАЙ СОБРАН! Получено: %d снопов пшеницы%s!" % [yield_amt, " и семена" if seeds_amt > 0 else ""]
	}

func get_crop_sprite_type(pos: Vector2i) -> String:
	if not crops.has(pos):
		return ""
	var stage = crops[pos]["stage"]
	match stage:
		STAGE_SEEDS: return "crop_stage_0"
		STAGE_SPROUT: return "crop_stage_1"
		STAGE_GROWING: return "crop_stage_2"
		STAGE_MATURE: return "crop_stage_3"
		_: return "crop_stage_3"
