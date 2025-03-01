#version 330 core

in vec2 vtexCoord;
uniform sampler2D explosion;

in vec4 frontColor;
out vec4 fragColor;

void main() {
	vec4 texColor = texture(explosion, vtexCoord);
    fragColor = texColor.a * texColor;
}
