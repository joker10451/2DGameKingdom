with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const SettlementUnrestSystemScript = preload("res://src/settlement/SettlementUnrestSystem.gd")'''
new_vars = '''const SettlementUnrestSystemScript = preload("res://src/settlement/SettlementUnrestSystem.gd")
const ProceduralAudioSystemScript = preload("res://src/audio/ProceduralAudioSystem.gd")
const JuiceEffectsSystemScript = preload("res://src/audio/JuiceEffectsSystem.gd")

var procedural_audio_system: RefCounted
var juice_effects_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tsettlement_unrest_system = SettlementUnrestSystemScript.new()'''
new_ready_end = '''\tsettlement_unrest_system = SettlementUnrestSystemScript.new()
\t
\t# 5.14. Процедурное Аудио и Тактильный Сок (Блок №5)
\tprocedural_audio_system = ProceduralAudioSystemScript.new()
\tprocedural_audio_system.init_player(self)
\tjuice_effects_system = JuiceEffectsSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Helper Methods
helpers = '''
# =========================================================
# ПРОЦЕДУРНОЕ АУДИО И ТАКТИЛЬНЫЙ СОК (GAME JUICE)
# =========================================================
func _play_sfx(sfx_name: String) -> void:
	if procedural_audio_system:
		procedural_audio_system.play_sfx(sfx_name)

func _shake_screen(intensity: float = 6.0, duration: float = 0.2) -> void:
	if juice_effects_system:
		juice_effects_system.trigger_shake(intensity, duration)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Pillar 5 Audio and Juice integrated into GameWorld2D.gd!")
