# 1. Update GameWorld2D.gd
with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# Add AtmosphereParticles2D variable
old_vars = '''var day_night_modulate: CanvasModulate'''
new_vars = '''var day_night_modulate: CanvasModulate
var atmosphere_particles: AtmosphereParticles2D'''
text = text.replace(old_vars, new_vars, 1)

# Add particles to _ready()
old_ready_lights = '''\t_spawn_environmental_lights()'''
new_ready_lights = '''\t_spawn_environmental_lights()
\t
\t# 5.5. Атмосферные частицы (листья, светлячки, искры)
\tatmosphere_particles = AtmosphereParticles2D.new()
\tatmosphere_particles.name = "AtmosphereParticles"
\tadd_child(atmosphere_particles)'''
text = text.replace(old_ready_lights, new_ready_lights, 1)

# Update day/night modulate calculation in _update_day_night()
old_day_night = '''func _update_day_night_cycle(hour: int, minute: int) -> void:
\tif not day_night_modulate: return
\t
\tvar col = DayNightSystem.get_modulate_color(hour, minute)
\tday_night_modulate.color = col'''

new_day_night = '''func _update_day_night_cycle(hour: int, minute: int) -> void:
\tif not day_night_modulate: return
\t
\tvar col = DayNightSystem.get_modulate_color(hour, minute)
\tday_night_modulate.color = col
\t
\tif atmosphere_particles:
\t\tatmosphere_particles.update_time_of_day(hour)'''

text = text.replace(old_day_night, new_day_night, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("GameWorld2D.gd updated with atmospheric particle effects!")
