#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap;
uniform int N = 3;
uniform float R = 0.2;
const vec2 C = vec2(0.5);

bool dins(vec2 st, float R){
    if (distance(vtexCoord, C) <= R) return true;
    return false;
}

void main()
{
    vec2 st = vtexCoord;
    
    if (N == 0)
        fragColor = texture2D(colorMap, st);
    else if (N == 1) {
        if (dins(st, R))  {
            st *= 2;
            st += C;
        }
        fragColor = texture2D(colorMap,st);
    } else if (N > 1) {
        int n = N;
        float r = R;
        while (n > 0) {
            if (dins(st, r))  {
                st *= 2;
                st += C;
                r /=2;
            }
            --n;
        }
        fragColor = texture2D(colorMap,st);
    }
}
