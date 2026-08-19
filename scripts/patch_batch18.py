with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload CombatDepthSystem
old_preload = '''const CitizenMindSystem = preload("res://src/economy/CitizenMindSystem.gd")'''
new_preload = '''const CitizenMindSystem = preload("res://src/economy/CitizenMindSystem.gd")
const CombatDepthSystem = preload("res://src/character/CombatDepthSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Variables for injuries and medicine
old_vars = '''# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false'''

new_vars = '''# Боевая глубина: травмы, кровотечения и медицина
var bleeding_timer: float = 0.0
var arm_injury_timer: float = 0.0
var leg_injury_timer: float = 0.0
var bleed_tick_timer: float = 0.0
var regen_salve_timer: float = 0.0

# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false'''

text = text.replace(old_vars, new_vars, 1)

# 3. Update _physics_process for injury effects and timers
old_phys = '''\t\tif swiftness_timer > 0.0:
\t\t\tswiftness_timer -= delta
\t\t\tspeed *= 1.35'''

new_phys = '''\t\tif swiftness_timer > 0.0:
\t\t\tswiftness_timer -= delta
\t\t\tspeed *= 1.35
\t\tif leg_injury_timer > 0.0:
\t\t\tleg_injury_timer -= delta
\t\t\tspeed *= 0.60
\t\tif arm_injury_timer > 0.0:
\t\t\tarm_injury_timer -= delta
\t\tif bleeding_timer > 0.0:
\t\t\tbleeding_timer -= delta
\t\t\tbleed_tick_timer -= delta
\t\t\tif bleed_tick_timer <= 0.0:
\t\t\t\tbleed_tick_timer = 1.5
\t\t\t\tif p: p.hp = maxf(1.0, p.hp - 2.0)
\t\t\t\t_spawn_floating_text(player_pos, "🩸 -2 (Кровь)", Color(0.9, 0.2, 0.2), 14)
\t\t\t\t_spawn_spark_particles(player_pos, Color.DARK_RED)
\t\tif regen_salve_timer > 0.0:
\t\t\tregen_salve_timer -= delta
\t\t\tif p: p.hp = minf(p.max_hp, p.hp + 3.0 * delta)'''

text = text.replace(old_phys, new_phys, 1)

# 4. Handle bandage and herbal_salve in inventory item usage
old_item_use = '''\t\telif it_id == "mead":
\t\t\tif p: p.fatigue = maxf(0.0, p.fatigue - 50.0)
\t\t\t_log("[color=yellow]🍺 Медовуха сняла усталость на -50%![/color]")
\t\t\t_spawn_floating_text(player_pos, "🍺 БОДРОСТЬ! -50% Усталости", Color.YELLOW, 18)'''

new_item_use = '''\t\telif it_id == "mead":
\t\t\tif p: p.fatigue = maxf(0.0, p.fatigue - 50.0)
\t\t\t_log("[color=yellow]🍺 Медовуха сняла усталость на -50%![/color]")
\t\t\t_spawn_floating_text(player_pos, "🍺 БОДРОСТЬ! -50% Усталости", Color.YELLOW, 18)
\t\telif it_id == "bandage":
\t\t\tbleeding_timer = 0.0
\t\t\tarm_injury_timer = 0.0
\t\t\tleg_injury_timer = 0.0
\t\t\tif p: p.hp = minf(p.max_hp, p.hp + 20.0)
\t\t\t_log("[color=green][b]🩹 ПЕРЕВЯЗКА: Кровотечение остановлено, раны перевязаны (+20 HP)![/b][/color]")
\t\t\t_spawn_floating_text(player_pos, "🩹 ПЕРЕВЯЗКА! +20 HP", Color.GREEN, 18)
\t\t\t_spawn_spark_particles(player_pos, Color.GREEN)
\t\telif it_id == "herbal_salve":
\t\t\tleg_injury_timer = 0.0
\t\t\tregen_salve_timer = 10.0
\t\t\tif p: p.hp = minf(p.max_hp, p.hp + 15.0)
\t\t\t_log("[color=green]🧪 ТРАВЯНАЯ МАЗЬ: Боль снята, активирована регенерация на 10 сек![/color]")
\t\t\t_spawn_floating_text(player_pos, "🧪 РЕГЕНЕРАЦИЯ!", Color.GREEN, 18)
\t\t\t_spawn_spark_particles(player_pos, Color.GREEN)'''

text = text.replace(old_item_use, new_item_use, 1)

# 5. Add arm injury penalty to player attack damage
old_dmg_calc = '''\tvar dmg = p.get_attack_damage() if p else 15.0
\tif is_shield_blocking:'''

new_dmg_calc = '''\tvar dmg = p.get_attack_damage() if p else 15.0
\tif arm_injury_timer > 0.0:
\t\tdmg *= 0.65 # Травма руки снижает урон на 35%
\tif is_shield_blocking:'''

text = text.replace(old_dmg_calc, new_dmg_calc, 1)

# 6. Add injury trigger to _take_damage
old_take_dmg = '''\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar final_dmg = amount'''

new_take_dmg = '''\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar inj = CombatDepthSystem.check_injury_on_hit(amount, is_crit)
\tif inj.get("caused_bleeding", false) and bleeding_timer <= 0.0:
\t\tbleeding_timer = 15.0
\t\t_log("[color=red][b]🩸 КРОВОТЕЧЕНИЕ: Вы получили глубокую рану! Перевяжите рану бинтом [ I ]![/b][/color]")
\t\t_spawn_floating_text(player_pos, "🩸 КРОВОТЕЧЕНИЕ!", Color.RED, 18)
\tif inj.get("caused_arm_injury", false) and arm_injury_timer <= 0.0:
\t\tarm_injury_timer = 12.0
\t\t_log("[color=orange]🦾 ТРАВМА РУКИ: Сила удара снижена на -35%![/color]")
\t\t_spawn_floating_text(player_pos, "🦾 ТРАВМА РУКИ!", Color.ORANGE, 16)
\tif inj.get("caused_leg_injury", false) and leg_injury_timer <= 0.0:
\t\tleg_injury_timer = 12.0
\t\t_log("[color=salmon]🦵 ХРОМОТА: Скорость бега снижена на -40%![/color]")
\t\t_spawn_floating_text(player_pos, "🦵 ХРОМОТА!", Color.SALMON, 16)
\t
\tvar final_dmg = amount'''

text = text.replace(old_take_dmg, new_take_dmg, 1)

# 7. Add enemy shield block and panic in _hit_npc
old_hit_calc = '''\tvar actual_dmg = maxf(1.0, dmg - float(npc.get("defense", 0)))
\tnpc["hp"] = maxf(0.0, float(npc.get("hp", 100.0)) - actual_dmg)'''

new_hit_calc = '''\tvar block_res = CombatDepthSystem.check_enemy_shield_block(npc)
\tif block_res.get("blocked", false):
\t\tdmg *= (1.0 - block_res.get("dmg_reduction", 0.70))
\t\t_spawn_floating_text(npc_positions[idx], "🛡️ БЛОК! -70%", Color.CYAN, 16)
\t\t_spawn_spark_particles(npc_positions[idx], Color.WHITE)
\t\t
\tvar actual_dmg = maxf(1.0, dmg - float(npc.get("defense", 0)))
\tnpc["hp"] = maxf(0.0, float(npc.get("hp", 100.0)) - actual_dmg)
\t
\tif CombatDepthSystem.check_enemy_panic(npc):
\t\t_log("[color=yellow]😱 Враг «%s» впал в панику и обратился в бегство![/color]" % npc.get("name", "Бандит"))
\t\t_spawn_floating_text(npc_positions[idx], "😱 БЕГСТВО!", Color.YELLOW, 18)'''

text = text.replace(old_hit_calc, new_hit_calc, 1)

# 8. Add panic movement for enemies in NPC loop
old_npc_move = '''\t\t\t\t\t\tvar dir = (player_pos - cur_pos).normalized()
\t\t\t\t\t\tnpc_positions[i] += dir * float(npc.get("walk_speed", 50.0)) * delta'''

new_npc_move = '''\t\t\t\t\t\tif npc.get("is_panicked", false):
\t\t\t\t\t\t\tvar dir = -(player_pos - cur_pos).normalized()
\t\t\t\t\t\t\tnpc_positions[i] += dir * float(npc.get("walk_speed", 50.0)) * 1.35 * delta
\t\t\t\t\t\telse:
\t\t\t\t\t\t\tvar dir = (player_pos - cur_pos).normalized()
\t\t\t\t\t\t\tnpc_positions[i] += dir * float(npc.get("walk_speed", 50.0)) * delta'''

text = text.replace(old_npc_move, new_npc_move, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print('Successfully patched GameWorld2D.gd for Batch 18!')
