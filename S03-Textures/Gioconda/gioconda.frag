#version 330 core

in vec2 vtexCoord;
uniform sampler2D colorMap;

uniform float time;
out vec4 fragColor;

const vec2 eye = vec2(0.393,0.652);
const vec2 mouth = vec2(0.45,0.48);
const vec2 offset = vec2(0.057,-0.172);
const float radius = 0.025;

void main() {
    if (fract(time) > 0.5 && distance(vtexCoord, eye) <= radius) 
    	fragColor = texture(colorMap, vtexCoord + offset);
	else 
		fragColor = texture(colorMap,vtexCoord);
	 		
}
