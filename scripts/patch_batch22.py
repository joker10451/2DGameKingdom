with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload LivingDialogueSystem
old_preload = '''const AtmosphereSystem = preload("res://src/world/AtmosphereSystem.gd")'''
new_preload = '''const AtmosphereSystem = preload("res://src/world/AtmosphereSystem.gd")
const LivingDialogueSystem = preload("res://src/world/LivingDialogueSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Add bard variables
old_vars = '''# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary'''

new_vars = '''# Бродячий Бард в Таверне 🎸🎶🍻
var bard_panel: PanelContainer
var bard_ballad_list: ItemList
var bard_dialogue_text: RichTextLabel
var selected_ballad_id: String = "king_ballad"
var bard_npc_idx: int = -1

# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary'''

text = text.replace(old_vars, new_vars, 1)

# 3. Add _build_bard_modal in _build_ui_hud
old_hud = '''\t_build_shipyard_modal(canvas)
\t_build_dog_modal(canvas)'''

new_hud = '''\t_build_shipyard_modal(canvas)
\t_build_dog_modal(canvas)
\t_build_bard_modal(canvas)'''

text = text.replace(old_hud, new_hud, 1)

# 4. Add bard_panel in _close_all_modals
old_close = '''\tif dog_panel: dog_panel.visible = false'''
new_close = '''\tif dog_panel: dog_panel.visible = false
\tif bard_panel: bard_panel.visible = false'''

text = text.replace(old_close, new_close, 1)

# 5. Spawn Bard in _generate_world_npcs
old_npc_spawn = '''\t# Спавн базовых жителей деревни (5 жителей)'''
new_npc_spawn = '''\t# Спавн бродячего барда в таверне
\tvar bard_pos = Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE)
\tvar bard_entry = {
\t\t"id": "bard_luthien",
\t\t"name": "Бард Сэр Лютиен 🎸",
\t\t"role": "Бард",
\t\t"role_prof": "bard",
\t\t"hp": 80.0,
\t\t"max_hp": 80.0,
\t\t"gold": 25,
\t\t"home_tile": Vector2i(24, 25),
\t\t"target_pos": bard_pos,
\t\t"idle_timer": 0.0,
\t\t"walk_speed": 40.0,
\t\t"is_dead": false,
\t\t"is_hostile": false
\t}
\tnpc_data.append(bard_entry)
\tnpc_positions.append(bard_pos)
\tbard_npc_idx = npc_data.size() - 1
\tvar bard_spr = Sprite2D.new()
\tbard_spr.texture = SpriteGenerator2D.get_character_texture("villager", TILE_SIZE)
\tbard_spr.modulate = Color(0.85, 0.55, 0.95) # Фиолетовый бархатный наряд барда
\tbard_spr.position = bard_pos
\tadd_child(bard_spr)
\tnpc_sprites.append(bard_spr)

\t# Спавн базовых жителей деревни (5 жителей)'''

text = text.replace(old_npc_spawn, new_npc_spawn, 1)

# 6. Use LivingDialogueSystem in _open_dialogue
old_open_diag = '''func _open_dialogue(npc: Dictionary) -> void:
\t_close_all_modals()
\tis_ui_open = true
\tdialogue_panel.visible = true
\t
\tvar r = npc.get("role", "Крестьянин")
\tdialogue_title.text = "Разговор: %s (%s)" % [npc.get("name", "Житель"), r]
\t
\t# Очистка старых опций
\tfor c in dialogue_options_container.get_children():
\t\tc.queue_free()
\t\t
\tvar dia_data = DialogueDatabase.get_dialogue(r)
\tdialogue_text.text = dia_data.get("text", "Приветствую тебя, путник!")'''

new_open_diag = '''func _open_dialogue(npc: Dictionary) -> void:
\tif npc.get("id", "") == "bard_luthien":
\t\t_open_bard_modal()
\t\treturn
\t\t
\t_close_all_modals()
\tis_ui_open = true
\tdialogue_panel.visible = true
\t
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tvar cur_hour = gm.game_hour if gm else 12
\t
\tvar l_data = LivingDialogueSystem.get_dialogue_content(npc, p, current_weather, cur_hour)
\tdialogue_title.text = "Разговор: %s" % l_data.get("title", npc.get("name", "Житель"))
\tdialogue_text.text = l_data.get("text", "Приветствую тебя, путник!")
\t
\t# Очистка старых опций
\tfor c in dialogue_options_container.get_children():
\t\tc.queue_free()
\t\t
\tvar r = npc.get("role", "Крестьянин")
\tvar dia_data = DialogueDatabase.get_dialogue(r)'''

text = text.replace(old_open_diag, new_open_diag, 1)

# 7. Append Bard Modal implementation
bard_code = '''

# =========================================================
# БРОДЯЧИЙ БАРД В ТАВЕРНЕ И БАЛЛАДЫ 🎸🎶🍻
# =========================================================
func _build_bard_modal(canvas: CanvasLayer) -> void:
\tbard_panel = PanelContainer.new()
\tbard_panel.position = Vector2(260, 90)
\tbard_panel.custom_minimum_size = Vector2(760, 480)
\tbard_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
\tbard_panel.visible = false
\tcanvas.add_child(bard_panel)
\t
\tvar vbox = VBoxContainer.new()
\tvbox.add_theme_constant_override("separation", 12)
\tbard_panel.add_child(vbox)
\t
\tvar top_h = HBoxContainer.new()
\ttop_h.add_theme_constant_override("separation", 12)
\tvbox.add_child(top_h)
\t
\tvar title = Label.new()
\ttitle.text = "🎸 БРОДЯЧИЙ БАРД СЭР ЛЮТИЕН"
\ttitle.add_theme_font_size_override("font_size", 18)
\ttitle.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
\ttop_h.add_child(title)
\t
\tvar spacer = Control.new()
\tspacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
\ttop_h.add_child(spacer)
\t
\tvar close_btn = Button.new()
\tclose_btn.text = "✖ Отойти [ ESC ]"
\t_style_button(close_btn)
\tclose_btn.pressed.connect(_close_all_modals)
\ttop_h.add_child(close_btn)
\t
\tvar body_h = HBoxContainer.new()
\tbody_h.size_flags_vertical = Control.SIZE_EXPAND_FILL
\tbody_h.add_theme_constant_override("separation", 14)
\tvbox.add_child(body_h)
\t
\tvar left_p = PanelContainer.new()
\tleft_p.custom_minimum_size = Vector2(320, 360)
\tleft_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
\tbody_h.add_child(left_p)
\t
\tbard_ballad_list = ItemList.new()
\tbard_ballad_list.custom_minimum_size = Vector2(300, 340)
\tbard_ballad_list.item_selected.connect(_on_ballad_selected)
\tleft_p.add_child(bard_ballad_list)
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
\tbard_dialogue_text = RichTextLabel.new()
\tbard_dialogue_text.bbcode_enabled = true
\tbard_dialogue_text.custom_minimum_size = Vector2(380, 280)
\tright_p.add_child(bard_dialogue_text)
\t
\tvar act_h = HBoxContainer.new()
\tact_h.add_theme_constant_override("separation", 10)
\tright_v.add_child(act_h)
\t
\tvar play_btn = Button.new()
\tplay_btn.text = "🎶 Заказать Балладу (5 з.)"
\t_style_button(play_btn)
\tplay_btn.pressed.connect(_play_selected_ballad)
\tact_h.add_child(play_btn)

func _open_bard_modal() -> void:
\t_close_all_modals()
\tis_ui_open = true
\tbard_panel.visible = true
\tselected_ballad_id = "king_ballad"
\t_refresh_bard_modal()

func _refresh_bard_modal() -> void:
\tbard_ballad_list.clear()
\tfor b_id in LivingDialogueSystem.BALLADS.keys():
\t\tvar b = LivingDialogueSystem.BALLADS[b_id]
\t\tbard_ballad_list.add_item("%s %s" % [b.get("icon", "🎵"), b.get("title", "")])
\t\tbard_ballad_list.set_item_metadata(bard_ballad_list.get_item_count() - 1, b_id)
\t\t
\tvar b = LivingDialogueSystem.BALLADS.get(selected_ballad_id, LivingDialogueSystem.BALLADS["king_ballad"])
\tvar verses_str = ""
\tfor l in b.get("lines", []):
\t\tverses_str += "  [i]«" + l + "»[/i]\\n"
\t\t
\tbard_dialogue_text.text = """[b][font_size=18]🎸 Сэр Лютиен: «Приветствую, благородный лорд!»[/font_size][/b]

[color=lightgray]Любуясь пляской пламени в камине, бард мягко перебирает струны своей верной лютни.
В таверне звенит эль, и вся деревня замирает в ожидании славной песни...[/color]

[b]Выбранная песнь:[/b] [color=gold]%s[/color]
[b]Стоимость исполнения:[/b] 5 золотых монет

%s

[color=lightblue]💡 Эффект песни:[/color]
Все посетители таверны подпевают хором, чокаются кружками эля и получают [b]+30 к Настроению[/b]!
""" % [b.get("title", ""), verses_str]

func _on_ballad_selected(idx: int) -> void:
\tvar b_id = bard_ballad_list.get_item_metadata(idx)
\tif b_id:
\t\tselected_ballad_id = b_id
\t\t_refresh_bard_modal()

func _play_selected_ballad() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tif p.gold < 5:
\t\t_log("[color=orange]🪙 У вас недостаточно золота для заказа баллады (нужно 5 з.).[/color]")
\t\treturn
\t\t
\tp.gold -= 5
\tvar b = LivingDialogueSystem.BALLADS.get(selected_ballad_id, LivingDialogueSystem.BALLADS["king_ballad"])
\t
\t_log("[color=gold][b]🎶 БАРД ЗАИГРАЛ: %s![/b][/color]" % b.get("title", ""))
\tfor l in b.get("lines", []):
\t\t_log("[color=yellow]  🎸 [i]%s[/i][/color]" % l)
\t\t
\t_log("[color=green][b]🍻 ЗАСТОЛЬЕ: Вся таверна ликует, чокается кружками эля и поет хором (+30 Mood)![/b][/color]")
\t
\t# Поднимаем настроение всем жителям в городе
\tvar citizens: Array = p.settlement.get("citizens", [])
\tfor c in citizens:
\t\tc["drank_ale_today"] = true
\t\tc["hunger"] = 100.0
\t\t
\t_spawn_spark_particles(Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE), Color.GOLD)
\t_spawn_floating_text(Vector2(24.5 * TILE_SIZE, 25.5 * TILE_SIZE), "🎶 ПЕСНЬ БАРДА! 🍻 ЧОКНУЛИСЬ ЭЛЕМ!", Color.GOLD, 20)
\t_refresh_bard_modal()
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + bard_code)

print('Successfully patched GameWorld2D.gd for Batch 22 Living Dialogues and Bard!')
