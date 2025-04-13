#version 330 core

in vec2 vtexCoord;
in vec3 P;

uniform sampler2D colorMap;
uniform sampler2D depthMap1;
uniform sampler2D normalMap2;

const float PI = 3.141592;
const vec3 golden = vec3(1.0, 0.84, 0.0);
const float shininess = 5.0; // no l'uso però diuen que és obligatori...

out vec4 fragColor;

uniform float AO = 1.5;
uniform int mode = 2;
uniform float R = 2;
uniform float time;

float f1() {
    float d = texture(depthMap1, vtexCoord).z;
    return min ((1-d) * AO, 1.0);
}

float f2() {
    vec4 N4 = texture(normalMap2, vtexCoord); // Eye space
    vec3 N = normalize(N4.xyz * 2.0 - 1.0); // Transform [0,1] -> [-1,1] and normalize
    float angle = time * 2.0 * PI; // One full rotation per second
    vec3 lightPos = vec3(R * cos(angle), R * sin(angle), 1.0); // Light position in eye space
    vec3 L = normalize(lightPos - P); // Light vector
    return max(0.0,dot(N, L));
}

void main()
{
    vec4 colOriginal = texture(colorMap, vtexCoord);
    if (mode == 0) fragColor = colOriginal;
    else if (mode == 1) fragColor = colOriginal * f1();
    else if (mode == 2) fragColor = colOriginal * f2();
    else if (mode == 3) fragColor = colOriginal * f1() * f2();
    else discard;
}
