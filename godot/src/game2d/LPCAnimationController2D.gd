class_name LPCAnimationController2D
extends RefCounted

# LPC Animation Controller for authentic 4-directional frame-by-frame sprites
# Directions: 0 = UP, 1 = LEFT, 2 = DOWN, 3 = RIGHT

enum AnimState { IDLE, WALK, SLASH, HURT }

var sprite: Sprite2D
var prefix: String = "skel" # "skel" or "male" or "boss"

var textures: Dictionary = {} # "idle", "walk", "slash", "hurt" -> Texture2D
var current_state: AnimState = AnimState.IDLE
var current_dir: int = 2 # 2 = DOWN (facing camera)
var frame_timer: float = 0.0
var current_frame_idx: int = 0
var is_locked: bool = false # locked during one-shot animations like slash or hurt
var on_anim_finished_cb: Callable

const FRAME_RATES = {
	AnimState.IDLE: 0.50,   # 2 frames = 1.0s loop
	AnimState.WALK: 0.085,  # 9 frames = ~0.76s loop (smooth walk)
	AnimState.SLASH: 0.055, # 6 frames = ~0.33s one-shot
	AnimState.HURT: 0.08    # 6 frames = ~0.48s one-shot
}

const FRAME_COUNTS = {
	AnimState.IDLE: 2,
	AnimState.WALK: 9,
	AnimState.SLASH: 6,
	AnimState.HURT: 6
}

func setup(spr: Sprite2D, char_prefix: String = "skel") -> void:
	sprite = spr
	prefix = char_prefix
	_load_textures()
	current_state = AnimState.IDLE
	current_dir = 2
	_apply_state_texture()
	_update_sprite_frame()

func _load_textures() -> void:
	var base_prefix = prefix
	for k in ["idle", "walk", "slash", "hurt"]:
		var p_comp = ProjectSettings.globalize_path("res://assets/lpc/composite/%s_%s.png" % [base_prefix, k])
		var p_raw = ProjectSettings.globalize_path("res://assets/lpc/raw/%s_%s.png" % [base_prefix, k])
		var p_to_load = p_comp if FileAccess.file_exists(p_comp) else p_raw
		if FileAccess.file_exists(p_to_load):
			var img = Image.load_from_file(p_to_load)
			if img and not img.is_empty():
				textures[k] = ImageTexture.create_from_image(img)

func play(state: AnimState, dir: int = -1, on_finished: Callable = Callable()) -> void:
	if dir >= 0:
		current_dir = clampi(dir, 0, 3)
		
	if is_locked and state != AnimState.HURT and current_state == AnimState.SLASH:
		return # Wait for slash to finish
		
	if current_state == state and not is_locked:
		_update_sprite_frame()
		return
		
	current_state = state
	current_frame_idx = 0
	frame_timer = 0.0
	on_anim_finished_cb = on_finished
	
	if state in [AnimState.SLASH, AnimState.HURT]:
		is_locked = true
	else:
		is_locked = false
		
	_apply_state_texture()
	_update_sprite_frame()

func set_direction_from_vector(dir_vec: Vector2) -> void:
	if dir_vec.length_squared() < 0.01:
		return
	var new_dir = current_dir
	if abs(dir_vec.x) > abs(dir_vec.y):
		new_dir = 3 if dir_vec.x > 0 else 1 # 3 = RIGHT, 1 = LEFT
	else:
		new_dir = 2 if dir_vec.y > 0 else 0 # 2 = DOWN, 0 = UP
	
	if new_dir != current_dir:
		current_dir = new_dir
		_update_sprite_frame()

func _apply_state_texture() -> void:
	if not is_instance_valid(sprite):
		return
		
	var state_name = "idle"
	match current_state:
		AnimState.IDLE:
			state_name = "idle"
		AnimState.WALK:
			state_name = "walk"
		AnimState.SLASH:
			state_name = "slash"
		AnimState.HURT:
			state_name = "hurt"
			
	if textures.has(state_name) and textures[state_name] != null:
		sprite.texture = textures[state_name]
		sprite.region_enabled = false
		sprite.centered = true

	match current_state:
		AnimState.IDLE:
			sprite.hframes = 2
			sprite.vframes = 4
		AnimState.WALK:
			sprite.hframes = 9
			sprite.vframes = 4
		AnimState.SLASH:
			sprite.hframes = 6
			sprite.vframes = 4
		AnimState.HURT:
			sprite.hframes = 6
			sprite.vframes = 1

func _update_sprite_frame() -> void:
	if not is_instance_valid(sprite):
		return
		
	var max_f = FRAME_COUNTS[current_state]
	var f = current_frame_idx % max_f
	
	if current_state == AnimState.HURT:
		sprite.frame = clampi(f, 0, 5)
	else:
		sprite.frame = current_dir * max_f + f

func update(delta: float) -> void:
	if not is_instance_valid(sprite):
		return
		
	var frame_dur = FRAME_RATES[current_state]
	frame_timer += delta
	
	if frame_timer >= frame_dur:
		frame_timer -= frame_dur
		var max_f = FRAME_COUNTS[current_state]
		current_frame_idx += 1
		
		if current_frame_idx >= max_f:
			if current_state in [AnimState.SLASH, AnimState.HURT]:
				is_locked = false
				var cb = on_anim_finished_cb
				on_anim_finished_cb = Callable()
				if current_state == AnimState.SLASH:
					play(AnimState.IDLE, current_dir)
				if cb.is_valid():
					cb.call()
				return
			else:
				current_frame_idx = 0
				
		_update_sprite_frame()
