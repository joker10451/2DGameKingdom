with open('godot/src/game/GameWorld3D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add 1st person state and dog companion to variables
old_vars = '''var camera_yaw: float = 0.0
var camera_pitch: float = -0.3'''

new_vars = '''var camera_yaw: float = 0.0
var camera_pitch: float = -0.3
var is_first_person: bool = false
var cur_cam_dist: float = 7.0
var target_cam_dist: float = 7.0

# 🐕 3D Собака-Компаньон
var dog_body: CharacterBody3D = null
var dog_target_pos: Vector3 = Vector3.ZERO
var dog_loyalty: int = 80'''

text = text.replace(old_vars, new_vars, 1)

# 2. Add Poly Haven and Dog spawns to _ready()
old_ready_calls = '''\t_spawn_player_character()
\t_spawn_npc_citizens()
\t_build_ui_hud()'''

new_ready_calls = '''\t_spawn_player_character()
\t_spawn_npc_citizens()
\t_spawn_polyhaven_structures()
\t_spawn_dog_companion_3d()
\t_build_ui_hud()'''

text = text.replace(old_ready_calls, new_ready_calls, 1)

# 3. Add Poly Haven structures and 3D Dog spawn functions before _setup_environment_and_lighting
polyhaven_funcs = '''# =========================================================
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
	lbl.text = "🐕 Верный (Пес-Компаньон)\n[E] Погладить / Дать кость"
	lbl.position = Vector3(0, 1.4, 0)
	lbl.font_size = 28
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.outline_size = 6
	lbl.modulate = Color(1.0, 0.9, 0.6)
	dog_body.add_child(lbl)
	
	add_child(dog_body)
'''

text = text.replace('# =========================================================\n# 1. СВЕТ, НЕБО И ОКРУЖЕНИЕ', polyhaven_funcs + '\n# =========================================================\n# 1. СВЕТ, НЕБО И ОКРУЖЕНИЕ', 1)

# 4. Update _physics_process to support Jump (Space)
old_jump_check = '''\tif not player.is_on_floor():
\t\tplayer.velocity.y -= GRAVITY * delta
\telse:
\t\tplayer.velocity.y = 0.0'''

new_jump_check = '''\tif not player.is_on_floor():
\t\tplayer.velocity.y -= GRAVITY * delta
\telse:
\t\tif Input.is_key_pressed(KEY_SPACE) and not is_ui_open:
\t\t\tplayer.velocity.y = 8.5
\t\t\tif player_stamina >= 10.0:
\t\t\t\tplayer_stamina -= 10.0
\t\telse:
\t\t\tplayer.velocity.y = 0.0'''

text = text.replace(old_jump_check, new_jump_check, 1)

# 5. Update _process to handle 1st / 3rd person camera smoothly and Dog Companion AI
old_cam_process = '''func _process(delta: float) -> void:
\tcamera_pivot.position = player.position + Vector3(0, CAMERA_HEIGHT, 0)
\tcamera_pivot.rotation = Vector3(camera_pitch, camera_yaw, 0)
\tcamera.position = Vector3(0, 0, CAMERA_DISTANCE)'''

new_cam_process = '''func _process(delta: float) -> void:
\ttarget_cam_dist = 0.0 if is_first_person else CAMERA_DISTANCE
\tcur_cam_dist = lerpf(cur_cam_dist, target_cam_dist, delta * 12.0)
\t
\tvar cam_height = 1.75 if is_first_person else CAMERA_HEIGHT
\tcamera_pivot.position = player.position + Vector3(0, cam_height, 0)
\tcamera_pivot.rotation = Vector3(camera_pitch, camera_yaw, 0)
\tcamera.position = Vector3(0, 0, cur_cam_dist)
\t
\t# Скрытие модели рыцаря в виде от 1-го лица
\tvar player_model = player.get_node_or_null("CharacterModel") if player else null
\tif player_model:
\t\tplayer_model.visible = not is_first_person
\t
\t# ИИ Собаки-Компаньона
\tif dog_body and player:
\t\tvar dog_dist = dog_body.position.distance_to(player.position)
\t\tif not dog_body.is_on_floor():
\t\t\tdog_body.velocity.y -= GRAVITY * delta
\t\telse:
\t\t\tdog_body.velocity.y = 0.0
\t\t\t
\t\tif dog_dist > 3.2:
\t\t\tvar d_dir = (player.position - dog_body.position).normalized()
\t\t\tvar d_speed = 6.5 if dog_dist > 8.0 else 3.5
\t\t\tdog_body.velocity.x = d_dir.x * d_speed
\t\t\tdog_body.velocity.z = d_dir.z * d_speed
\t\t\tdog_body.rotation.y = lerp_angle(dog_body.rotation.y, atan2(d_dir.x, d_dir.z), delta * 8.0)
\t\telse:
\t\t\tdog_body.velocity.x = move_toward(dog_body.velocity.x, 0, 8.0 * delta)
\t\t\tdog_body.velocity.z = move_toward(dog_body.velocity.z, 0, 8.0 * delta)
\t\tdog_body.move_and_slide()'''

text = text.replace(old_cam_process, new_cam_process, 1)

# 6. Update _input to handle [ V ] camera toggle and mouse capture
old_input_key = '''\t\tif event.keycode == KEY_B:
\t\t\t_toggle_building_mode()'''

new_input_key = '''\t\tif event.keycode == KEY_V:
\t\t\tis_first_person = not is_first_person
\t\t\t_log("[color=cyan]📷 Камера переключена: %s [V][/color]" % ("1-е Лицо (Вид из глаз)" if is_first_person else "3-е Лицо (Из-за плеча)"))
\t\telif event.keycode == KEY_B:
\t\t\t_toggle_building_mode()'''

text = text.replace(old_input_key, new_input_key, 1)

with open('godot/src/game/GameWorld3D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Successfully upgraded GameWorld3D.gd with 1st/3rd person toggle, Poly Haven models, and 3D Dog Companion!")
