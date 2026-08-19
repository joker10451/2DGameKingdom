extends Node

## TimeManager: Управление внутриигровым временем, сезонами и тиками симуляции

const SEASONS: Array[String] = ["Весна", "Лето", "Осень", "Зима"]
const DAYS_PER_SEASON: int = 30
const HOURS_PER_DAY: int = 24
const MINUTES_PER_HOUR: int = 60

# Скорость времени: 1 реальная секунда = REAL_SECONDS_TO_GAME_MINUTES игровых минут при 1x
var time_scale: float = 1.0 # 0 = пауза, 1.0 = нормальная, 2.0 / 5.0 = ускорение
var minute_accumulator: float = 0.0
const SECONDS_PER_GAME_MINUTE: float = 1.0 # 1 секунда = 1 минута в игре по умолчанию

# Текущее время
var minute: int = 0
var hour: int = 7 # Начинаем утро в 07:00
var day: int = 1
var season_index: int = 0
var year: int = 1042

func _process(delta: float) -> void:
	if is_zero_approx(time_scale):
		return
	
	minute_accumulator += delta * time_scale
	while minute_accumulator >= SECONDS_PER_GAME_MINUTE:
		minute_accumulator -= SECONDS_PER_GAME_MINUTE
		_advance_minute()

func _get_event_bus() -> Node:
	return get_node_or_null("/root/EventBus")

func _advance_minute() -> void:
	minute += 1
	if minute >= MINUTES_PER_HOUR:
		minute = 0
		_advance_hour()
	
	var eb = _get_event_bus()
	if eb:
		eb.minute_passed.emit(minute, hour)

func _advance_hour() -> void:
	hour += 1
	if hour >= HOURS_PER_DAY:
		hour = 0
		_advance_day()
	
	var eb = _get_event_bus()
	if eb:
		eb.hour_passed.emit(hour, day)

func _advance_day() -> void:
	day += 1
	if day > DAYS_PER_SEASON:
		day = 1
		_advance_season()
	
	var eb = _get_event_bus()
	if eb:
		eb.day_passed.emit(day, get_current_season())

func _advance_season() -> void:
	season_index += 1
	if season_index >= SEASONS.size():
		season_index = 0
		year += 1
	
	var eb = _get_event_bus()
	if eb:
		eb.season_passed.emit(get_current_season(), year)

func get_current_season() -> String:
	return SEASONS[season_index]

func get_formatted_time() -> String:
	return "%02d:%02d" % [hour, minute]

func get_formatted_date() -> String:
	return "%d-й день, %s, %d год" % [day, get_current_season(), year]

func set_speed(speed: float) -> void:
	time_scale = maxf(0.0, speed)
