with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload MountSystem
old_preload = '''const GarrisonManager = preload("res://src/character/GarrisonManager.gd")'''
new_preload = '''const GarrisonManager = preload("res://src/character/GarrisonManager.gd")
const MountSystem = preload("res://src/economy/MountSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Variables for Mounts and Tournaments
old_vars = '''# Осада разбойничьих фортов
var is_fort_siege_active: bool = false
var active_siege_fort_id: String = ""
var siege_enemies: Array[int] = []
var siege_boss_idx: int = -1'''

new_vars = '''# Осада разбойничьих фортов
var is_fort_siege_active: bool = false
var active_siege_fort_id: String = ""
var siege_enemies: Array[int] = []
var siege_boss_idx: int = -1

# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false
var mount_panel: PanelContainer
var mount_list: ItemList
var mount_info: RichTextLabel
var selected_horse_breed: String = "horse_bay"
var is_tourney_active: bool = false
var tourney_round: int = 0
var tourney_enemy_idx: int = -1'''

text = text.replace(old_vars, new_vars, 1)

# 3. Add stable to build_catalog
old_build_cat = '''\t{"id": "beehive", "name": "🐝 Пчелиный Улей (Пасека)", "cost": {"plank": 4, "wheat": 2}, "desc": "Улей для сбора меда и воска [E] и варки хмельной медовухи."}
]'''

new_build_cat = '''\t{"id": "beehive", "name": "🐝 Пчелиный Улей (Пасека)", "cost": {"plank": 4, "wheat": 2}, "desc": "Улей для сбора меда и воска [E] и варки хмельной медовухи."},
\t{"id": "stable", "name": "🐎 Конюшня (Разведение лошадей)", "cost": {"wood": 8, "plank": 4, "wheat": 4}, "desc": "Конюшня для покупки и содержания скакунов [E] и верховой езды [R]."}
]'''

text = text.replace(old_build_cat, new_build_cat, 1)

# 4. Add KEY_R handler in _unhandled_input
old_input = '''\t\telif event.keycode == KEY_E and not is_ui_open:
\t\t\t_handle_interaction_key()'''

new_input = '''\t\telif event.keycode == KEY_R and not is_ui_open:
\t\t\t_toggle_mount()
\t\telif event.keycode == KEY_E and not is_ui_open:
\t\t\t_handle_interaction_key()'''

text = text.replace(old_input, new_input, 1)

# 5. Add stable interaction in _handle_interaction_key
old_interact = '''\t\t\t\telif nd["type"] == "beehive":
\t\t\t\t\t_harvest_beehive(t_pos)
\t\t\t\t\treturn'''

new_interact = '''\t\t\t\telif nd["type"] == "beehive":
\t\t\t\t\t_harvest_beehive(t_pos)
\t\t\t\t\treturn
\t\t\t\telif nd["type"] == "stable":
\t\t\t\t\t_open_stable_modal()
\t\t\t\t\treturn'''

text = text.replace(old_interact, new_interact, 1)

# 6. Apply mount speed mult and trample in _physics_process
old_speed = '''\t\tif swiftness_timer > 0.0:
\t\t\tswiftness_timer -= delta
\t\t\tspeed *= 1.35'''

new_speed = '''\t\tif swiftness_timer > 0.0:
\t\t\tswiftness_timer -= delta
\t\t\tspeed *= 1.35
\t\tif is_mounted:
\t\t\tvar m_mult = MountSystem.get_mount_speed_mult(p)
\t\t\tspeed *= m_mult'''

text = text.replace(old_speed, new_speed, 1)

# 7. Add modal builders in _build_ui_hud
old_hud_modal = '''\t_build_citizen_shop_modal(canvas)
\t_build_alchemy_modal(canvas)'''

new_hud_modal = '''\t_build_citizen_shop_modal(canvas)
\t_build_alchemy_modal(canvas)
\t_build_stable_modal(canvas)'''

text = text.replace(old_hud_modal, new_hud_modal, 1)

# 8. Add mount_panel to _close_all_modals
old_close = '''\tif alchemy_panel: alchemy_panel.visible = false'''
new_close = '''\tif alchemy_panel: alchemy_panel.visible = false
\tif mount_panel: mount_panel.visible = false'''

text = text.replace(old_close, new_close, 1)

# 9. Add Tournament trigger in _enter_overworld_location
old_enter_loc = '''\t\tif loc.get("type") == "fort":
\t\t\t_start_fort_siege(loc["id"])
\t\t\treturn'''

new_enter_loc = '''\t\tif loc.get("type") == "fort":
\t\t\t_start_fort_siege(loc["id"])
\t\t\treturn
\t\telif loc.get("id") == "capital_olderia":
\t\t\t_start_royal_tournament(1)
\t\t\treturn'''

text = text.replace(old_enter_loc, new_enter_loc, 1)

# 10. Append stable modal, mount toggle, and tournament functions
mount_and_tourney_code = '''

# =========================================================
# КОНЮШНИ, ВЕРХОВАЯ ЕЗДА И РЫЦАРСКИЕ ТУРНИРЫ 🐎🏇🏆
# =========================================================
func _build_stable_modal(canvas: CanvasLayer) -> void:
\tmount_panel = PanelContainer.new()
\tmount_panel.position = Vector2(250, 75)
\tmount_panel.custom_minimum_size = Vector2(780, 500)
\tmount_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
\tmount_panel.visible = false
\tcanvas.add_child(mount_panel)
\t
\tvar vbox = VBoxContainer.new()
\tvbox.add_theme_constant_override("separation", 10)
\tmount_panel.add_child(vbox)
\t
\tvar top_h = HBoxContainer.new()
\ttop_h.add_theme_constant_override("separation", 12)
\tvbox.add_child(top_h)
\t
\tvar title = Label.new()
\ttitle.text = "🐎 КОНЮШНЯ И РАЗВЕДЕНИЕ СКАКУНОВ"
\ttitle.add_theme_font_size_override("font_size", 18)
\ttitle.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
\ttop_h.add_child(title)
\t
\tvar spacer = Control.new()
\tspacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
\ttop_h.add_child(spacer)
\t
\tvar close_btn = Button.new()
\tclose_btn.text = "✖ Закрыть [ ESC ]"
\t_style_button(close_btn)
\tclose_btn.pressed.connect(_close_all_modals)
\ttop_h.add_child(close_btn)
\t
\tvar body_h = HBoxContainer.new()
\tbody_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
\tbody_h.add_theme_constant_override("separation", 16)
\tvbox.add_child(body_h)
\t
\tvar left_p = PanelContainer.new()
\tleft_p.custom_minimum_size = Vector2(340, 380)
\tleft_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
\tbody_h.add_child(left_p)
\t
\tmount_list = ItemList.new()
\tmount_list.custom_minimum_size = Vector2(320, 360)
\tmount_list.item_selected.connect(_on_stable_item_selected)
\tleft_p.add_child(mount_list)
\t
\tvar right_v = VBoxContainer.new()
\tright_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
\tright_v.add_theme_constant_override("separation", 10)
\tbody_h.add_child(right_v)
\t
\tvar right_p = PanelContainer.new()
\tright_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
\tright_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
\tright_v.add_child(right_p)
\t
\tmount_info = RichTextLabel.new()
\tmount_info.bbcode_enabled = true
\tmount_info.custom_minimum_size = Vector2(380, 300)
\tright_p.add_child(mount_info)
\t
\tvar act_h = HBoxContainer.new()
\tact_h.add_theme_constant_override("separation", 12)
\tright_v.add_child(act_h)
\t
\tvar buy_btn = Button.new()
\tbuy_btn.text = "🪙 Купить Скакуна"
\t_style_button(buy_btn)
\tbuy_btn.pressed.connect(_buy_selected_horse)
\tact_h.add_child(buy_btn)
\t
\tvar mount_btn = Button.new()
\tmount_btn.text = "🏇 Сесть в седло [ R ]"
\t_style_button(mount_btn)
\tmount_btn.pressed.connect(func():
\t\t_toggle_mount()
\t\t_refresh_stable_modal()
\t)
\tact_h.add_child(mount_btn)

func _open_stable_modal() -> void:
\t_close_all_modals()
\tis_ui_open = true
\tmount_panel.visible = true
\tselected_horse_breed = "horse_bay"
\t_refresh_stable_modal()

func _refresh_stable_modal() -> void:
\tmount_list.clear()
\tfor b_id in MountSystem.HORSE_BREEDS.keys():
\t\tvar b = MountSystem.HORSE_BREEDS[b_id]
\t\tmount_list.add_item("%s %s — %d з." % [b.get("icon", "🐎"), b.get("name", ""), b.get("cost", 40)])
\t\tmount_list.set_item_metadata(mount_list.get_item_count() - 1, b_id)
\t\t
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tMountSystem.ensure_mount_data(p)
\t
\tvar b = MountSystem.HORSE_BREEDS.get(selected_horse_breed, MountSystem.HORSE_BREEDS["horse_bay"])
\tvar active_b = p.settlement.get("active_horse", "") if p else ""
\tvar has_horse = (active_b != "")
\t
\tmount_info.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Стоимость покупки:[/b] [color=gold]%d золотых[/color]
[b]Бонус к скорости:[/b] [color=green]+%d%%[/color]
[b]Здоровье скакуна:[/b] %.0f HP
[b]Таранный урон:[/b] %d урона

[color=lightgray]%s[/color]

---------------------------------------------------------
[b]Текущий статус верховой езды:[/b] %s
[b]Активный конь в стойле:[/b] %s
[color=gold]Нажмите [ R ] во время странствий, чтобы оседлать или спешиться![/color]
""" % [
\t\tb.get("icon", "🐎"), b.get("name", ""),
\t\tb.get("cost", 40),
\t\tint((b.get("speed_mult", 1.70) - 1.0) * 100),
\t\tb.get("max_hp", 120.0),
\t\tb.get("ram_dmg", 12),
\t\tb.get("desc", ""),
\t\t("[color=green]В СЕДЛЕ 🏇[/color]" if is_mounted else "[color=orange]ПЕШКОМ 🚶‍♂️[/color]"),
\t\t(active_b if has_horse else "Нет скакуна")
\t]

func _on_stable_item_selected(idx: int) -> void:
\tvar b_id = mount_list.get_item_metadata(idx)
\tif b_id:
\t\tselected_horse_breed = b_id
\t\t_refresh_stable_modal()

func _buy_selected_horse() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar res = MountSystem.buy_horse(p, selected_horse_breed)
\tif res.get("success", false):
\t\t_log("[color=gold][b]🐎 ПОКУПКА: Вы приобрели скакуна: %s %s![/b][/color]" % [res.get("icon", "🐎"), res.get("name", "")])
\t\t_spawn_spark_particles(player_pos, Color.GOLD)
\t\t_spawn_floating_text(player_pos, "🐎 " + res.get("name", ""), Color.GOLD, 18)
\t\t_refresh_stable_modal()
\telse:
\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка покупки"))

func _toggle_mount() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tMountSystem.ensure_mount_data(p)
\tvar active_b = p.settlement.get("active_horse", "")
\tif active_b == "":
\t\t_log("[color=orange]🐎 У вас нет скакуна в стойле. Приобретите лошадь в Конюшне [E]![/color]")
\t\t_spawn_floating_text(player_pos, "НЕТ СКАКУНА 🐎", Color.ORANGE, 16)
\t\treturn
\t\t
\tis_mounted = not is_mounted
\tvar h_def = MountSystem.HORSE_BREEDS.get(active_b, {})
\tif is_mounted:
\t\t_log("[color=green][b]🏇 Вы оседлали своего скакуна (%s)! Скорость бега увеличена на +%d%%![/b][/color]" % [h_def.get("name", "Конь"), int((h_def.get("speed_mult", 1.70) - 1.0) * 100)])
\t\t_spawn_spark_particles(player_pos, Color.GREEN)
\t\t_spawn_floating_text(player_pos, "В СЕДЛЕ 🏇 (+%d%%)" % int((h_def.get("speed_mult", 1.70) - 1.0) * 100), Color.GREEN, 18)
\telse:
\t\t_log("[color=yellow]🚶‍♂️ Вы спешились со скакуна.[/color]")
\t\t_spawn_floating_text(player_pos, "СПЕШИЛСЯ 🚶‍♂️", Color.YELLOW, 16)

# =========================================================
# КОРОЛЕВСКИЙ РЫЦАРСКИЙ ТУРНИР В СТОЛИЦЕ 🏆👑⚔️
# =========================================================
func _start_royal_tournament(round_num: int) -> void:
\t_close_all_modals()
\tif is_overworld_mode:
\t\t_toggle_overworld_mode()
\t\t
\tis_tourney_active = true
\ttourney_round = round_num
\t
\tvar r_names = [
\t\t"Раунд 1: Поединок на мечах (Рыцарь Южных Долов)",
\t\t"Раунд 2: Конная сшибка на копьях (Джостинг)",
\t\t"Гран-Финал: Битва с Чемпионом Сэром Годфридом Черным Грифоном"
\t]
\tvar r_name = r_names[round_num - 1]
\t
\t_log("[color=gold][b]🏆 КОРОЛЕВСКИЙ ТУРНИР ОЛДЕРИИ: %s![/b][/color]" % r_name)
\t_log("[color=yellow]Трибуны ликуют! Докажите свое рыцарское мастерство на Арене Столицы![/color]")
\t_spawn_spark_particles(player_pos, Color.GOLD)
\t_spawn_floating_text(player_pos, "🏆 ТУРНИР: РАУНД %d / 3" % round_num, Color.GOLD, 22)
\t
\t# Спавним противника на Арене (севернее игрока)
\tvar e_pos = Vector2(23.5 * TILE_SIZE, 14.0 * TILE_SIZE)
\tvar enemy_hp = 100.0 if round_num == 1 else (160.0 if round_num == 2 else 280.0)
\tvar enemy_def = 8 if round_num == 1 else (12 if round_num == 2 else 16)
\tvar enemy_name = "Рыцарь Южных Долов" if round_num == 1 else ("Турнирный Копейщик" if round_num == 2 else "Сэр Годфрид Черный Грифон")
\t
\tvar npc_entry = {
\t\t"id": "tourney_champion_%d" % round_num,
\t\t"name": enemy_name,
\t\t"role": "Рыцарь",
\t\t"hp": enemy_hp,
\t\t"max_hp": enemy_hp,
\t\t"defense": enemy_def,
\t\t"gold": 50,
\t\t"home_tile": Vector2i(23, 14),
\t\t"target_pos": player_pos,
\t\t"idle_timer": 0.0,
\t\t"walk_speed": 60.0,
\t\t"is_dead": false,
\t\t"is_hostile": true,
\t\t"is_ranged": false,
\t\t"is_boss": (round_num == 3),
\t\t"traits": ["Благородный", "Чемпион Арены"]
\t}
\t
\tnpc_data.append(npc_entry)
\tnpc_positions.append(e_pos)
\ttourney_enemy_idx = npc_data.size() - 1
\t
\tvar spr = Sprite2D.new()
\tspr.texture = SpriteGenerator2D.get_character_texture("knight", TILE_SIZE)
\tspr.position = e_pos
\tadd_child(spr)
\tnpc_sprites.append(spr)
\t
\tplayer_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_tournament_progress() -> void:
\tif not is_tourney_active: return
\tif tourney_enemy_idx < 0 or tourney_enemy_idx >= npc_data.size(): return
\t
\tif npc_data[tourney_enemy_idx].get("is_dead", false):
\t\tif tourney_round < 3:
\t\t\t_log("[color=green]🎉 Раунд %d выигран! Следующий противник выходит на арену...[/color]" % tourney_round)
\t\t\t_spawn_floating_text(player_pos, "РАУНД %d ПРОЙДЕН!" % tourney_round, Color.GREEN, 18)
\t\t\tget_tree().create_timer(3.0).timeout.connect(func():
\t\t\t\tif is_tourney_active:
\t\t\t\t\t_start_royal_tournament(tourney_round + 1)
\t\t\t)
\t\telse:
\t\t\t_on_tournament_victory()

func _on_tournament_victory() -> void:
\tis_tourney_active = false
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tp.gold += 250
\tp.renown += 60
\tp.honor += 40
\tp.inventory["trophy_chalice"] = p.inventory.get("trophy_chalice", 0) + 1
\tp.inventory["lance_tourney"] = p.inventory.get("lance_tourney", 0) + 1
\t
\t_log("[color=gold][b]🏆 ВЕЛИКАЯ ПОБЕДА! ВЫ СТАЛИ ЧЕМПИОНОМ КОРОЛЕВСКОГО ТУРНИРА ОЛДЕРИИ![/b][/color]")
\t_log("[color=yellow]Вам вручен Золотой Кубок Чемпиона 🏆, Турнирное Копье 🔱 и 250 золотых монет![/color]")
\t_log("[color=cyan]👑 Ваша Слава взлетела до небес (+60 Славы, +40 Чести)![/color]")
\t_spawn_spark_particles(player_pos, Color.GOLD)
\t_spawn_floating_text(player_pos, "🏆 ЧЕМПИОН ТУРНИРА! +250 ЗОЛОТА", Color.GOLD, 24)
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + mount_and_tourney_code)

print('Successfully patched GameWorld2D.gd for Batch 15!')
