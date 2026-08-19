class_name BuildingSystem3D
extends RefCounted

## 3D СИСТЕМА СТРОИТЕЛЬСТВА ПОСЕЛЕНИЯ В РЕАЛЬНОМ МИРЕ (KINGDOMS STYLE)
## Управляет 3D-чертежами, пространственным позиционированием, превью-призраками и размещением

const BLUEPRINTS := {
	"wall_stone": {
		"id": "wall_stone",
		"name": "Каменная Крепостная Стена Tier 2",
		"icon": "🧱",
		"category": "fortifications",
		"cost": {"stone": 4},
		"size": Vector3(3.0, 3.2, 0.8),
		"mesh_type": "box",
		"color": Color(0.65, 0.65, 0.68),
		"hp": 250
	},
	"fort_tower": {
		"id": "fort_tower",
		"name": "Круглая Дозорная Башня с Зубцами",
		"icon": "🏰",
		"category": "fortifications",
		"cost": {"stone": 12, "wood": 4},
		"size": Vector3(4.0, 7.5, 4.0),
		"mesh_type": "cylinder",
		"color": Color(0.60, 0.60, 0.64),
		"hp": 600
	},
	"fort_gate": {
		"id": "fort_gate",
		"name": "Крепостные Ворота с Аркой",
		"icon": "🚪",
		"category": "fortifications",
		"cost": {"stone": 8, "wood": 6},
		"size": Vector3(3.6, 4.0, 1.0),
		"mesh_type": "gate",
		"color": Color(0.55, 0.52, 0.48),
		"hp": 400
	},
	"lantern_post": {
		"id": "lantern_post",
		"name": "Кованый Уличный Фонарь на Столбе",
		"icon": "🕯️",
		"category": "lighting",
		"cost": {"iron_ingot": 1, "wood": 2},
		"size": Vector3(0.6, 2.6, 0.6),
		"mesh_type": "lantern",
		"color": Color(0.25, 0.22, 0.18),
		"hp": 50,
		"has_light": true
	},
	"fireplace": {
		"id": "fireplace",
		"name": "Каменный Камин с Очагом",
		"icon": "🔥",
		"category": "comfort",
		"cost": {"stone": 6, "wood": 3},
		"size": Vector3(1.6, 2.2, 1.0),
		"mesh_type": "fireplace",
		"color": Color(0.5, 0.48, 0.45),
		"hp": 150,
		"has_light": true,
		"comfort": 15
	},
	"wall_wood": {
		"id": "wall_wood",
		"name": "Частокол из Дубовых Брёвен Tier 1",
		"icon": "🪵",
		"category": "fortifications",
		"cost": {"wood": 3},
		"size": Vector3(2.5, 2.4, 0.4),
		"mesh_type": "box",
		"color": Color(0.48, 0.35, 0.22),
		"hp": 100
	},
	"table_oak": {
		"id": "table_oak",
		"name": "Массивный Дубовый Стол",
		"icon": "🪵",
		"category": "furniture",
		"cost": {"wood": 4},
		"size": Vector3(1.8, 0.9, 1.0),
		"mesh_type": "box",
		"color": Color(0.52, 0.38, 0.24),
		"hp": 80,
		"comfort": 8
	},
	"chair_oak": {
		"id": "chair_oak",
		"name": "Резной Дубовый Стул",
		"icon": "🪑",
		"category": "furniture",
		"cost": {"wood": 2},
		"size": Vector3(0.6, 1.0, 0.6),
		"mesh_type": "box",
		"color": Color(0.55, 0.40, 0.25),
		"hp": 40,
		"comfort": 5
	},
	"bed_oak": {
		"id": "bed_oak",
		"name": "Уютная Кровать с Периной",
		"icon": "🛏️",
		"category": "furniture",
		"cost": {"wood": 6, "leather": 2},
		"size": Vector3(1.6, 1.0, 2.2),
		"mesh_type": "box",
		"color": Color(0.6, 0.2, 0.2),
		"hp": 100,
		"comfort": 15
	},
	"chest": {
		"id": "chest",
		"name": "Окованный Сундук для Ресурсов",
		"icon": "📦",
		"category": "containers",
		"cost": {"wood": 4, "iron_ingot": 1},
		"size": Vector3(1.2, 0.8, 0.8),
		"mesh_type": "box",
		"color": Color(0.45, 0.32, 0.20),
		"hp": 120
	},
	"bakery_oven": {
		"id": "bakery_oven",
		"name": "Пекарная Печь для Хлеба",
		"icon": "🍞",
		"category": "workshops",
		"cost": {"stone": 8, "wood": 4},
		"size": Vector3(2.0, 2.2, 2.0),
		"mesh_type": "box",
		"color": Color(0.7, 0.55, 0.4),
		"hp": 200,
		"has_light": true
	},
	"carpentry": {
		"id": "carpentry",
		"name": "Плотницкий Верстак",
		"icon": "🪚",
		"category": "workshops",
		"cost": {"wood": 6, "iron_ingot": 1},
		"size": Vector3(2.2, 1.1, 1.2),
		"mesh_type": "box",
		"color": Color(0.50, 0.38, 0.25),
		"hp": 120
	},
	"alchemy_lab": {
		"id": "alchemy_lab",
		"name": "Алхимический Стол с Ретортами",
		"icon": "🧪",
		"category": "workshops",
		"cost": {"wood": 4, "glass": 2, "herb_hypericum": 2},
		"size": Vector3(1.8, 1.2, 1.0),
		"mesh_type": "box",
		"color": Color(0.35, 0.45, 0.55),
		"hp": 80
	}
}

static func get_blueprint(id: String) -> Dictionary:
	return BLUEPRINTS.get(id, {})

static func get_blueprint_list() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for k in BLUEPRINTS.keys():
		list.append(BLUEPRINTS[k])
	return list

static func create_ghost_node(id: String) -> Node3D:
	var bp = get_blueprint(id)
	if bp.is_empty(): return null
	
	var root = Node3D.new()
	root.name = "Ghost_" + id
	
	var sz: Vector3 = bp["size"]
	var mesh_inst = MeshInstance3D.new()
	mesh_inst.name = "GhostMesh"
	
	if bp["mesh_type"] == "cylinder":
		var cyl = CylinderMesh.new()
		cyl.top_radius = sz.x * 0.5
		cyl.bottom_radius = sz.z * 0.5
		cyl.height = sz.y
		mesh_inst.mesh = cyl
		mesh_inst.position.y = sz.y * 0.5
	elif bp["mesh_type"] == "lantern":
		var box = BoxMesh.new()
		box.size = sz
		mesh_inst.mesh = box
		mesh_inst.position.y = sz.y * 0.5
	else:
		var box = BoxMesh.new()
		box.size = sz
		mesh_inst.mesh = box
		mesh_inst.position.y = sz.y * 0.5
		
	# Полупрозрачный материал
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(0.2, 0.85, 0.4, 0.55)
	mat.emission_enabled = true
	mat.emission = Color(0.1, 0.7, 0.3)
	mat.emission_energy_multiplier = 0.5
	mesh_inst.material_override = mat
	root.add_child(mesh_inst)
	
	return root

static func set_ghost_valid(ghost_node: Node3D, is_valid: bool) -> void:
	if not ghost_node: return
	var mesh_inst: MeshInstance3D = ghost_node.get_node_or_null("GhostMesh")
	if not mesh_inst or not mesh_inst.material_override: return
	
	var mat: StandardMaterial3D = mesh_inst.material_override
	if is_valid:
		mat.albedo_color = Color(0.2, 0.9, 0.4, 0.6)
		mat.emission = Color(0.1, 0.8, 0.3)
	else:
		mat.albedo_color = Color(0.9, 0.2, 0.2, 0.6)
		mat.emission = Color(0.8, 0.1, 0.1)

static func spawn_placed_structure(id: String, xform: Transform3D, parent_node: Node3D) -> Node3D:
	var bp = get_blueprint(id)
	if bp.is_empty(): return null
	
	var root = StaticBody3D.new()
	root.name = "Placed_" + id + "_" + str(Time.get_ticks_msec())
	root.transform = xform
	
	var sz: Vector3 = bp["size"]
	var mesh_inst = MeshInstance3D.new()
	mesh_inst.name = "Mesh"
	
	var col_shape = CollisionShape3D.new()
	col_shape.name = "Collision"
	
	if bp["mesh_type"] == "cylinder":
		var cyl = CylinderMesh.new()
		cyl.top_radius = sz.x * 0.5
		cyl.bottom_radius = sz.z * 0.5
		cyl.height = sz.y
		mesh_inst.mesh = cyl
		mesh_inst.position.y = sz.y * 0.5
		
		var shape = CylinderShape3D.new()
		shape.radius = sz.x * 0.5
		shape.height = sz.y
		col_shape.shape = shape
		col_shape.position.y = sz.y * 0.5
	else:
		var box = BoxMesh.new()
		box.size = sz
		mesh_inst.mesh = box
		mesh_inst.position.y = sz.y * 0.5
		
		var shape = BoxShape3D.new()
		shape.size = sz
		col_shape.shape = shape
		col_shape.position.y = sz.y * 0.5
		
	# Текстурированный средневековый материал
	var mat = StandardMaterial3D.new()
	mat.albedo_color = bp.get("color", Color.GRAY)
	mat.roughness = 0.85
	mat.metallic = 0.1
	mesh_inst.material_override = mat
	
	root.add_child(mesh_inst)
	root.add_child(col_shape)
	
	# Освещение для светильников и очагов
	if bp.get("has_light", false):
		var light = OmniLight3D.new()
		light.name = "BuildingLight"
		light.light_color = Color(1.0, 0.78, 0.40)
		light.light_energy = 2.2
		light.omni_range = 9.0
		light.omni_attenuation = 1.2
		light.shadow_enabled = true
		light.position.y = sz.y + 0.2
		root.add_child(light)
		
	root.set_meta("structure_id", id)
	root.set_meta("hp", bp.get("hp", 100))
	root.set_meta("max_hp", bp.get("hp", 100))
	root.set_meta("display_name", bp.get("name", id))
	
	if parent_node:
		parent_node.add_child(root)
		
	return root
