//Number of bloom samples. Higher = smoother, slower
#define SAMPLES 64.

uniform float radius;
uniform sampler2D noise;//bluenoise texture

varying vec4 v_color;
varying vec2 v_coord;
varying vec2 v_texel;

vec2 hash2(vec2 p)
{
	return normalize(texture2D(noise,p/256.).rg-.5);
	//normalize(fract(cos(mod(p*mat2(195,174,286,183)+radius*vec2(9,7),99.))*742.)-.5)
}

void main()
{
	vec4 blur = vec4(0);
	float total = 0.;
	
	float scale = radius/SAMPLES;
	vec2 point = hash2(gl_FragCoord.xy+radius/3.)*scale;
	//vec2 point = vec2(scale,0);
	
	mat2 ang = mat2(.73736882209777832,-.67549037933349609,.67549037933349609,.73736882209777832);
	
	for(float i = 1.;i<=SAMPLES;i++)
	{
		point *= ang;
		
		vec2 coord = v_coord + i*point*v_texel;
		
		blur += texture2D(gm_BaseTexture,coord)/i;
		total += 1./i;
	}
	blur /= total/1.2;
	blur = max(texture2D(gm_BaseTexture,v_coord),blur);
	gl_FragColor = v_color * blur;
}