 #version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

uniform mat3 normalMatrix;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    gl_Position =  vec4(vertex, 1.0);
}