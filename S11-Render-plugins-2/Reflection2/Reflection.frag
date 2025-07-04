#version 330 core

uniform sampler2D colorMap;
uniform bool mirror;
uniform vec2 size;

in vec3 colorVS;
out vec4 fragColor;

void main() {
	if (mirror) {
		vec2 st = (gl_FragCoord.xy - vec2(0.5)) / size;
		fragColor = vec4(0.5 * vec3(0.5), 1) + 0.5 * texture2D(colorMap, st);
	} else {
		fragColor = vec4(colorVS, 1);
	}
}
