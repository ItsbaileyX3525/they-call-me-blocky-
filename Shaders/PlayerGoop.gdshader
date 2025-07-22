shader_type canvas_item;

uniform float time_scale = 1.0;
uniform float blob_amount = 0.15;
uniform float blob_frequency = 8.0;
uniform float sharpness = 3.0;
uniform vec4 slime_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = UV;
	float t = TIME * time_scale;

	float y = uv.y;

	if (y > 0.5) {
		float falloff = pow((y - 0.5) * 2.0, sharpness); // smoother falloff near 0.5

		float distortion = sin((uv.x + t) * blob_frequency) * blob_amount * falloff;

		uv.y += distortion;
	}

	if (uv.y < 0.0 || uv.y > 1.0)
		discard;

	COLOR = slime_color;
}
