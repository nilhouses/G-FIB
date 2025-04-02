#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap;

uniform float time;

void print(int d) {
	vec2 st = vec2(fract(vtexCoord.s)/10.0 + d/10.0, vtexCoord.t);
	fragColor = texture(colorMap, st);
    if (fragColor.a < 0.5) discard;
    else fragColor = vec4(1.0,0.0,0.0,1.0) * fragColor;
}

void main() {
	int t = int(time), d;
	if (vtexCoord.s < 1) d = (t/100)%10;
	else if (vtexCoord.s < 2) d = (t/10)%10;
	else d = t%10;
	print(d);
}