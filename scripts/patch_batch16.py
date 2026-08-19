with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload NavalSystem
old_preload = '''const MountSystem = preload("res://src/economy/MountSystem.gd")'''
new_preload = '''const MountSystem = preload("res://src/economy/MountSystem.gd")
const NavalSystem = preload("res://src/economy/NavalSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Variables for Naval and Island Expeditions
old_vars = '''# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false
var mount_panel: PanelContainer
var mount_list: ItemList
var mount_info: RichTextLabel
var selected_horse_breed: String = "horse_bay"
var is_tourney_active: bool = false
var tourney_round: int = 0
var tourney_enemy_idx: int = -1'''

new_vars = '''# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false
var mount_panel: PanelContainer
var mount_list: ItemList
var mount_info: RichTextLabel
var selected_horse_breed: String = "horse_bay"
var is_tourney_active: bool = false
var tourney_round: int = 0
var tourney_enemy_idx: int = -1

# Морская верфь, корабли и экспедиции на острова
var shipyard_panel: PanelContainer
var shipyard_list: ItemList
var shipyard_info: RichTextLabel
var selected_ship_type: String = "ship_longboat"
var is_island_expedition_active: bool = false
var active_island_id: String = ""
var island_enemies: Array[int] = []
var island_boss_idx: int = -1'''

text = text.replace(old_vars, new_vars, 1)

# 3. Add shipyard to build_catalog
old_build_cat = '''\t{"id": "stable", "name": "🐎 Конюшня (Разведение лошадей)", "cost": {"wood": 8, "plank": 4, "wheat": 4}, "desc": "Конюшня для покупки и содержания скакунов [E] и верховой езды [R]."}
]'''

new_build_cat = '''\t{"id": "stable", "name": "🐎 Конюшня (Разведение лошадей)", "cost": {"wood": 8, "plank": 4, "wheat": 4}, "desc": "Конюшня для покупки и содержания скакунов [E] и верховой езды [R]."},
\t{"id": "shipyard", "name": "⛵ Морская Верфь (Судостроение)", "cost": {"wood": 12, "plank": 8, "iron_ingot": 4}, "desc": "Верфь для постройки кораблей [E], морского промысла и отплытия на Забытые Острова."}
]'''

text = text.replace(old_build_cat, new_build_cat, 1)

# 4. Add shipyard interaction in _handle_interaction_key
old_interact = '''\t\t\t\telif nd["type"] == "stable":
\t\t\t\t\t_open_stable_modal()
\t\t\t\t\treturn'''

new_interact = '''\t\t\t\telif nd["type"] == "stable":
\t\t\t\t\t_open_stable_modal()
\t\t\t\t\treturn
\t\t\t\telif nd["type"] == "shipyard":
\t\t\t\t\t_open_shipyard_modal()
\t\t\t\t\treturn'''

text = text.replace(old_interact, new_interact, 1)

# 5. Add modal builder in _build_ui_hud
old_hud_modal = '''\t_build_alchemy_modal(canvas)
\t_build_stable_modal(canvas)'''

new_hud_modal = '''\t_build_alchemy_modal(canvas)
\t_build_stable_modal(canvas)
\t_build_shipyard_modal(canvas)'''

text = text.replace(old_hud_modal, new_hud_modal, 1)

# 6. Add shipyard_panel to _close_all_modals
old_close = '''\tif mount_panel: mount_panel.visible = false'''
new_close = '''\tif mount_panel: mount_panel.visible = false
\tif shipyard_panel: shipyard_panel.visible = false'''

text = text.replace(old_close, new_close, 1)

# 7. Add island expedition trigger in _enter_overworld_location
old_enter_loc = '''\t\telif loc.get("id") == "capital_olderia":
\t\t\t_start_royal_tournament(1)
\t\t\treturn'''

new_enter_loc = '''\t\telif loc.get("id") == "capital_olderia":
\t\t\t_start_royal_tournament(1)
\t\t\treturn
\t\telif loc.get("type") == "island":
\t\t\t_start_island_expedition(loc["id"])
\t\t\treturn'''

text = text.replace(old_enter_loc, new_enter_loc, 1)

# 8. Add island check in _hit_npc
old_hit = '''\t\tif is_tourney_active:
\t\t\t_check_tournament_progress()'''

new_hit = '''\t\tif is_tourney_active:
\t\t\t_check_tournament_progress()
\t\tif is_island_expedition_active:
\t\t\t_check_island_expedition_progress()'''

text = text.replace(old_hit, new_hit, 1)

# 9. Append shipyard and island expedition code
shipyard_and_island_code = '''

# =========================================================
# МОРСКАЯ ВЕРФЬ, СУДОСТРОЕНИЕ И ЭКСПЕДИЦИИ НА ОСТРОВА ⛵🌴🗿
# =========================================================
func _build_shipyard_modal(canvas: CanvasLayer) -> void:
\tshipyard_panel = PanelContainer.new()
\tshipyard_panel.position = Vector2(250, 75)
\tshipyard_panel.custom_minimum_size = Vector2(780, 500)
\tshipyard_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
\tshipyard_panel.visible = false
\tcanvas.add_child(shipyard_panel)
\t
\tvar vbox = VBoxContainer.new()
\tvbox.add_theme_constant_override("separation", 10)
\tshipyard_panel.add_child(vbox)
\t
\tvar top_h = HBoxContainer.new()
\ttop_h.add_theme_constant_override("separation", 12)
\tvbox.add_child(top_h)
\t
\tvar title = Label.new()
\ttitle.text = "⛵ МОРСКАЯ ВЕРФЬ И СУДОСТРОЕНИЕ"
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
\tshipyard_list = ItemList.new()
\tshipyard_list.custom_minimum_size = Vector2(320, 360)
\tshipyard_list.item_selected.connect(_on_shipyard_item_selected)
\tleft_p.add_child(shipyard_list)
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
\tshipyard_info = RichTextLabel.new()
\tshipyard_info.bbcode_enabled = true
\tshipyard_info.custom_minimum_size = Vector2(380, 300)
\tright_p.add_child(shipyard_info)
\t
\tvar act_h = HBoxContainer.new()
\tact_h.add_theme_constant_override("separation", 12)
\tright_v.add_child(act_h)
\t
\tvar build_btn = Button.new()
\tbuild_btn.text = "🔨 Построить Судно"
\t_style_button(build_btn)
\tbuild_btn.pressed.connect(_buy_selected_ship)
\tact_h.add_child(build_btn)
\t
\tvar fish_btn = Button.new()
\tfish_btn.text = "🐟 Морской Промысел"
\t_style_button(fish_btn)
\tfish_btn.pressed.connect(_sail_sea_fishing)
\tact_h.add_child(fish_btn)

func _open_shipyard_modal() -> void:
\t_close_all_modals()
\tis_ui_open = true
\tshipyard_panel.visible = true
\tselected_ship_type = "ship_longboat"
\t_refresh_shipyard_modal()

func _refresh_shipyard_modal() -> void:
\tshipyard_list.clear()
\tfor s_id in NavalSystem.SHIPS.keys():
\t\tvar s = NavalSystem.SHIPS[s_id]
\t\tshipyard_list.add_item("%s %s — %d з. (%d др.)" % [s.get("icon", "⛵"), s.get("name", ""), s.get("cost", 60), s.get("wood_cost", 8)])
\t\tshipyard_list.set_item_metadata(shipyard_list.get_item_count() - 1, s_id)
\t\t
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tNavalSystem.ensure_naval_data(p)
\t
\tvar s = NavalSystem.SHIPS.get(selected_ship_type, NavalSystem.SHIPS["ship_longboat"])
\tvar active_s = p.settlement.get("active_ship", "") if p else ""
\tvar has_ship = (active_s != "")
\t
\tshipyard_info.text = """[b][font_size=18]%s %s[/font_size][/b]
[b]Стоимость верфи:[/b] [color=gold]%d золотых[/color]
[b]Необходимые материалы:[/b] %d бревен дерева

[color=lightgray]%s[/color]

---------------------------------------------------------
[b]Флагман поселения в гавани:[/b] %s

[color=lightblue]💡 Возможности флота:[/color]
 • Рыбалка в открытом море (Лосось, Тунец, Жемчуг 🦪)
 • Плавание на Забытые Острова за пиратскими сокровищами через карту мира [M]!
""" % [
\t\ts.get("icon", "⛵"), s.get("name", ""),
\t\ts.get("cost", 60),
\t\ts.get("wood_cost", 8),
\t\ts.get("desc", ""),
\t\t(active_s if has_ship else "Нет корабля в гавани")
\t]

func _on_shipyard_item_selected(idx: int) -> void:
\tvar s_id = shipyard_list.get_item_metadata(idx)
\tif s_id:
\t\tselected_ship_type = s_id
\t\t_refresh_shipyard_modal()

func _buy_selected_ship() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar res = NavalSystem.build_ship(p, selected_ship_type)
\tif res.get("success", false):
\t\t_log("[color=gold][b]⛵ СУДОСТРОЕНИЕ: Со стапелей верфи спущен новый корабль: %s %s![/b][/color]" % [res.get("icon", "⛵"), res.get("name", "")])
\t\t_spawn_spark_particles(player_pos, Color.CYAN)
\t\t_spawn_floating_text(player_pos, "⛵ " + res.get("name", ""), Color.CYAN, 18)
\t\t_refresh_shipyard_modal()
\telse:
\t\t_log("[color=red]⚠️ %s[/color]" % res.get("reason", "Ошибка постройки судна"))

func _sail_sea_fishing() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar res = NavalSystem.go_sea_fishing(p)
\tif res.get("success", false):
\t\t_log("[color=lightblue]🌊 [b]МОРСКОЙ ПРОМЫСЕЛ:[/b] Ваш корабль вернулся из открытого моря с богатым уловом: %s %s x%d![/color]" % [res.get("icon", "🐟"), res.get("name", ""), res.get("count", 1)])
\t\t_spawn_spark_particles(player_pos, Color.CYAN)
\t\t_spawn_floating_text(player_pos, "+%d %s" % [res.get("count", 1), res.get("name", "")], Color.CYAN, 18)
\t\t_refresh_shipyard_modal()
\telse:
\t\t_log("[color=orange]⚓ %s[/color]" % res.get("reason", "Нет корабля"))

func _start_island_expedition(island_id: String) -> void:
\t_close_all_modals()
\tif is_overworld_mode:
\t\t_toggle_overworld_mode()
\t\t
\tis_island_expedition_active = true
\tactive_island_id = island_id
\tisland_enemies.clear()
\t
\tvar island_name = "Остров Пиратских Бухт" if island_id == "island_isle_of_coves" else "Затонувший Храм Морей"
\tvar is_temple = (island_id == "island_ancient_temple")
\tvar enemy_count = 12 if is_temple else 8
\t
\t_log("[color=gold][b]🌴 МОРСКАЯ ЭКСПЕДИЦИЯ: Высадка на «%s»![/b][/color]" % island_name)
\t_log("[color=yellow]Корабль бросил якорь в лагуне! Дружина десантируется на неизведанный берег![/color]")
\t_spawn_spark_particles(player_pos, Color.GOLD)
\t_spawn_floating_text(player_pos, "🌴 ЭКСПЕДИЦИЯ: " + island_name.to_upper(), Color.GOLD, 22)
\t
\t# Спавним пиратов и морских корсаров
\tfor i in range(enemy_count):
\t\tvar sp = Vector2i(randi_range(18, 28), randi_range(10, 17))
\t\tvar w_pos = Vector2(sp.x * TILE_SIZE + TILE_SIZE/2.0, sp.y * TILE_SIZE + TILE_SIZE/2.0)
\t\tvar is_boss = (is_temple and i == 0)
\t\t
\t\tvar npc_entry = {
\t\t\t"id": "pirate_%d" % i,
\t\t\t"name": ("Капитан Черная Борода" if is_boss else "Морской Корсар"),
\t\t\t"role": "Бандит",
\t\t\t"hp": (320.0 if is_boss else 85.0),
\t\t\t"max_hp": (320.0 if is_boss else 85.0),
\t\t\t"defense": (15 if is_boss else 8),
\t\t\t"gold": (70 if is_boss else 18),
\t\t\t"home_tile": sp,
\t\t\t"target_pos": player_pos,
\t\t\t"idle_timer": 0.0,
\t\t\t"walk_speed": 52.0,
\t\t\t"is_dead": false,
\t\t\t"is_hostile": true,
\t\t\t"is_ranged": (i % 2 == 1),
\t\t\t"shoot_cooldown": randf_range(1.5, 3.0),
\t\t\t"is_boss": is_boss,
\t\t\t"traits": ["Морской Разбойник", "Головорез"]
\t\t}
\t\t
\t\tnpc_data.append(npc_entry)
\t\tnpc_positions.append(w_pos)
\t\tvar n_idx = npc_data.size() - 1
\t\tisland_enemies.append(n_idx)
\t\tif is_boss: island_boss_idx = n_idx
\t\t
\t\tvar spr = Sprite2D.new()
\t\tspr.texture = SpriteGenerator2D.get_character_texture("bandit", TILE_SIZE)
\t\tspr.position = w_pos
\t\tadd_child(spr)
\t\tnpc_sprites.append(spr)
\t\t
\tplayer_pos = Vector2(23.5 * TILE_SIZE, 22.0 * TILE_SIZE)

func _check_island_expedition_progress() -> void:
\tif not is_island_expedition_active: return
\t
\tvar alive_count := 0
\tfor idx in island_enemies:
\t\tif idx < npc_data.size() and not npc_data[idx].get("is_dead", false):
\t\t\talive_count += 1
\t\t\t
\tif alive_count == 0:
\t\t_on_island_expedition_victory()

func _on_island_expedition_victory() -> void:
\tis_island_expedition_active = false
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar gold_gain = 380 if active_island_id == "island_isle_of_coves" else 550
\tp.settlement["treasury"] = int(p.settlement.get("treasury", 0)) + gold_gain
\tp.renown += 60
\tp.honor += 40
\tp.inventory["pearl"] = p.inventory.get("pearl", 0) + 2
\tp.inventory["silk"] = p.inventory.get("silk", 0) + 3
\tp.inventory["spices"] = p.inventory.get("spices", 0) + 2
\tif active_island_id == "island_ancient_temple":
\t\tp.inventory["ancient_relic"] = p.inventory.get("ancient_relic", 0) + 1
\t\t
\t_log("[color=gold][b]🏆 ВЕЛИКИЙ ТРИУМФ! Остров полностью зачищен от пиратов![/b][/color]")
\t_log("[color=yellow]💰 Сундуки корсаров разграблены: +%d золотых в казну города![/color]" % gold_gain)
\t_log("[color=lightgreen]🦪 Добыты заморские сокровища: +2 Жемчуга, +3 Имперского Шелка, +2 Пряностей![/color]")
\t_log("[color=cyan]👑 Королевская Слава (+60 Славы, +40 Чести)![/color]")
\t_spawn_spark_particles(player_pos, Color.GOLD)
\t_spawn_floating_text(player_pos, "🏆 ОСТРОВ ЗАХВАЧЕН! +%d ЗОЛОТА В КАЗНУ" % gold_gain, Color.GOLD, 24)
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + shipyard_and_island_code)

print('Successfully patched GameWorld2D.gd for Batch 16!')
