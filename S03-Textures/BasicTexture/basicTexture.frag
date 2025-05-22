#version 330 core

in vec2 vtexCoord;
uniform sampler2D colorMap;

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = frontColor * texture(colorMap,vtexCoord);
}
