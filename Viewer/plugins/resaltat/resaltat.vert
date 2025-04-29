#version 330 core

layout (location = 0) in vec3 vertex;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 transformMatrix; // Matriu per moure la bb
uniform mat3 normalMatrix;

out vec4 frontColor;

void main()
{
    frontColor = vec4(vec3(0.0), 1.0); // Black bounding box
    gl_Position = modelViewProjectionMatrix * transformMatrix * vec4(vertex, 1.0);
}
