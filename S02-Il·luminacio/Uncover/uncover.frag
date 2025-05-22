#version 330 core

in vec4 frontColor;
out vec4 fragColor;

in float xNDC;
uniform float time;
const vec4 B = vec4(0.0,0.0,1.0,1.0);

void main() {
	//NDC €[-1,1], li sumo 1 per tenir [0,2]
    if (xNDC + 1 <= time) fragColor = B;
    else discard;
}
