#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec4 matDiffuse;
uniform vec4 lightDiffuse;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    const vec3 L = vec3(0,0,1);
    float NL = dot(N,L);
    frontColor = matDiffuse * lightDiffuse * max(0,NL); 
    //Equivalent a N.z, el que tinc al shader bàsic quan hi entro
    // VALOR ANTIC --> frontColor = vec4(color,1.0) * N.z;
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
