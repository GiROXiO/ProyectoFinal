shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const vec3 TRITA_FILA0 = vec3(0.950, 0.050, 0.000);
const vec3 TRITA_FILA1 = vec3(0.000, 0.433, 0.567);
const vec3 TRITA_FILA2 = vec3(0.000, 0.475, 0.525);

void fragment() {
    // Leemos el color debajo de este ColorRect
    vec4 src_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 c = src_color.rgb;

    // Multiplicación manual fila por fila
    float r = dot(TRITA_FILA0, c);
    float g = dot(TRITA_FILA1, c);
    float b = dot(TRITA_FILA2, c);
    vec3 dal_color = vec3(r, g, b);

    COLOR = vec4(dal_color, src_color.a);
}