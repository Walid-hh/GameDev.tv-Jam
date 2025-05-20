shader_type canvas_item;

// Replace TIME with custom time parameter
uniform float visible_time = 0.0;

// Controls how much the texture elongates downward
uniform float elongation_factor : hint_range(0.0, 300.0) = 40.0;
// Controls the horizontal shrink amount (as a percentage from each side)
uniform float shrink_factor : hint_range(0.0, 10.0) = 5.0;
// Animation duration in seconds
uniform float duration : hint_range(0.1, 10.0) = 3.0;
// Time offset to control when shrinking starts (as fraction of duration)
uniform float shrink_start_time : hint_range(0.0, 1.0) = 0.5;
// Whether the animation should loop
uniform bool loop = false;
// Controls alpha fade during shrink phase
uniform bool fade_out = true;

void vertex() {
    // Get the normalized time (0.0 to 1.0) - use visible_time instead of TIME
    float normalized_time = loop ? fract(visible_time / duration) : clamp(visible_time / duration, 0.0, 1.0);
    
    // Calculate elongation progress (increases from 0 to 1 during phase 1)
    float elongation_progress = clamp(normalized_time / shrink_start_time, 0.0, 1.0);
    
    // Calculate shrink progress (increases from 0 to 1 during phase 2)
    float shrink_progress = clamp((normalized_time - shrink_start_time) / (1.0 - shrink_start_time), 0.0, 1.0);
    
    // Only elongate bottom vertices (y > 0.5)
    // This creates the stretching effect downward
    if (UV.y > 0.5) {
        // Calculate how much to elongate based on how far down the vertex is
        // Bottom vertices (UV.y = 1.0) get maximum elongation
        float vertex_elongation = elongation_factor * elongation_progress * (UV.y - 0.5) * 2.0;
        
        // Apply elongation to position (move vertices downward)
        VERTEX.y += vertex_elongation * TEXTURE_PIXEL_SIZE.y * 100.0;
    }
    
    // Apply horizontal shrinking during phase 2
    if (normalized_time > shrink_start_time) {
        // Calculate current shrink width from each side
        float current_shrink = shrink_factor * shrink_progress;
        
        // UV.x ranges from 0.0 to 1.0 across the sprite
        // Move vertices inward based on their horizontal position
        if (UV.x < 0.5) {
            // Left side vertices move right
            VERTEX.x += current_shrink * TEXTURE_PIXEL_SIZE.x * 100.0 * (0.5 - UV.x) * 2.0;
        } else {
            // Right side vertices move left
            VERTEX.x -= current_shrink * TEXTURE_PIXEL_SIZE.x * 100.0 * (UV.x - 0.5) * 2.0;
        }
    }
}

void fragment() {
    // Get the normalized time (0.0 to 1.0) - use visible_time instead of TIME
    float normalized_time = loop ? fract(visible_time / duration) : clamp(visible_time / duration, 0.0, 1.0);
    
    // Calculate shrink progress (increases from 0 to 1 during phase 2)
    float shrink_progress = clamp((normalized_time - shrink_start_time) / (1.0 - shrink_start_time), 0.0, 1.0);
    
    // Sample the texture with original UVs (vertices have already been moved)
    COLOR = texture(TEXTURE, UV);
    
    // Fade out alpha as we approach the end of the animation
    if (fade_out && normalized_time > shrink_start_time) {
        COLOR.a *= (1.0 - shrink_progress);
    }
}