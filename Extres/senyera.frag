#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;


const vec4 GROC = vec4(1.0,1.0,0.0,1.0);
const vec4 VERMELL = vec4(1.0,0.0,0.0,1.0);

void main()
{
    float s = vtexCoord.s;
    float a = 1.0/9.0;
    if ((s >= 0 && s < a) ||
        (s >= 2*a && s < 3*a) ||
        (s >= 4*a && s < 5*a) ||
        (s >= 6*a && s < 7*a) ||
        (s >= 8*a && s < 9*a)
        ) {
            fragColor = GROC;
        } else fragColor = VERMELL;
}
