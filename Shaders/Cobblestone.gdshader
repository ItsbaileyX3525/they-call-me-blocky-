shader_type canvas_item;

uniform float crack_density = 40.0;
uniform float crack_intensity = 0.15;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 screen_pos = SCREEN_UV / SCREEN_PIXEL_SIZE;

	vec2 scaled = screen_pos / crack_density;

	float noise = rand(floor(scaled));

	vec4 base = COLOR;
	base.rgb -= crack_intensity * step(0.9, noise);

	COLOR = base;
}
