with open('godot/src/game2d/GameWorld2D.gd', 'rb') as f:
    raw = f.read()

text = raw.decode('utf-8', errors='replace')
cutoff = text.find('«Я вернусь, когда заслужу достаточно славы и чести»')
end_of_noble = text.find('_close_all_modals)', cutoff) + len('_close_all_modals)')
base_text = text[:end_of_noble]

addition = '''

# =========================================================
# ОБОРОНА ДЕРЕВНИ ОТ НАБЕГОВ РАЗБОЙНИКОВ 🔔⚔️
# =========================================================
func _trigger_alarm_bell() -> void:
	if is_raid_active:
		_log("[color=orange]🔔 Тревожный набат уже звучит! Отразите текущую волну нападающих![/color]")
		_spawn_floating_text(player_pos, "🔔 НАБАТ УЖЕ ЗВУЧИТ!", Color.ORANGE, 16)
		return
		
	_log("[color=red][b]🔔 БУМ! БУМ! БУМ! Зазвучал Тревожный Колокол Олдерии![/b][/color]")
	_log("[color=gold]К деревне приближается крупная шайка лесных разбойников! Стража и жители готовятся к обороне![/color]")
	_spawn_spark_particles(player_pos, Color.RED)
	_spawn_floating_text(player_pos, "🔔 ТРЕВОЖНЫЙ НАБАТ!", Color.RED, 22)
	
	_start_village_raid()

func _start_village_raid() -> void:
	is_raid_active = true
	raid_wave = 1
	raid_wave_enemies.clear()
	_spawn_raid_wave(1)

func _spawn_raid_wave(wave_num: int) -> void:
	raid_wave = wave_num
	raid_wave_enemies.clear()
	
	_log("[color=red][b]⚔️ НАБЕГ НА ДЕРЕВНЮ: ВОЛНА %d / 3![/b][/color]" % wave_num)
	_spawn_floating_text(player_pos, "⚔️ НАБЕГ: ВОЛНА %d/3" % wave_num, Color.RED, 20)
	
	var spawn_points: Array[Vector2i] = []
	var enemies_info: Array[Dictionary] = []
	
	if wave_num == 1:
		# Волна 1: 3 легких разведчика с севера
		spawn_points = [Vector2i(23, 6), Vector2i(21, 7), Vector2i(25, 7)]
		for sp in spawn_points:
			enemies_info.append({
				"name": "Разбойник-разведчик",
				"role": "Разбойник",
				"hp": 55.0,
				"max_hp": 55.0,
				"defense": 4,
				"gold": randi_range(6, 14),
				"is_ranged": false
			})
	elif wave_num == 2:
		# Волна 2: 2 мечника со щитами + 2 лучника с запада
		spawn_points = [Vector2i(5, 23), Vector2i(5, 26), Vector2i(4, 24), Vector2i(4, 25)]
		enemies_info.append({"name": "Бандит со щитом", "role": "Бандит", "hp": 85.0, "max_hp": 85.0, "defense": 10, "gold": 15, "is_ranged": false})
		enemies_info.append({"name": "Бандит со щитом", "role": "Бандит", "hp": 85.0, "max_hp": 85.0, "defense": 10, "gold": 15, "is_ranged": false})
		enemies_info.append({"name": "Разбойник-лучник", "role": "Разбойник-лучник", "hp": 60.0, "max_hp": 60.0, "defense": 5, "gold": 18, "is_ranged": true})
		enemies_info.append({"name": "Разбойник-лучник", "role": "Разбойник-лучник", "hp": 60.0, "max_hp": 60.0, "defense": 5, "gold": 18, "is_ranged": true})
	elif wave_num == 3:
		# Волна 3: Босс Аттила Железный Клык + 2 телохранителя с юга
		spawn_points = [Vector2i(23, 58), Vector2i(21, 59), Vector2i(25, 59)]
		enemies_info.append({"name": "Аттила Железный Клык", "role": "Бандит", "hp": 250.0, "max_hp": 250.0, "defense": 14, "gold": 75, "is_boss": true, "is_ranged": false})
		enemies_info.append({"name": "Ветеран-телохранитель", "role": "Бандит", "hp": 110.0, "max_hp": 110.0, "defense": 12, "gold": 25, "is_ranged": false})
		enemies_info.append({"name": "Ветеран-телохранитель", "role": "Бандит", "hp": 110.0, "max_hp": 110.0, "defense": 12, "gold": 25, "is_ranged": false})
		
	for i in range(spawn_points.size()):
		var sp = spawn_points[i]
		var einfo = enemies_info[i]
		var w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)
		
		var npc_entry = {
			"id": "raider_%d_%d" % [wave_num, i],
			"name": einfo["name"],
			"role": einfo["role"],
			"hp": einfo["hp"],
			"max_hp": einfo["max_hp"],
			"defense": einfo.get("defense", 6),
			"gold": einfo.get("gold", 10),
			"home_tile": sp,
			"target_pos": player_pos,
			"idle_timer": 0.0,
			"walk_speed": 55.0,
			"is_dead": false,
			"is_hostile": true,
			"is_ranged": einfo.get("is_ranged", false),
			"shoot_cooldown": randf_range(1.5, 3.0),
			"traits": ["Жестокий", "Грабитель"]
		}
		
		npc_data.append(npc_entry)
		npc_positions.append(w_pos)
		var new_idx = npc_data.size() - 1
		raid_wave_enemies.append(new_idx)
		
		if einfo.get("is_boss", false):
			raid_boss_idx = new_idx
			
		var spr = Sprite2D.new()
		spr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)
		spr.position = w_pos
		add_child(spr)
		npc_sprites.append(spr)
		
		_spawn_spark_particles(w_pos, Color.RED)

func _check_raid_wave_progress() -> void:
	if not is_raid_active: return
	
	var alive_count := 0
	for idx in raid_wave_enemies:
		if idx < npc_data.size() and not npc_data[idx].get("is_dead", false):
			alive_count += 1
			
	if alive_count == 0:
		if raid_wave < 3:
			_log("[color=green]🎉 Волна %d успешно отбита! Готовьтесь к следующей волне через 3 секунды...[/color]" % raid_wave)
			_spawn_floating_text(player_pos, "ВОЛНА %d ОТБИТА!" % raid_wave, Color.GREEN, 18)
			get_tree().create_timer(3.0).timeout.connect(func():
				if is_raid_active:
					_spawn_raid_wave(raid_wave + 1)
			)
		else:
			_on_raid_victory()

func _on_raid_victory() -> void:
	is_raid_active = false
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if p:
		p.gold += 80
		p.renown += 25
		p.honor += 20
		
	_log("[color=gold][b]🏆 ПОБЕДА! Главарь разбойников Аттила и его шайка повержены![/b][/color]")
	_log("[color=yellow]Королевская награда от Лорда: +80 золотых, +25 Славы, +20 Чести![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "🏆 ПОБЕДА! НАБЕГ ОТБИТ! +80 ЗОЛОТА", Color.GOLD, 22)

# =========================================================
# ФИЗИЧЕСКИЙ ТРУД ЖИТЕЛЕЙ (COLONIST LABOR SIMULATION) 🌾🪓⚒️
# =========================================================
func _update_colonists_labor(delta: float) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p or not p.settlement.get("has_town", false): return
	
	var banner_tile = p.settlement.get("banner_tile", Vector2i(23, 21))
	for n_i in range(npc_data.size()):
		var npc = npc_data[n_i]
		if not npc.has("role_prof"): continue
		if npc.get("is_dead", false): continue
		
		var cur_pos = npc_positions[n_i]
		var step_res = ColonistAISystem.process_colonist_step(npc, cur_pos, delta, world_map, banner_tile)
		npc_positions[n_i] = step_res["new_pos"]
		if n_i < npc_sprites.size() and is_instance_valid(npc_sprites[n_i]):
			npc_sprites[n_i].position = step_res["new_pos"]
			
		if step_res.get("did_finish_work", false):
			var act_tile = step_res["action_tile"]
			var act_world = Vector2(act_tile.x * TILE_SIZE + TILE_SIZE/2.0, act_tile.y * TILE_SIZE + TILE_SIZE/2.0)
			_spawn_spark_particles(act_world, Color(0.9, 0.8, 0.3))
			if step_res.get("thought_icon", "") != "":
				_spawn_floating_text(act_world, step_res["thought_icon"], Color.GOLD, 18)

# =========================================================
# KINGDOMS SANDBOX: ВЫБОР СТАРТОВОГО ПУТИ (ORIGINS) 🎭
# =========================================================
func _build_origin_modal(canvas: CanvasLayer) -> void:
	origin_panel = PanelContainer.new()
	origin_panel.position = Vector2(240, 70)
	origin_panel.custom_minimum_size = Vector2(800, 520)
	origin_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.15, 0.98), Color(0.88, 0.72, 0.30), 2, 8))
	origin_panel.visible = false
	canvas.add_child(origin_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	origin_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "👑 ВЫБОР ВАШЕГО ПУТИ В ОЛДЕРИИ (KINGDOMS ORIGIN)"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	vbox.add_child(title)
	
	var desc = Label.new()
	desc.text = "Кем вы начнете свое путешествие в средневековом мире? Каждый путь дает уникальный стартовый набор и цели."
	desc.add_theme_font_size_override("font_size", 12)
	desc.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
	vbox.add_child(desc)
	
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 380)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)
	
	var list_v = VBoxContainer.new()
	list_v.add_theme_constant_override("separation", 8)
	scroll.add_child(list_v)
	
	for o_id in SettlementDatabase.ORIGINS.keys():
		var o = SettlementDatabase.ORIGINS[o_id]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(740, 68)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.text = "%s %s\\n%s" % [o.get("icon", "⚔️"), o.get("name", ""), o.get("desc", "")]
		_style_button(btn)
		btn.pressed.connect(func():
			_choose_origin(o_id)
		)
		list_v.add_child(btn)

func _show_origin_modal() -> void:
	_close_all_modals()
	is_ui_open = true
	origin_panel.visible = true

func _choose_origin(orig_id: String) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	var o_def = SettlementDatabase.get_origin_def(orig_id)
	p.origin_role = orig_id
	p.character_name = "Герой"
	p.current_role = o_def.get("name", "Странник").split(" ")[0]
	p.gold = o_def.get("starting_gold", 25)
	
	# Выдача предметов
	for it_id in o_def.get("starting_items", {}).keys():
		p.inventory[it_id] = o_def["starting_items"][it_id]
		
	_log("[color=gold][b]🎭 ВЫ ВЫБРАЛИ ПУТЬ: %s %s![/b][/color]" % [o_def.get("icon", ""), o_def.get("name", "")])
	_log("[color=cyan]Вам выдано стартовое снаряжение и припасы. Ваша судьба — в ваших руках![/color]")
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "ПУТЬ: " + o_def.get("name", "").to_upper(), Color.GOLD, 20)
	_close_all_modals()

# =========================================================
# KINGDOMS SANDBOX: УПРАВЛЕНИЕ ПОСЕЛЕНИЕМ [ T ] 🏛️🚩
# =========================================================
func _build_settlement_modal(canvas: CanvasLayer) -> void:
	settlement_panel = PanelContainer.new()
	settlement_panel.position = Vector2(160, 50)
	settlement_panel.custom_minimum_size = Vector2(960, 560)
	settlement_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.11, 0.12, 0.16, 0.97), Color(0.85, 0.70, 0.32), 2, 8))
	settlement_panel.visible = false
	canvas.add_child(settlement_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	settlement_panel.add_child(vbox)
	
	# Шапка
	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)
	
	var title = Label.new()
	title.text = "🏛️ РАТУША И УПРАВЛЕНИЕ ПОСЕЛЕНИЕМ"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	top_h.add_child(title)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_h.add_child(spacer)
	
	var close_btn = Button.new()
	close_btn.text = "✖ Закрыть [ ESC ]"
	_style_button(close_btn)
	close_btn.pressed.connect(_close_all_modals)
	top_h.add_child(close_btn)
	
	# Вкладки
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 10)
	vbox.add_child(tab_bar)
	
	var tab_main_btn = Button.new()
	tab_main_btn.text = "📊 Обзор и Казна"
	_style_button(tab_main_btn)
	tab_main_btn.pressed.connect(func():
		settlement_tab_idx = 0
		_refresh_settlement_window()
	)
	tab_bar.add_child(tab_main_btn)
	
	var tab_citizens_btn = Button.new()
	tab_citizens_btn.text = "👨‍🌾 Граждане и Профессии"
	_style_button(tab_citizens_btn)
	tab_citizens_btn.pressed.connect(func():
		settlement_tab_idx = 1
		_refresh_settlement_window()
	)
	tab_bar.add_child(tab_citizens_btn)
	
	var tab_laws_btn = Button.new()
	tab_laws_btn.text = "📜 Налоги и Законы"
	_style_button(tab_laws_btn)
	tab_laws_btn.pressed.connect(func():
		settlement_tab_idx = 2
		_refresh_settlement_window()
	)
	tab_bar.add_child(tab_laws_btn)
	
	var tab_proj_btn = Button.new()
	tab_proj_btn.text = "🔨 Строительные Проекты"
	_style_button(tab_proj_btn)
	tab_proj_btn.pressed.connect(func():
		settlement_tab_idx = 3
		_refresh_settlement_window()
	)
	tab_bar.add_child(tab_proj_btn)
	
	# Тело
	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)
	
	# Левая колонка
	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(360, 410)
	left_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)
	
	settlement_list = ItemList.new()
	settlement_list.custom_minimum_size = Vector2(340, 390)
	settlement_list.item_selected.connect(_on_settlement_item_selected)
	left_p.add_child(settlement_list)
	
	# Правая колонка
	var right_v = VBoxContainer.new()
	right_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_v.add_theme_constant_override("separation", 10)
	body_h.add_child(right_v)
	
	var right_p = PanelContainer.new()
	right_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	right_v.add_child(right_p)
	
	settlement_info_label = RichTextLabel.new()
	settlement_info_label.bbcode_enabled = true
	settlement_info_label.custom_minimum_size = Vector2(530, 330)
	right_p.add_child(settlement_info_label)
	
	var act_h = HBoxContainer.new()
	act_h.add_theme_constant_override("separation", 12)
	right_v.add_child(act_h)
	
	settlement_withdraw_btn = Button.new()
	settlement_withdraw_btn.text = "💰 Забрать 25 з. из казны"
	_style_button(settlement_withdraw_btn)
	settlement_withdraw_btn.pressed.connect(func():
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		if p:
			var taken = SettlementManager.withdraw_treasury(p, 25)
			if taken > 0:
				_log("[color=green]💰 Вы забрали из казны поселения: %d золотых.[/color]" % taken)
				_refresh_settlement_window()
	)
	act_h.add_child(settlement_withdraw_btn)
	
	settlement_tax_btn = Button.new()
	settlement_tax_btn.text = "🪙 Пополнить казну (25 з.)"
	_style_button(settlement_tax_btn)
	settlement_tax_btn.pressed.connect(func():
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		if p:
			if SettlementManager.deposit_treasury(p, 25):
				_log("[color=gold]🪙 Вы вложили в городскую казну 25 золотых.[/color]")
				_refresh_settlement_window()
			else:
				_log("[color=red]У вас недостаточно золота![/color]")
	)
	act_h.add_child(settlement_tax_btn)
	
	settlement_action_btn = Button.new()
	settlement_action_btn.text = "🏗️ Заказать постройку (Возвести проект)"
	_style_button(settlement_action_btn)
	settlement_action_btn.pressed.connect(func():
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		if not p: return
		if selected_project_id == "":
			selected_project_id = "house_peasant"
		var banner_pos = p.settlement.get("banner_tile", Vector2i(23, 21))
		var offset = Vector2i(randi_range(-4, 4), randi_range(-4, 4))
		var res = SettlementManager.build_project(p, selected_project_id, banner_pos + offset, world_map)
		if res.get("success", false):
			_log("[color=gold][b]🏗️ СТРОИТЕЛЬСТВО: Жители успешно возвели объект: %s![/b][/color]" % res.get("name", ""))
			_spawn_spark_particles(player_pos, Color.GOLD)
			_spawn_floating_text(player_pos, "🏗️ " + res.get("name", ""), Color.GOLD, 20)
			_refresh_settlement_window()
		else:
			_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка стройки"))
	)
	act_h.add_child(settlement_action_btn)

func _toggle_settlement_menu() -> void:
	if settlement_panel.visible:
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		settlement_panel.visible = true
		settlement_tab_idx = 0
		_refresh_settlement_window()

func _refresh_settlement_window() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	SettlementManager.ensure_settlement(p)
	settlement_list.clear()
	
	if not p.settlement.get("has_town", false):
		settlement_list.add_item("🚩 Знамя Поселения (Не установлено)")
		settlement_withdraw_btn.visible = false
		settlement_tax_btn.visible = false
		settlement_action_btn.visible = false
		
		settlement_info_label.text = """[b][font_size=18]🚩 Собственное Поселение Олдерии[/font_size][/b]
[color=orange]Статус: Вы еще не основали свой город[/color]

В мире Kingdoms вы можете заложить поселение в [b]абсолютно любой точке карты[/b]!
Чтобы основать город:
 1. Откройте меню строительства [b][ B ][/b] или создайте «Знамя Поселения» на верстаке.
 2. Разместите [b]«🚩 Знамя Поселения»[/b] на выбранной земле.
 3. Стройте деревянные дома, стены и ставьте кровати [b]🛏️[/b].
 4. Бродяги и переселенцы начнут приходить в ваш город, выбирать ремесла, строить мастерские и платить вам налоги в казну!
"""
		return
		
	# Игрок основал город
	var town_name = p.settlement.get("town_name", "Новый Оксфорд")
	var tier = int(p.settlement.get("tier", 1))
	var tier_def = SettlementDatabase.get_tier_def(tier)
	var treasury = int(p.settlement.get("treasury", 0))
	var tax_rate = float(p.settlement.get("tax_rate", 0.10))
	var citizens: Array = p.settlement.get("citizens", [])
	
	# Подсчет построенных кроватей на карте
	var total_beds := 0
	for pos in world_map.interactive_nodes.keys():
		if world_map.interactive_nodes[pos].get("type") == "bed":
			total_beds += 1
			
	if settlement_tab_idx == 0:
		# Обзор
		settlement_withdraw_btn.visible = true
		settlement_tax_btn.visible = true
		settlement_action_btn.visible = false
		
		settlement_list.add_item("%s Ранг: %s" % [tier_def.get("icon", "🏕️"), tier_def.get("name", "")])
		settlement_list.add_item("👥 Граждане: %d чел." % citizens.size())
		settlement_list.add_item("🛏️ Спальные места: %d шт." % total_beds)
		settlement_list.add_item("💰 Казна: %d золотых" % treasury)
		settlement_list.add_item("📜 Налог: %d%%" % int(tax_rate * 100))
		
		settlement_info_label.text = """[b][font_size=18]🚩 Поселение «%s» (%s %s)[/font_size][/b]
[color=green]Статус: Процветающий вольный удел[/color]

%s

---------------------------------------------------------
[b]👥 Население:[/b] %d чел. | [b]🛏️ Жилые места:[/b] %d свободных
[b]💰 Городская Казна:[/b] [color=gold]%d золотых[/color]
[b]📜 Ежедневный налог с доходов:[/b] %d%% (сбор каждое утро в 08:00)

[color=lightblue]💡 Совет:[/color] Стройте больше кроватей и домов [B], чтобы привлекать странников и развивать город до ранга Города-Крепости!
""" % [
			town_name, tier_def.get("icon", ""), tier_def.get("name", ""),
			tier_def.get("desc", ""),
			citizens.size(), maxi(0, total_beds - citizens.size()),
			treasury,
			int(tax_rate * 100)
		]

	elif settlement_tab_idx == 1:
		# Граждане
		settlement_withdraw_btn.visible = false
		settlement_tax_btn.visible = false
		settlement_action_btn.visible = false
		
		if citizens.size() == 0:
			settlement_list.add_item("👥 Нет жителей (Постройте кровати [B])")
			settlement_info_label.text = """[b][font_size=18]👥 Граждане вашего поселения[/font_size][/b]
В поселении пока нет жителей.
Постройте кровати [B] в домах, и странники-переселенцы сами придут и попросят осесть в вашем городе!"""
		else:
			for c in citizens:
				var p_def = SettlementDatabase.get_profession_def(c.get("profession", "farmer"))
				settlement_list.add_item("%s %s (%s)" % [p_def.get("icon", "👨‍🌾"), c.get("name", "Житель"), p_def.get("name", "")])
				settlement_list.set_item_metadata(settlement_list.get_item_count() - 1, c.get("id"))
				
			if selected_citizen_id != "":
				for c in citizens:
					if c.get("id") == selected_citizen_id:
						var p_def = SettlementDatabase.get_profession_def(c.get("profession", "farmer"))
						settlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Профессия:[/b] %s %s
[b]Личные сбережения:[/b] [color=gold]%d золотых[/color]
[b]Сытость:[/b] %d%%

[color=lightgray]%s[/color]
""" % [
							p_def.get("icon", "👨‍🌾"), c.get("name", ""),
							p_def.get("icon", ""), p_def.get("name", ""),
							c.get("gold", 10),
							c.get("hunger", 90),
							p_def.get("yield_desc", "")
						]
						break

	elif settlement_tab_idx == 2:
		# Законы и налоги
		settlement_withdraw_btn.visible = false
		settlement_tax_btn.visible = false
		settlement_action_btn.visible = false
		
		settlement_list.add_item("🪙 Налог: 5% (Высокое счастье)")
		settlement_list.set_item_metadata(0, "tax_5")
		settlement_list.add_item("🪙 Налог: 10% (Норма)")
		settlement_list.set_item_metadata(1, "tax_10")
		settlement_list.add_item("🪙 Налог: 15% (Умеренный)")
		settlement_list.set_item_metadata(2, "tax_15")
		settlement_list.add_item("🪙 Налог: 20% (Высокий налог)")
		settlement_list.set_item_metadata(3, "tax_20")
		
		settlement_info_label.text = """[b][font_size=18]📜 Законы и Налогообложение Поселения[/font_size][/b]
Текущая ставка налога: [b][color=gold]%d%%[/color][/b]

Выберите ставку в списке слева, чтобы изменить налоговую политику.
Налоги собираются ежедневно в 08:00 со всех работающих жителей и идут на финансирование городской стражи и развитие!""" % int(tax_rate * 100)

	elif settlement_tab_idx == 3:
		# Проекты строительства
		settlement_withdraw_btn.visible = false
		settlement_tax_btn.visible = false
		settlement_action_btn.visible = true
		
		for pr_id in SettlementDatabase.TOWN_PROJECTS.keys():
			var pr = SettlementDatabase.TOWN_PROJECTS[pr_id]
			settlement_list.add_item("%s %s" % [pr.get("icon", "🔨"), pr.get("name", "")])
			settlement_list.set_item_metadata(settlement_list.get_item_count() - 1, pr_id)
			
		if selected_project_id == "":
			selected_project_id = "house_peasant"
			
		var pr = SettlementDatabase.get_project_def(selected_project_id)
		var cost_str = ""
		for it_id in pr.get("cost", {}).keys():
			var it = ItemDatabase.get_item(it_id)
			cost_str += "%s %s: %d шт.  " % [it.get("icon", "📦"), it.get("name", it_id), pr["cost"][it_id]]
			
		settlement_info_label.text = """[b][font_size=18]%s %s[/font_size][/b]
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

func _on_settlement_item_selected(idx: int) -> void:
	if settlement_tab_idx == 1:
		var c_id = settlement_list.get_item_metadata(idx)
		if c_id:
			selected_citizen_id = c_id
			_refresh_settlement_window()
	elif settlement_tab_idx == 2:
		var gm = _get_game_manager()
		var p: CharacterData = gm.player_data if gm else null
		if not p: return
		var meta = settlement_list.get_item_metadata(idx)
		match meta:
			"tax_5": SettlementManager.set_tax_rate(p, 0.05)
			"tax_10": SettlementManager.set_tax_rate(p, 0.10)
			"tax_15": SettlementManager.set_tax_rate(p, 0.15)
			"tax_20": SettlementManager.set_tax_rate(p, 0.20)
		_log("[color=gold]📜 Налоговая ставка изменена на %d%%![/color]" % int(p.settlement.get("tax_rate", 0.10) * 100))
		_refresh_settlement_window()
	elif settlement_tab_idx == 3:
		var pr_id = settlement_list.get_item_metadata(idx)
		if pr_id:
			selected_project_id = pr_id
			_refresh_settlement_window()

func _check_settler_migration() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p or not p.settlement.get("has_town", false): return
	
	# Подсчет свободных кроватей
	var total_beds := 0
	for pos in world_map.interactive_nodes.keys():
		if world_map.interactive_nodes[pos].get("type") == "bed":
			total_beds += 1
			
	var current_pop = p.settlement.get("citizens", []).size()
	if total_beds <= current_pop:
		return # Нет свободных спальных мест
		
	# Спавним нового переселенца
	var rand_names = ["Рагнар", "Томас", "Берта", "Эльза", "Годфрид", "Хельга", "Бруно", "Агнесса"]
	var prof_keys = SettlementDatabase.PROFESSIONS.keys()
	var chosen_prof = prof_keys[randi() % prof_keys.size()]
	var c_name = rand_names[randi() % rand_names.size()]
	
	var new_citizen = {
		"id": "colonist_%d" % Time.get_ticks_msec(),
		"name": c_name,
		"profession": chosen_prof,
		"gold": randi_range(5, 18),
		"hunger": 100
	}
	
	SettlementManager.add_citizen(p, new_citizen)
	var p_def = SettlementDatabase.get_profession_def(chosen_prof)
	
	# Спавним физического NPC в мире
	var spawn_tile = Vector2i(23, 3)
	var w_pos = Vector2(spawn_tile.x * TILE_SIZE + TILE_SIZE/2.0, spawn_tile.y * TILE_SIZE + TILE_SIZE/2.0)
	
	var npc_entry = {
		"id": new_citizen["id"],
		"name": c_name,
		"role": p_def.get("name", "Житель"),
		"role_prof": chosen_prof,
		"hp": 80.0,
		"max_hp": 80.0,
		"gold": new_citizen["gold"],
		"home_tile": spawn_tile,
		"target_pos": player_pos,
		"idle_timer": 2.0,
		"walk_speed": 45.0,
		"is_dead": false,
		"is_hostile": false,
		"work_state": "idle",
		"work_timer": 0.0,
		"work_target_tile": Vector2i(-1, -1),
		"traits": ["Трудолюбивый", "Честный"]
	}
	npc_data.append(npc_entry)
	npc_positions.append(w_pos)
	
	var spr = Sprite2D.new()
	spr.texture = SpriteGenerator2D.get_character_texture("peasant", TILE_SIZE)
	spr.position = w_pos
	add_child(spr)
	npc_sprites.append(spr)
	
	p.renown += 5
	_log("[color=lightgreen][b]🚶‍♂️ МИГРАЦИЯ: В ваш город прибыл переселенец %s и занял свободную кровать! Профессия: %s %s.[/b][/color]" % [c_name, p_def.get("icon", ""), p_def.get("name", "")])
	_spawn_spark_particles(player_pos, Color.LIGHT_GREEN)
	_spawn_floating_text(player_pos, "+1 ЖИТЕЛЬ: " + c_name, Color.LIGHT_GREEN, 18)
	
	# Проверка повышения ранга поселения
	var tier_check = SettlementManager.update_tier_progress(p, total_beds)
	if tier_check.get("leveled_up", false):
		var t_def = tier_check["tier_def"]
		_log("[color=gold][b]🎉 ПОЗДРАВЛЯЕМ! Ваше поселение выросло до нового ранга: %s %s![/b][/color]" % [t_def.get("icon", ""), t_def.get("name", "")])
		_spawn_spark_particles(player_pos, Color.GOLD)
		_spawn_floating_text(player_pos, "👑 РАНГ ГОРОДА: " + t_def.get("name", "").to_upper(), Color.GOLD, 22)

# =========================================================
# ЛАВКА ЖИТЕЛЯ ПОСЕЛЕНИЯ (CITIZEN TRADE STALL) 🛒
# =========================================================
func _build_citizen_shop_modal(canvas: CanvasLayer) -> void:
	citizen_shop_panel = PanelContainer.new()
	citizen_shop_panel.position = Vector2(260, 80)
	citizen_shop_panel.custom_minimum_size = Vector2(760, 480)
	citizen_shop_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.15, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
	citizen_shop_panel.visible = false
	canvas.add_child(citizen_shop_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	citizen_shop_panel.add_child(vbox)
	
	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	vbox.add_child(top_h)
	
	var title = Label.new()
	title.text = "🛒 ТОРГОВЫЙ ПРИЛАВОК ГОРОЖАНИНА"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	top_h.add_child(title)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_h.add_child(spacer)
	
	var close_btn = Button.new()
	close_btn.text = "✖ Закрыть [ ESC ]"
	_style_button(close_btn)
	close_btn.pressed.connect(_close_all_modals)
	top_h.add_child(close_btn)
	
	var body_h = HBoxContainer.new()
	body_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_h.add_theme_constant_override("separation", 16)
	vbox.add_child(body_h)
	
	var left_p = PanelContainer.new()
	left_p.custom_minimum_size = Vector2(340, 360)
	left_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	body_h.add_child(left_p)
	
	citizen_shop_list = ItemList.new()
	citizen_shop_list.custom_minimum_size = Vector2(320, 340)
	citizen_shop_list.item_selected.connect(_on_citizen_shop_item_selected)
	left_p.add_child(citizen_shop_list)
	
	var right_v = VBoxContainer.new()
	right_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_v.add_theme_constant_override("separation", 10)
	body_h.add_child(right_v)
	
	var right_p = PanelContainer.new()
	right_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
	right_v.add_child(right_p)
	
	citizen_shop_info = RichTextLabel.new()
	citizen_shop_info.bbcode_enabled = true
	citizen_shop_info.custom_minimum_size = Vector2(360, 280)
	right_p.add_child(citizen_shop_info)
	
	var buy_btn = Button.new()
	buy_btn.text = "💰 Купить выбранный товар"
	_style_button(buy_btn)
	buy_btn.pressed.connect(func():
		var sel = citizen_shop_list.get_selected_items()
		if sel.size() == 0: return
		var meta = citizen_shop_list.get_item_metadata(sel[0])
		if meta:
			_buy_citizen_shop_item(meta["id"], meta["price"])
	)
	right_v.add_child(buy_btn)

func _open_citizen_shop(npc_idx: int) -> void:
	active_shop_npc_idx = npc_idx
	_close_all_modals()
	is_ui_open = true
	citizen_shop_panel.visible = true
	_refresh_citizen_shop()

func _refresh_citizen_shop() -> void:
	citizen_shop_list.clear()
	if active_shop_npc_idx < 0 or active_shop_npc_idx >= npc_data.size(): return
	
	var npc = npc_data[active_shop_npc_idx]
	var prof = npc.get("role_prof", "")
	if prof == "":
		match npc.get("role", ""):
			"Кузнец": prof = "blacksmith"
			"Хлебопашец": prof = "farmer"
			"Лесоруб", "Лесоруб-Плотник": prof = "woodcutter"
			"Пекарь": prof = "baker"
			"Охотник", "Охотник-Егерь": prof = "hunter"
			"Городской Стражник": prof = "guard"
			_: prof = "farmer"
			
	var shop_items = SettlementDatabase.get_shop_items(prof)
	for it_entry in shop_items:
		var it = ItemDatabase.get_item(it_entry["id"])
		citizen_shop_list.add_item("%s %s — %d з." % [it.get("icon", "📦"), it.get("name", it_entry["id"]), it_entry["price"]])
		citizen_shop_list.set_item_metadata(citizen_shop_list.get_item_count() - 1, it_entry)
		
	citizen_shop_info.text = """[b][font_size=18]Прилавок жителя: %s (%s)[/font_size][/b]
[color=lightgray]Житель продает товары собственного ремесленного производства.[/color]

[b]Личные сбережения мастера:[/b] [color=gold]%d золотых[/color]

Выберите предмет из списка слева и нажмите кнопку «Купить».""" % [npc["name"], npc["role"], npc.get("gold", 10)]

func _on_citizen_shop_item_selected(idx: int) -> void:
	var meta = citizen_shop_list.get_item_metadata(idx)
	if not meta: return
	var it = ItemDatabase.get_item(meta["id"])
	var npc = npc_data[active_shop_npc_idx] if active_shop_npc_idx >= 0 and active_shop_npc_idx < npc_data.size() else {}
	
	citizen_shop_info.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Стоимость:[/b] [color=gold]%d золотых[/color]
[b]Категория:[/b] %s

[color=lightgray]%s[/color]

[color=cyan]Покупка обогатит жителя %s и пополнит городскую казну налогами в 08:00![/color]
""" % [
		it.get("icon", "📦"), it.get("name", ""),
		meta["price"],
		it.get("category", "предмет").capitalize(),
		it.get("desc", ""),
		npc.get("name", "Мастер")
	]

func _buy_citizen_shop_item(item_id: String, price: int) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	if p.gold < price:
		_log("[color=red]У вас недостаточно золота для покупки (%d з.)![/color]" % price)
		return
		
	p.gold -= price
	p.inventory[item_id] = p.inventory.get(item_id, 0) + 1
	
	if active_shop_npc_idx >= 0 and active_shop_npc_idx < npc_data.size():
		npc_data[active_shop_npc_idx]["gold"] = npc_data[active_shop_npc_idx].get("gold", 10) + price
		
	var it = ItemDatabase.get_item(item_id)
	_log("[color=green]🛍️ Вы купили %s %s за %d золотых у горожанина![/color]" % [it.get("icon", "📦"), it.get("name", item_id), price])
	_spawn_spark_particles(player_pos, Color.GOLD)
	_spawn_floating_text(player_pos, "+1 " + it.get("name", ""), Color.LIGHT_GREEN, 16)
	_refresh_citizen_shop()
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8') as f:
    f.write(base_text + addition)

print('Successfully patched GameWorld2D.gd!')
