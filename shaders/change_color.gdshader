shader_type canvas_item;
uniform vec4 color;
void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	// Preserve alpha
	COLOR = vec4(color.x, color.y, color.z, curr_color.w);
}