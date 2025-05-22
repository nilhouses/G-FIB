#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

const float areamax = 0.0005;
uniform mat4 projectionMatrix;

const vec3 R = vec3(1.0, 0.0, 0.0);
const vec3 Y = vec3(1.0, 1.0, 0.0);

void main( void )
{
	vec3 v0 = gl_in[0].gl_Position.xyz;
	vec3 v1 = gl_in[1].gl_Position.xyz;
	vec3 v2 = gl_in[2].gl_Position.xyz;

	vec3 v = v1 - v0;
	vec3 u = v2 - v0;

	float modul = length(cross(u, v));

	float area = (modul / 2.0) / areamax;

	gfrontColor = vec4(mix(R,Y, fract(area)),1.0);

	for( int i = 0 ; i < 3 ; i++ )
	{
		//gfrontColor = vfrontColor[i];
		gl_Position = projectionMatrix * gl_in[i].gl_Position;
		EmitVertex();
	}
    EndPrimitive();
}
