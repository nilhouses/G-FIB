#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    vtexCoord = texCoord;
    //ra -> 4:3
    vec3 v = vec3(vertex.x*4/3,vertex.y,vertex.z);
    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
