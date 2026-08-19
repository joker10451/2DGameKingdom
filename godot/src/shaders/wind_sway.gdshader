shader_type canvas_item;

// Шейдер плавного колыхания крон деревьев и пшеницы на ветру
uniform float wind_speed : hint_range(0.1, 10.0) = 2.2;
uniform float wind_strength : hint_range(0.0, 30.0) = 3.5;
uniform float detail_strength : hint_range(0.0, 10.0) = 1.2;

void vertex() {
	// Колышем только верхнюю часть объекта (чем меньше UV.y, тем сильнее амплитуда)
	float height_factor = 1.0 - clamp(UV.y, 0.0, 1.0);
	float wave = sin(TIME * wind_speed + VERTEX.x * 0.05) * wind_strength;
	float micro_wave = cos(TIME * wind_speed * 1.7 + VERTEX.y * 0.08) * detail_strength;
	
	VERTEX.x += (wave + micro_wave) * height_factor;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
}
