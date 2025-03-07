#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const float r = 0.2;
const vec2 center = vec2(0.5);

void main()
{
	if (distance(vtexCoord, center) <= r) 
		fragColor = vec4(1.0,0.0,0.0,0.0);
	else 
		fragColor = vec4(1.0,1.0,1.0,0.0);
}
