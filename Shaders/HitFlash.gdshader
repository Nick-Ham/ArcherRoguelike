shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_strength : hint_range(0.0, 1.0);

void fragment() {
	vec4 newColor = texture(TEXTURE, UV);

	float flashStrengthClamped = clamp(flash_strength, 0.0, 1.0);
	vec3 maxFlash = flash_color.rgb;

	newColor = mix(newColor, vec4(maxFlash, newColor.a), flashStrengthClamped);

	COLOR = newColor;
}