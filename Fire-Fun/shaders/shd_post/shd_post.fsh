//#define glitch
#define glitch_amt .05
#define glitch_num 20.

varying vec4 v_color;
varying vec2 v_coord;
varying vec2 v_texel;

uniform float time;

vec2 hash2(vec2 p)
{
	return fract(cos(p*mat2(195,174,286,183))*742.)-.5;
}
vec2 coord(vec2 c,float s)
{
	vec2 new = (c-.5)/s;
	float v = dot(new,new);
	
	#ifdef glitch
	vec2 off = hash2(ceil(c*glitch_num)+time*.1);
	new += hash2(ceil(c*glitch_num-time*.1+off))*glitch_amt*v;
	#endif
	return new+.5;
}
void main()
{
	vec4 tex   = texture2D(gm_BaseTexture,coord(v_coord,1.00));
	     tex.g = texture2D(gm_BaseTexture,coord(v_coord,1.01)).g;
	     tex.b = texture2D(gm_BaseTexture,coord(v_coord,1.02)).b;
	gl_FragColor = v_color * tex;
}