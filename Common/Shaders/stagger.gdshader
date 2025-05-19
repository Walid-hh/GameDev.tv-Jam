shader_type canvas_item;

// How fast the flash effect occurs (higher = faster)
uniform float flash_speed : hint_range(1.0, 20.0) = 8.0;
// How intense the white flash is (0.0 = no effect, 1.0 = full white)
uniform float flash_intensity : hint_range(0.0, 1.0) = 0.9;
// Whether the flash effect is active
uniform bool is_flashing = false;

void fragment() {
	// Get the original sprite texture
	vec4 original_color = texture(TEXTURE, UV);
	
	// Only apply effect to non-transparent pixels
	if (original_color.a > 0.0 && is_flashing) {
		// Create flashing effect using sine wave
		float flash_amount = (sin(TIME * flash_speed) + 1.0) * 0.5 * flash_intensity;
		
		// Mix between original color and white based on the flash amount
		vec4 white_color = vec4(1.0, 1.0, 1.0, original_color.a);
		COLOR = mix(original_color, white_color, flash_amount);
	} else {
		// If not flashing or pixel is transparent, use original color
		COLOR = original_color;
	}
}