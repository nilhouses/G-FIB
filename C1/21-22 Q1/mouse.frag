#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const vec4 BLANC = vec4(1.0);
const vec4 NEGRE = vec4(0.0,0.0,0.0,1.0);
const vec4 GRIS = vec4(vec3(0.8),1.0);
const vec4 PELL = vec4(1.0,0.8,0.6,1.0);

uniform int mode = 2;

void main()
{
    vec4 color = GRIS;
    //mode  0, 1 o 2
    if (distance(vtexCoord, vec2(0.5,0.43)) <= 0.35) color = NEGRE;
    else if (distance(vtexCoord, vec2(0.2,0.8)) <= 0.175) color = NEGRE;
    else if (distance(vtexCoord, vec2(0.8,0.8)) <= 0.175) color = NEGRE;

    if (mode == 1 || mode == 2) {
        //pell
        vec2 c1 = vec2(0.5, 0.36);
        vec2 vtexCoord = vtexCoord;
        vec2 v = vtexCoord - c1;
        v.x /= 2; 
        if (length(v) <= 0.15) color = PELL;
        else {
            vec2 c2 = vec2(0.45, 0.55);
            vec2 c3 = vec2(0.55, 0.55);
            v = vtexCoord - c2;
            v.x *= 2; 
            if (length(v) <= 0.20) color = PELL;
            else  {
                v = vtexCoord - c3;
                v.x *= 2;
                if (length(v) <= 0.2) color = PELL;
            }
        }
        if (mode == 2) { 
            //ulls
            vec2 c1 = vec2(0.45, 0.55);
            vec2 c2 = vec2(0.55, 0.55);
            vec2 v1 = vtexCoord - c1;
            vec2 v2 = vtexCoord - c2;
            v1.x *= 2; v2.x *= 2;
            if (length(v1) <= 0.15 || length(v2) <= 0.15) color = BLANC;
            c1 = vec2(0.45, 0.5);
            c2 = vec2(0.55, 0.5);
            v1 = vtexCoord - c1;
            v2 = vtexCoord - c2;
            v1.x *= 2; v2.x *= 2;
            if (length(v1) <= 0.07 || length(v2) <= 0.07) color = NEGRE;
        }
    }
    fragColor = color;
}
