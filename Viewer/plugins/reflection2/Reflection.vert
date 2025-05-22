#version 330 core
layout (location = 0) in vec3 position;
layout (location = 2) in vec3 color;

out vec3 colorVS;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 reflectionMatrix;

void main() {
	colorVS = color;
	gl_Position = modelViewProjectionMatrix * reflectionMatrix * vec4(position, 1.0);
}
