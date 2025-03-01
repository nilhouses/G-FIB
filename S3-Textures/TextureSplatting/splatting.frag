#version 330 core

out vec4 fragColor;

in vec2 vtexCoord;
uniform sampler2D noise0;
uniform sampler2D rock1;
uniform sampler2D grass2;

// interpolació lineal -> mix
// interpolació -> smoothstep

void main() {

    vec4 rockCol = texture(rock1,vtexCoord);
    vec4 grassCol = texture(grass2,vtexCoord);
	
	float noise =  texture(noise0, vtexCoord).r;
    
    fragColor = mix(rockCol, grassCol, noise);
}


