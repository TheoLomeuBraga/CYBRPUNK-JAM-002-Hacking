shader_type sky;

uniform sampler2D sky_gradient : filter_nearest_mipmap_anisotropic ;

void sky() {

	COLOR = texture(sky_gradient,vec2((EYEDIR.y / 2.0) + 0.5,0.0)).xyz / 1.25;

}
