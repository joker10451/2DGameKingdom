extends Node3D

## 3D ЖИВАЯ ДЕРЕВНЯ ОЛДЕРИИ (Godot 4.x)
## Полноценная RPG-песочница: Инвентарь, Экипировка, Торговля на рынке, Кузница и Боевая система

# === НАСТРОЙКИ УПРАВЛЕНИЯ И КАМЕРЫ ===
const PLAYER_SPEED := 5.5
const PLAYER_RUN_SPEED := 10.0
const MOUSE_SENSITIVITY := 0.003
const CAMERA_MIN_PITCH := -0.65
const CAMERA_MAX_PITCH := -0.08
const CAMERA_DISTANCE := 7.0
const CAMERA_HEIGHT := 3.0
const NPC_SPEED := 2.2
const GRAVITY := 19.6

# === ССЫЛКИ НА НОДЫ ===
var player: CharacterBody3D
var player_anim: AnimationPlayer
var camera_pivot: Node3D
var camera: Camera3D
var npcs_container: Node3D
var buildings_container: Node3D
var nature_container: Node3D

# === КАМЕРА ===
var camera_yaw: float = 0.0
var camera_pitch: float = -0.3
var is_first_person: bool = false
var cur_cam_dist: float = 7.0
var target_cam_dist: float = 7.0

# 🐕 3D Собака-Компаньон
var dog_body: CharacterBody3D = null
var dog_target_pos: Vector3 = Vector3.ZERO
var dog_loyalty: int = 80

# === БОЕВАЯ СИСТЕМА И СТАТЫ ИГРОКА ===
var player_hp: float = 100.0
var player_max_hp: float = 100.0
var player_stamina: float = 100.0
var player_max_stamina: float = 100.0
var is_attacking: bool = false
var attack_cooldown: float = 0.0

# === ОБЩАЯ БИБЛИОТЕКА АНИМАЦИЙ ===
var shared_anim_lib: AnimationLibrary

# === ПОЗИЦИИ 3D МОДЕЛЕЙ ЗДАНИЙ (МОНУМЕНТАЛЬНЫЙ МАСШТАБ 2X) ===
var building_locations := {
	"tavern": Vector3(-45, 0, -38),
	"market": Vector3(-25, 0, 20),
	"blacksmith": Vector3(-55, 0, 50),
	"windmill": Vector3(65, 0, 40),
	"castle": Vector3(80, 0, -70),
	"church": Vector3(15, 0, -80),
	"barracks": Vector3(45, 0, -28),
	"bandit_camp": Vector3(110, 0, 90),
	"home_a": Vector3(-68, 0, -10),
	"home_b": Vector3(15, 0, 60),
	"farm": Vector3(55, 0, 55),
}

# === ОТКРЫТЫЕ ТОЧКИ АКТИВНОСТИ И ПАТРУЛЕЙ ===
var npc_activity_spots := {
	"tavern": Vector3(-45, 0, -22),       # Площадь перед таверной
	"market": Vector3(-12, 0, 18),        # Торговые ряды на площади
	"blacksmith": Vector3(-40, 0, 42),    # Наковальня под навесом
	"windmill": Vector3(48, 0, 30),       # Дорога у мельницы
	"castle": Vector3(60, 0, -48),        # Замковые ворота и плац
	"church": Vector3(15, 0, -58),        # Площадь перед собором
	"barracks": Vector3(30, 0, -18),      # Пост стражи на перекрестке
	"bandit_camp": Vector3(95, 0, 78),    # Лесная поляна бандитов
	"home_a": Vector3(-52, 0, -8),        # Двор купца
	"home_b": Vector3(15, 0, 42),         # Двор крестьянина
	"farm": Vector3(42, 0, 45),           # Дорожка к пшеничному полю
}

# === ПРОЦЕДУРНО ГЕНЕРИРУЕМЫЕ ЖИТЕЛИ (KINGDOMS STYLE) ===
var npc_data: Array[Dictionary] = []

var npc_nodes := []
var npc_anims := []
var interaction_target := -1

# === СОСТОЯНИЯ ОКОН UI ===
var is_ui_open := false

# HUD Ноды
var time_label: Label
var player_card: RichTextLabel
var health_bar: ProgressBar
var stamina_bar: ProgressBar
var hp_label: Label
var stamina_label: Label
var hint_label: Label
var log_box: RichTextLabel
var dialogue_panel: PanelContainer
var dialogue_title: Label
var dialogue_text: RichTextLabel
var dialogue_options_container: VBoxContainer
var role_option_btn: OptionButton
var change_role_btn: Button

# Окно Инвентаря
var inventory_panel: PanelContainer
var inv_items_list: ItemList
var inv_details_label: RichTextLabel
var inv_equip_btn: Button
var inv_use_btn: Button
var inv_drop_btn: Button
var selected_inv_item: String = ""

# Окно Торговли
var trade_panel: PanelContainer
var trade_merchant_list: ItemList
var trade_player_list: ItemList
var trade_gold_label: Label

# Окно Кузницы
var smith_panel: PanelContainer
var smith_recipe_list: ItemList
var smith_details_label: RichTextLabel
var smith_craft_btn: Button
var selected_recipe_idx: int = -1

# Окно Случайных Событий
var event_panel: PanelContainer
var event_title_lbl: Label
var event_desc_lbl: RichTextLabel
var event_options_vbox: VBoxContainer
var event_timer: float = 60.0

# === СИСТЕМА СТРОИТЕЛЬСТВА ВЛАДЕНИЙ [B] ===
var is_building_mode: bool = false
var build_panel: PanelContainer
var build_list: ItemList
var build_info_lbl: RichTextLabel
var build_confirm_btn: Button
var ghost_instance: Node3D = null
var selected_blueprint_idx: int = 0
var ghost_rotation_y: float = 0.0
var player_buildings_container: Node3D
var is_blocking: bool = false

var build_blueprints := [
	{
		"name": "Личная Усадьба 🏡",
		"desc": "Уютный жилой дом. Приносит +3 золотых налога каждый день.",
		"model_path": "res://assets/medieval/buildings/blue/building_home_A_blue.gltf",
		"scale": 7.5,
		"req": {"wood": 4, "iron_ingot": 1},
		"income": 3
	},
	{
		"name": "Сторожевая Башня 🏰",
		"desc": "Высокая дозорная башня. Охраняет окрестности от разбойников.",
		"model_path": "res://assets/medieval/buildings/blue/building_tower_A_blue.gltf",
		"scale": 7.0,
		"req": {"wood": 4, "iron_ingot": 1},
		"income": 1
	},
	{
		"name": "Деревянный Частокол 🪵",
		"desc": "Защитное ограждение. Блокирует проход диких зверей и разбойников.",
		"model_path": "res://assets/medieval/gltf/fence_wood_straight.gltf",
		"scale": 5.0,
		"req": {"wood": 1},
		"income": 0
	},
	{
		"name": "Походная Палатка ⛺",
		"desc": "Место для отдыха и найма свободных странников в дружину.",
		"model_path": "res://assets/medieval/gltf/tent.gltf",
		"scale": 4.5,
		"req": {"wood": 2},
		"income": 0
	},
	{
		"name": "Деревенский Колодец 💧",
		"desc": "Источник чистой воды. Повышает довольство всех жителей вокруг.",
		"model_path": "res://assets/medieval/buildings/blue/building_well_blue.gltf",
		"scale": 6.0,
		"req": {"wood": 2, "iron_ingot": 1},
		"income": 1
	}
]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	npc_data = NPCGenerator.generate_population(18)
	
	player_buildings_container = Node3D.new()
	player_buildings_container.name = "PlayerConstructedBuildings"
	add_child(player_buildings_container)
	
	_build_shared_animation_library()
	_setup_environment_and_lighting()
	_spawn_solid_ground_and_roads()
	_spawn_exact_collision_buildings()
	_spawn_nature_with_collisions()
	_spawn_player_character()
	_spawn_npc_citizens()
	_spawn_polyhaven_structures()
	_spawn_dog_companion_3d()
	_build_ui_hud()

# =========================================================
# 0. СОЗДАНИЕ ЕДИНОЙ БИБЛИОТЕКИ АНИМАЦИЙ
# =========================================================
func _build_shared_animation_library() -> void:
	shared_anim_lib = AnimationLibrary.new()
	
	var sources = [
		"res://assets/characters/Rig_Medium/Rig_Medium_MovementBasic.glb",
		"res://assets/characters/Rig_Medium/Rig_Medium_General.glb"
	]
	
	for src_path in sources:
		if not ResourceLoader.exists(src_path):
			continue
		var src_scene = load(src_path).instantiate()
		var src_ap: AnimationPlayer = src_scene.get_node_or_null("AnimationPlayer")
		if src_ap:
			for a_name in src_ap.get_animation_list():
				if not shared_anim_lib.has_animation(a_name):
					var orig_anim: Animation = src_ap.get_animation(a_name)
					var cloned_anim: Animation = orig_anim.duplicate()
					if a_name.begins_with("Walking") or a_name.begins_with("Running") or a_name.begins_with("Idle"):
						cloned_anim.loop_mode = Animation.LOOP_LINEAR
					shared_anim_lib.add_animation(a_name, cloned_anim)
		src_scene.queue_free()

func _attach_model_and_anim(parent_body: CharacterBody3D, model_path: String, weapon_r: String = "", weapon_l: String = "") -> AnimationPlayer:
	if not ResourceLoader.exists(model_path):
		return null
	
	var model_res = load(model_path)
	var model_inst = model_res.instantiate()
	model_inst.name = "CharacterModel"
	parent_body.add_child(model_inst)
	
	_equip_weapon_to_skeleton(model_inst, weapon_r, weapon_l)
	
	var ap = AnimationPlayer.new()
	ap.name = "AnimationPlayer"
	model_inst.add_child(ap)
	
	if shared_anim_lib:
		ap.add_animation_library("", shared_anim_lib)
	
	return ap

func _equip_weapon_to_skeleton(model_inst: Node3D, r_path: String, l_path: String) -> void:
	var skel: Skeleton3D = _find_skeleton(model_inst)
	if not skel:
		return
	
	# Очищаем старые прикрепленные предметы
	for c in skel.get_children():
		if c is BoneAttachment3D:
			c.queue_free()
	
	if r_path != "" and ResourceLoader.exists(r_path):
		var r_idx = skel.find_bone("handslot.r")
		if r_idx == -1: r_idx = skel.find_bone("hand.r")
		if r_idx != -1:
			var att = BoneAttachment3D.new()
			att.name = "WeaponSlot_R"
			att.bone_name = skel.get_bone_name(r_idx)
			var w_inst = load(r_path).instantiate()
			w_inst.scale = Vector3.ONE * 0.95
			att.add_child(w_inst)
			skel.add_child(att)
	
	if l_path != "" and ResourceLoader.exists(l_path):
		var l_idx = skel.find_bone("handslot.l")
		if l_idx == -1: l_idx = skel.find_bone("hand.l")
		if l_idx != -1:
			var att_l = BoneAttachment3D.new()
			att_l.name = "ShieldSlot_L"
			att_l.bone_name = skel.get_bone_name(l_idx)
			var s_inst = load(l_path).instantiate()
			s_inst.scale = Vector3.ONE * 0.95
			att_l.add_child(s_inst)
			skel.add_child(att_l)

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for c in node.get_children():
		var s = _find_skeleton(c)
		if s: return s
	return null

func _refresh_player_equipment() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p or not player:
		return
	var model_inst = player.get_node_or_null("CharacterModel")
	if not model_inst:
		return
	var w_item = ItemDatabase.get_item(p.equipped_weapon)
	var s_item = ItemDatabase.get_item(p.equipped_shield)
	var w_path = w_item.get("model_path", "")
	var s_path = s_item.get("model_path", "")
	_equip_weapon_to_skeleton(model_inst, w_path, s_path)

# =========================================================
# 0.5. СПАВН 3D ФОРТИФИКАЦИЙ POLY HAVEN И СОБАКИ-КОМПАНЬОНА
# =========================================================
func _spawn_polyhaven_structures() -> void:
	# 1. Замковый комплекс Poly Haven (modular_fort_polyhaven.glb)
	var fort_path = "res://assets/models/modular_fort_polyhaven.glb"
	if ResourceLoader.exists(fort_path):
		var fort_res = load(fort_path)
		if fort_res:
			var fort_inst = fort_res.instantiate()
			fort_inst.name = "PolyHaven_CastleFortress"
			fort_inst.position = Vector3(80, 0, -70)
			fort_inst.scale = Vector3.ONE * 1.3
			add_child(fort_inst)
			
			var lbl = Label3D.new()
			lbl.text = "🏰 Крепость Барона (Poly Haven 3D)"
			lbl.position = Vector3(80, 24.0, -70)
			lbl.font_size = 44
			lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			lbl.outline_size = 8
			lbl.modulate = Color.GOLD
			add_child(lbl)
	
	# 2. Уличные кованые фонари Poly Haven (lantern_polyhaven.glb) с теплым светом
	var lantern_path = "res://assets/models/lantern_polyhaven.glb"
	var lantern_spots = [
		Vector3(-45, 0, -22), # Таверна
		Vector3(-25, 0, 18),  # Рынок
		Vector3(-40, 0, 42),  # Кузница
		Vector3(15, 0, 42),   # Усадьба
		Vector3(48, 0, 30),   # Мельница
		Vector3(0, 0, 0)      # Центр перекрестка
	]
	
	for spot in lantern_spots:
		var post = StaticBody3D.new()
		post.position = spot
		post.name = "LanternPost_" + str(spot)
		
		# Столб
		var post_mesh = CylinderMesh.new()
		post_mesh.top_radius = 0.12
		post_mesh.bottom_radius = 0.16
		post_mesh.height = 3.2
		var p_mat = StandardMaterial3D.new()
		p_mat.albedo_color = Color(0.35, 0.25, 0.15)
		post_mesh.material = p_mat
		
		var p_inst = MeshInstance3D.new()
		p_inst.mesh = post_mesh
		p_inst.position.y = 1.6
		post.add_child(p_inst)
		
		# Модель фонаря Poly Haven
		if ResourceLoader.exists(lantern_path):
			var l_res = load(lantern_path)
			if l_res:
				var l_inst = l_res.instantiate()
				l_inst.scale = Vector3.ONE * 0.9
				l_inst.position = Vector3(0, 3.1, 0)
				post.add_child(l_inst)
		
		# Теплый золотой свет
		var light = OmniLight3D.new()
		light.light_color = Color(1.0, 0.82, 0.45)
		light.light_energy = 2.4
		light.omni_range = 11.0
		light.omni_attenuation = 1.2
		light.shadow_enabled = true
		light.position = Vector3(0, 3.2, 0)
		post.add_child(light)
		
		add_child(post)
		
	# 3. Камин в Таверне (fireplace.glb)
	var fp_path = "res://assets/models/fireplace.glb"
	if ResourceLoader.exists(fp_path):
		var fp_res = load(fp_path)
		if fp_res:
			var fp_inst = fp_res.instantiate()
			fp_inst.position = Vector3(-45, 0, -32)
			fp_inst.scale = Vector3.ONE * 1.2
			add_child(fp_inst)
			
			var fire_light = OmniLight3D.new()
			fire_light.name = "TavernFireLight"
			fire_light.light_color = Color(1.0, 0.65, 0.25)
			fire_light.light_energy = 3.0
			fire_light.omni_range = 12.0
			fire_light.position = Vector3(-45, 1.2, -32)
			add_child(fire_light)

func _spawn_dog_companion_3d() -> void:
	dog_body = CharacterBody3D.new()
	dog_body.name = "DogCompanion3D"
	dog_body.position = player.position + Vector3(2, 0, 2)
	
	# Тело собаки
	var body_mesh = BoxMesh.new()
	body_mesh.size = Vector3(0.6, 0.6, 1.1)
	var dog_mat = StandardMaterial3D.new()
	dog_mat.albedo_color = Color(0.72, 0.52, 0.28) # Золотистый ретривер / гончая
	body_mesh.material = dog_mat
	
	var b_inst = MeshInstance3D.new()
	b_inst.mesh = body_mesh
	b_inst.position.y = 0.5
	dog_body.add_child(b_inst)
	
	# Голова
	var head_mesh = BoxMesh.new()
	head_mesh.size = Vector3(0.45, 0.45, 0.45)
	head_mesh.material = dog_mat
	var h_inst = MeshInstance3D.new()
	h_inst.mesh = head_mesh
	h_inst.position = Vector3(0, 0.85, -0.6)
	dog_body.add_child(h_inst)
	
	# Коллизия
	var col = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(0.7, 0.9, 1.2)
	col.shape = shape
	col.position.y = 0.45
	dog_body.add_child(col)
	
	# Метка над головой
	var lbl = Label3D.new()
	lbl.name = "DogLabel"
	lbl.text = "🐕 Верный (Пес-Компаньон)
[E] Погладить / Дать кость"
	lbl.position = Vector3(0, 1.4, 0)
	lbl.font_size = 28
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.outline_size = 6
	lbl.modulate = Color(1.0, 0.9, 0.6)
	dog_body.add_child(lbl)
	
	add_child(dog_body)

# =========================================================
# 1. СВЕТ, НЕБО И ОКРУЖЕНИЕ
# =========================================================
func _setup_environment_and_lighting() -> void:
	var world_env = WorldEnvironment.new()
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.52, 0.72, 0.96)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.75, 0.8, 0.9)
	env.ambient_light_energy = 0.65
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.fog_enabled = true
	env.fog_light_color = Color(0.72, 0.82, 0.92)
	env.fog_density = 0.0025
	world_env.environment = env
	add_child(world_env)
	
	var sun = DirectionalLight3D.new()
	sun.name = "SunLight"
	sun.rotation_degrees = Vector3(-48, 38, 0)
	sun.light_energy = 1.35
	sun.light_color = Color(1.0, 0.96, 0.88)
	sun.shadow_enabled = true
	sun.shadow_bias = 0.03
	add_child(sun)

# =========================================================
# 2. ТВЕРДАЯ ЗЕМЛЯ И ШИРОКИЕ ДОРОГИ
# =========================================================
func _spawn_solid_ground_and_roads() -> void:
	var ground_body = StaticBody3D.new()
	ground_body.name = "GroundStaticBody"
	
	var ground_col = CollisionShape3D.new()
	var col_shape = BoxShape3D.new()
	col_shape.size = Vector3(360, 2.0, 360)
	ground_col.shape = col_shape
	ground_col.position.y = -1.0
	ground_body.add_child(ground_col)
	
	var ground_mesh = BoxMesh.new()
	ground_mesh.size = Vector3(360, 2.0, 360)
	var ground_mat = StandardMaterial3D.new()
	ground_mat.albedo_color = Color(0.32, 0.52, 0.22)
	ground_mat.roughness = 0.9
	ground_mesh.material = ground_mat
	
	var ground_inst = MeshInstance3D.new()
	ground_inst.mesh = ground_mesh
	ground_inst.position.y = -1.0
	ground_body.add_child(ground_inst)
	
	add_child(ground_body)
	
	_create_road(Vector3(0, 0.02, 0), Vector3(160, 0.04, 9.0), Color(0.54, 0.46, 0.34))
	_create_road(Vector3(-25, 0.02, 5), Vector3(8.5, 0.04, 150), Color(0.54, 0.46, 0.34))
	_create_road(Vector3(40, 0.02, -20), Vector3(8.0, 0.04, 130), Color(0.48, 0.42, 0.32))
	_create_road(Vector3(70, 0.02, 55), Vector3(80, 0.04, 6.0), Color(0.46, 0.40, 0.30))

func _create_road(pos: Vector3, size: Vector3, col: Color) -> void:
	var r_mesh = BoxMesh.new()
	r_mesh.size = size
	var mat = StandardMaterial3D.new()
	mat.albedo_color = col
	mat.roughness = 0.95
	r_mesh.material = mat
	var inst = MeshInstance3D.new()
	inst.mesh = r_mesh
	inst.position = pos
	add_child(inst)

# =========================================================
# 3. ТОЧНЫЕ TRIMESH КОЛЛИЗИИ ЗДАНИЙ
# =========================================================
func _spawn_exact_collision_buildings() -> void:
	buildings_container = Node3D.new()
	buildings_container.name = "Buildings"
	add_child(buildings_container)
	
	var buildings_manifest = [
		{"path": "res://assets/medieval/buildings/blue/building_tavern_blue.gltf", "pos": building_locations["tavern"], "rot": 0.0, "scale": 9.6, "name": "Таверна «Пьяный Кабан» 🍺", "h": 16.0},
		{"path": "res://assets/medieval/buildings/blue/building_market_blue.gltf", "pos": building_locations["market"], "rot": 90.0, "scale": 9.0, "name": "Рыночная Площадь ⚖️", "h": 14.0},
		{"path": "res://assets/medieval/buildings/blue/building_blacksmith_blue.gltf", "pos": building_locations["blacksmith"], "rot": 180.0, "scale": 9.0, "name": "Кузница Вульфрика ⚒️", "h": 15.0},
		{"path": "res://assets/medieval/buildings/blue/building_windmill_blue.gltf", "pos": building_locations["windmill"], "rot": 45.0, "scale": 11.0, "name": "Мельница и Ферма 🌾", "h": 22.0},
		{"path": "res://assets/medieval/buildings/blue/building_castle_blue.gltf", "pos": building_locations["castle"], "rot": -45.0, "scale": 13.0, "name": "Замок Барона Вильгельма 🏰", "h": 26.0},
		{"path": "res://assets/medieval/buildings/blue/building_church_blue.gltf", "pos": building_locations["church"], "rot": 0.0, "scale": 11.0, "name": "Собор Ордена ⛪", "h": 22.0},
		{"path": "res://assets/medieval/buildings/blue/building_barracks_blue.gltf", "pos": building_locations["barracks"], "rot": -90.0, "scale": 10.0, "name": "Казармы Городской Стражи 🛡️", "h": 16.0},
		{"path": "res://assets/medieval/buildings/blue/building_home_A_blue.gltf", "pos": building_locations["home_a"], "rot": 30.0, "scale": 8.4, "name": "Усадьба Купца 🏠", "h": 14.0},
		{"path": "res://assets/medieval/buildings/blue/building_home_B_blue.gltf", "pos": building_locations["home_b"], "rot": -20.0, "scale": 8.4, "name": "Дом Крестьянина 🏡", "h": 14.0},
	]
	
	for b in buildings_manifest:
		_instantiate_exact_building(b["path"], b["pos"], b["rot"], b["scale"], b["name"], b["h"], buildings_container)

func _instantiate_exact_building(res_path: String, pos: Vector3, rot_y_deg: float, scale_val: float, label_name: String, label_h: float, parent_node: Node3D) -> void:
	var body = StaticBody3D.new()
	body.position = pos
	body.rotation_degrees.y = rot_y_deg
	body.name = label_name
	
	if ResourceLoader.exists(res_path):
		var scene_res = load(res_path)
		if scene_res:
			var model_inst = scene_res.instantiate()
			model_inst.scale = Vector3.ONE * scale_val
			body.add_child(model_inst)
			_generate_exact_trimesh_recursive(model_inst, body, scale_val)
	
	var lbl = Label3D.new()
	lbl.text = label_name
	lbl.position = Vector3(0, label_h, 0)
	lbl.font_size = 42
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.outline_size = 8
	lbl.modulate = Color(1.0, 0.95, 0.8)
	body.add_child(lbl)
	
	parent_node.add_child(body)

func _generate_exact_trimesh_recursive(node: Node, parent_body: StaticBody3D, scale_val: float) -> void:
	if node is MeshInstance3D and node.mesh:
		var shape = node.mesh.create_trimesh_shape()
		if shape:
			var col = CollisionShape3D.new()
			col.shape = shape
			col.transform = node.transform
			col.scale = Vector3.ONE * scale_val
			parent_body.add_child(col)
	for child in node.get_children():
		_generate_exact_trimesh_recursive(child, parent_body, scale_val)

# =========================================================
# 4. ПРИРОДА С ТВЕРДЫМИ КОЛЛИЗИЯМИ ДЕРЕВЬЕВ
# =========================================================
func _spawn_nature_with_collisions() -> void:
	nature_container = Node3D.new()
	nature_container.name = "Nature"
	add_child(nature_container)
	
	var tree_paths = [
		"res://assets/nature/glTF/CommonTree_1.gltf",
		"res://assets/nature/glTF/CommonTree_2.gltf",
		"res://assets/nature/glTF/CommonTree_3.gltf"
	]
	
	for i in 40:
		var rx = randf_range(-75, 75)
		var rz = randf_range(-75, 75)
		
		var too_close := false
		for loc in building_locations.values():
			if Vector2(rx, rz).distance_to(Vector2(loc.x, loc.z)) < 12.0:
				too_close = true
				break
		if too_close:
			continue
		
		var t_path = tree_paths.pick_random()
		var tree_body = StaticBody3D.new()
		tree_body.position = Vector3(rx, 0, rz)
		tree_body.rotation_degrees.y = randf_range(0, 360)
		tree_body.name = "Tree_%d" % i
		var t_scale = randf_range(1.4, 2.2)
		
		var trunk_col = CollisionShape3D.new()
		var cyl = CylinderShape3D.new()
		cyl.radius = 0.38 * t_scale
		cyl.height = 3.8 * t_scale
		trunk_col.shape = cyl
		trunk_col.position.y = 1.9 * t_scale
		tree_body.add_child(trunk_col)
		
		if ResourceLoader.exists(t_path):
			var res = load(t_path)
			if res:
				var inst = res.instantiate()
				inst.scale = Vector3.ONE * t_scale
				tree_body.add_child(inst)
		
		nature_container.add_child(tree_body)

# =========================================================
# 5. СПАВН ПЕРСОНАЖА ИГРОКА С МЕЧОМ И ЩИТОМ
# =========================================================
func _spawn_player_character() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 0.2, 0)
	
	player_anim = _attach_model_and_anim(player, "res://assets/characters/Knight.glb", "res://assets/characters/sword_1handed.gltf", "res://assets/characters/shield_badge.gltf")
	if player_anim and player_anim.has_animation("Idle_A"):
		player_anim.play("Idle_A")
	
	var col = CollisionShape3D.new()
	var cap = CapsuleShape3D.new()
	cap.radius = 0.4
	cap.height = 1.8
	col.shape = cap
	col.position.y = 0.9
	player.add_child(col)
	
	# Метка игрока в 3D не нужна, так как имя и статы отображаются в HUD внизу
	add_child(player)
	
	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	add_child(camera_pivot)
	
	camera = Camera3D.new()
	camera.name = "MainCamera3D"
	camera.fov = 68
	camera_pivot.add_child(camera)

# =========================================================
# 6. СПАВН NPC
# =========================================================
func _spawn_npc_citizens() -> void:
	npcs_container = Node3D.new()
	npcs_container.name = "Citizens"
	add_child(npcs_container)
	
	for i in npc_data.size():
		var npc = npc_data[i]
		var start_spot = npc_activity_spots.get(npc["work"], Vector3.ZERO)
		var spawn_pos = start_spot + Vector3(randf_range(-1.2, 1.2), 0.2, randf_range(-1.2, 1.2))
		
		npc["target"] = spawn_pos
		
		var node = CharacterBody3D.new()
		node.name = "Citizen_" + npc["name"]
		node.position = spawn_pos
		
		var npc_ap = _attach_model_and_anim(node, npc["model"], npc["weapon_r"], npc["weapon_l"])
		if npc_ap and npc_ap.has_animation("Idle_A"):
			npc_ap.play("Idle_A")
		
		var col = CollisionShape3D.new()
		var cap = CapsuleShape3D.new()
		cap.radius = 0.38
		cap.height = 1.7
		col.shape = cap
		col.position.y = 0.85
		node.add_child(col)
		
		var lbl = Label3D.new()
		lbl.name = "StatusPlate"
		lbl.text = "%s\n%s %s" % [npc["name"], npc["thought"], npc["role"]]
		lbl.position = Vector3(0, 2.7, 0)
		lbl.font_size = 32
		lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		lbl.outline_size = 6
		lbl.modulate = Color.WHITE
		node.add_child(lbl)
		
		npc_nodes.append(node)
		npc_anims.append(npc_ap)
		npcs_container.add_child(node)

# =========================================================
# 7. ИГРОВОЙ HUD, ИНВЕНТАРЬ, РЫНОК И КУЗНИЦА
# =========================================================
func _build_ui_hud() -> void:
	var canvas = CanvasLayer.new()
	canvas.name = "HUD"
	add_child(canvas)
	
	# Верхняя полоса: Время, кнопки скорости и меню
	var top_bar = HBoxContainer.new()
	top_bar.position = Vector2(20, 14)
	top_bar.add_theme_constant_override("separation", 10)
	canvas.add_child(top_bar)
	
	time_label = Label.new()
	time_label.add_theme_font_size_override("font_size", 18)
	time_label.add_theme_color_override("font_color", Color.WHITE)
	time_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	time_label.add_theme_constant_override("shadow_offset_x", 1)
	time_label.add_theme_constant_override("shadow_offset_y", 1)
	top_bar.add_child(time_label)
	
	var p_btn = Button.new()
	p_btn.text = "⏸"
	p_btn.pressed.connect(func(): var tm = _get_time_manager(); if tm: tm.set_speed(0.0))
	top_bar.add_child(p_btn)
	
	var s1_btn = Button.new()
	s1_btn.text = "▶ 1x"
	s1_btn.pressed.connect(func(): var tm = _get_time_manager(); if tm: tm.set_speed(1.0))
	top_bar.add_child(s1_btn)
	
	var s2_btn = Button.new()
	s2_btn.text = "⏩ 2x"
	s2_btn.pressed.connect(func(): var tm = _get_time_manager(); if tm: tm.set_speed(2.0))
	top_bar.add_child(s2_btn)
	
	var s5_btn = Button.new()
	s5_btn.text = "⚡ 5x"
	s5_btn.pressed.connect(func(): var tm = _get_time_manager(); if tm: tm.set_speed(5.0))
	top_bar.add_child(s5_btn)
	
	var sep = VSeparator.new()
	top_bar.add_child(sep)
	
	var inv_top_btn = Button.new()
	inv_top_btn.text = "🎒 Инвентарь [I]"
	inv_top_btn.pressed.connect(_toggle_inventory)
	top_bar.add_child(inv_top_btn)
	
	var market_top_btn = Button.new()
	market_top_btn.text = "⚖️ Рынок"
	market_top_btn.pressed.connect(_open_market_trade)
	top_bar.add_child(market_top_btn)
	
	var smith_top_btn = Button.new()
	smith_top_btn.text = "⚒️ Кузница"
	smith_top_btn.pressed.connect(_open_smithing_menu)
	top_bar.add_child(smith_top_btn)
	
	var event_top_btn = Button.new()
	event_top_btn.text = "📜 Событие мира"
	event_top_btn.pressed.connect(func(): _trigger_random_event())
	top_bar.add_child(event_top_btn)
	
	var build_top_btn = Button.new()
	build_top_btn.text = "🔨 Постройка [B]"
	build_top_btn.pressed.connect(_toggle_building_mode)
	top_bar.add_child(build_top_btn)
	
	# Полоски здоровья и стамины в левом верхнем углу
	var stats_box = VBoxContainer.new()
	stats_box.position = Vector2(20, 50)
	stats_box.custom_minimum_size = Vector2(240, 50)
	canvas.add_child(stats_box)
	
	health_bar = ProgressBar.new()
	health_bar.custom_minimum_size = Vector2(240, 20)
	health_bar.value = 100.0
	health_bar.show_percentage = false
	hp_label = Label.new()
	hp_label.text = "❤️ Здоровье: 100 / 100"
	hp_label.position = Vector2(8, 0)
	health_bar.add_child(hp_label)
	stats_box.add_child(health_bar)
	
	stamina_bar = ProgressBar.new()
	stamina_bar.custom_minimum_size = Vector2(240, 16)
	stamina_bar.value = 100.0
	stamina_bar.show_percentage = false
	stamina_label = Label.new()
	stamina_label.text = "⚡ Выносливость: 100 / 100"
	stamina_label.position = Vector2(8, -2)
	stamina_bar.add_child(stamina_label)
	stats_box.add_child(stamina_bar)
	
	# Нижняя панель
	var bot_bar = HBoxContainer.new()
	bot_bar.position = Vector2(20, 580)
	bot_bar.custom_minimum_size = Vector2(1240, 120)
	bot_bar.add_theme_constant_override("separation", 16)
	canvas.add_child(bot_bar)
	
	var p_panel = PanelContainer.new()
	p_panel.custom_minimum_size = Vector2(420, 110)
	bot_bar.add_child(p_panel)
	
	var p_vbox = VBoxContainer.new()
	p_panel.add_child(p_vbox)
	
	player_card = RichTextLabel.new()
	player_card.bbcode_enabled = true
	player_card.fit_content = true
	p_vbox.add_child(player_card)
	
	var role_hbox = HBoxContainer.new()
	p_vbox.add_child(role_hbox)
	
	role_option_btn = OptionButton.new()
	role_option_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for r in HierarchyManager.ROLES.keys():
		role_option_btn.add_item(r)
	role_hbox.add_child(role_option_btn)
	
	change_role_btn = Button.new()
	change_role_btn.text = "Принять титул"
	change_role_btn.pressed.connect(_on_change_role_pressed)
	role_hbox.add_child(change_role_btn)
	
	var log_panel = PanelContainer.new()
	log_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bot_bar.add_child(log_panel)
	
	log_box = RichTextLabel.new()
	log_box.bbcode_enabled = true
	log_box.scroll_following = true
	log_box.text = "[color=yellow]3D мир Олдерии запущен.[/color]\nЛКМ — атака | I — инвентарь | E — диалог | ПКМ — курсор"
	log_panel.add_child(log_box)
	
	hint_label = Label.new()
	hint_label.position = Vector2(480, 540)
	hint_label.add_theme_font_size_override("font_size", 18)
	hint_label.add_theme_color_override("font_color", Color(1, 1, 0.4))
	hint_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	hint_label.add_theme_constant_override("shadow_offset_x", 2)
	hint_label.add_theme_constant_override("shadow_offset_y", 2)
	hint_label.visible = false
	canvas.add_child(hint_label)
	
	# === 1. ДИАЛОГОВОЕ ОКНО ===
	dialogue_panel = PanelContainer.new()
	dialogue_panel.position = Vector2(360, 160)
	dialogue_panel.custom_minimum_size = Vector2(560, 340)
	dialogue_panel.visible = false
	canvas.add_child(dialogue_panel)
	
	var d_vbox = VBoxContainer.new()
	d_vbox.add_theme_constant_override("separation", 10)
	dialogue_panel.add_child(d_vbox)
	
	dialogue_title = Label.new()
	dialogue_title.add_theme_font_size_override("font_size", 16)
	dialogue_title.text = "Разговор"
	d_vbox.add_child(dialogue_title)
	
	dialogue_text = RichTextLabel.new()
	dialogue_text.bbcode_enabled = true
	dialogue_text.custom_minimum_size = Vector2(540, 120)
	dialogue_text.fit_content = true
	d_vbox.add_child(dialogue_text)
	
	dialogue_options_container = VBoxContainer.new()
	dialogue_options_container.add_theme_constant_override("separation", 6)
	d_vbox.add_child(dialogue_options_container)
	
	# === 2. ОКНО ИНВЕНТАРЯ (I / Tab) ===
	_build_inventory_modal(canvas)
	
	# === 3. ОКНО РЫНКА ===
	_build_trade_modal(canvas)
	
	# === 4. ОКНО КУЗНИЦЫ ===
	_build_smithing_modal(canvas)
	
	# === 5. ОКНО СЛУЧАЙНЫХ СОБЫТИЙ ===
	_build_event_modal(canvas)
	
	# === 6. ОКНО СТРОИТЕЛЬСТВА ВЛАДЕНИЙ ===
	_build_construction_ui(canvas)

func _build_inventory_modal(canvas: CanvasLayer) -> void:
	inventory_panel = PanelContainer.new()
	inventory_panel.position = Vector2(300, 100)
	inventory_panel.custom_minimum_size = Vector2(680, 440)
	inventory_panel.visible = false
	canvas.add_child(inventory_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	inventory_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "🎒 СУМА И СНАРЯЖЕНИЕ ПЕРСОНАЖА"
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)
	
	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 14)
	vbox.add_child(hbox)
	
	inv_items_list = ItemList.new()
	inv_items_list.custom_minimum_size = Vector2(300, 320)
	inv_items_list.item_selected.connect(_on_inv_item_selected)
	hbox.add_child(inv_items_list)
	
	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_vbox.add_theme_constant_override("separation", 10)
	hbox.add_child(right_vbox)
	
	inv_details_label = RichTextLabel.new()
	inv_details_label.bbcode_enabled = true
	inv_details_label.custom_minimum_size = Vector2(320, 220)
	inv_details_label.fit_content = true
	inv_details_label.text = "[color=gray]Выберите предмет слева...[/color]"
	right_vbox.add_child(inv_details_label)
	
	var btn_hbox = HBoxContainer.new()
	btn_hbox.add_theme_constant_override("separation", 8)
	right_vbox.add_child(btn_hbox)
	
	inv_equip_btn = Button.new()
	inv_equip_btn.text = "⚔️ Экипировать"
	inv_equip_btn.pressed.connect(_on_equip_item_btn_pressed)
	btn_hbox.add_child(inv_equip_btn)
	
	inv_use_btn = Button.new()
	inv_use_btn.text = "🍖 Съесть/Выпить"
	inv_use_btn.pressed.connect(_on_use_item_btn_pressed)
	btn_hbox.add_child(inv_use_btn)
	
	inv_drop_btn = Button.new()
	inv_drop_btn.text = "🗑️ Выбросить"
	inv_drop_btn.pressed.connect(_on_drop_item_btn_pressed)
	btn_hbox.add_child(inv_drop_btn)
	
	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	close_btn.pressed.connect(_close_all_modals)
	vbox.add_child(close_btn)

func _build_trade_modal(canvas: CanvasLayer) -> void:
	trade_panel = PanelContainer.new()
	trade_panel.position = Vector2(240, 90)
	trade_panel.custom_minimum_size = Vector2(800, 460)
	trade_panel.visible = false
	canvas.add_child(trade_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	trade_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "⚖️ РЫНОЧНЫЙ ПРИЛАВОК: ДИНАМИЧЕСКИЕ ЦЕНЫ ОЛДЕРИИ"
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)
	
	trade_gold_label = Label.new()
	trade_gold_label.text = "💰 Ваше золото: 0 монет"
	vbox.add_child(trade_gold_label)
	
	var columns = HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 16)
	vbox.add_child(columns)
	
	# Колонка покупки
	var buy_vbox = VBoxContainer.new()
	buy_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(buy_vbox)
	
	var buy_lbl = Label.new()
	buy_lbl.text = "🛒 Товары торговца (Купить):"
	buy_vbox.add_child(buy_lbl)
	
	trade_merchant_list = ItemList.new()
	trade_merchant_list.custom_minimum_size = Vector2(360, 280)
	buy_vbox.add_child(trade_merchant_list)
	
	var buy_action_btn = Button.new()
	buy_action_btn.text = "Купить выбранный товар (1 шт.)"
	buy_action_btn.pressed.connect(_on_buy_market_item)
	buy_vbox.add_child(buy_action_btn)
	
	# Колонка продажи
	var sell_vbox = VBoxContainer.new()
	sell_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(sell_vbox)
	
	var sell_lbl = Label.new()
	sell_lbl.text = "🎒 Ваша сума (Продать):"
	sell_vbox.add_child(sell_lbl)
	
	trade_player_list = ItemList.new()
	trade_player_list.custom_minimum_size = Vector2(360, 280)
	sell_vbox.add_child(trade_player_list)
	
	var sell_action_btn = Button.new()
	sell_action_btn.text = "Продать выбранный товар (1 шт.)"
	sell_action_btn.pressed.connect(_on_sell_market_item)
	sell_vbox.add_child(sell_action_btn)
	
	var close_btn = Button.new()
	close_btn.text = "Покинуть рынок [Esc]"
	close_btn.pressed.connect(_close_all_modals)
	vbox.add_child(close_btn)

func _build_smithing_modal(canvas: CanvasLayer) -> void:
	smith_panel = PanelContainer.new()
	smith_panel.position = Vector2(280, 100)
	smith_panel.custom_minimum_size = Vector2(720, 440)
	smith_panel.visible = false
	canvas.add_child(smith_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	smith_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "⚒️ КУЗНИЧНЫЙ ГОРН И НАКОВАЛЬНЯ ВУЛЬФРИКА"
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)
	
	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 14)
	vbox.add_child(hbox)
	
	smith_recipe_list = ItemList.new()
	smith_recipe_list.custom_minimum_size = Vector2(320, 300)
	smith_recipe_list.item_selected.connect(_on_recipe_selected)
	hbox.add_child(smith_recipe_list)
	
	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_vbox.add_theme_constant_override("separation", 10)
	hbox.add_child(right_vbox)
	
	smith_details_label = RichTextLabel.new()
	smith_details_label.bbcode_enabled = true
	smith_details_label.custom_minimum_size = Vector2(340, 220)
	smith_details_label.fit_content = true
	smith_details_label.text = "[color=gray]Выберите рецепт ковки слева...[/color]"
	right_vbox.add_child(smith_details_label)
	
	smith_craft_btn = Button.new()
	smith_craft_btn.text = "🔥 Выковать предмет"
	smith_craft_btn.pressed.connect(_on_craft_recipe_pressed)
	right_vbox.add_child(smith_craft_btn)
	
	var close_btn = Button.new()
	close_btn.text = "Отойти от наковальни [Esc]"
	close_btn.pressed.connect(_close_all_modals)
	vbox.add_child(close_btn)

# =========================================================
# 8. ЛОГИКА ИНВЕНТАРЯ, ТОРГОВЛИ И КРАФТА
# =========================================================
func _toggle_inventory() -> void:
	if inventory_panel.visible:
		_close_all_modals()
	else:
		_open_inventory()

func _open_inventory() -> void:
	_close_all_modals()
	is_ui_open = true
	inventory_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_refresh_inventory_list()

func _refresh_inventory_list() -> void:
	inv_items_list.clear()
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	for item_id in p.inventory.keys():
		var item = ItemDatabase.get_item(item_id)
		var count = p.inventory[item_id]
		var is_eq = (p.equipped_weapon == item_id or p.equipped_shield == item_id)
		var tag = " [Экип.]" if is_eq else ""
		inv_items_list.add_item("%s %s x%d%s" % [item.get("icon", "📦"), item.get("name", item_id), count, tag])
		inv_items_list.set_item_metadata(inv_items_list.get_item_count() - 1, item_id)
	
	if inv_items_list.get_item_count() > 0:
		inv_items_list.select(0)
		_on_inv_item_selected(0)
	else:
		inv_details_label.text = "[color=gray]Инвентарь пуст.[/color]"

func _on_inv_item_selected(idx: int) -> void:
	var item_id = inv_items_list.get_item_metadata(idx)
	selected_inv_item = item_id
	var item = ItemDatabase.get_item(item_id)
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	
	var is_weapon = item.get("category") == "weapon"
	var is_shield = item.get("category") == "shield"
	var is_food = item.get("category") == "food"
	
	inv_equip_btn.visible = (is_weapon or is_shield)
	inv_use_btn.visible = is_food
	
	var stat_text = ""
	if is_weapon: stat_text = "\n[color=orange]Урон оружия: %d[/color]" % item.get("damage", 25)
	if is_food: stat_text = "\n[color=green]Лечение: +%.0f HP | Выносливость: +%.0f[/color]" % [item.get("heal_hp", 20.0), item.get("restore_stamina", 10.0)]
	
	inv_details_label.text = """[b]%s %s[/b]
[color=gold]Категория:[/color] %s | [color=gold]Ценность:[/color] %d монет%s

%s""" % [item.get("icon", ""), item.get("name", ""), item.get("category", ""), item.get("value", 1), stat_text, item.get("desc", "")]

func _on_equip_item_btn_pressed() -> void:
	if selected_inv_item == "": return
	var item = ItemDatabase.get_item(selected_inv_item)
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	if item.get("category") == "weapon":
		p.equipped_weapon = selected_inv_item
		_refresh_player_equipment()
		_log("[color=gold]Вы экипировали оружие: %s[/color]" % item.get("name", ""))
	elif item.get("category") == "shield":
		p.equipped_shield = selected_inv_item
		_refresh_player_equipment()
		_log("[color=gold]Вы экипировали щит: %s[/color]" % item.get("name", ""))
	
	_refresh_inventory_list()

func _on_use_item_btn_pressed() -> void:
	if selected_inv_item == "": return
	var item = ItemDatabase.get_item(selected_inv_item)
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	if p.remove_item(selected_inv_item, 1):
		var heal = item.get("heal_hp", 0.0)
		var st = item.get("restore_stamina", 0.0)
		player_hp = minf(player_max_hp, player_hp + heal)
		player_stamina = minf(player_max_stamina, player_stamina + st)
		_log("[color=green]Вы использовали %s (+%.0f HP, +%.0f выносливости)![/color]" % [item.get("name", ""), heal, st])
	
	_refresh_inventory_list()

func _on_drop_item_btn_pressed() -> void:
	if selected_inv_item == "": return
	var item = ItemDatabase.get_item(selected_inv_item)
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	p.remove_item(selected_inv_item, 1)
	_log("[color=gray]Вы выбросили %s.[/color]" % item.get("name", ""))
	_refresh_inventory_list()

# --- ТОРГОВЛЯ НА РЫНКЕ ---
func _open_market_trade() -> void:
	_close_all_modals()
	is_ui_open = true
	trade_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_refresh_trade_window()

func _refresh_trade_window() -> void:
	trade_merchant_list.clear()
	trade_player_list.clear()
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	var m = gm.local_market if gm else null
	if not p or not m: return
	
	trade_gold_label.text = "💰 Ваше золото: %d монет" % p.gold
	
	# Список товаров рынка
	for item_id in m.inventory.keys():
		var count = m.inventory[item_id]
		var price = m.get_current_price(item_id)
		var item = ItemDatabase.get_item(item_id)
		trade_merchant_list.add_item("%s %s (Запас: %d) — %.1f золотых" % [item.get("icon", "📦"), item.get("name", item_id), count, price])
		trade_merchant_list.set_item_metadata(trade_merchant_list.get_item_count() - 1, item_id)
	
	# Список инвентаря игрока
	for item_id in p.inventory.keys():
		var count = p.inventory[item_id]
		var item = ItemDatabase.get_item(item_id)
		var price = m.get_current_price(item_id) * 0.8
		trade_player_list.add_item("%s %s x%d — продажа: %.1f з." % [item.get("icon", "📦"), item.get("name", item_id), count, price])
		trade_player_list.set_item_metadata(trade_player_list.get_item_count() - 1, item_id)

func _on_buy_market_item() -> void:
	var sel = trade_merchant_list.get_selected_items()
	if sel.size() == 0: return
	var item_id = trade_merchant_list.get_item_metadata(sel[0])
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	var m = gm.local_market if gm else null
	if p and m:
		if m.buy_from_market(p, item_id, 1):
			var item = ItemDatabase.get_item(item_id)
			_log("[color=gold]Вы купили %s за %.1f золотых.[/color]" % [item.get("name", ""), m.get_current_price(item_id)])
			_refresh_trade_window()
		else:
			_log("[color=red]Недостаточно золота или товара нет на складе![/color]")

func _on_sell_market_item() -> void:
	var sel = trade_player_list.get_selected_items()
	if sel.size() == 0: return
	var item_id = trade_player_list.get_item_metadata(sel[0])
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	var m = gm.local_market if gm else null
	if p and m:
		if m.sell_to_market(p, item_id, 1):
			var item = ItemDatabase.get_item(item_id)
			_log("[color=green]Вы продали %s на рынке.[/color]" % item.get("name", ""))
			_refresh_trade_window()

# --- КУЗНИЦА И КРАФТ ---
var smith_recipes := [
	{
		"result_id": "iron_ingot",
		"name": "Выплавка: Слиток Синего Чугуна",
		"req": {"iron_ore": 2},
		"desc": "Переплавка 2 единиц железной руды в чистый слиток."
	},
	{
		"result_id": "sword_1h",
		"name": "Ковка: Стальной Меч",
		"req": {"iron_ingot": 3, "wood": 1},
		"desc": "Острый клинок для ближнего боя. Требует: 3 Слитка, 1 Дерево."
	},
	{
		"result_id": "sword_2h",
		"name": "Ковка: Двуручный Меч Лорда",
		"req": {"iron_ingot": 5, "wood": 2},
		"desc": "Тяжелый благородный меч. Требует: 5 Слитков, 2 Дерева."
	},
	{
		"result_id": "axe_1h",
		"name": "Ковка: Боевой Топор Кузнеца",
		"req": {"iron_ingot": 2, "wood": 2},
		"desc": "Рубящее оружие. Требует: 2 Слитка, 2 Дерева."
	},
	{
		"result_id": "shield_badge",
		"name": "Ковка: Рыцарский Щит",
		"req": {"iron_ingot": 2, "wood": 3},
		"desc": "Прочный дубовый щит. Требует: 2 Слитка, 3 Дерева."
	}
]

func _open_smithing_menu() -> void:
	_close_all_modals()
	is_ui_open = true
	smith_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	smith_recipe_list.clear()
	for i in smith_recipes.size():
		var r = smith_recipes[i]
		var item = ItemDatabase.get_item(r["result_id"])
		smith_recipe_list.add_item("%s %s" % [item.get("icon", "⚒️"), r["name"]])
	
	if smith_recipes.size() > 0:
		smith_recipe_list.select(0)
		_on_recipe_selected(0)

func _on_recipe_selected(idx: int) -> void:
	selected_recipe_idx = idx
	var r = smith_recipes[idx]
	var item = ItemDatabase.get_item(r["result_id"])
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	
	var req_str = ""
	for req_id in r["req"].keys():
		var req_item = ItemDatabase.get_item(req_id)
		var req_amt = r["req"][req_id]
		var have_amt = p.get_item_count(req_id) if p else 0
		var col = "green" if have_amt >= req_amt else "red"
		req_str += "• %s %s: [color=%s]%d / %d[/color]\n" % [req_item.get("icon", ""), req_item.get("name", req_id), col, have_amt, req_amt]
	
	smith_details_label.text = """[b]%s %s[/b]
%s

[b]Необходимые ресурсы:[/b]
%s""" % [item.get("icon", ""), r["name"], r["desc"], req_str]

func _on_craft_recipe_pressed() -> void:
	if selected_recipe_idx < 0: return
	var r = smith_recipes[selected_recipe_idx]
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	# Проверка наличия всех ингредиентов
	for req_id in r["req"].keys():
		if p.get_item_count(req_id) < r["req"][req_id]:
			_log("[color=red]Недостаточно ресурсов для ковки![/color]")
			return
	
	# Списание ресурсов
	for req_id in r["req"].keys():
		p.remove_item(req_id, r["req"][req_id])
	
	# Выдача результата
	p.add_item(r["result_id"], 1)
	var res_item = ItemDatabase.get_item(r["result_id"])
	_log("[color=gold]🔥 Вы успешно выковали: %s %s![/color]" % [res_item.get("icon", ""), res_item.get("name", "")])
	_on_recipe_selected(selected_recipe_idx)

func _close_all_modals() -> void:
	is_ui_open = false
	if is_building_mode:
		_cancel_building_mode()
	if dialogue_panel: dialogue_panel.visible = false
	if inventory_panel: inventory_panel.visible = false
	if trade_panel: trade_panel.visible = false
	if smith_panel: smith_panel.visible = false
	if event_panel: event_panel.visible = false
	if build_panel: build_panel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- ОКНО И ЛОГИКА СЛУЧАЙНЫХ СОБЫТИЙ МИРА ---
func _build_event_modal(canvas: CanvasLayer) -> void:
	event_panel = PanelContainer.new()
	event_panel.position = Vector2(280, 110)
	event_panel.custom_minimum_size = Vector2(720, 460)
	event_panel.visible = false
	canvas.add_child(event_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	event_panel.add_child(vbox)
	
	event_title_lbl = Label.new()
	event_title_lbl.add_theme_font_size_override("font_size", 18)
	event_title_lbl.text = "📜 СОБЫТИЕ МИРА ОЛДЕРИИ"
	vbox.add_child(event_title_lbl)
	
	event_desc_lbl = RichTextLabel.new()
	event_desc_lbl.bbcode_enabled = true
	event_desc_lbl.custom_minimum_size = Vector2(700, 130)
	event_desc_lbl.fit_content = true
	vbox.add_child(event_desc_lbl)
	
	var opt_title = Label.new()
	opt_title.text = "⚡ Ваше решение:"
	opt_title.add_theme_font_size_override("font_size", 15)
	vbox.add_child(opt_title)
	
	event_options_vbox = VBoxContainer.new()
	event_options_vbox.add_theme_constant_override("separation", 8)
	vbox.add_child(event_options_vbox)

func _trigger_random_event(force_id: String = "") -> void:
	var ev = EventSystem.get_event_by_id(force_id) if force_id != "" else EventSystem.get_random_event()
	_close_all_modals()
	is_ui_open = true
	event_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	event_title_lbl.text = "📜 %s: %s" % [ev.get("icon", "📜"), ev["title"]]
	event_desc_lbl.text = ev["desc"]
	
	for c in event_options_vbox.get_children():
		c.queue_free()
	
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	
	for opt in ev["options"]:
		var btn = Button.new()
		btn.text = opt["text"]
		
		# Проверка условий (предметы в инвентаре)
		var can_choose = true
		if opt.has("req_item"):
			var req_item_id = opt["req_item"]
			var req_amt = opt.get("req_amount", 1)
			var has_cnt = p.get_item_count(req_item_id) if p else 0
			if has_cnt < req_amt:
				can_choose = false
				btn.text += " (Нет нужного предмета!)"
				btn.disabled = true
		
		btn.pressed.connect(func(): _on_event_option_chosen(ev, opt))
		event_options_vbox.add_child(btn)

func _on_event_option_chosen(ev: Dictionary, opt: Dictionary) -> void:
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p:
		if opt.has("item_take") and opt["item_take"] != "":
			p.remove_item(opt["item_take"], opt.get("req_amount", 1))
		if opt.has("item_give") and opt["item_give"] != "":
			p.add_item(opt["item_give"], opt.get("item_give_amt", 1))
		if opt.has("gold"):
			p.gold += opt["gold"]
		if opt.has("honor"):
			p.honor += opt["honor"]
		if opt.has("renown"):
			p.renown += opt["renown"]
		if opt.has("hp_change"):
			player_hp = clampf(player_hp + opt["hp_change"], 1.0, player_max_hp)
		if opt.has("stamina_change"):
			player_stamina = clampf(player_stamina + opt["stamina_change"], 0.0, player_max_stamina)
	
	_log("[color=yellow][СОБЫТИЕ: %s][/color] %s" % [ev["title"], opt["outcome"]])
	_close_all_modals()

# --- РЕЖИМ СТРОИТЕЛЬСТВА И ВЛАДЕНИЙ [B] ---
func _build_construction_ui(canvas: CanvasLayer) -> void:
	build_panel = PanelContainer.new()
	build_panel.position = Vector2(280, 100)
	build_panel.custom_minimum_size = Vector2(720, 460)
	build_panel.visible = false
	canvas.add_child(build_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	build_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "🔨 ЧЕРТЕЖИ И СТРОИТЕЛЬСТВО ВЛАДЕНИЙ"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)
	
	var hbox = HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 16)
	vbox.add_child(hbox)
	
	build_list = ItemList.new()
	build_list.custom_minimum_size = Vector2(300, 300)
	build_list.item_selected.connect(_on_blueprint_selected)
	for i in build_blueprints.size():
		var b = build_blueprints[i]
		build_list.add_item(b["name"])
	hbox.add_child(build_list)
	
	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_vbox.add_theme_constant_override("separation", 12)
	hbox.add_child(right_vbox)
	
	build_info_lbl = RichTextLabel.new()
	build_info_lbl.bbcode_enabled = true
	build_info_lbl.custom_minimum_size = Vector2(360, 220)
	build_info_lbl.fit_content = true
	right_vbox.add_child(build_info_lbl)
	
	build_confirm_btn = Button.new()
	build_confirm_btn.text = "📐 Выбрать место для постройки"
	build_confirm_btn.pressed.connect(_start_ghost_placement)
	right_vbox.add_child(build_confirm_btn)
	
	var close_btn = Button.new()
	close_btn.text = "Закрыть [Esc]"
	close_btn.pressed.connect(_close_all_modals)
	vbox.add_child(close_btn)
	
	if build_blueprints.size() > 0:
		build_list.select(0)
		_on_blueprint_selected(0)

func _toggle_building_mode() -> void:
	if is_building_mode or (build_panel and build_panel.visible):
		_close_all_modals()
	else:
		_close_all_modals()
		is_ui_open = true
		build_panel.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_on_blueprint_selected(selected_blueprint_idx)

func _on_blueprint_selected(idx: int) -> void:
	selected_blueprint_idx = idx
	var bp = build_blueprints[idx]
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	
	var req_str = ""
	var can_build = true
	for req_id in bp["req"].keys():
		var item = ItemDatabase.get_item(req_id)
		var req_amt = bp["req"][req_id]
		var have_amt = p.get_item_count(req_id) if p else 0
		var col = "green" if have_amt >= req_amt else "red"
		if have_amt < req_amt: can_build = false
		req_str += "• %s %s: [color=%s]%d / %d[/color]\n" % [item.get("icon", ""), item.get("name", req_id), col, have_amt, req_amt]
	
	var income_str = "\n[color=gold]💰 Доход:[/color] +%d золотых/день" % bp["income"] if bp["income"] > 0 else ""
	
	build_info_lbl.text = """[b]%s[/b]
%s%s

[b]Необходимые материалы:[/b]
%s""" % [bp["name"], bp["desc"], income_str, req_str]
	
	build_confirm_btn.disabled = not can_build

func _start_ghost_placement() -> void:
	_close_all_modals()
	is_building_mode = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_spawn_ghost_mesh()
	_log("[color=yellow]Режим размещения: ЛКМ — построить | Q/R — вращение | Esc — отмена[/color]")

func _spawn_ghost_mesh() -> void:
	if ghost_instance:
		ghost_instance.queue_free()
	
	var bp = build_blueprints[selected_blueprint_idx]
	if ResourceLoader.exists(bp["model_path"]):
		var res = load(bp["model_path"])
		if res:
			ghost_instance = res.instantiate()
			ghost_instance.scale = Vector3.ONE * bp["scale"]
			_apply_ghost_material(ghost_instance)
			add_child(ghost_instance)

func _apply_ghost_material(node: Node) -> void:
	if node is MeshInstance3D:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.9, 0.3, 0.55)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		node.material_override = mat
	for c in node.get_children():
		_apply_ghost_material(c)

func _update_ghost_placement() -> void:
	if not ghost_instance or not player:
		return
	var cam_fwd = -camera_pivot.global_transform.basis.z
	cam_fwd.y = 0
	cam_fwd = cam_fwd.normalized()
	var place_pos = player.global_position + cam_fwd * 8.5
	place_pos.y = 0.0
	ghost_instance.global_position = place_pos
	ghost_instance.rotation_degrees.y = ghost_rotation_y

func _place_current_building() -> void:
	if not is_building_mode or not ghost_instance:
		return
	
	var bp = build_blueprints[selected_blueprint_idx]
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	for req_id in bp["req"].keys():
		if p.get_item_count(req_id) < bp["req"][req_id]:
			_log("[color=red]Недостаточно материалов для постройки![/color]")
			return
	
	for req_id in bp["req"].keys():
		p.remove_item(req_id, bp["req"][req_id])
	
	var build_pos = ghost_instance.global_position
	var build_rot = ghost_rotation_y
	
	var body = StaticBody3D.new()
	body.position = build_pos
	body.rotation_degrees.y = build_rot
	body.name = "Player_" + bp["name"]
	
	if ResourceLoader.exists(bp["model_path"]):
		var res = load(bp["model_path"])
		if res:
			var inst = res.instantiate()
			inst.scale = Vector3.ONE * bp["scale"]
			body.add_child(inst)
			_generate_exact_trimesh_recursive(inst, body, bp["scale"])
	
	var lbl = Label3D.new()
	lbl.text = "👑 " + bp["name"]
	lbl.position = Vector3(0, 10.0, 0)
	lbl.font_size = 38
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.outline_size = 6
	lbl.modulate = Color.GOLD
	body.add_child(lbl)
	
	player_buildings_container.add_child(body)
	p.owned_properties.append(body.name)
	p.renown += 10
	
	_log("[color=green]🎉 Вы успешно построили: %s (+10 славы)![/color]" % bp["name"])
	_cancel_building_mode()

func _cancel_building_mode() -> void:
	is_building_mode = false
	if ghost_instance:
		ghost_instance.queue_free()
		ghost_instance = null

func _update_shield_block_visual(blocking: bool) -> void:
	var model_inst = player.get_node_or_null("CharacterModel") if player else null
	if model_inst:
		var skel = _find_skeleton(model_inst)
		var s_slot = skel.get_node_or_null("ShieldSlot_L") if skel else null
		if s_slot:
			var tw = create_tween()
			var target_rot = Vector3(30, -45, 20) if blocking else Vector3.ZERO
			tw.tween_property(s_slot, "rotation_degrees", target_rot, 0.15)

# =========================================================
# 9. ФИЗИКА, УПРАВЛЕНИЕ И БОЕВАЯ СИСТЕМА
# =========================================================
func _physics_process(delta: float) -> void:
	if is_ui_open:
		return
	
	if not player.is_on_floor():
		player.velocity.y -= GRAVITY * delta
	else:
		if Input.is_key_pressed(KEY_SPACE) and not is_ui_open:
			player.velocity.y = 8.5
			if player_stamina >= 10.0:
				player_stamina -= 10.0
		else:
			player.velocity.y = 0.0
	
	if player_stamina < player_max_stamina:
		player_stamina = minf(player_max_stamina, player_stamina + 15.0 * delta)
	
	if attack_cooldown > 0.0:
		attack_cooldown -= delta
	
	var input := Vector2.ZERO
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		input.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		input.x += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		input.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		input.y += 1
	
	var is_moving = input != Vector2.ZERO
	var is_running = Input.is_key_pressed(KEY_SHIFT) and is_moving and player_stamina > 5.0
	
	if is_running:
		player_stamina = maxf(0.0, player_stamina - 20.0 * delta)
	
	if is_moving and not is_attacking:
		var cur_speed = PLAYER_RUN_SPEED if is_running else PLAYER_SPEED
		
		var cam_basis = camera_pivot.global_transform.basis
		var forward = -cam_basis.z
		forward.y = 0
		forward = forward.normalized()
		var right = cam_basis.x
		right.y = 0
		right = right.normalized()
		
		var move_dir = (forward * -input.y + right * input.x).normalized()
		player.velocity.x = move_dir.x * cur_speed
		player.velocity.z = move_dir.z * cur_speed
		
		var target_angle = atan2(move_dir.x, move_dir.z)
		player.rotation.y = lerp_angle(player.rotation.y, target_angle, delta * 12.0)
		
		if player_anim:
			var target_anim = "Running_A" if is_running else "Walking_A"
			if player_anim.current_animation != target_anim and player_anim.has_animation(target_anim):
				player_anim.play(target_anim)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, PLAYER_SPEED * 8.0 * delta)
		player.velocity.z = move_toward(player.velocity.z, 0, PLAYER_SPEED * 8.0 * delta)
		
		if player_anim and not is_attacking:
			if player_anim.current_animation != "Idle_A" and player_anim.has_animation("Idle_A"):
				player_anim.play("Idle_A")
	
	player.move_and_slide()

func _process(delta: float) -> void:
	target_cam_dist = 0.0 if is_first_person else CAMERA_DISTANCE
	cur_cam_dist = lerpf(cur_cam_dist, target_cam_dist, delta * 12.0)
	
	var cam_height = 1.75 if is_first_person else CAMERA_HEIGHT
	camera_pivot.position = player.position + Vector3(0, cam_height, 0)
	camera_pivot.rotation = Vector3(camera_pitch, camera_yaw, 0)
	camera.position = Vector3(0, 0, cur_cam_dist)
	
	# Скрытие модели рыцаря в виде от 1-го лица
	var player_model = player.get_node_or_null("CharacterModel") if player else null
	if player_model:
		player_model.visible = not is_first_person
	
	# ИИ Собаки-Компаньона
	if dog_body and player:
		var dog_dist = dog_body.position.distance_to(player.position)
		if not dog_body.is_on_floor():
			dog_body.velocity.y -= GRAVITY * delta
		else:
			dog_body.velocity.y = 0.0
			
		if dog_dist > 3.2:
			var d_dir = (player.position - dog_body.position).normalized()
			var d_speed = 6.5 if dog_dist > 8.0 else 3.5
			dog_body.velocity.x = d_dir.x * d_speed
			dog_body.velocity.z = d_dir.z * d_speed
			dog_body.rotation.y = lerp_angle(dog_body.rotation.y, atan2(d_dir.x, d_dir.z), delta * 8.0)
		else:
			dog_body.velocity.x = move_toward(dog_body.velocity.x, 0, 8.0 * delta)
			dog_body.velocity.z = move_toward(dog_body.velocity.z, 0, 8.0 * delta)
		dog_body.move_and_slide()
	
	if health_bar:
		health_bar.value = (player_hp / player_max_hp) * 100.0
	if hp_label:
		hp_label.text = "❤️ Здоровье: %.0f / %.0f" % [player_hp, player_max_hp]
	if stamina_bar:
		stamina_bar.value = (player_stamina / player_max_stamina) * 100.0
	if stamina_label:
		stamina_label.text = "⚡ Выносливость: %.0f / %.0f" % [player_stamina, player_max_stamina]
	
	# Поведение NPC
	for i in npc_data.size():
		var npc = npc_data[i]
		var node: CharacterBody3D = npc_nodes[i]
		var n_anim: AnimationPlayer = npc_anims[i]
		var dist = node.position.distance_to(npc["target"])
		
		if not node.is_on_floor():
			node.velocity.y -= GRAVITY * delta
		else:
			node.velocity.y = 0.0
		
		if dist > 1.2:
			var dir = (npc["target"] - node.position).normalized()
			node.velocity.x = dir.x * NPC_SPEED
			node.velocity.z = dir.z * NPC_SPEED
			var t_rot = atan2(dir.x, dir.z)
			node.rotation.y = lerp_angle(node.rotation.y, t_rot, delta * 6.0)
			
			if n_anim and n_anim.has_animation("Walking_A") and n_anim.current_animation != "Walking_A":
				n_anim.play("Walking_A")
		else:
			node.velocity.x = 0.0
			node.velocity.z = 0.0
			_update_npc_routine(i)
			if n_anim and n_anim.has_animation("Idle_A") and n_anim.current_animation != "Idle_A":
				n_anim.play("Idle_A")
		
		node.move_and_slide()
		
		var plate: Label3D = node.get_node_or_null("StatusPlate")
		if plate:
			plate.text = "%s\n%s %s" % [npc["name"], npc["thought"], npc["role"]]
	
	# Обновление голограммы строительства
	if is_building_mode:
		_update_ghost_placement()
	
	# Агрессивный AI разбойников в лесу
	for i in npc_data.size():
		var npc = npc_data[i]
		if npc["role"] in ["Разбойник", "Бандит"] and not npc.get("is_dead", false):
			var n_node: CharacterBody3D = npc_nodes[i]
			var dist_to_p = n_node.global_position.distance_to(player.global_position)
			if dist_to_p < 18.0 and dist_to_p > 2.0:
				npc["target"] = player.global_position
				npc["thought"] = "⚔️"
			elif dist_to_p <= 2.0 and attack_cooldown <= 0.0:
				_on_bandit_attack_player(i)
	
	# Таймер случайных событий
	if not is_ui_open:
		event_timer -= delta
		if event_timer <= 0.0:
			event_timer = randf_range(120.0, 240.0)
			_trigger_random_event()
	
	var tm = _get_time_manager()
	var time_str = tm.get_formatted_time() if tm else "07:00"
	var date_str = tm.get_formatted_date() if tm else "1-й день"
	time_label.text = "🕒 %s | %s" % [time_str, date_str]
	
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p:
		var w_name = ItemDatabase.get_item(p.equipped_weapon).get("name", "Кулаки")
		var s_name = ItemDatabase.get_item(p.equipped_shield).get("name", "Нет")
		player_card.text = """[b]%s[/b] | 💰 Золото: [color=gold]%d[/color] | Слава: %d | Честь: %d
[b]Оружие:[/b] %s | [b]Щит:[/b] %s""" % [p.get_full_display_name(), p.gold, p.renown, p.honor, w_name, s_name]
	
	if interaction_target >= 0 and not is_ui_open:
		hint_label.text = "[ E ] Поговорить с %s | [ ЛКМ ] Атака | [ I ] Инвентарь" % npc_data[interaction_target]["name"]
		hint_label.visible = true
	else:
		hint_label.visible = false

func _perform_melee_attack() -> void:
	if is_attacking or attack_cooldown > 0.0 or player_stamina < 15.0:
		return
	
	is_attacking = true
	attack_cooldown = 0.55
	player_stamina -= 18.0
	
	# Запуск правильной боевой анимации замаха (Throw)
	if player_anim:
		if player_anim.has_animation("Throw"):
			player_anim.play("Throw")
		elif player_anim.has_animation("Interact"):
			player_anim.play("Interact")
	
	# Процедурный стремительный взмах клинка
	var model_inst = player.get_node_or_null("CharacterModel")
	if model_inst:
		var skel: Skeleton3D = _find_skeleton(model_inst)
		var w_slot = skel.get_node_or_null("WeaponSlot_R") if skel else null
		if w_slot:
			var tw = create_tween()
			tw.tween_property(w_slot, "rotation_degrees", Vector3(35, 45, -30), 0.07)
			tw.tween_property(w_slot, "rotation_degrees", Vector3(-55, -60, 45), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tw.tween_property(w_slot, "rotation_degrees", Vector3.ZERO, 0.18)
	
	get_tree().create_timer(0.45).timeout.connect(func(): is_attacking = false)
	
	var forward = -player.global_transform.basis.z.normalized()
	for i in npc_nodes.size():
		var node: CharacterBody3D = npc_nodes[i]
		var to_npc = node.global_position - player.global_position
		var dist = to_npc.length()
		if dist < 3.2:
			var dot = forward.dot(to_npc.normalized())
			if dot > 0.3:
				_on_hit_npc(i)

func _on_hit_npc(idx: int) -> void:
	var npc = npc_data[idx]
	var node = npc_nodes[idx]
	var anim = npc_anims[idx]
	var dmg = randi_range(20, 35)
	npc["hp"] -= dmg
	
	if anim and anim.has_animation("Hit_A"):
		anim.play("Hit_A")
	
	_log("[color=orange]Вы нанесли %d урона персонажу %s![/color]" % [dmg, npc["name"]])
	
	if npc["role"] != "Бандит":
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		if p: p.honor -= 10
		_alert_guards(node.global_position)
	
	if npc["hp"] <= 0:
		_on_npc_defeated(idx)

func _alert_guards(crime_pos: Vector3) -> void:
	for i in npc_data.size():
		if npc_data[i]["role"] == "Стражник":
			npc_data[i]["target"] = crime_pos
			npc_data[i]["thought"] = "⚔️"
			_log("[color=red]Стражник Роланд заметил преступление и обнажил меч![/color]")

func _on_npc_defeated(idx: int) -> void:
	var npc = npc_data[idx]
	var loot = npc["gold"]
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if p:
		p.gold += loot
		p.renown += 5
	_log("[color=green]%s повержен! Вы забрали трофеи: %d золотых.[/color]" % [npc["name"], loot])
	npc["gold"] = 0
	npc["hp"] = 60.0
	npc["thought"] = "🩹"

func _update_npc_routine(idx: int) -> void:
	var npc = npc_data[idx]
	var tm = _get_time_manager()
	var hour = tm.hour if tm else 12
	
	var dest_key: String
	if hour >= 22 or hour < 6:
		npc["thought"] = "💤"
		dest_key = npc["home"]
	elif hour >= 6 and hour < 18:
		dest_key = npc["work"]
		match npc["role"]:
			"Крестьянин": npc["thought"] = "🌾"
			"Торговец": npc["thought"] = "⚖️"
			"Стражник": npc["thought"] = "🛡️"
			"Бандит": npc["thought"] = "🗡️"
			"Кузнец": npc["thought"] = "⚒️"
			"Лорд": npc["thought"] = "👑"
			"Наемник": npc["thought"] = "🏹"
	else:
		dest_key = npc["evening"]
		npc["thought"] = "🍺"
	
	var base = npc_activity_spots.get(dest_key, Vector3.ZERO)
	npc["target"] = base + Vector3(randf_range(-2.5, 2.5), 0, randf_range(-2.5, 2.5))

# =========================================================
# 10. УПРАВЛЕНИЕ МЫШЬЮ И ДИАЛОГАМИ
# =========================================================
func _on_bandit_attack_player(idx: int) -> void:
	var npc = npc_data[idx]
	var dmg = randi_range(14, 24)
	if is_blocking and player_stamina >= 10.0:
		player_stamina -= 12.0
		dmg = int(dmg * 0.25)
		_log("[color=lightblue]🛡️ Вы заблокировали удар %s щитом! (-%d HP)[/color]" % [npc["name"], dmg])
	else:
		_log("[color=red]⚔️ %s нанес вам %d урона![/color]" % [npc["name"], dmg])
	player_hp = maxf(0.0, player_hp - dmg)
	attack_cooldown = 1.4

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_yaw -= event.relative.x * MOUSE_SENSITIVITY
		camera_pitch -= event.relative.y * MOUSE_SENSITIVITY
		camera_pitch = clampf(camera_pitch, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_building_mode:
				_place_current_building()
			elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				_perform_melee_attack()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_building_mode:
				_cancel_building_mode()
			elif not is_ui_open:
				is_blocking = event.pressed
				_update_shield_block_visual(is_blocking)
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_V:
			is_first_person = not is_first_person
			_log("[color=cyan]📷 Камера переключена: %s [V][/color]" % ("1-е Лицо (Вид из глаз)" if is_first_person else "3-е Лицо (Из-за плеча)"))
		elif event.keycode == KEY_B:
			_toggle_building_mode()
		elif is_building_mode and event.keycode == KEY_Q:
			ghost_rotation_y -= 45.0
		elif is_building_mode and event.keycode == KEY_R:
			ghost_rotation_y += 45.0
		elif event.keycode == KEY_I or event.keycode == KEY_TAB:
			_toggle_inventory()
		elif event.keycode == KEY_E and interaction_target >= 0 and not is_ui_open and not is_building_mode:
			_open_dialogue(interaction_target)
		elif event.keycode == KEY_ESCAPE:
			if is_building_mode:
				_cancel_building_mode()
			elif is_ui_open:
				_close_all_modals()
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _open_dialogue(idx: int) -> void:
	var npc = npc_data[idx]
	_close_all_modals()
	is_ui_open = true
	dialogue_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	dialogue_title.text = "Разговор: %s (%s)" % [npc["name"], npc["role"]]
	
	var traits_str = ", ".join(npc.get("traits", []))
	var goal_str = npc.get("goal", "Жить своей жизнью")
	
	var greeting := ""
	match npc["role"]:
		"Крестьянин": greeting = "«Приветствую тебя, путник. Земля требует заботы с рассвета до заката.»"
		"Торговец": greeting = "«Добро пожаловать! У меня лучшие товары во всей Олдерии, клянусь честью!»"
		"Городской Стражник": greeting = "«Стой, путник. В городе закон и порядок. Держи свой клинок в ножнах.»"
		"Кузнец": greeting = "«Звон наковальни не умолкает! Нужен острый клинок или починка брони?»"
		"Наемник": greeting = "«Мой клинок служит тому, кто платит звонкой монетой. Есть дело?»"
		"Разбойник": greeting = "«Ты зашел слишком далеко в чащу, путник... Либо плати пошлину, либо готовься к бою!»"
		"Дворянин": greeting = "«Говори быстро и по делу. Время знати стоит дороже золота простолюдинов.»"
		_: greeting = "«Здравствуй, путник. Чем могу помочь?»"
	
	if "Жадный" in npc.get("traits", []):
		greeting += " «...И если у тебя звенят монеты — мы обязательно договоримся.»"
	elif "Набожный" in npc.get("traits", []):
		greeting += " «Да хранят тебя Светлые Боги на этих опасных дорогах.»"
	elif "Трусливый" in npc.get("traits", []):
		greeting += " «(нервно оглядывается по сторонам) Только без резких движений...»"
	elif "Храбрый" in npc.get("traits", []):
		greeting += " «Я не боюсь ни разбойников из чащи, ни волков из Чернолесья!»"
	
	dialogue_text.text = """%s

[color=gold]🎭 Черты:[/color] %s
[color=lightblue]🎯 Цель жизни:[/color] %s
[color=gray]💰 Золото: %d з. | ❤️ Здоровье: %.0f/%.0f | Отношение: %d[/color]""" % [greeting, traits_str, goal_str, npc["gold"], npc["hp"], npc.get("max_hp", 100.0), npc.get("reputation_to_player", 0)]
	
	for c in dialogue_options_container.get_children():
		c.queue_free()
	
	if npc["role"] == "Торговец" or npc["work"] == "tavern" or npc["work"] == "market":
		_add_dialogue_btn("«Открыть торговлю» (Купить / Продать)", _open_market_trade)
	
	if npc["role"] == "Кузнец" or npc["work"] == "blacksmith":
		_add_dialogue_btn("«Использовать кузницу и горн» (Крафт оружия)", _open_smithing_menu)
	
	_add_dialogue_btn("«Я помогу твоей цели» (Подарить 15 золотых)", func():
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		if p and p.gold >= 15:
			p.gold -= 15
			npc["gold"] += 15
			npc["reputation_to_player"] = npc.get("reputation_to_player", 0) + 35
			p.honor += 8
			p.renown += 3
			_log("[color=green]%s горячо благодарит вас (+35 отношения, +8 чести)![/color]" % npc["name"])
		else:
			_log("[color=red]У вас недостаточно золота для подарка![/color]")
		_close_all_modals()
	)
	
	_add_dialogue_btn("«Поделиться хлебом» (Угостить едой)", func():
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		if p and p.remove_item("bread", 1):
			npc["gold"] += 2
			npc["reputation_to_player"] = npc.get("reputation_to_player", 0) + 15
			p.honor += 5
			_log("[color=green]%s сердечно благодарит вас за хлеб (+15 отношения)![/color]" % npc["name"])
		else:
			_log("[color=red]У вас нет хлеба в инвентаре![/color]")
		_close_all_modals()
	)
	
	if npc["role"] in ["Наемник", "Крестьянин", "Разбойник"]:
		_add_dialogue_btn("«Вступай в мою дружину» (Нанять за 40 золотых)", func():
			var gm = _get_game_manager()
			var p = gm.player_data if gm else null
			if p and p.gold >= 40:
				p.gold -= 40
				npc["gold"] += 40
				npc["role"] = "Дружинник"
				npc["thought"] = "⚔️"
				npc["reputation_to_player"] = 100
				p.subordinates.append(npc["name"])
				p.renown += 10
				_log("[color=gold]🎉 %s присягнул вам на верность и вступил в ваш отряд![/color]" % npc["name"])
			else:
				_log("[color=red]Недостаточно золота для найма (нужно 40 монет)![/color]")
			_close_all_modals()
		)
	
	_add_dialogue_btn("«Отдавай кошелек!» (Ограбить)", func():
		var gm = _get_game_manager()
		var p = gm.player_data if gm else null
		if "Трусливый" in npc.get("traits", []) or randf() < 0.4:
			var loot = randi_range(10, min(npc["gold"], 35))
			if p:
				p.gold += loot
				p.honor -= 20
				p.renown += 4
			npc["gold"] = max(0, npc["gold"] - loot)
			npc["reputation_to_player"] = -80
			_log("[color=red]Вы запугали и ограбили %s на %d золотых (-20 чести)![/color]" % [npc["name"], loot])
		else:
			_log("[color=orange]%s дал отпор и зовет стражу![/color]" % npc["name"])
			_alert_guards(player.global_position)
		_close_all_modals()
	)
	
	_add_dialogue_btn("«Бывай.» (Закрыть)", _close_all_modals)

func _add_dialogue_btn(txt: String, callback: Callable) -> void:
	var btn = Button.new()
	btn.text = txt
	btn.pressed.connect(callback)
	dialogue_options_container.add_child(btn)

func _on_change_role_pressed() -> void:
	var idx = role_option_btn.selected
	var target_role = role_option_btn.get_item_text(idx)
	var gm = _get_game_manager()
	var p = gm.player_data if gm else null
	if not p: return
	
	var check = HierarchyManager.can_assume_role(p, target_role)
	if check["allowed"]:
		HierarchyManager.change_role(p, target_role)
		_log("[color=green]Вы успешно приняли новый статус: %s![/color]" % target_role)
	else:
		_log("[color=red]Не удалось сменить статус: %s[/color]" % check["reason"])

func _log(msg: String) -> void:
	var tm = _get_time_manager()
	var time_str = tm.get_formatted_time() if tm else "00:00"
	log_box.text = "[%s] %s\n" % [time_str, msg] + log_box.text

func _get_time_manager() -> Node:
	return get_node_or_null("/root/TimeManager")

func _get_game_manager() -> Node:
	return get_node_or_null("/root/GameManager")
