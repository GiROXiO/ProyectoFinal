shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 src_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 c = src_color.rgb;

    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    vec3 mono = vec3(gray);
    COLOR = vec4(mono, src_color.a);
}