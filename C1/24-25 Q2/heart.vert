#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 st;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform int mode;
uniform float time;

void main()
{
    st = texCoord;
    if (mode > 2) {
        float S = 0.5 + abs(sin(time*2))*0.2;
        gl_Position = modelViewProjectionMatrix * vec4(vertex*S, 1.0);
    } else 
        gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    
}
