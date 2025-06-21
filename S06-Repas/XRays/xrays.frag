#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D foot0;
uniform sampler2D foot1;
uniform sampler2D foot2;
uniform sampler2D foot3;

const float R = 80.0;

uniform int layer = 2;

uniform vec2 mousePosition;
uniform bool virtualMouse;
uniform float mouseX, mouseY; 
uniform vec2 viewport;

vec2 mouse()
{
	if (virtualMouse) return vec2(mouseX, mouseY);
	else return mousePosition;
}

void main() 
{
    float d = distance(vtexCoord * viewport, mouse());

    vec4 C = texture(foot0, vtexCoord);
    vec4 D = vec4(0.0);
    if (layer == 0) D = texture(foot0, vtexCoord);
    else if (layer == 1) D = texture(foot1, vtexCoord);
    else if (layer == 2) D = texture(foot2, vtexCoord);
    else if (layer == 3) D = texture(foot3, vtexCoord);

    if (d >= R) fragColor = C;
    else fragColor = mix(D,C, d/R);
}

