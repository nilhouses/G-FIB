#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    // normal (object space)
    // N (eye space)
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(normal.z); //vec4(N.z); //vec4(color,1.0) * N.z;
    vtexCoord = texCoord;
    vec3 v = vertex;
    //vec4(normal.z); //vec4(N.z);//vec4(color,1.0) * N.z;
    //v+= vec3(1,0,0); //movem la v i metre cap a l'eix x (vermell)
    //v+= vec3(v.y,0,0); //maxaco
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
