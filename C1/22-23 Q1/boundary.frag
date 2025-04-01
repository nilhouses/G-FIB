#version 330 core

out vec4 fragColor;

uniform float edge0 = 0.35;
uniform float edge1 = 0.4;

in vec3 N;
in vec3 P;

const vec3 B = vec3(0.0);
const vec3 W = vec3(1.0);


void main()
{
    vec3 V = normalize(vec3(0.0)-P);
    vec3 Nnorm = normalize(N);
    float c = dot(Nnorm,V); 
    vec3 color = vec3(0.0);
    color = vec3(smoothstep(edge0, edge1, c));
    fragColor = vec4(color,1.0);
}
