#define color_multiply vec3(.965,.95,.93) //dark orange
//#define color_multiply vec3(.99,.983,.97) //orange
//#define color_multiply vec3(.985,.97,.99) //purple
//#define color_multiply vec3(.98,.99,.96) //lime
//#define color_multiply vec3(.96,.98,.99) //blue

varying vec4 v_color;
varying vec2 v_coord;
varying vec2 v_texel;

uniform float time;

vec2 hash2(vec2 p)
{
	return fract(cos(p*mat2(195,174,286,183))*742.)-.5;
}

vec2 value2(vec2 p)
{
	vec2 o = vec2(0,1);
	vec2 f = floor(p);
	vec2 s = p-f;
	s *= s*(3.-s*2.);
	
	return mix(mix(hash2(f+o.xx),hash2(f+o.yx),s.x),mix(hash2(f+o.xy),hash2(f+o.yy),s.x),s.y);
}

void main()
{
	vec2 off = cos(gl_FragCoord.yx/46.+cos(gl_FragCoord.xy/99.)+time)
	+2.*value2(gl_FragCoord.xy/20.+vec2(0,4)*time);
	//vec2 off = 2.*value2(gl_FragCoord.xy/26.+vec2(1,4)*time);
	//vec2 off = 3.*sign(cos(gl_FragCoord.yx/36.+time));
	//vec2 off = 4.*value2(gl_FragCoord.xy/26.+vec2(0,4)*time);
	//vec2 off = cos(gl_FragCoord.yx/6.+cos(gl_FragCoord.yx/45.));
	off.y += 2.0;
	
	//Sample the last frame, but with local offsets:
	vec4 tex = texture2D(gm_BaseTexture, v_coord+off*v_texel);
	tex = max(tex,texture2D(gm_BaseTexture,v_coord+v_texel*vec2(0,1))*.99); 
	
	//Fade to black:
	gl_FragColor = v_color * vec4(tex.rgb*color_multiply-1./255.,1);
}