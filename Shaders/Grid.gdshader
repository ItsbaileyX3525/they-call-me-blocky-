shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float grid_size = 64.0;
uniform float line_thickness = 1.0;

void fragment() {
	vec2 screen_pos = FRAGCOORD.xy;

	vec2 dist = mod(screen_pos, grid_size);

	float line_x = step(dist.x, line_thickness);
	float line_y = step(dist.y, line_thickness);
	float line = max(line_x, line_y);

	COLOR = mix(COLOR, grid_color, line);
}
