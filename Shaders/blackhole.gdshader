shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform float strength : hint_range(0.0, 0.5) = 0.2;
uniform float black_radius : hint_range(0.1, 1.0) = 0.3;

void fragment() {
	vec2 diff = vec2(0.5) - UV;
	float d = length(diff);
	vec2 dir = normalize(diff);

	float f = clamp(1.0 - d / (black_radius * 2.0), 0.0, 1.0);
	float shelf = smoothstep(0.0, 1.0, f);

	float displacement = strength / (d * d + 0.01);
	vec2 uv = SCREEN_UV + dir * displacement * shelf;

	vec3 col = texture(SCREEN_TEXTURE, uv).rgb;

	float horizon = smoothstep(black_radius - 0.05, black_radius + 0.05, d);
	col = mix(col, vec3(0.0), horizon);

	COLOR = vec4(col, 1.0);
}