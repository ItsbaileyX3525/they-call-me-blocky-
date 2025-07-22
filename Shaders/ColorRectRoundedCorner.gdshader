shader_type canvas_item;

uniform vec2 rect_size = vec2(200.0, 200.0);
uniform float radius = 20.0;

void fragment() {
    vec2 pos = UV * rect_size;

    float dist_tl = length(pos - vec2(radius, radius));
    float dist_tr = length(pos - vec2(rect_size.x - radius, radius));
    float dist_bl = length(pos - vec2(radius, rect_size.y - radius));
    float dist_br = length(pos - vec2(rect_size.x - radius, rect_size.y - radius));

    if (pos.x < radius && pos.y < radius && dist_tl > radius) {
        discard;
    } else if (pos.x > rect_size.x - radius && pos.y < radius && dist_tr > radius) {
        discard;
    } else if (pos.x < radius && pos.y > rect_size.y - radius && dist_bl > radius) {
        discard;
    } else if (pos.x > rect_size.x - radius && pos.y > rect_size.y - radius && dist_br > radius) {
        discard;
    }

    COLOR = COLOR;
}
