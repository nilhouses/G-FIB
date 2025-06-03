#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform int nstripes = 16;
uniform vec2 origin = vec2(0.0,0.0);

const vec4 GROC = vec4(1.0,1.0,0.0,1.0);
const vec4 VERMELL = vec4(1.0,0.0,0.0,1.0);


void main()
{
    float R = distance(vtexCoord, origin);
    float stripeWidth = 1.0 / float(nstripes);
    int stripeIndex = int(floor(R / stripeWidth));

    if (stripeIndex % 2 == 0)
        fragColor = VERMELL;
    else
        fragColor = GROC;
}
