with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload PetCompanionSystem
old_preload = '''const InteriorSystem = preload("res://src/economy/InteriorSystem.gd")'''
new_preload = '''const InteriorSystem = preload("res://src/economy/InteriorSystem.gd")
const PetCompanionSystem = preload("res://src/character/PetCompanionSystem.gd")'''

text = text.replace(old_preload, new_preload, 1)

# 2. Add dog variables
old_vars = '''# Морская верфь, корабли и экспедиции на острова
var shipyard_panel: PanelContainer'''

new_vars = '''# Морская верфь, корабли и экспедиции на острова
var shipyard_panel: PanelContainer

# Преданный пес-компаньон 🐕❤️
var dog_data: Dictionary = {
\t"is_tamed": false,
\t"name": "Бродячий пес",
\t"loyalty": 0,
\t"state": "stay",
\t"hp": 80.0,
\t"max_hp": 80.0,
\t"hunger": 20.0
}
var dog_pos: Vector2 = Vector2.ZERO
var dog_sprite: Sprite2D
var dog_panel: PanelContainer
var dog_dialogue_text: RichTextLabel
var dog_bark_cooldown: float = 0.0
var dog_thought_timer: float = 0.0'''

text = text.replace(old_vars, new_vars, 1)

# 3. Initialize dog in _ready
old_ready_spawn = '''\t_generate_world_npcs()
\t_build_ui_hud(hud_canvas)'''

new_ready_spawn = '''\t_generate_world_npcs()
\t_spawn_dog_companion()
\t_build_ui_hud(hud_canvas)'''

text = text.replace(old_ready_spawn, new_ready_spawn, 1)

# 4. Add _build_dog_modal in _build_ui_hud
old_hud = '''\t_build_stable_modal(canvas)
\t_build_shipyard_modal(canvas)'''

new_hud = '''\t_build_stable_modal(canvas)
\t_build_shipyard_modal(canvas)
\t_build_dog_modal(canvas)'''

text = text.replace(old_hud, new_hud, 1)

# 5. Add dog_panel to _close_all_modals
old_close = '''\tif shipyard_panel: shipyard_panel.visible = false'''
new_close = '''\tif shipyard_panel: shipyard_panel.visible = false
\tif dog_panel: dog_panel.visible = false'''

text = text.replace(old_close, new_close, 1)

# 6. Add dog interaction in _handle_interaction_key
old_interact_top = '''func _handle_interaction_key() -> void:
\tvar gm = _get_game_manager()'''

new_interact_top = '''func _handle_interaction_key() -> void:
\tvar gm = _get_game_manager()
\tif dog_pos != Vector2.ZERO and dog_pos.distance_to(player_pos) <= 55.0:
\t\t_open_dog_modal()
\t\treturn'''

text = text.replace(old_interact_top, new_interact_top, 1)

# 7. Add _process_dog_companion in _physics_process
old_phys_bottom = '''\t_process_companion_party(delta)
\t_process_citizens(delta)'''

new_phys_bottom = '''\t_process_companion_party(delta)
\t_process_citizens(delta)
\t_process_dog_companion(delta)'''

text = text.replace(old_phys_bottom, new_phys_bottom, 1)

# 8. Append dog companion system code
dog_code = '''

# =========================================================
# ПРЕДАННЫЙ ПЕС-КОМПАНЬОН И ТЕПЛО ДОМА 🐕❤️🐾🔥
# =========================================================
func _spawn_dog_companion() -> void:
\tdog_pos = Vector2(16.0 * TILE_SIZE + 24.0, 50.0 * TILE_SIZE + 24.0)
\tdog_sprite = Sprite2D.new()
\tdog_sprite.texture = SpriteGenerator2D.get_character_texture("wolf", TILE_SIZE)
\tdog_sprite.modulate = Color(0.95, 0.75, 0.45) # Теплый золотисто-рыжий окрас
\tdog_sprite.position = dog_pos
\tadd_child(dog_sprite)

func _process_dog_companion(delta: float) -> void:
\tif not dog_sprite: return
\t
\tdog_thought_timer -= delta
\tdog_bark_cooldown -= delta
\t
\tif not dog_data.get("is_tamed", false):
\t\t# Дикий / бродячий пес сидит у мельницы
\t\tdog_sprite.position = dog_pos
\t\tif dog_thought_timer <= 0.0:
\t\t\tdog_thought_timer = randf_range(4.0, 7.0)
\t\t\t_spawn_floating_text(dog_pos, "🥺 *тихо поскуливает*", Color(0.9, 0.8, 0.6), 14)
\t\treturn
\t\t
\tvar state = dog_data.get("state", "follow")
\t
\t# 1. Проверка врагов поблизости (защита хозяина)
\tvar closest_hostile_idx := -1
\tvar closest_dist := 140.0
\tfor i in range(npc_data.size()):
\t\tvar n = npc_data[i]
\t\tif n.get("is_hostile", false) and not n.get("is_dead", false):
\t\t\tvar d = dog_pos.distance_to(npc_positions[i])
\t\t\tif d < closest_dist:
\t\t\t\tclosest_dist = d
\t\t\t\tclosest_hostile_idx = i
\t\t\t\t
\tif closest_hostile_idx != -1 and state != "stay":
\t\t# Бежим в атаку на врага!
\t\tvar target_pos = npc_positions[closest_hostile_idx]
\t\tvar dir = (target_pos - dog_pos).normalized()
\t\tdog_pos += dir * 90.0 * delta
\t\tdog_sprite.position = dog_pos
\t\t
\t\tif closest_dist <= 25.0 and dog_bark_cooldown <= 0.0:
\t\t\tdog_bark_cooldown = 2.0
\t\t\tvar bite_dmg = PetCompanionSystem.get_combat_bite_damage(dog_data)
\t\t\tnpc_data[closest_hostile_idx]["hp"] = maxf(0.0, float(npc_data[closest_hostile_idx].get("hp", 50.0)) - bite_dmg)
\t\t\t_log("[color=gold]🐕 [b]%s[/b] с лаем вцепился во врага и нанес %.0f урона![/color]" % [dog_data.get("name", "Пес"), bite_dmg])
\t\t\t_spawn_floating_text(npc_positions[closest_hostile_idx], "🐕 УКУС! -%.0f" % bite_dmg, Color.GOLD, 16)
\t\t\t_spawn_spark_particles(dog_pos, Color.GOLD)
\t\treturn
\t\t
\t# 2. Следование за игроком
\tif state == "follow":
\t\tvar dist_to_player = dog_pos.distance_to(player_pos)
\t\tif dist_to_player > 42.0:
\t\t\tvar dir = (player_pos - dog_pos).normalized()
\t\t\tvar dog_speed = 85.0 if dist_to_player < 100.0 else 140.0
\t\t\tdog_pos += dir * dog_speed * delta
\t\t\tdog_sprite.position = dog_pos
\t\t\t
\t\tif dog_thought_timer <= 0.0:
\t\t\tdog_thought_timer = randf_range(5.0, 9.0)
\t\t\tvar dog_emotes = ["🐶 ГАВ!", "🐾 *радостно виляет хвостом*", "❤️ *бежит рядом*", "🦋 *ловит бабочку*"]
\t\t\t_spawn_floating_text(dog_pos, dog_emotes[randi() % dog_emotes.size()], Color(1.0, 0.9, 0.6), 14)
\t\t\t
\t# 3. Охрана места
\telif state == "stay":
\t\tdog_sprite.position = dog_pos
\t\tif dog_thought_timer <= 0.0:
\t\t\tdog_thought_timer = randf_range(7.0, 12.0)
\t\t\t_spawn_floating_text(dog_pos, "🐾 *сторожит на месте*", Color(0.9, 0.8, 0.6), 14)

func _build_dog_modal(canvas: CanvasLayer) -> void:
\tdog_panel = PanelContainer.new()
\tdog_panel.position = Vector2(280, 100)
\tdog_panel.custom_minimum_size = Vector2(720, 440)
\tdog_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.10, 0.11, 0.16, 0.98), Color(0.85, 0.70, 0.30), 2, 8))
\tdog_panel.visible = false
\tcanvas.add_child(dog_panel)
\t
\tvar vbox = VBoxContainer.new()
\tvbox.add_theme_constant_override("separation", 12)
\tdog_panel.add_child(vbox)
\t
\tvar top_h = HBoxContainer.new()
\ttop_h.add_theme_constant_override("separation", 12)
\tvbox.add_child(top_h)
\t
\tvar title = Label.new()
\ttitle.text = "🐕 ПРЕДАННЫЙ ЧЕТВЕРОНОГИЙ ДРУГ"
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
\tvar body_p = PanelContainer.new()
\tbody_p.size_flags_vertical = Control.SIZE_EXPAND_FILL
\tbody_p.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.9), Color(0.6, 0.5, 0.25), 1, 6))
\tvbox.add_child(body_p)
\t
\tdog_dialogue_text = RichTextLabel.new()
\tdog_dialogue_text.bbcode_enabled = true
\tdog_dialogue_text.custom_minimum_size = Vector2(680, 240)
\tbody_p.add_child(dog_dialogue_text)
\t
\tvar act_h = HBoxContainer.new()
\tact_h.add_theme_constant_override("separation", 10)
\tvbox.add_child(act_h)
\t
\tvar feed_btn = Button.new()
\tfeed_btn.text = "🍖 Угостить мясом / рыбой"
\t_style_button(feed_btn)
\tfeed_btn.pressed.connect(func(): _feed_dog_food("meat_cooked"))
\tact_h.add_child(feed_btn)
\t
\tvar pet_btn = Button.new()
\tpet_btn.text = "✋ Погладить за ушком ❤️"
\t_style_button(pet_btn)
\tpet_btn.pressed.connect(_pet_dog_companion)
\tact_h.add_child(pet_btn)
\t
\tvar paw_btn = Button.new()
\tpaw_btn.text = "🐾 Дай лапу!"
\t_style_button(paw_btn)
\tpaw_btn.pressed.connect(_dog_give_paw_action)
\tact_h.add_child(paw_btn)
\t
\tvar follow_btn = Button.new()
\tfollow_btn.text = "🚶‍♂️ За мной / Охраняй"
\t_style_button(follow_btn)
\tfollow_btn.pressed.connect(_toggle_dog_stay)
\tact_h.add_child(follow_btn)
\t
\tvar name_btn = Button.new()
\tname_btn.text = "🏷️ Дать кличку"
\t_style_button(name_btn)
\tname_btn.pressed.connect(_rename_dog_prompt)
\tact_h.add_child(name_btn)

func _open_dog_modal() -> void:
\t_close_all_modals()
\tis_ui_open = true
\tdog_panel.visible = true
\t_refresh_dog_modal()

func _refresh_dog_modal() -> void:
\tvar is_t = dog_data.get("is_tamed", false)
\tvar d_name = dog_data.get("name", "Бродячий пес")
\tvar loyalty = dog_data.get("loyalty", 0)
\tvar state = dog_data.get("state", "stay")
\t
\tif not is_t:
\t\tdog_dialogue_text.text = """[b][font_size=18]🐕 Бродячий Пес[/font_size][/b]

[color=lightgray]Перед вами сидит лохматый худой пес с умными и немного грустными глазами.
Он тихо поскуливает от холода и с надеждой смотрит на вас, прижимая уши. 
В его взгляде читается тоска по заботе и теплому очагу...[/color]

[b]Статус:[/b] [color=orange]Бродячий и одинокий 🥺[/color]
[color=gold]💡 Угостите его жареным мясом или рыбкой, чтобы заслужить его доверие и сделать верным спутником![/color]
"""
\telse:
\t\tvar state_str = "Бежит рядом 🐾" if state == "follow" else "Охраняет место 🛑"
\t\tdog_dialogue_text.text = """[b][font_size=18]🐕 %s — Ваш Верный Пес[/font_size][/b]

[color=lightgreen]Пес радостно крутится вокруг ваших ног, довольно сопит и преданно заглядывает вам в глаза.
Рядом с ним на душе становится спокойно и тепло. В бою он защитит вас от волков и бандитов![/color]

[b]Уровень привязанности (Loyalty):[/b] [color=gold]%d / 100 ❤️[/color]
[b]Текущая команда:[/b] %s
[b]Здоровье друга:[/b] %.0f / %.0f HP

[color=lightblue]🔥 Домашний уют:[/color]
Когда вы дома у камина, пес ложится спать у ваших ног на теплый ковер и тихо посапывает.
""" % [
\t\t\td_name, loyalty, state_str,
\t\t\tdog_data.get("hp", 80.0), dog_data.get("max_hp", 80.0)
\t\t]

func _feed_dog_food(food_pref: String) -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return
\t
\tvar chosen_food = ""
\tfor f_id in ["meat_cooked", "meat_raw", "fish_trout", "fish_salmon", "fish_soup", "bread"]:
\t\tif p.get_item_count(f_id) > 0:
\t\t\tchosen_food = f_id
\t\t\tbreak
\t\t\t
\tif chosen_food == "":
\t\t_log("[color=orange]🍖 У вас нет еды для пса (нужно жареное мясо, рыба, уха или хлеб).[/color]")
\t\t_refresh_dog_modal()
\t\treturn
\t\t
\tvar res = PetCompanionSystem.feed_pet(p, dog_data, chosen_food)
\tif res.get("success", false):
\t\t_log("[color=gold][b]❤️ %s[/b][/color]" % res.get("message", ""))
\t\t_spawn_spark_particles(dog_pos, Color.GOLD)
\t\t_spawn_floating_text(dog_pos, "❤️ ДОВЕРИЕ И ДРУЖБА!", Color.GOLD, 20)
\t\t_refresh_dog_modal()

func _pet_dog_companion() -> void:
\tvar res = PetCompanionSystem.pet_dog(dog_data)
\t_log("[color=lightgreen]🐾 %s[/color]" % res.get("message", ""))
\t_spawn_floating_text(dog_pos, "❤️ *довольно сопит*", Color(1.0, 0.8, 0.9), 16)
\t_spawn_spark_particles(dog_pos, Color.PINK)
\t_refresh_dog_modal()

func _dog_give_paw_action() -> void:
\tvar res = PetCompanionSystem.give_paw(dog_data)
\t_log("[color=gold]🐾 %s[/color]" % res.get("message", ""))
\t_spawn_floating_text(dog_pos, "🐾 ДАЛ ЛАПУ!", Color.GOLD, 16)
\t_refresh_dog_modal()

func _toggle_dog_stay() -> void:
\tif not dog_data.get("is_tamed", false):
\t\t_feed_dog_food("meat_cooked")
\t\treturn
\t\t
\tvar cur_st = dog_data.get("state", "follow")
\tif cur_st == "follow":
\t\tdog_data["state"] = "stay"
\t\t_log("[color=yellow]🛑 Вы велели псу оставаться на месте и охранять.[/color]")
\t\t_spawn_floating_text(dog_pos, "🛑 ОХРАНЯТЬ", Color.YELLOW, 16)
\telse:
\t\tdog_data["state"] = "follow"
\t\t_log("[color=green]🚶‍♂️ Пес радостно вскочил и бежит за вами![/color]")
\t\t_spawn_floating_text(dog_pos, "🚶‍♂️ ЗА МНОЙ!", Color.GREEN, 16)
\t_refresh_dog_modal()

func _rename_dog_prompt() -> void:
\tvar names = PetCompanionSystem.PET_NAMES
\tvar cur_name = dog_data.get("name", "Верный")
\tvar n_idx = (names.find(cur_name) + 1) % names.size()
\tdog_data["name"] = names[n_idx]
\t_log("[color=gold]🏷️ Вы назвали своего друга: [b]%s[/b]![/color]" % dog_data["name"])
\t_spawn_floating_text(dog_pos, "🐕 " + dog_data["name"], Color.GOLD, 18)
\t_refresh_dog_modal()
'''

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text + dog_code)

print('Successfully patched GameWorld2D.gd for Batch 20 Pet Companion!')
