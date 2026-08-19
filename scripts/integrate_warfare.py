with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add Preloads and variables
old_vars = '''const WorldEventSystemScript = preload("res://src/world/WorldEventSystem.gd")'''
new_vars = '''const WorldEventSystemScript = preload("res://src/world/WorldEventSystem.gd")
const RaidSystemScript = preload("res://src/combat/RaidSystem.gd")
const AlarmBellSystemScript = preload("res://src/combat/AlarmBellSystem.gd")
const BanditCampSystemScript = preload("res://src/combat/BanditCampSystem.gd")

var raid_system: RefCounted
var alarm_bell_system: RefCounted
var bandit_camp_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tworld_event_system = WorldEventSystemScript.new()'''
new_ready_end = '''\tworld_event_system = WorldEventSystemScript.new()
\t
\t# 5.7. Военные системы и Оборона Поселения (Этап 2)
\traid_system = RaidSystemScript.new()
\talarm_bell_system = AlarmBellSystemScript.new()
\tbandit_camp_system = BanditCampSystemScript.new()
\tif world_map:
\t\tbandit_camp_system.spawn_camp_structures(world_map)'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add Alarm Bell interaction handler in _input or interaction handling
old_bell_interaction = '''\t\t\t\telif nd["type"] == "alarm_bell":'''
# Let's check what nd["type"] == "alarm_bell" does
if 'elif nd["type"] == "alarm_bell":' in text:
    old_bell_block = '''\t\t\t\telif nd["type"] == "alarm_bell":
\t\t\t\t\t_ring_alarm_bell()'''
    new_bell_block = '''\t\t\t\telif nd["type"] == "alarm_bell":
\t\t\t\t\t_ring_alarm_bell()'''
else:
    # Add helper method _ring_alarm_bell()
    pass

helpers = '''
# =========================================================
# ВОЕННЫЕ СИСТЕМЫ, ТРЕВОЖНЫЙ КОЛОКОЛ И РЕЙДЫ
# =========================================================
func _ring_alarm_bell() -> void:
	if not alarm_bell_system: return
	var res = alarm_bell_system.ring_bell(npc_data)
	var col = "red" if res["active"] else "green"
	_log("[color=%s]%s[/color]" % [col, res["msg"]])
	
func _trigger_bandit_raid() -> void:
	if not raid_system: return
	var raid_info = raid_system.start_raid(Vector2i(6, 6))
	_log("[color=red]%s[/color]" % raid_info["message"])
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Warfare and Settlement Defense systems integrated into GameWorld2D.gd!")
