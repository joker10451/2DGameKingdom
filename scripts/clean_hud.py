with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Find the two occurrences of "func _build_ui_hud() -> void:"
hud_indices = [i for i, l in enumerate(lines) if "func _build_ui_hud() -> void:" in l]
print(f"HUD indices: {hud_indices}")

if len(hud_indices) >= 2:
    # First index is the accidental duplicate before overworld mode
    # Let's find where _style_button before it starts
    first_idx = hud_indices[0]
    style_btn_idx = -1
    for i in range(first_idx - 1, -1, -1):
        if "func _style_button(" in lines[i]:
            style_btn_idx = i
            break
            
    # Find where the duplicate ends (before # === ГЛОБАЛЬНАЯ КАРТА)
    end_idx = -1
    for i in range(first_idx, len(lines)):
        if "# === ГЛОБАЛЬНАЯ КАРТА" in lines[i]:
            end_idx = i
            break
            
    if style_btn_idx != -1 and end_idx != -1:
        print(f"Removing duplicate block from line {style_btn_idx+1} to {end_idx+1}")
        del lines[style_btn_idx:end_idx]

content = "".join(lines)

# Now update the real _style_button and _build_ui_hud
old_style_and_top = '''func _style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
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
\tbtn.add_theme_font_size_override("font_size", 12)

func _build_ui_hud() -> void:
\tvar canvas = CanvasLayer.new()
\tcanvas.name = "HUD2D"
\tadd_child(canvas)
\t
\t# Верхняя панель (Деревянно-золотая рамка)
\tvar top_panel = PanelContainer.new()
\ttop_panel.position = Vector2(16, 10)
\ttop_panel.custom_minimum_size = Vector2(1248, 40)
\ttop_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.12, 0.13, 0.17, 0.95), Color(0.75, 0.60, 0.25), 2, 6))
\tcanvas.add_child(top_panel)
\t
\tvar top_bar = HBoxContainer.new()
\ttop_bar.add_theme_constant_override("separation", 6)
\ttop_panel.add_child(top_bar)
\t
\ttime_label = Label.new()
\ttime_label.text = "🕒 12:00 | Весна, 1-й год"
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

new_style_and_top = '''func _style_button(btn: Button, icon_color: Color = Color(0.9, 0.8, 0.5)) -> void:
\tvar normal = _make_medieval_panel_style(Color(0.14, 0.15, 0.20, 0.92), Color(0.65, 0.52, 0.22), 1, 3)
\tnormal.content_margin_left = 5
\tnormal.content_margin_right = 5
\tnormal.content_margin_top = 2
\tnormal.content_margin_bottom = 2
\tvar hover = _make_medieval_panel_style(Color(0.22, 0.24, 0.32, 0.96), Color(0.95, 0.82, 0.35), 2, 3)
\thover.content_margin_left = 5
\thover.content_margin_right = 5
\thover.content_margin_top = 2
\thover.content_margin_bottom = 2
\tvar pressed = _make_medieval_panel_style(Color(0.08, 0.09, 0.12, 0.96), Color(0.5, 0.4, 0.15), 2, 3)
\tpressed.content_margin_left = 5
\tpressed.content_margin_right = 5
\tpressed.content_margin_top = 2
\tpressed.content_margin_bottom = 2
\tbtn.add_theme_stylebox_override("normal", normal)
\tbtn.add_theme_stylebox_override("hover", hover)
\tbtn.add_theme_stylebox_override("pressed", pressed)
\tbtn.add_theme_color_override("font_color", icon_color)
\tbtn.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
\tbtn.add_theme_font_size_override("font_size", 11)

func _build_ui_hud() -> void:
\tvar canvas = CanvasLayer.new()
\tcanvas.name = "HUD2D"
\tadd_child(canvas)
\t
\t# Верхняя панель (Деревянно-золотая рамка)
\tvar top_panel = PanelContainer.new()
\ttop_panel.position = Vector2(16, 8)
\ttop_panel.custom_minimum_size = Vector2(1248, 36)
\ttop_panel.add_theme_stylebox_override("panel", _make_medieval_panel_style(Color(0.12, 0.13, 0.17, 0.95), Color(0.75, 0.60, 0.25), 2, 5))
\tcanvas.add_child(top_panel)
\t
\tvar top_bar = HBoxContainer.new()
\ttop_bar.add_theme_constant_override("separation", 4)
\ttop_panel.add_child(top_bar)
\t
\ttime_label = Label.new()
\ttime_label.text = "🕒 12:00 | Весна"
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

content = content.replace(old_style_and_top, new_style_and_top)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(content)

print("GameWorld2D.gd cleaned up and real top bar updated!")
