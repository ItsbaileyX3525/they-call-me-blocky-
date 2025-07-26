shader_type canvas_item;

uniform float crack_density = 40.0;
uniform float crack_intensity = 0.15;
uniform vec2 world_offset; // the object's position in world space

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// Use object position + screen UV to create stable world-based cracks
	vec2 world_pos = UV * crack_density + world_offset;

	float noise = rand(floor(world_pos));

	vec4 base = COLOR;
	base.rgb -= crack_intensity * step(0.9, noise);

	COLOR = base;
}
