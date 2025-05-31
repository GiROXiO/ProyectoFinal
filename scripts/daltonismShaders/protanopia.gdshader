shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const vec3 PROTAN_FILA0 = vec3(0.567, 0.433, 0.000);
const vec3 PROTAN_FILA1 = vec3(0.558, 0.442, 0.000);
const vec3 PROTAN_FILA2 = vec3(0.000, 0.242, 0.758);

void fragment() {
    vec4 src_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 c = src_color.rgb;

    float r = dot(PROTAN_FILA0, c);
    float g = dot(PROTAN_FILA1, c);
    float b = dot(PROTAN_FILA2, c);

    vec3 dal_color = vec3(r, g, b);
    COLOR = vec4(dal_color, src_color.a);
}
