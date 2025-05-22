#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec3 N[];
const float speed = 0.5; //enunciat 1.2, racó  0.5
uniform float time;

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;

vec3 mean( vec3 N1, vec3 N2, vec3 N3 )
{
	return (N1 + N2 + N3)/3.0;
}

vec3 explode (vec3 P, vec3 n)
{
	return  P + n * speed * time;
}

void main( void )
{
	vec3 n = mean(N[0], N[1], N[2]);
	
	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vfrontColor[i];
		gl_Position = modelViewProjectionMatrix * vec4(explode(gl_in[i].gl_Position.xyz, n), 1.0);
		EmitVertex();
	}
    EndPrimitive();
}
