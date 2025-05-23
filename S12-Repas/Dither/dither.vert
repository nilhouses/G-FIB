#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

out float ilum;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    ilum =  N.z;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
