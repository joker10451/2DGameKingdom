with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preload
old_pre = '''const WorldDecorationsSystemScript = preload("res://src/world/WorldDecorationsSystem.gd")'''
new_pre = '''const WorldDecorationsSystemScript = preload("res://src/world/WorldDecorationsSystem.gd")
const FaunaVisualLayerScript = preload("res://src/world/FaunaVisualLayer.gd")

var fauna_visual_layer: Node2D'''
text = text.replace(old_pre, new_pre, 1)

# 2. Add child in _ready()
old_init = '''\tworld_decorations_system = WorldDecorationsSystemScript.new()'''
new_init = '''\tworld_decorations_system = WorldDecorationsSystemScript.new()
\tfauna_visual_layer = FaunaVisualLayerScript.new()
\tfauna_visual_layer.name = "FaunaVisualLayer"
\tadd_child(fauna_visual_layer)'''
text = text.replace(old_init, new_init, 1)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("FaunaVisualLayer attached to GameWorld2D.gd!")
