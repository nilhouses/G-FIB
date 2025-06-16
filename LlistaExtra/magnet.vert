#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrixInverse;
uniform mat3 normalMatrix;

uniform float n = 4;
uniform vec4 lightPosition;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(vec3(N.z),1.0);
    vec3 F = (modelViewMatrixInverse * lightPosition).xyz;
    float d = distance(vertex,F);
    float w = clamp(1.0/pow(d,n), 0, 1);
    vec3 V = mix(vertex,F,w);
    gl_Position = modelViewProjectionMatrix * vec4(V, 1.0);
}
