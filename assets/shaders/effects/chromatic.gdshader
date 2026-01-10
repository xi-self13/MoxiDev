shader_type canvas_item;

uniform float intensity : hint_range(0, 10) = 2.0; // how strong the split is
uniform float health_ratio : hint_range(0,1) = 1.0; // 1 = full health, 0 = dead
uniform float time : hint_range(0,100) = 0.0; // for wobbly effect
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
    vec2 uv = SCREEN_UV;

    // make the effect stronger as health drops
    float amt = intensity * (1.0 - health_ratio);

    // add a tiny time-based wobble
    float wobble = sin(time * 5.0) * 0.005;

    // sample the screen texture for each channel slightly offset
    //vec4 r = texture(SCREEN_TEXTURE, uv + vec2(amt + wobble, 0));
    //vec4 g = texture(SCREEN_TEXTURE, uv + vec2(0, amt + wobble));
    //vec4 b = texture(SCREEN_TEXTURE, uv + vec2(-amt - wobble, 0));
	vec4 r = texture(SCREEN_TEXTURE)
    COLOR = vec4(0,0,0, 1.0);
}