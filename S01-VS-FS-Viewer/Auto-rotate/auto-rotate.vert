#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float speed = 0.5; // rad/s
uniform float time;
void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0);
    //𝜃=speed×time=rad/s×s=radians
    float theta = speed*time;
    //Files i columnes de la matriu invertides, coses de GLSL
    mat3 rotationMatrix = mat3( cos(theta),0.0,-sin(theta),
    				            0.0       ,1.0,        0.0,
    				            sin(theta),0.0, cos(theta));
				   
    vec3 rotatedVertex = rotationMatrix*vertex;
    gl_Position = modelViewProjectionMatrix * vec4(rotatedVertex,1.0);
}

