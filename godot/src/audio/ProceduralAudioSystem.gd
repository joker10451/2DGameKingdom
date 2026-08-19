class_name ProceduralAudioSystem
extends RefCounted

## АУДИО-СИСТЕМА И МЕНЕДЖЕР ЗВУКОВ (SFX, AMBIENCE, MUSIC)
## Загружает и воспроизводит реальные аудио-ассеты (WAV, MP3, OGG)

var music_player: AudioStreamPlayer
var ambience_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var next_sfx_idx: int = 0

var audio_cache: Dictionary = {}

func init_player(parent_node: Node) -> void:
	# 1. Музыкальный плеер
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		music_player.volume_db = -10.0
		parent_node.add_child(music_player)
		
	# 2. Плеер фоновой атмосферы
	if not ambience_player:
		ambience_player = AudioStreamPlayer.new()
		ambience_player.name = "AmbiencePlayer"
		ambience_player.volume_db = -14.0
		parent_node.add_child(ambience_player)
		
	# 3. Пул SFX плееров для полифонии
	for i in range(8):
		var p = AudioStreamPlayer.new()
		p.name = "SFXPlayer_%d" % i
		p.volume_db = -4.0
		parent_node.add_child(p)
		sfx_players.append(p)
		
	_preload_all_audio()
	play_music("main_theme")

func _preload_all_audio() -> void:
	# Музыка
	_load_stream("main_theme", "res://assets/audio/music/main_theme.mp3")
	
	# Эмбиент
	_load_stream("amb_village_day", "res://assets/audio/ambience/amb_village_day.wav")
	_load_stream("amb_tavern", "res://assets/audio/ambience/amb_tavern.wav")
	_load_stream("amb_night_camp", "res://assets/audio/ambience/amb_night_camp.wav")
	_load_stream("amb_windmill", "res://assets/audio/ambience/amb_windmill.wav")
	
	# SFX
	_load_stream("sfx_anvil", "res://assets/audio/sfx/sfx_anvil.wav")
	_load_stream("sfx_bandage", "res://assets/audio/sfx/sfx_bandage.wav")
	_load_stream("sfx_bow_shot", "res://assets/audio/sfx/sfx_bow_shot.wav")
	_load_stream("sfx_chop", "res://assets/audio/sfx/sfx_chop.wav")
	_load_stream("sfx_coins", "res://assets/audio/sfx/sfx_coins.wav")
	_load_stream("sfx_dodge_roll", "res://assets/audio/sfx/sfx_dodge_roll.wav")
	_load_stream("sfx_door_open", "res://assets/audio/sfx/sfx_door_open.wav")
	_load_stream("sfx_harvest", "res://assets/audio/sfx/sfx_harvest.wav")
	_load_stream("sfx_level_up", "res://assets/audio/sfx/sfx_level_up.wav")
	_load_stream("sfx_parchment", "res://assets/audio/sfx/sfx_parchment.wav")
	_load_stream("sfx_pickaxe", "res://assets/audio/sfx/sfx_pickaxe.wav")
	_load_stream("sfx_quench", "res://assets/audio/sfx/sfx_quench.wav")
	_load_stream("sfx_shield_block", "res://assets/audio/sfx/sfx_shield_block.wav")
	_load_stream("sfx_splash", "res://assets/audio/sfx/sfx_splash.wav")
	_load_stream("sfx_step_grass", "res://assets/audio/sfx/sfx_step_grass.wav")
	_load_stream("sfx_step_stone", "res://assets/audio/sfx/sfx_step_stone.wav")
	_load_stream("sfx_sword_hit", "res://assets/audio/sfx/sfx_sword_hit.wav")
	_load_stream("sfx_sword_swing", "res://assets/audio/sfx/sfx_sword_swing.wav")

func _load_stream(key: String, path: String) -> void:
	if ResourceLoader.exists(path):
		var stream = load(path)
		if stream:
			audio_cache[key] = stream

func play_music(music_name: String = "main_theme") -> void:
	if not music_player or not audio_cache.has(music_name): return
	music_player.stream = audio_cache[music_name]
	music_player.play()

func play_ambience(amb_name: String = "amb_village_day") -> void:
	if not ambience_player or not audio_cache.has(amb_name): return
	ambience_player.stream = audio_cache[amb_name]
	ambience_player.play()

func play_sfx(sfx_name: String) -> void:
	# Сопоставление алиасов
	var key = sfx_name
	if not key.begins_with("sfx_") and not audio_cache.has(key):
		key = "sfx_" + key
	if key == "sfx_coin": key = "sfx_coins"
	elif key == "sfx_sword": key = "sfx_sword_hit"
	elif key == "sfx_shield": key = "sfx_shield_block"
	elif key == "sfx_step": key = "sfx_step_grass"
	elif key == "sfx_mine": key = "sfx_pickaxe"
	
	if not audio_cache.has(key) or sfx_players.is_empty(): return
	
	var player = sfx_players[next_sfx_idx]
	next_sfx_idx = (next_sfx_idx + 1) % sfx_players.size()
	
	player.stream = audio_cache[key]
	player.pitch_scale = randf_range(0.96, 1.04)
	
	# Тонкая настройка громкости отдельных эффектов
	if key == "sfx_door_open":
		player.volume_db = -18.0 # Очень тихий и мягкий звук двери (-18 dB)
	elif key in ["sfx_step_grass", "sfx_step_stone"]:
		player.volume_db = -6.0
	else:
		player.volume_db = 0.0
		
	player.play()
