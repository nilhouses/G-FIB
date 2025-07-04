#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const float r = 0.2;
const vec2 center = vec2(0.5);

const vec3 RED = vec3(1,0,0);
const vec3 WHITE = vec3(1,1,1);

float aastep(float threshold, float x)
{
	float width = 0.7*length(vec2(dFdx(x), dFdy(x)));
	return smoothstep(threshold-width, threshold+width, x);
}

void main()
{
	float d = distance(vtexCoord,center);
	float alpha = aastep(r, d);
	vec3 Color = mix(RED, WHITE, alpha);
	fragColor = vec4(Color,1.0);
}
