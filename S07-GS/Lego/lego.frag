#version 330 core

in vec4 gfrontColor;
out vec4 fragColor;

in vec2 gtexCoord;
uniform sampler2D colorMap;


void main() {
    fragColor = gfrontColor * texture(colorMap, gtexCoord);
}

