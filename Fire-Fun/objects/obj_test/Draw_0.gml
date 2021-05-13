///@desc Fireballs!

if !clear
{
	draw_clear(0);
	clear = 1;
}

if !surface_exists(surf1) surf1 = surface_create(ww,wh);
if !surface_exists(surf2) surf2 = surface_create(ww,wh);


surface_copy(surf1,0,0,application_surface);

shader_set(shd_distort);
shader_set_uniform_f(uni_time,get_timer()/1000000);
texture_set_stage(uni_noise,sprite_get_texture(spr_bluenoise,0));
draw_surface(surf1,0,0);
shader_reset();

//Draw fire
if mouse_check_button(mb_left)
{
	var radius = random(ww/32);
	draw_circle(mouse_x,mouse_y,radius,0);
	draw_line_width(mouse_x,mouse_y,xprev,yprev,radius*2);
}
//Erase
if mouse_check_button(mb_right) 
{
	draw_set_color(0);
	draw_circle(mouse_x,mouse_y,ww/16,0);
	draw_set_color(-1);
}
//Make lots of particles!
if keyboard_check(vk_space)
{
	ds_list_add(px,mouse_x);
	ds_list_add(py,mouse_y);
	ds_list_add(vx,random(20)-10);
	ds_list_add(vy,random(20)-10);
}

xprev = mouse_x;
yprev = mouse_y;

//Draw the particles
for(var i = 0;i<ds_list_size(px);i++)
{
	px[|i] += vx[|i];
	py[|i] += vy[|i];
	//Gravity
	vy[|i] += .1;
	//Or follow the mouse?
	//vx[|i] += .01*(mouse_x+random_range(-ww,ww)/8-px[|i])-.1*vx[|i];
	//vy[|i] += .01*(mouse_y+random_range(-ww,ww)/8-py[|i])-.1*vy[|i];
	
	draw_set_color(c_white);
	draw_circle(px[|i],py[|i],ww/256,0);
	draw_set_color(-1);
	
	//Get rid of the ones outside the screen
	if (abs(px[|i]-ww/2)>ww/2+ww/64 || abs(py[|i]-wh/2)>wh/2+ww/64)
	{
		ds_list_delete(px,i);
		ds_list_delete(py,i);
		ds_list_delete(vx,i);
		ds_list_delete(vy,i);
		i--;
	}
}

if keyboard_check(vk_escape) game_end();