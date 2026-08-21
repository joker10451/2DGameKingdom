class_name AgricultureSystem2D
extends RefCounted

## МНОГОСТАДИЙНАЯ СИСТЕМА ЗЕМЛЕДЕЛИЯ И ИРРИГАЦИИ
## Рост идёт по игровым часам, а не по кадрам. Полив действует до рассвета.

var crops: Dictionary = {}

const STAGE_SEEDS := 0
const STAGE_SPROUT := 1
const STAGE_GROWING := 2
const STAGE_MATURE := 3

# Базовый прогресс за один игровой час. 1.0 = одна стадия.
const BASE_GROWTH_PER_HOUR: float = 0.18
const WATERED_GROWTH_MULTIPLIER: float = 2.5
const DRY_HOUR_GROWTH_MULTIPLIER: float = 0.65

var current_weather: String = "clear"
var last_processed_day: int = -1
var last_processed_hour: int = -1

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
	if not crops.has(pos):
		return false
	crops[pos]["is_watered"] = true
	return true

func set_weather(weather: String) -> void:
	current_weather = weather
	if weather in ["rain", "storm"]:
		auto_water_all()

func auto_water_all() -> int:
	var watered := 0
	for pos in crops.keys():
		if not crops[pos]["is_watered"]:
			crops[pos]["is_watered"] = true
			watered += 1
	return watered

func dry_all() -> void:
	for pos in crops.keys():
		crops[pos]["is_watered"] = false

func process_game_hour(weather: String = "") -> Array[Vector2i]:
	if weather != "":
		set_weather(weather)
	
	var updated_tiles: Array[Vector2i] = []
	if current_weather in ["rain", "storm"]:
		auto_water_all()
	
	for pos in crops.keys():
		var c = crops[pos]
		if c["stage"] >= STAGE_MATURE:
			continue

		var speed_mult := WATERED_GROWTH_MULTIPLIER if c["is_watered"] else DRY_HOUR_GROWTH_MULTIPLIER
		c["growth_progress"] += BASE_GROWTH_PER_HOUR * speed_mult
		var new_stage := mini(int(c["growth_progress"]), STAGE_MATURE)
		if new_stage > c["stage"]:
			c["stage"] = new_stage
			updated_tiles.append(pos)
	
	return updated_tiles

func on_new_day(hour: int = 6) -> void:
	# Рассвет высушивает открытые грядки. Вызов рекомендуется на часе 06:00.
	if hour == 6:
		dry_all()

func process_growth(delta_time: float) -> Array[Vector2i]:
	# Backward-compatible API. Legacy callers should migrate to process_game_hour().
	# Не использует frame delta, чтобы не возвращать рассинхрон real-time/game-time.
	return []

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
