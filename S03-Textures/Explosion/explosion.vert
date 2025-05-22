#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float slice = 1.0 / 30.0; // 1/FPS
const int nCols = 8;
const int nRows = 6;
uniform float time;

void main() {
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(N.z);
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);

	//Textures
	 int nFrames = nCols * nRows;
  
    float frameWidth = 1.0 / float(nCols);
    float frameHeight = 1.0 / float(nRows);
    int frameNumber = int(mod(time / slice, float(nFrames)));

    // Frame Actual
    int frameX = frameNumber % nCols;
    int frameY = nRows - 1 - (frameNumber / nCols); //Left-Top 

    vec2 frameOffset = vec2(/*s*/frameX * frameWidth, 
    						/*t*/frameY * frameHeight);
    						
	
    vtexCoord = texCoord * vec2(frameWidth, frameHeight) + frameOffset;
}


