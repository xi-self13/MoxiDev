shader_type spatial;
render_mode unshaded, depth_prepass_alpha, cull_back, blend_add;

uniform vec4 beam_color : source_color = vec4(1.0, 1.0, 0.8, 0.5); // Light yellow
uniform float beam_softness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Simple fade from center to edges
    float alpha = 1.0 - (UV.x * 2.0 - 1.0) * (UV.x * 2.0 - 1.0);
    alpha = pow(alpha, 0.5) * beam_softness;
    ALBEDO = beam_color.rgb;
    ALPHA = beam_color.a * alpha;
}