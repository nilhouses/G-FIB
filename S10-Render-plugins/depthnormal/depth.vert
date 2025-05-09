#version 330 core

layout (location = 0) in vec3 vertex;

uniform mat4 modelViewProjectionMatrix;
out vec3 NDC;

void main()
{
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    NDC = gl_Position.xyz / gl_Position.w;
}
