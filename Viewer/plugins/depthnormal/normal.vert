#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

out vec3 nOS;

void main()
{
    nOS = normal;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
