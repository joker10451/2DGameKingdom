shader_type spatial;
render_mode unshaded, fog_disabled;

// Стилизованный Post-Process шейдер для создания авторского контура (Outline) и цветовой градации
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;

uniform float outline_thickness : hint_range(0.5, 3.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.06, 0.08, 0.14, 1.0);
uniform float depth_threshold : hint_range(0.0005, 0.02) = 0.0035;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 tex_size = vec2(textureSize(screen_texture, 0));
	vec2 uv = SCREEN_UV;
	vec2 offset = vec2(outline_thickness) / tex_size;
	
	float d_c = texture(depth_texture, uv).r;
	float d_u = texture(depth_texture, uv + vec2(0.0, offset.y)).r;
	float d_d = texture(depth_texture, uv - vec2(0.0, offset.y)).r;
	float d_l = texture(depth_texture, uv - vec2(offset.x, 0.0)).r;
	float d_r = texture(depth_texture, uv + vec2(offset.x, 0.0)).r;
	
	float depth_diff = abs(d_u - d_d) + abs(d_r - d_l);
	
	vec4 base_color = texture(screen_texture, uv);
	
	if (depth_diff > depth_threshold && d_c < 0.9995) {
		ALBEDO = outline_color.rgb;
	} else {
		// Мягкая стилизованная коррекция насыщенности и контраста
		vec3 col = base_color.rgb;
		col = pow(col, vec3(0.96));
		ALBEDO = col;
	}
}
