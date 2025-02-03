// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 color : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.01);

const vec3 magic = vec3(0.06711056f, 0.00583715f, 52.9829189f);

void fragment() {
	ALBEDO = color.rgb;
	EMISSION = (color.rgb) * emission_energy;

	ALBEDO.rgb = color.rgb;
	if (color.a < 0.001 || color.a < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
