shader_type canvas_item;

// Шейдер живой реки со световыми бликами, рябью и течением
uniform vec4 deep_color : source_color = vec4(0.12, 0.32, 0.58, 0.92);
uniform vec4 shallow_color : source_color = vec4(0.20, 0.50, 0.78, 0.95);
uniform vec4 highlight_color : source_color = vec4(0.70, 0.88, 1.0, 0.7);
uniform float flow_speed : hint_range(0.1, 5.0) = 1.2;

void fragment() {
	vec2 uv = UV;
	
	// Горизонтальное течение реки
	float t = TIME * flow_speed;
	float wave1 = sin(uv.y * 18.0 + t + uv.x * 6.0);
	float wave2 = cos(uv.x * 24.0 - t * 1.3 + uv.y * 10.0);
	float ripple = (wave1 + wave2) * 0.5;
	
	// Градиент глубины
	vec4 base_water = mix(deep_color, shallow_color, smoothstep(-0.6, 0.6, ripple));
	
	// Солнечные блики (caustics)
	float caustic = smoothstep(0.72, 0.95, ripple);
	vec4 final_col = mix(base_water, highlight_color, caustic * 0.45);
	
	// Пена по краям
	float edge_foam = smoothstep(0.08, 0.0, uv.y) + smoothstep(0.92, 1.0, uv.y);
	final_col = mix(final_col, vec4(0.95, 0.98, 1.0, 0.8), clamp(edge_foam * 0.6, 0.0, 1.0));
	
	COLOR = final_col;
}
