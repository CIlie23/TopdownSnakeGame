RSRC                    VisualShader            ��������                                            |      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    parameter_name 
   qualifier    texture_type    color_default    texture_filter    texture_repeat    texture_source    script    source    texture    noise_type    seed 
   frequency    offset    fractal_type    fractal_octaves    fractal_lacunarity    fractal_gain    fractal_weighted_strength    fractal_ping_pong_strength    cellular_distance_function    cellular_jitter    cellular_return_type    domain_warp_enabled    domain_warp_type    domain_warp_amplitude    domain_warp_frequency    domain_warp_fractal_type    domain_warp_fractal_octaves    domain_warp_fractal_lacunarity    domain_warp_fractal_gain    width    height    invert    in_3d_space    generate_mipmaps 	   seamless    seamless_blend_skirt    as_normal_map    bump_strength 
   normalize    color_ramp    noise    input_name 	   function    hint    min    max    step    default_value_enabled    default_value 	   operator    op_type    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    flags/fog_disabled    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        1   local://VisualShaderNodeTexture2DParameter_im7kn '      &   local://VisualShaderNodeTexture_txmjo m         local://FastNoiseLite_gegdl �         local://NoiseTexture2D_42x00 �      &   local://VisualShaderNodeTexture_4psiy �      $   local://VisualShaderNodeInput_hx25j :      (   local://VisualShaderNodeFloatFunc_bkyay q      $   local://VisualShaderNodeRemap_0m23q �      -   local://VisualShaderNodeFloatParameter_sa6lw       &   local://VisualShaderNodeFloatOp_2tlpq r      &   local://VisualShaderNodeFloatOp_27jqf �      #   local://VisualShaderNodeStep_atkes �      #   res://shaders/dissolve_shader.tres #      #   VisualShaderNodeTexture2DParameter             Albedo          VisualShaderNodeTexture                      FastNoiseLite             NoiseTexture2D    0                     VisualShaderNodeTexture                                         VisualShaderNodeInput    1         time          VisualShaderNodeFloatFunc    2                   VisualShaderNodeRemap                        ��           �?                        �?         VisualShaderNodeFloatParameter             Speed 7         8         @         VisualShaderNodeFloatOp    9                  VisualShaderNodeFloatOp                                 )   �������?         VisualShaderNodeStep             VisualShader    ;      u  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D Albedo;
uniform sampler2D tex_frg_4;
uniform float Speed = 2;



void fragment() {
	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(Albedo, UV);


// Texture2D:4
	vec4 n_out4p0 = texture(tex_frg_4, UV);
	float n_out4p1 = n_out4p0.r;


// FloatParameter:8
	float n_out8p0 = Speed;


// Input:5
	float n_out5p0 = TIME;


// FloatOp:9
	float n_out9p0 = n_out8p0 * n_out5p0;


// FloatFunc:6
	float n_out6p0 = sin(n_out9p0);


// FloatOp:10
	float n_in10p1 = 0.10000;
	float n_out10p0 = n_out6p0 + n_in10p1;


// Step:11
	float n_out11p0 = step(n_out4p1, n_out10p0);


	float n_out7p0;
// Remap:7
	float n_in7p1 = -1.00000;
	float n_in7p2 = 1.00000;
	float n_in7p3 = 0.00000;
	float n_in7p4 = 1.00000;
	{
		float __input_range = n_in7p2 - n_in7p1;
		float __output_range = n_in7p4 - n_in7p3;
		n_out7p0 = n_in7p3 + __output_range * ((n_out6p0 - n_in7p1) / __input_range);
	}


// Output:0
	ALBEDO = vec3(n_out3p0.xyz);
	ALPHA = n_out4p0.x;
	EMISSION = vec3(n_out11p0);
	ALPHA_SCISSOR_THRESHOLD = n_out7p0;


}
 W             X   
      �  �BY            Z   
     ��  �A[            \   
     \�  �C]            ^   
     u�  �D_            `   
     �� ��Da            b   
   d{�Bh�>Dc            d   
     k�  �De         	   f   
     �  �Dg         
   h   
     ��  WDi            j   
     ��  4Dk       0                                                                                	              	      	                     
       
                                              RSRC