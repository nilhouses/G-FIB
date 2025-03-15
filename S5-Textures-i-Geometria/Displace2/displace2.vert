#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform sampler2D heightMap;
uniform float scale = 0.05;

out vec2 st;


void main() 
{
    vec3 N = normalize(normalMatrix * normal);
    
    //Displacement Mapping
    st = 0.49 * vertex.xy + vec2(0.5);
    float h = (texture(heightMap, st)).r;
    vec3 displacedVertex = vertex + N * scale*h;
    gl_Position = modelViewProjectionMatrix * vec4(displacedVertex, 1.0);
}
