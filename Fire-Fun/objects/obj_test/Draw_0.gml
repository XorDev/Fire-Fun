///@desc Fireballs!

if !clear
{
	draw_clear(0);
	clear = 1;
}

if !surface_exists(surf1) surf1 = surface_create(ww,wh);
if !surface_exists(surf2) surf2 = surface_create(ww,wh);

//Resize surfaces
if (ww != window_get_width()) || (wh != window_get_height())
{
	ww = max(window_get_width(),1);
	wh = max(window_get_height(),1);

	camera_set_view_size(view_camera[0],ww,wh);
	surface_resize(application_surface,ww,wh);
	surface_resize(surf1,ww,wh);
	surface_resize(surf2,ww,wh);
}

surface_copy(surf1,0,0,application_surface);

shader_set(shd_distort);
shader_set_uniform_f(uni_time,get_timer()/1000000);
draw_surface(surf1,0,0);
shader_reset();

var radius = ww/64;
//Draw fire
if mouse_check_button(mb_left)
{
	draw_circle(mouse_x,mouse_y,radius,0);
	draw_line_width(mouse_x,mouse_y,xprev,yprev,radius*2);
	
	if !irandom(9)
	{
		ds_list_add(px,mouse_x);
		ds_list_add(py,mouse_y);
		ds_list_add(vx,random(10)-5);
		ds_list_add(vy,random(10)-5);
	}
}
//Erase
if mouse_check_button(mb_right) 
{
	draw_set_color(0);
	draw_circle(mouse_x,mouse_y,radius+10,0);
	draw_line_width(mouse_x,mouse_y,xprev,yprev,radius*2+20);
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
	//Gravity
	vy[|i] += .2;
	//Or follow the mouse?
	//vx[|i] += .005*(mouse_x+random_range(-ww,ww)/1-px[|i])-.01*vx[|i];
	//vy[|i] += .005*(mouse_y+random_range(-ww,ww)/1-py[|i])-.01*vy[|i];
	
	//Update position
	var _px,_py;
	_px = px[|i];
	_py = py[|i];
	px[|i] += vx[|i];
	py[|i] += vy[|i];
	
	draw_circle(px[|i],py[|i],ww/256,0);
	draw_line_width(_px,_py,px[|i],py[|i],ww/128);
	
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