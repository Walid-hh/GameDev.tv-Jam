/*
	Camera Shake Effect Shader by @Near

	MIT License
*/

shader_type canvas_item;
uniform bool is_shaking = false;
uniform float ShakeStrength = 0.2;
uniform vec2 FactorA  = vec2(100.0,100.0);
uniform vec2 FactorB  = vec2(1.0,1.0);
uniform vec2 magnitude = vec2(0.01,0.01);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

void fragment() {
	vec2 uv = SCREEN_UV;
	if (is_shaking == true){
	uv -= 0.5;
    uv *= 1.0 - 2.0 * magnitude.x;
    uv += 0.5;
	vec2 dt = vec2(0.0, 0.0);
	dt.x = sin(TIME * FactorA.x+FactorB.x) * magnitude.x;
	dt.y = cos(TIME *FactorA.y+ FactorB.y) * magnitude.y;
	COLOR = texture(SCREEN_TEXTURE,uv + (dt*ShakeStrength));
	}
	else {
		COLOR = texture(SCREEN_TEXTURE ,uv);
	}
}

