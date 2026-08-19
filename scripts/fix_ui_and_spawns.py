# 1. Update GameWorld2D.gd HUD and Player Spawn
with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# Change default player_pos declaration
text = text.replace(
    'var player_pos := Vector2(31.5 * TILE_SIZE, 32.5 * TILE_SIZE)',
    'var player_pos := Vector2(25.0 * TILE_SIZE, 27.5 * TILE_SIZE)'
)

# Update _style_button padding
old_style_btn = '''func _style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
\tvar normal = _make_medieval_panel_style(Color(0.14, 0.15, 0.20, 0.92), Color(0.65, 0.52, 0.22), 1, 4)
\tnormal.content_margin_left = 7
\tnormal.content_margin_right = 7
\tnormal.content_margin_top = 4
\tnormal.content_margin_bottom = 4
\tvar hover = _make_medieval_panel_style(Color(0.22, 0.24, 0.32, 0.96), Color(0.95, 0.82, 0.35), 2, 4)
\thover.content_margin_left = 7
\thover.content_margin_right = 7
\thover.content_margin_top = 4
\thover.content_margin_bottom = 4
\tvar pressed = _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.96), Color(0.5, 0.4, 0.15), 2, 4)
\tpressed.content_margin_left = 7
\tpressed.content_margin_right = 7
\tpressed.content_margin_top = 4
\tpressed.content_margin_bottom = 4
\tbtn.add_theme_stylebox_override("normal", normal)
\tbtn.add_theme_stylebox_override("hover", hover)
\tbtn.add_theme_stylebox_override("pressed", pressed)
\tbtn.add_theme_color_override("font_color", icon_color)
\tbtn.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
\tbtn.add_theme_font_size_override("font_size", 12)'''

new_style_btn = '''func _style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
\tvar normal = _make_medieval_panel_style(Color(0.14, 0.15, 0.20, 0.92), Color(0.65, 0.52, 0.22), 1, 4)
\tnormal.content_margin_left = 5
\tnormal.content_margin_right = 5
\tnormal.content_margin_top = 2
\tnormal.content_margin_bottom = 2
\tvar hover = _make_medieval_panel_style(Color(0.22, 0.24, 0.32, 0.96), Color(0.95, 0.82, 0.35), 2, 4)
\thover.content_margin_left = 5
\thover.content_margin_right = 5
\thover.content_margin_top = 2
\thover.content_margin_bottom = 2
\tvar pressed = _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.96), Color(0.5, 0.4, 0.15), 2, 4)
\tpressed.content_margin_left = 5
\tpressed.content_margin_right = 5
\tpressed.content_margin_top = 2
\tpressed.content_margin_bottom = 2
\tbtn.add_theme_stylebox_override("normal", normal)
\tbtn.add_theme_stylebox_override("hover", hover)
\tbtn.add_theme_stylebox_override("pressed", pressed)
\tbtn.add_theme_color_override("font_color", icon_color)
\tbtn.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
\tbtn.add_theme_font_size_override("font_size", 11)'''

text = text.replace(old_style_btn, new_style_btn)

# Update top bar button texts
old_top_bar_block = '''\ttime_label.text = "🕒 12:00 | Весна, 1-й год"
\ttime_label.add_theme_font_size_override("font_size", 12)
\ttime_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.65))
\ttop_bar.add_child(time_label)
\t
\tvar sep = VSeparator.new()
\ttop_bar.add_child(sep)
\t
\tvar inv_btn = Button.new()
\tinv_btn.text = "🎒 Инвентарь [I]"
\t_style_button(inv_btn)
\tinv_btn.pressed.connect(_toggle_inventory)
\ttop_bar.add_child(inv_btn)
\t
\tvar skill_btn = Button.new()
\tskill_btn.text = "📖 Навыки [K]"
\t_style_button(skill_btn)
\tskill_btn.pressed.connect(_toggle_skills)
\ttop_bar.add_child(skill_btn)
\t
\tvar quest_btn = Button.new()
\tquest_btn.text = "📜 Задания [Q]"
\t_style_button(quest_btn)
\tquest_btn.pressed.connect(_toggle_contracts_menu)
\ttop_bar.add_child(quest_btn)
\t
\tvar market_btn = Button.new()
\tmarket_btn.text = "⚖️ Рынок"
\t_style_button(market_btn)
\tmarket_btn.pressed.connect(_open_market_trade)
\ttop_bar.add_child(market_btn)
\t
\tvar smith_btn = Button.new()
\tsmith_btn.text = "⚒️ Кузница"
\t_style_button(smith_btn)
\tsmith_btn.pressed.connect(_open_smithing_menu)
\ttop_bar.add_child(smith_btn)
\t
\tvar build_btn = Button.new()
\tbuild_btn.text = "🔨 Стройка [B]"
\t_style_button(build_btn)
\tbuild_btn.pressed.connect(_toggle_building_mode)
\ttop_bar.add_child(build_btn)
\t
\tvar map_btn = Button.new()
\tmap_btn.text = "🗺️ Карта [M]"
\t_style_button(map_btn)
\tmap_btn.pressed.connect(_toggle_overworld_mode)
\ttop_bar.add_child(map_btn)
\t
\tvar party_btn = Button.new()
\tparty_btn.text = "👥 Дружина [C]"
\t_style_button(party_btn)
\tparty_btn.pressed.connect(_toggle_party_menu)
\ttop_bar.add_child(party_btn)
\t
\tvar estate_btn = Button.new()
\testate_btn.text = "🏰 Поместье [H]"
\t_style_button(estate_btn)
\testate_btn.pressed.connect(_toggle_estate_menu)
\ttop_bar.add_child(estate_btn)
\t
\tvar settlement_btn = Button.new()
\tsettlement_btn.text = "🏛️ Поселение [T]"'''

new_top_bar_block = '''\ttime_label.text = "🕒 12:00 | Весна"
\ttime_label.add_theme_font_size_override("font_size", 11)
\ttime_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.65))
\ttop_bar.add_child(time_label)
\t
\tvar sep = VSeparator.new()
\ttop_bar.add_child(sep)
\t
\tvar inv_btn = Button.new()
\tinv_btn.text = "🎒 Инв. [I]"
\t_style_button(inv_btn)
\tinv_btn.pressed.connect(_toggle_inventory)
\ttop_bar.add_child(inv_btn)
\t
\tvar skill_btn = Button.new()
\tskill_btn.text = "📖 Навыки [K]"
\t_style_button(skill_btn)
\tskill_btn.pressed.connect(_toggle_skills)
\ttop_bar.add_child(skill_btn)
\t
\tvar quest_btn = Button.new()
\tquest_btn.text = "📜 Квесты [Q]"
\t_style_button(quest_btn)
\tquest_btn.pressed.connect(_toggle_contracts_menu)
\ttop_bar.add_child(quest_btn)
\t
\tvar market_btn = Button.new()
\tmarket_btn.text = "⚖️ Торг"
\t_style_button(market_btn)
\tmarket_btn.pressed.connect(_open_market_trade)
\ttop_bar.add_child(market_btn)
\t
\tvar smith_btn = Button.new()
\tsmith_btn.text = "⚒️ Кузня"
\t_style_button(smith_btn)
\tsmith_btn.pressed.connect(_open_smithing_menu)
\ttop_bar.add_child(smith_btn)
\t
\tvar build_btn = Button.new()
\tbuild_btn.text = "🔨 Стройка [B]"
\t_style_button(build_btn)
\tbuild_btn.pressed.connect(_toggle_building_mode)
\ttop_bar.add_child(build_btn)
\t
\tvar map_btn = Button.new()
\tmap_btn.text = "🗺️ Карта [M]"
\t_style_button(map_btn)
\tmap_btn.pressed.connect(_toggle_overworld_mode)
\ttop_bar.add_child(map_btn)
\t
\tvar party_btn = Button.new()
\tparty_btn.text = "👥 Отряд [C]"
\t_style_button(party_btn)
\tparty_btn.pressed.connect(_toggle_party_menu)
\ttop_bar.add_child(party_btn)
\t
\tvar estate_btn = Button.new()
\testate_btn.text = "🏰 Усадьба [H]"
\t_style_button(estate_btn)
\testate_btn.pressed.connect(_toggle_estate_menu)
\ttop_bar.add_child(estate_btn)
\t
\tvar settlement_btn = Button.new()
\tsettlement_btn.text = "🏛️ Ратуша [T]"'''

text = text.replace(old_top_bar_block, new_top_bar_block)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("GameWorld2D.gd top bar and spawn updated!")

# 2. Update WorldMap2D.gd to place Stone Fortification Outpost and Lanterns
with open('godot/src/game2d/WorldMap2D.gd', 'r', encoding='utf-8') as f:
    map_text = f.read()

old_map_spawns = '''\t# Производственные станки деревни и Доска Объявлений
\t_spawn_furniture(Vector2i(23, 21), "alarm_bell", "🔔 Тревожный Колокол Олдерии")'''

new_map_spawns = '''\t# Каменные фортификации и уличные фонари (Poly Haven)
\tfor wx in range(21, 30):
\t\tstructure_tiles[Vector2i(wx, 19)] = "wall_stone"
\tstructure_tiles[Vector2i(21, 20)] = "wall_stone"
\tstructure_tiles[Vector2i(29, 20)] = "wall_stone"
\t_spawn_furniture(Vector2i(25, 19), "door", "Крепостные Ворота 🏰")
\t_spawn_furniture(Vector2i(22, 21), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(28, 21), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(25, 27), "lantern", "Кованый Фонарь 🕯️")
\t_spawn_furniture(Vector2i(31, 31), "lantern", "Кованый Фонарь 🕯️")

\t# Производственные станки деревни и Доска Объявлений
\t_spawn_furniture(Vector2i(23, 21), "alarm_bell", "🔔 Тревожный Колокол Олдерии")'''

map_text = map_text.replace(old_map_spawns, new_map_spawns)

with open('godot/src/game2d/WorldMap2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    map_text.write(map_text)

print("WorldMap2D.gd updated with stone fortifications and street lanterns!")
