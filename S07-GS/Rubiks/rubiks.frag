#version 330 core

in vec2 vtexCoord;
in vec4 gfrontColor;
out vec4 fragColor;

const vec4 BLACK = vec4(vec3(0.0), 1.0);

void main()
{
    float s = vtexCoord.s;
    float t = vtexCoord.t;
    if (s >= 0.05 && s <= 0.95 && t >= 0.05 && t <= 0.95) fragColor = gfrontColor;
    else  fragColor = BLACK;
}
