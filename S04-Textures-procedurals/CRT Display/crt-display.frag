#version 330 core

in vec4 frontColor;
out vec4 fragColor;

uniform int n;

void main()
{
    if (mod(floor(gl_FragCoord.y),n) == 0) fragColor = frontColor;
	else discard;
}
