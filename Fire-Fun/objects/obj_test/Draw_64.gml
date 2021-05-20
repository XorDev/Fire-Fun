///@desc Post process

var bloom_passes = 4;//higher = brighter, but slower

//First bloom pass:
var scale = 2;
surface_set_target(surf1);
shader_set(shd_bloom);
texture_set_stage(uni_noise,sprite_get_texture(spr_bluenoise,0));
shader_set_uniform_f(uni_radius,scale);
draw_surface(application_surface,0,0);
shader_reset();
surface_reset_target();

//Additional bloom passes:
repeat(bloom_passes)
{
	scale *= 2;
	surface_set_target(surf2);
	shader_set(shd_bloom);
	shader_set_uniform_f(uni_radius,scale);
	draw_surface(surf1,0,0);
	shader_reset()
	surface_reset_target();

	scale *= 2;
	surface_set_target(surf1);
	shader_set(shd_bloom);
	shader_set_uniform_f(uni_radius,scale);
	draw_surface(surf2,0,0);
	shader_reset();
	surface_reset_target();
}

//Post processing:
shader_set(shd_post);
shader_set_uniform_f(uni_ptime,get_timer()/1000000);
draw_surface(surf1,0,0);
shader_reset()