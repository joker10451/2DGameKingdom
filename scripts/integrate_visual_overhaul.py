with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const FactionWarfareSystemScript = preload("res://src/world/FactionWarfareSystem.gd")'''
new_vars = '''const FactionWarfareSystemScript = preload("res://src/world/FactionWarfareSystem.gd")
const EnhancedArtGeneratorScript = preload("res://src/world/EnhancedArtGenerator.gd")
const FaunaSystem2DScript = preload("res://src/world/FaunaSystem2D.gd")
const AtmosphereVFXSystemScript = preload("res://src/world/AtmosphereVFXSystem.gd")
const WorldDecorationsSystemScript = preload("res://src/world/WorldDecorationsSystem.gd")

var enhanced_textures: Dictionary = {}
var fauna_system: RefCounted
var atmosphere_vfx_system: RefCounted
var world_decorations_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tfaction_warfare_system = FactionWarfareSystemScript.new()'''
new_ready_end = '''\tfaction_warfare_system = FactionWarfareSystemScript.new()
\t
\t# 5.16. Тотальное Визуальное и Атмосферное Преображение
\tenhanced_textures = EnhancedArtGeneratorScript.generate_enhanced_textures()
\tfauna_system = FaunaSystem2DScript.new()
\tfauna_system.init_fauna()
\tatmosphere_vfx_system = AtmosphereVFXSystemScript.new()
\tatmosphere_vfx_system.init_vfx()
\tworld_decorations_system = WorldDecorationsSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Update in _process()
old_proc = '''\t_process_fishing(delta)'''
new_proc = '''\t_process_fishing(delta)
\tif fauna_system:
\t\tfauna_system.update_fauna(delta, player_pos)
\tif atmosphere_vfx_system:
\t\tvar is_night = (current_hour >= 20 or current_hour <= 5)
\t\tatmosphere_vfx_system.update_vfx(delta, is_night, [Vector2(20*48, 12*48), Vector2(28*48, 12*48)])
\tif world_decorations_system:
\t\tworld_decorations_system.update(delta)
\tqueue_redraw()'''
text = text.replace(old_proc, new_proc, 1)

# 4. Draw in _draw()
old_draw = '''\t_draw_player()'''
new_draw = '''\tif world_decorations_system:
\t\tworld_decorations_system.draw_decorations(self, enhanced_textures)
\tif fauna_system:
\t\tfauna_system.draw_fauna(self)
\tif atmosphere_vfx_system:
\t\tvar is_night = (current_hour >= 20 or current_hour <= 5)
\t\tatmosphere_vfx_system.draw_vfx(self, is_night)
\t_draw_player()'''
text = text.replace(old_draw, new_draw, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Visual & Atmosphere Overhaul integrated into GameWorld2D.gd!")
