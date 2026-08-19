with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

target = 'var siege_boss_idx: int = -1'
replacement = '''var siege_boss_idx: int = -1

# Верховая езда, конюшни и рыцарские турниры
var is_mounted: bool = false
var mount_panel: PanelContainer
var mount_list: ItemList
var mount_info: RichTextLabel
var selected_horse_breed: String = "horse_bay"
var is_tourney_active: bool = false
var tourney_round: int = 0
var tourney_enemy_idx: int = -1'''

text = text.replace(target, replacement, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print('Inserted mount & tournament variables successfully!')
