with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload InteriorSystem
old_preload = '''const CombatDepthSystem = preload("res://src/character/CombatDepthSystem.gd")'''
new_preload = '''const CombatDepthSystem = preload("res://src/character/CombatDepthSystem.gd")
const InteriorSystem = preload("res://src/economy/InteriorSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Add furniture and stone wall to build_catalog
old_build_cat = '''\t{"id": "shipyard", "name": "⛵ Морская Верфь (Судостроение)", "cost": {"wood": 12, "plank": 8, "iron_ingot": 4}, "desc": "Верфь для постройки кораблей [E], морского промысла и отплытия на Забытые Острова."}
]'''

new_build_cat = '''\t{"id": "shipyard", "name": "⛵ Морская Верфь (Судостроение)", "cost": {"wood": 12, "plank": 8, "iron_ingot": 4}, "desc": "Верфь для постройки кораблей [E], морского промысла и отплытия на Забытые Острова."},
\t{"id": "wall_stone", "name": "🧱 Каменная Стена (Tier 2)", "cost": {"stone": 4}, "desc": "Прочная фортификация из тесаного камня с повышенной защитой."},
\t{"id": "chair_oak", "name": "🪑 Дубовый Стул", "cost": {"plank": 2}, "desc": "Удобный стул для жилых покоев (+10 к комфорту дома)."},
\t{"id": "table_oak", "name": "🪵 Обеденный Стол", "cost": {"plank": 4}, "desc": "Массивный деревянный стол (+15 к комфорту дома)."},
\t{"id": "fireplace", "name": "🔥 Каменный Камин", "cost": {"stone": 4, "wood": 2}, "desc": "Камин для тепла и мягкого света по ночам (+20 к комфорту дома)."},
\t{"id": "candle_stand", "name": "🕯️ Восковой Подсвечник", "cost": {"beeswax": 2, "iron_ingot": 1}, "desc": "Светильник из кованого железа и воска (+10 к комфорту дома)."},
\t{"id": "rug_wolf", "name": "🐺 Ковер из Шкуры Волка", "cost": {"pelt_wolf": 2}, "desc": "Роскошный волчий ковер для знатных покоев (+15 к комфорту дома)."}
]'''

text = text.replace(old_build_cat, new_build_cat, 1)

# 3. Update Tab 1 in _refresh_settlement_window to include room comfort
old_tab1_eval = '''\t\t\tvar t_def = CitizenMindSystem.TRAITS.get(trait_id, CitizenMindSystem.TRAITS["workaholic"])
\t\t\tvar m_data = CitizenMindSystem.calculate_citizen_mood(sel_c, p, total_beds)'''

new_tab1_eval = '''\t\t\tvar t_def = CitizenMindSystem.TRAITS.get(trait_id, CitizenMindSystem.TRAITS["workaholic"])
\t\t\tvar home_b = sel_c.get("home_tile", Vector2i(25, 25))
\t\t\tvar c_data = InteriorSystem.evaluate_room_comfort(home_b, world_map)
\t\t\tvar m_data = CitizenMindSystem.calculate_citizen_mood(sel_c, p, total_beds, c_data)'''

text = text.replace(old_tab1_eval, new_tab1_eval, 1)

# 4. Include comfort in citizen info text
old_info_text = '''[b]Характер:[/b] %s [b]%s[/b] — [color=gray]%s[/color]
[b]Настроение:[/b] [color=gold]%.0f%%[/color] — [b]%s[/b]'''

new_info_text = '''[b]Характер:[/b] %s [b]%s[/b] — [color=gray]%s[/color]
[b]Уют Покоев:[/b] [color=cyan]%s[/color] (Очки уюта: %d)
[b]Настроение:[/b] [color=gold]%.0f%%[/color] — [b]%s[/b]'''

text = text.replace(old_info_text, new_info_text, 1)

# 5. Add c_data args into format list
old_fmt_args = '''\t\t\t\tprof_icon, sel_c.get("name", "Житель"),
\t\t\t\tprof_name,
\t\t\t\tt_def.get("icon", "🎭"), t_def.get("name", "Трудоголик"), t_def.get("desc", ""),
\t\t\t\tm_data.get("mood", 70.0), m_data.get("status_text", "Норма"),'''

new_fmt_args = '''\t\t\t\tprof_icon, sel_c.get("name", "Житель"),
\t\t\t\tprof_name,
\t\t\t\tt_def.get("icon", "🎭"), t_def.get("name", "Трудоголик"), t_def.get("desc", ""),
\t\t\t\tc_data.get("name", "Простая Лачуга"), c_data.get("score", 0),
\t\t\t\tm_data.get("mood", 70.0), m_data.get("status_text", "Норма"),'''

text = text.replace(old_fmt_args, new_fmt_args, 1)

# 6. Add wall repair interaction in _handle_interaction_key
old_interact_end = '''\t\t\t\telif nd["type"] == "shipyard":
\t\t\t\t\t_open_shipyard_modal()
\t\t\t\t\treturn'''

new_interact_end = '''\t\t\t\telif nd["type"] == "shipyard":
\t\t\t\t\t_open_shipyard_modal()
\t\t\t\t\treturn
\t\t\t\telif nd["type"] in ["wooden_fence", "wall_wood", "wall_stone"]:
\t\t\t\t\t_repair_structure(t_pos, nd["type"])
\t\t\t\t\treturn'''

text = text.replace(old_interact_end, new_interact_end, 1)

# 7. Append _repair_structure function
repair_func = '''

func _repair_structure(t_pos: Vector2i, type_name: String) -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tif p.get_item_count("plank") < 1 and p.get_item_count("wood") < 1 and p.get_item_count("stone") < 1:
\t\t_log("[color=orange]🔨 Для починки и укрепления структуры нужна 1 доска или камень.[/color]")
\t\t_spawn_floating_text(player_pos, "НУЖНЫ МАТЕРИАЛЫ 🪵", Color.ORANGE, 16)
\t\treturn
\t\t
\tif p.get_item_count("plank") >= 1:
\t\tp.remove_item("plank", 1)
\telif p.get_item_count("wood") >= 1:
\t\tp.remove_item("wood", 1)
\telse:
\t\tp.remove_item("stone", 1)
\t\t
\tp.add_skill_xp("crafting", 25.0)
\t_log("[color=green][b]🔨 РЕМОНТ: Укрепление «%s» успешно отремонтировано и укреплено![/b][/color]" % type_name)
\t_spawn_spark_particles(Vector2(t_pos.x * TILE_SIZE + TILE_SIZE/2.0, t_pos.y * TILE_SIZE + TILE_SIZE/2.0), Color.GREEN)
\t_spawn_floating_text(Vector2(t_pos.x * TILE_SIZE + TILE_SIZE/2.0, t_pos.y * TILE_SIZE + TILE_SIZE/2.0), "🔨 ОТРЕМОНТИРОВАНО!", Color.GREEN, 18)
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + repair_func)

print('Successfully patched GameWorld2D.gd for Batch 19!')
