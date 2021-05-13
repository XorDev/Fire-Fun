///@desc Init

ww = window_get_width();
wh = window_get_height();

camera_set_view_size(view_camera[0],ww,wh);
surface_resize(application_surface,ww,wh);

xprev = 0;
yprev = 0;

//Surfaces:
clear = 0;
surf1 = -1;
surf2 = -1;

//Shader uniforms:
uni_radius = shader_get_uniform(shd_bloom,"radius");
uni_noise = shader_get_sampler_index(shd_bloom,"noise");
gpu_set_tex_filter_ext(uni_noise,0);
gpu_set_tex_repeat_ext(uni_noise,1);
uni_time = shader_get_uniform(shd_distort,"time");
uni_ptime = shader_get_uniform(shd_post,"time");

//Particle list (probably a bad method.)
px = ds_list_create();
py = ds_list_create();
vx = ds_list_create();
vy = ds_list_create();