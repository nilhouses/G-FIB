#version 330 core
//És el mateix que vaig fer a la S3, però faig lo de les textures al fragment shader, ara fer 
layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;


void main() {
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}


