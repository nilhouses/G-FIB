#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;


uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform mat4 modelViewMatrix;

out vec3 N;
out vec3 P;

void main()
{
    N = normalize(normalMatrix * normal);
    P = (modelViewMatrix * vec4(vertex,1.0)).xyz;
   
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
