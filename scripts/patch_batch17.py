with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload CitizenMindSystem
old_preload = '''const NavalSystem = preload("res://src/economy/NavalSystem.gd")'''
new_preload = '''const NavalSystem = preload("res://src/economy/NavalSystem.gd")
const CitizenMindSystem = preload("res://src/economy/CitizenMindSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Add Feast button variable in GameWorld2D
old_vars = '''var settlement_dismiss_btn: Button'''
new_vars = '''var settlement_dismiss_btn: Button
var settlement_feast_btn: Button'''

text = text.replace(old_vars, new_vars, 1)

# 3. Add Feast button to Town Hall modal UI in _build_settlement_modal
old_btn_build = '''\tsettlement_dismiss_btn = Button.new()
\tsettlement_dismiss_btn.text = "❌ Выгнать"
\t_style_button(settlement_dismiss_btn)
\tsettlement_dismiss_btn.pressed.connect(_dismiss_selected_citizen)
\tact_h.add_child(settlement_dismiss_btn)'''

new_btn_build = '''\tsettlement_dismiss_btn = Button.new()
\tsettlement_dismiss_btn.text = "❌ Выгнать"
\t_style_button(settlement_dismiss_btn)
\tsettlement_dismiss_btn.pressed.connect(_dismiss_selected_citizen)
\tact_h.add_child(settlement_dismiss_btn)
\t
\tsettlement_feast_btn = Button.new()
\tsettlement_feast_btn.text = "🍖 Закатить Городской Пир"
\t_style_button(settlement_feast_btn)
\tsettlement_feast_btn.pressed.connect(_on_host_feast_pressed)
\tact_h.add_child(settlement_feast_btn)'''

text = text.replace(old_btn_build, new_btn_build, 1)

# 4. Enhance Tab 1 citizen details in _refresh_settlement_modal
old_tab1 = '''\t\tvar citizens: Array = p.settlement.get("citizens", [])
\t\tvar sel_c = null
\t\tfor c in citizens:
\t\t\tvar prof_name = SettlementDatabase.CITIZEN_PROFESSIONS.get(c.get("role", "farmer"), {}).get("name", "Житель")
\t\t\tvar prof_icon = SettlementDatabase.CITIZEN_PROFESSIONS.get(c.get("role", "farmer"), {}).get("icon", "👨‍🌾")
\t\t\tsettlement_list.add_item("%s %s (%s) — %d з." % [prof_icon, c.get("name", "Житель"), prof_name, c.get("gold", 0)])
\t\t\tsettlement_list.set_item_metadata(settlement_list.get_item_count() - 1, c.get("id", ""))
\t\t\tif c.get("id", "") == selected_citizen_id:
\t\t\t\tsel_c = c
\t\t\t\t
\t\tif sel_c:
\t\t\tvar prof_name = SettlementDatabase.CITIZEN_PROFESSIONS.get(sel_c.get("role", "farmer"), {}).get("name", "Житель")
\t\t\tvar prof_icon = SettlementDatabase.CITIZEN_PROFESSIONS.get(sel_c.get("role", "farmer"), {}).get("icon", "👨‍🌾")
\t\t\tsettlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Профессия:[/b] %s
[b]Личный кошелек:[/b] [color=gold]%d золотых[/color]
[b]Уровень сытости:[/b] %.0f%%
[b]Здоровье:[/b] %.0f / %.0f HP

[color=lightblue]💡 Физический труд и лавки:[/color]
Житель автоматически работает в мире, продает товары в личной лавке [E] и платит утренний налог в казну!
""" % [
\t\t\t\tprof_icon, sel_c.get("name", "Житель"),
\t\t\t\tprof_name,
\t\t\t\tsel_c.get("gold", 0),
\t\t\t\tsel_c.get("hunger", 100.0),
\t\t\t\tsel_c.get("hp", 75.0), sel_c.get("max_hp", 75.0)
\t\t\t]
\t\t\tsettlement_action_btn.visible = true
\t\t\tsettlement_action_btn.text = "🔄 Сменить профессию"
\t\t\tsettlement_dismiss_btn.visible = true
\t\telse:
\t\t\tsettlement_info_label.text = "Выберите жителя из списка слева, чтобы посмотреть его параметры, настроение или сменить профессию."
\t\t\tsettlement_action_btn.visible = false
\t\t\tsettlement_dismiss_btn.visible = false'''

new_tab1 = '''\t\tvar citizens: Array = p.settlement.get("citizens", [])
\t\tvar total_beds = _count_settlement_beds()
\t\tvar sel_c = null
\t\tfor c in citizens:
\t\t\tvar prof_name = SettlementDatabase.CITIZEN_PROFESSIONS.get(c.get("role", "farmer"), {}).get("name", "Житель")
\t\t\tvar prof_icon = SettlementDatabase.CITIZEN_PROFESSIONS.get(c.get("role", "farmer"), {}).get("icon", "👨‍🌾")
\t\t\tvar m_data = CitizenMindSystem.calculate_citizen_mood(c, p, total_beds)
\t\t\tvar mood_icon = "😊" if m_data["mood"] >= 85.0 else ("👿" if m_data["mood"] < 30.0 else "😐")
\t\t\tsettlement_list.add_item("%s %s %s (%s)" % [mood_icon, prof_icon, c.get("name", "Житель"), prof_name])
\t\t\tsettlement_list.set_item_metadata(settlement_list.get_item_count() - 1, c.get("id", ""))
\t\t\tif c.get("id", "") == selected_citizen_id:
\t\t\t\tsel_c = c
\t\t\t\t
\t\tif sel_c:
\t\t\tvar prof_name = SettlementDatabase.CITIZEN_PROFESSIONS.get(sel_c.get("role", "farmer"), {}).get("name", "Житель")
\t\t\tvar prof_icon = SettlementDatabase.CITIZEN_PROFESSIONS.get(sel_c.get("role", "farmer"), {}).get("icon", "👨‍🌾")
\t\t\tvar trait_id = sel_c.get("trait", "workaholic")
\t\t\tvar t_def = CitizenMindSystem.TRAITS.get(trait_id, CitizenMindSystem.TRAITS["workaholic"])
\t\t\tvar m_data = CitizenMindSystem.calculate_citizen_mood(sel_c, p, total_beds)
\t\t\t
\t\t\tvar thoughts_str = ""
\t\t\tfor th in m_data.get("thoughts", []):
\t\t\t\tthoughts_str += " • " + th + "\\n"
\t\t\t\t
\t\t\tsettlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Профессия:[/b] %s
[b]Характер:[/b] %s [b]%s[/b] — [color=gray]%s[/color]
[b]Настроение:[/b] [color=gold]%.0f%%[/color] — [b]%s[/b]
[b]Личный кошелек:[/b] [color=gold]%d золотых[/color]
[b]Сытость:[/b] %.0f%% | [b]HP:[/b] %.0f / %.0f

[b]🧠 Мысли жителя:[/b]
%s
""" % [
\t\t\t\tprof_icon, sel_c.get("name", "Житель"),
\t\t\t\tprof_name,
\t\t\t\tt_def.get("icon", "🎭"), t_def.get("name", "Трудоголик"), t_def.get("desc", ""),
\t\t\t\tm_data.get("mood", 70.0), m_data.get("status_text", "Норма"),
\t\t\t\tsel_c.get("gold", 0),
\t\t\t\tsel_c.get("hunger", 100.0),
\t\t\t\tsel_c.get("hp", 75.0), sel_c.get("max_hp", 75.0),
\t\t\t\tthoughts_str
\t\t\t]
\t\t\tsettlement_action_btn.visible = true
\t\t\tsettlement_action_btn.text = "🔄 Сменить профессию"
\t\t\tsettlement_dismiss_btn.visible = true
\t\t\tsettlement_feast_btn.visible = true
\t\telse:
\t\t\tsettlement_info_label.text = "Выберите жителя из списка слева, чтобы посмотреть его параметры, настроение или сменить профессию."
\t\t\tsettlement_action_btn.visible = false
\t\t\tsettlement_dismiss_btn.visible = false
\t\t\tsettlement_feast_btn.visible = true'''

text = text.replace(old_tab1, new_tab1, 1)

# 5. Add feast button handler and trait assignment
feast_handler_code = '''

func _on_host_feast_pressed() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar res = SettlementManager.host_feast(p)
\tif res.get("success", false):
\t\t_log("[color=gold][b]🍖 ПИР ПОСЕЛЕНИЯ: %s[/b][/color]" % res.get("message", ""))
\t\t_spawn_spark_particles(player_pos, Color.GOLD)
\t\t_spawn_floating_text(player_pos, "🍖 КОРОЛЕВСКИЙ ПИР! (100% MOOD)", Color.GOLD, 22)
\t\t_refresh_settlement_modal()
\telse:
\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка"))
'''

# 6. Pass hour and mood to ColonistAISystem in _process_citizens
old_colonist_step = '''\t\t\tvar res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile)'''
new_colonist_step = '''\t\t\tvar cur_hour = gm.game_hour if gm else 12
\t\t\tvar total_b = _count_settlement_beds()
\t\t\tvar m_data = CitizenMindSystem.calculate_citizen_mood(npc, p, total_b)
\t\t\tvar res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile, cur_hour, m_data)'''

text = text.replace(old_colonist_step, new_colonist_step, 1)

# 7. Update _check_settler_migration to assign traits
old_migration = '''\t\tvar new_citizen = {
\t\t\t"id": "citizen_%d" % Time.get_ticks_msec(),
\t\t\t"name": "Поселенец %s" % ["Ханс", "Бьорн", "Эрик", "Анна", "Хельга", "Гуннар"][randi() % 6],
\t\t\t"role": "farmer",
\t\t\t"gold": 10,
\t\t\t"hp": 75.0,
\t\t\t"max_hp": 75.0,
\t\t\t"hunger": 95.0
\t\t}'''

new_migration = '''\t\tvar traits_list = CitizenMindSystem.TRAITS.keys()
\t\tvar rand_trait = traits_list[randi() % traits_list.size()]
\t\tvar new_citizen = {
\t\t\t"id": "citizen_%d" % Time.get_ticks_msec(),
\t\t\t"name": "Поселенец %s" % ["Ханс", "Бьорн", "Эрик", "Анна", "Хельга", "Гуннар"][randi() % 6],
\t\t\t"role": "farmer",
\t\t\t"trait": rand_trait,
\t\t\t"gold": 10,
\t\t\t"hp": 75.0,
\t\t\t"max_hp": 75.0,
\t\t\t"hunger": 95.0,
\t\t\t"drank_ale_today": false
\t\t}'''

text = text.replace(old_migration, new_migration, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + feast_handler_code)

print('Successfully patched GameWorld2D.gd for Batch 17!')
