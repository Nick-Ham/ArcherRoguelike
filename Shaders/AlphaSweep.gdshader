shader_type canvas_item;

uniform float sweepAmount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 newColor = texture(TEXTURE, UV);

	float newAlpha = UV.x > sweepAmount ? 0.0 : newColor.a;

	COLOR = vec4(newColor.rgb, newAlpha);
}