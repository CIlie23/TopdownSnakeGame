shader_type spatial;
render_mode unshaded, cull_front, blend_mix;

uniform vec4 fog_color : source_color = vec4(0.6, 0.7, 0.8, 1.0);
uniform float edge_fade_start = 40.0;
uniform float edge_fade_end = 90.0;
uniform float fog_density = 1.0;

void fragment() {
    float dist = length(VERTEX.xz); // radial distance on flat ground
    float fade = smoothstep(edge_fade_start, edge_fade_end, dist * fog_density);

    ALBEDO = fog_color.rgb;
    ALPHA = fade * fog_color.a;
}
