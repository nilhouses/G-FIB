#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const float PI = 3.141592;

const vec3 RED = vec3(1,0,0);
const vec3 WHITE = vec3(1,1,1);

float aastep(float threshold, float x)
{
	float width = 0.7*length(vec2(dFdx(x), dFdy(x)));
	return smoothstep(threshold-width, threshold+width, x);
}

uniform bool classic = true; 
 
void main()
{
	float r = 0.2;
	vec2 center = vec2(0.5);
	float d = distance(vtexCoord,center);
	//Cercle
	if (distance(vtexCoord, center) <= r) 
		fragColor = vec4(RED,0.0);
	else
		fragColor = vec4(WHITE,0.0);
	//Raigs
	if (!classic) {
		float phi = PI/16;
		vec2 u = vtexCoord - vec2(0.5);  
		float theta = atan(u.t, u.s);
		if (mod(theta/phi + 0.5, 2) < 1) fragColor = vec4(RED,1.0);
	}
}

