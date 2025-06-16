#version 330 core

in vec4 gfrontColor;
in vec2 gtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap;

void main()
{
    vec4 color = texture(colorMap, gtexCoord);
    if (color.a < 1.0) discard;
    else fragColor = color;  
    // fragColor = gfrontColor;
}
