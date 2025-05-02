#version 330 core

layout (location = 0) in vec3 vertex;

uniform float radius;
uniform mat4 modelViewProjectionMatrix;
out vec2 vtexCoord;

void main()
{
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    vtexCoord = (4.0 / radius) * (vertex.xy + vertex.zx);
}


