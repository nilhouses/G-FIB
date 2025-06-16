#version 330 core

in vec2 vtexCoord;
uniform sampler2D sampler0;
uniform sampler2D sampler1;
uniform sampler2D sampler2;
uniform sampler2D sampler3;

out vec4 fragColor;

uniform float slice = 0.1;
uniform float time;

void main()
{
    float t = mod(time, 4*slice);
    if (0 <= t && t < slice) fragColor = texture(sampler0, vtexCoord);
    else if (slice <= t && t < 2*slice) fragColor = texture(sampler1, vtexCoord);
    else if (2*slice <= t && t < 3*slice) fragColor = texture(sampler2, vtexCoord);
    else fragColor = texture(sampler3, vtexCoord);
}
