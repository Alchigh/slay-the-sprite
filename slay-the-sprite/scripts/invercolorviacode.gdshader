shader_type canvas_item;

uniform bool invert = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (invert) {
        COLOR.rgb = 1.0 - tex_color.rgb;
    } else {
        COLOR.rgb = tex_color.rgb;
    }
    COLOR.a = tex_color.a;
}