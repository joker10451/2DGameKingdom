with open('godot/src/game2d/GameWorld2D.gd', 'rb') as f:
    raw = f.read()

text = raw.decode('utf-8', errors='replace')

# 1. Update tab buttons in _build_settlement_modal
old_tab_proj = '''\ttab_bar.add_child(tab_proj_btn)'''
new_tab_proj = '''\ttab_bar.add_child(tab_proj_btn)
\t
\tvar tab_garrison_btn = Button.new()
\ttab_garrison_btn.text = "🛡️ Гарнизон и Стража"
\t_style_button(tab_garrison_btn)
\ttab_garrison_btn.pressed.connect(func():
\t\tsettlement_tab_idx = 4
\t\t_refresh_settlement_window()
\t)
\ttab_bar.add_child(tab_garrison_btn)'''

text = text.replace(old_tab_proj, new_tab_proj, 1)

# 2. Update action buttons in _build_settlement_modal
old_act_end = '''\tact_h.add_child(settlement_action_btn)'''
new_act_end = '''\tact_h.add_child(settlement_action_btn)
\t
\tsettlement_recruit_militia_btn = Button.new()
\tsettlement_recruit_militia_btn.text = "🗡️ Нанять Ополченца (15 з.)"
\t_style_button(settlement_recruit_militia_btn)
\tsettlement_recruit_militia_btn.pressed.connect(func():
\t\tvar gm = _get_game_manager()
\t\tvar p: CharacterData = gm.player_data if gm else null
\t\tif p:
\t\t\tvar res = GarrisonManager.recruit_unit(p, "militia")
\t\t\tif res.get("success", false):
\t\t\t\t_log("[color=green]🛡️ Вы наняли в гарнизон бойца: %s![/color]" % res.get("name", ""))
\t\t\t\t_spawn_spark_particles(player_pos, Color.GREEN)
\t\t\t\t_refresh_settlement_window()
\t\t\telse:
\t\t\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка найма"))
\t)
\tact_h.add_child(settlement_recruit_militia_btn)
\t
\tsettlement_recruit_archer_btn = Button.new()
\tsettlement_recruit_archer_btn.text = "🏹 Нанять Лучника (25 з.)"
\t_style_button(settlement_recruit_archer_btn)
\tsettlement_recruit_archer_btn.pressed.connect(func():
\t\tvar gm = _get_game_manager()
\t\tvar p: CharacterData = gm.player_data if gm else null
\t\tif p:
\t\t\tvar res = GarrisonManager.recruit_unit(p, "archer")
\t\t\tif res.get("success", false):
\t\t\t\t_log("[color=green]🏹 Вы наняли в гарнизон лучника: %s![/color]" % res.get("name", ""))
\t\t\t\t_spawn_spark_particles(player_pos, Color.GREEN)
\t\t\t\t_refresh_settlement_window()
\t\t\telse:
\t\t\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка найма"))
\t)
\tact_h.add_child(settlement_recruit_archer_btn)
\t
\tsettlement_recruit_knight_btn = Button.new()
\tsettlement_recruit_knight_btn.text = "🛡️ Нанять Латника (45 з.)"
\t_style_button(settlement_recruit_knight_btn)
\tsettlement_recruit_knight_btn.pressed.connect(func():
\t\tvar gm = _get_game_manager()
\t\tvar p: CharacterData = gm.player_data if gm else null
\t\tif p:
\t\t\tvar res = GarrisonManager.recruit_unit(p, "man_at_arms")
\t\t\tif res.get("success", false):
\t\t\t\t_log("[color=gold]🛡️ Вы наняли в гарнизон рыцарского латника: %s![/color]" % res.get("name", ""))
\t\t\t\t_spawn_spark_particles(player_pos, Color.GOLD)
\t\t\t\t_refresh_settlement_window()
\t\t\telse:
\t\t\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка найма"))
\t)
\tact_h.add_child(settlement_recruit_knight_btn)
\t
\tsettlement_dismiss_btn = Button.new()
\tsettlement_dismiss_btn.text = "✖ Распустить"
\t_style_button(settlement_dismiss_btn)
\tsettlement_dismiss_btn.pressed.connect(func():
\t\tvar gm = _get_game_manager()
\t\tvar p: CharacterData = gm.player_data if gm else null
\t\tif p and selected_garrison_idx >= 0:
\t\t\tif GarrisonManager.dismiss_unit(p, selected_garrison_idx):
\t\t\t\t_log("[color=orange]Стражник распущен из городского гарнизона.[/color]")
\t\t\t\tselected_garrison_idx = -1
\t\t\t\t_refresh_settlement_window()
\t)
\tact_h.add_child(settlement_dismiss_btn)'''

text = text.replace(old_act_end, new_act_end, 1)

# 3. Update _refresh_settlement_window for tab 4 (Garrison)
old_not_has_town = '''\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false'''

new_not_has_town = '''\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false
\t\tsettlement_recruit_militia_btn.visible = false
\t\tsettlement_recruit_archer_btn.visible = false
\t\tsettlement_recruit_knight_btn.visible = false
\t\tsettlement_dismiss_btn.visible = false'''

text = text.replace(old_not_has_town, new_not_has_town, 1)

# Tab 0 visibility
old_tab_0 = '''\tif settlement_tab_idx == 0:
\t\t# Обзор
\t\tsettlement_withdraw_btn.visible = true
\t\tsettlement_tax_btn.visible = true
\t\tsettlement_action_btn.visible = false'''

new_tab_0 = '''\tif settlement_tab_idx == 0:
\t\t# Обзор
\t\tsettlement_withdraw_btn.visible = true
\t\tsettlement_tax_btn.visible = true
\t\tsettlement_action_btn.visible = false
\t\tsettlement_recruit_militia_btn.visible = false
\t\tsettlement_recruit_archer_btn.visible = false
\t\tsettlement_recruit_knight_btn.visible = false
\t\tsettlement_dismiss_btn.visible = false'''

text = text.replace(old_tab_0, new_tab_0, 1)

# Tab 1 visibility
old_tab_1 = '''\telif settlement_tab_idx == 1:
\t\t# Граждане
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false'''

new_tab_1 = '''\telif settlement_tab_idx == 1:
\t\t# Граждане
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false
\t\tsettlement_recruit_militia_btn.visible = false
\t\tsettlement_recruit_archer_btn.visible = false
\t\tsettlement_recruit_knight_btn.visible = false
\t\tsettlement_dismiss_btn.visible = false'''

text = text.replace(old_tab_1, new_tab_1, 1)

# Tab 2 visibility
old_tab_2 = '''\telif settlement_tab_idx == 2:
\t\t# Законы и налоги
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false'''

new_tab_2 = '''\telif settlement_tab_idx == 2:
\t\t# Законы и налоги
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false
\t\tsettlement_recruit_militia_btn.visible = false
\t\tsettlement_recruit_archer_btn.visible = false
\t\tsettlement_recruit_knight_btn.visible = false
\t\tsettlement_dismiss_btn.visible = false'''

text = text.replace(old_tab_2, new_tab_2, 1)

# Tab 3 visibility
old_tab_3 = '''\telif settlement_tab_idx == 3:
\t\t# Проекты строительства
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = true'''

new_tab_3 = '''\telif settlement_tab_idx == 3:
\t\t# Проекты строительства
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = true
\t\tsettlement_recruit_militia_btn.visible = false
\t\tsettlement_recruit_archer_btn.visible = false
\t\tsettlement_recruit_knight_btn.visible = false
\t\tsettlement_dismiss_btn.visible = false'''

text = text.replace(old_tab_3, new_tab_3, 1)

# Add Tab 4 (Garrison) handling right after Tab 3
old_after_tab_3 = '''\t\tsettlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Необходимые материалы:[/b] %s
[b]Вместимость:[/b] +%d спальных мест

[color=lightgray]%s[/color]

[color=gold]Нажмите кнопку «🏗️ Заказать постройку», чтобы возвести этот проект![/color]
""" % [
			pr.get("icon", "🔨"), pr.get("name", ""),
			cost_str,
			pr.get("bed_yield", 0),
			pr.get("desc", "")
		]'''

new_after_tab_3 = '''\t\tsettlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Необходимые материалы:[/b] %s
[b]Вместимость:[/b] +%d спальных мест

[color=lightgray]%s[/color]

[color=gold]Нажмите кнопку «🏗️ Заказать постройку», чтобы возвести этот проект![/color]
""" % [
			pr.get("icon", "🔨"), pr.get("name", ""),
			cost_str,
			pr.get("bed_yield", 0),
			pr.get("desc", "")
		]

\telif settlement_tab_idx == 4:
\t\t# Гарнизон и Стража
\t\tsettlement_withdraw_btn.visible = false
\t\tsettlement_tax_btn.visible = false
\t\tsettlement_action_btn.visible = false
\t\tsettlement_recruit_militia_btn.visible = true
\t\tsettlement_recruit_archer_btn.visible = true
\t\tsettlement_recruit_knight_btn.visible = true
\t\tsettlement_dismiss_btn.visible = true
\t\t
\t\tvar garrison = GarrisonManager.get_garrison_units(p)
\t\tvar total_wages = GarrisonManager.calculate_daily_wages(p)
\t\tvar garrison_pwr = GarrisonManager.get_garrison_power(p)
\t\t
\t\tif garrison.size() == 0:
\t\t\tsettlement_list.add_item("🛡️ Гарнизон пуст (Наймите стражу)")
\t\t\tsettlement_info_label.text = """[b][font_size=18]🛡️ Городской Гарнизон и Стража Поселения[/font_size][/b]
В поселении пока нет регулярной стражи.

[b]Казна поселения:[/b] [color=gold]%d золотых[/color]
[b]Суточное содержание гарнизона:[/b] 0 з./день (списание в 08:00)

Наймите бойцов с помощью кнопок снизу:
 • 🗡️ [b]Ополченец[/b] (15 з., жалование 2 з./день)
 • 🏹 [b]Лучник[/b] (25 з., жалование 3 з./день)
 • 🛡️ [b]Ветеран-Латник[/b] (45 з., жалование 5 з./день)

Стража защищает город от набегов и отправляется с вами на [b]Осаду Разбойничьих Фортов[/b] на карте континента [M]!""" % treasury
\t\telse:
\t\t\tfor i in range(garrison.size()):
\t\t\t\tvar s = garrison[i]
\t\t\t\tvar u_def = GarrisonManager.UNIT_TYPES.get(s.get("unit_type", "militia"), {})
\t\t\t\tsettlement_list.add_item("%s %s (Жалование: %d з.)" % [u_def.get("icon", "🛡️"), s.get("name", "Стражник"), s.get("wage", 2)])
\t\t\t\tsettlement_list.set_item_metadata(settlement_list.get_item_count() - 1, i)
\t\t\t\t
\t\t\tif selected_garrison_idx >= 0 and selected_garrison_idx < garrison.size():
\t\t\t\tvar s = garrison[selected_garrison_idx]
\t\t\t\tvar u_def = GarrisonManager.UNIT_TYPES.get(s.get("unit_type", "militia"), {})
\t\t\t\tsettlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Здоровье (HP):[/b] %.0f / %.0f
[b]Защита (DEF):[/b] %d
[b]Тип атаки:[/b] %s
[b]Суточное жалование:[/b] [color=gold]%d золотых/день[/color]

[color=lightgray]%s[/color]

[b]Общая военная мощь гарнизона:[/b] [color=orange]%d очков[/color]
[b]Суточные расходы на армию:[/b] [color=gold]%d золотых/день[/color] (из казны города)
""" % [
					u_def.get("icon", "🛡️"), s.get("name", ""),
					s.get("hp", 75.0), s.get("max_hp", 75.0),
					s.get("defense", 6),
					"Дальний бой (Лук)" if s.get("is_ranged", false) else "Ближний бой (Меч и Щит)",
					s.get("wage", 2),
					u_def.get("desc", ""),
					garrison_pwr,
					total_wages
				]
\t\t\telse:
\t\t\t\tsettlement_info_label.text = """[b][font_size=18]🛡️ Гарнизон: %d бойцов[/font_size][/b]
[b]Военная мощь поселения:[/b] [color=orange]%d очков[/color]
[b]Суточные расходы на стражу:[/b] [color=gold]%d золотых/день[/color] (списание из казны в 08:00)

Выберите бойца в списке слева для просмотра параметров или наймите новых защитников!""" % [garrison.size(), garrison_pwr, total_wages]'''

text = text.replace(old_after_tab_3, new_after_tab_3, 1)

# Update _on_settlement_item_selected for tab 4
old_item_sel = '''\telif settlement_tab_idx == 3:
\t\tvar pr_id = settlement_list.get_item_metadata(idx)
\t\tif pr_id:
\t\t\tselected_project_id = pr_id
\t\t\t_refresh_settlement_window()'''

new_item_sel = '''\telif settlement_tab_idx == 3:
\t\tvar pr_id = settlement_list.get_item_metadata(idx)
\t\tif pr_id:
\t\t\tselected_project_id = pr_id
\t\t\t_refresh_settlement_window()
\telif settlement_tab_idx == 4:
\t\tvar g_idx = settlement_list.get_item_metadata(idx)
\t\tif g_idx != null:
\t\t\tselected_garrison_idx = int(g_idx)
\t\t\t_refresh_settlement_window()'''

text = text.replace(old_item_sel, new_item_sel, 1)

# Add Fort Siege System functions at the end
siege_code = '''

# =========================================================
# ОСАДА РАЗБОЙНИЧЬИХ ФОРТОВ И ВОЙНА ЗА ТЕРРИТОРИИ 🏰⚔️🚩
# =========================================================
func _start_fort_siege(fort_id: String) -> void:
	_close_all_modals()
	if is_overworld_mode:
		_toggle_overworld_map()
		
	is_fort_siege_active = true
	active_siege_fort_id = fort_id
	siege_enemies.clear()
	
	var fort_info = {
		"name": "Чернолесный Форт",
		"enemy_count": 8,
		"gold_reward": 180,
		"captives": 2,
		"has_boss": false
	}
	
	if fort_id == "fort_red_gorge":
		fort_info = {
			"name": "Крепость Красного Ущелья",
			"enemy_count": 12,
			"gold_reward": 320,
			"captives": 3,
			"has_boss": true
		}
	elif fort_id == "fort_smugglers":
		fort_info = {
			"name": "Лагерь Контрабандистов",
			"enemy_count": 5,
			"gold_reward": 120,
			"captives": 2,
			"has_boss": false
		}
		
	_log("[color=red][b]⚔️ НАЧАЛАСЬ ОСАДА: «%s»![/b][/color]" % fort_info["name"])
	_log("[color=gold]Ваша дружина и городской гарнизон идут на штурм укреплений разбойников![/color]")
	_spawn_spark_particles(player_pos, Color.RED)
	_spawn_floating_text(player_pos, "⚔️ ШТУРМ: " + fort_info["name"].to_upper(), Color.RED, 22)
	
	# Размещаем частоколы и ворота форта на севере карты
	for x in range(18, 30):
		world_map.structure_tiles[Vector2i(x, 10)] = "wall_wood"
		world_map.structure_tiles[Vector2i(x, 18)] = "wall_wood"
	for y in range(10, 19):
		world_map.structure_tiles[Vector2i(18, y)] = "wall_wood"
		world_map.structure_tiles[Vector2i(29, y)] = "wall_wood"
		
	# Открытый проход ворот
	world_map.structure_tiles.erase(Vector2i(23, 18))
	world_map.structure_tiles.erase(Vector2i(24, 18))
	world_map.queue_redraw()
	
	# Спавним врагов форта
	for e_i in range(fort_info["enemy_count"]):
		var sp = Vector2i(randi_range(19, 28), randi_range(11, 16))
		var w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)
		var is_b = (fort_info.get("has_boss", false) and e_i == 0)
		var is_rng = (e_i % 2 == 1)
		
		var npc_entry = {
			"id": "fort_enemy_%d" % e_i,
			"name": ("Атаман Гримвульф" if is_b else ("Разбойник-Снайпер" if is_rng else "Головорез Форта")),
			"role": "Бандит",
			"hp": (300.0 if is_b else 80.0),
			"max_hp": (300.0 if is_b else 80.0),
			"defense": (14 if is_b else 8),
			"gold": (50 if is_b else 12),
			"home_tile": sp,
			"target_pos": player_pos,
			"idle_timer": 0.0,
			"walk_speed": 50.0,
			"is_dead": false,
			"is_hostile": true,
			"is_ranged": is_rng,
			"shoot_cooldown": randf_range(1.5, 3.0),
			"is_boss": is_b,
			"traits": ["Жестокий", "Защитник Форта"]
		}
		
		npc_data.append(npc_entry)
		npc_positions.append(w_pos)
		var n_idx = npc_data.size() - 1
		siege_enemies.append(n_idx)
		if is_b: siege_boss_idx = n_idx
		
		var spr = Sprite2D.new()
		spr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)
		spr.position = w_pos
		add_child(spr)
		npc_sprites.append(spr)
		
	# Телепортируем игрока на исходную позицию штурма
	player_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_fort_siege_progress() -> void:
	if not is_fort_siege_active: return
	
	var alive_count := 0
	for idx in siege_enemies:
		if idx < npc_data.size() and not npc_data[idx].get("is_dead", false):
			alive_count += 1
			
	if alive_count == 0:
		_on_fort_siege_victory()

func _on_fort_siege_victory() -> void:
	is_fort_siege_active = false
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	var gold_gain = 220
	var freed_count = 2
	if active_siege_fort_id == "fort_red_gorge":
		gold_gain = 350
		freed_count = 3
	elif active_siege_fort_id == "fort_smugglers":
		gold_gain = 140
		freed_count = 2
		
	p.settlement["treasury"] = int(p.settlement.get("treasury", 0)) + gold_gain
	p.renown += 50
	p.honor += 30
	
	# Освобождение пленников и присоединение к поселению
	var freed_names = ["Освальд", "Гертруда", "Виллем", "Бьянка"]
	for k in range(freed_count):
		var fn = freed_names[randi() % freed_names.size()]
		var citizen = {
			"id": "freed_%d" % (Time.get_ticks_msec() + k),
			"name": fn,
			"profession": "farmer",
			"gold": 15,
			"hunger": 100
		}
		SettlementManager.add_citizen(p, citizen)
		
	_log("[color=gold][b]🏆 ПОБЕДА! Вражеский форт полностью пал под натиском вашей армии![/b][/color]")
	_log("[color=yellow]💰 Казна вашего города пополнена на +%d золотых![/color]" % gold_gain)
	_log("[color=lightgreen]👥 Вы освободили %d пленных, и они благодарно присоединились к вашему поселению![/color]" % freed_count)
	_log("[color=cyan]👑 Ваша Слава во всем королевстве возросла (+50 Славы, +30 Чести)![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ФОРТ ЗАХВАЧЕН! +%d ЗОЛОТА В КАЗНУ" % gold_gain, Color.GOLD, 22)
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8') as f:
    f.write(text + siege_code)

print('Successfully patched GameWorld2D.gd for Batch 14!')
