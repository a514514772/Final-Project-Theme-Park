#version 420 core

layout(location = 0) in vec3 iv3vertex;
layout(location = 1) in vec3 iv3normal;
layout(location = 2) in vec2 iv2texcoord;

uniform mat4 um4mvp;
uniform mat4 M;
uniform mat4 V;
uniform mat4 shadow_matrix;
uniform vec4 plane;

out vec4 shadow_coord;
out vec3 vv3color;
out vec2 vv2texcoord;
out vec3 vv3vertex;
out int flag;
out float visibility;

const float density = 0.0005;
const float grad = 5;

void main()
{
	vec4 world_cor = M * vec4(iv3vertex, 1.0);

	gl_Position = um4mvp*vec4(iv3vertex, 1.0);
	gl_ClipDistance[0] = dot(plane, world_cor);

	vv3color = iv3normal;
	vv2texcoord = iv2texcoord;
	vv3vertex = iv3vertex;
	
	shadow_coord = shadow_matrix * vec4(iv3vertex, 1.0);

	vec4 posToCam = V * world_cor;
	float dis = length(posToCam.xyz);
	visibility = exp(-pow((dis*density),grad));
	visibility = clamp(visibility,0.5,1.0);
}