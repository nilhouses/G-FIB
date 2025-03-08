#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;
out vec2 P;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    vtexCoord = texCoord;
    P = vec2(vertex.x*5, vertex.y*10); //Object Space XY[-1,1] -> Court Space X[-5,5] Y[-10,10]
    gl_Position = modelViewProjectionMatrix * vec4(vec3(vertex.x, 2 * vertex.y, vertex.z), 1.0);
}
