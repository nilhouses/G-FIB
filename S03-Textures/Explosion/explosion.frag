#version 330 core

in vec2 vtexCoord;
uniform sampler2D explosion;

in vec4 frontColor;
out vec4 fragColor;

uniform float slice = 1.0 / 30.0; // 1/FPS
const int nCols = 8;
const int nRows = 6;
uniform float time;

void main() {
    
	//Textures
	int nFrames = nCols * nRows;
  
    float frameWidth = 1.0 / float(nCols);
    float frameHeight = 1.0 / float(nRows);
    int frameNumber = int(floor(mod(time / slice, float(nFrames))));

    // Frame Actual
    int frameX = frameNumber % nCols;
    int frameY = nRows - 1 - (frameNumber / nCols); //Left-Top 

    vec2 frameOffset = vec2(/*s*/frameX * frameWidth, 
    						/*t*/frameY * frameHeight);
    						
	
    vec2 st = vtexCoord * vec2(frameWidth, frameHeight) + frameOffset;
    vec4 color = texture(explosion, st);
    fragColor = color.a * color;
}