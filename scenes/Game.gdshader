shader_type fog;

uniform sampler2D noise_tex;
//uniform float fall_off = 0.0;
uniform float noise_scale = 1.0;

void fog() {
	float noise = texture(noise_tex, WORLD_POSITION.xz*noise_scale).r;
	DENSITY = noise;
	DENSITY *= step(0.0, -SDF);
	ALBEDO = vec3(10.0);
}
