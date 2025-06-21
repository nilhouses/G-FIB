#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform mat4 modelViewMatrix;

//Eye i world space
out vec3 NE;
out vec3 PE;

out vec3 NW;


void main()
{
	//Eye Space
    NE = normalize(normalMatrix * normal);
    PE = (modelViewMatrix * vec4(vertex.xyz,1.0)).xyz;
    //World Space
    NW = normal;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
