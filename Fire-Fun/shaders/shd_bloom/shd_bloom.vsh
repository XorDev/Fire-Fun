attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 v_color;
varying vec2 v_coord;
varying vec2 v_texel;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position,1);
	mat4 proj = gm_Matrices[MATRIX_PROJECTION];
    
    v_color = in_Colour;
    v_coord = in_TextureCoord;
	v_texel = vec2(length(proj[0].xyz),length(proj[1].xyz))/2.;
}