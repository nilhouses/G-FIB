#version 330 core

in float ilum;
out vec4 fragColor;

uniform int mode = 2;

const vec4 WHITE = vec4(1.0);
const vec4 BLACK = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 RED = vec4(1.0, 0.0, 0.0, 1.0);

void main()
{
    if (mode == 1) {
        fragColor = (ilum < 0.5) ? BLACK : WHITE;
    }
    else if (mode == 2) {
        // floor(float) retorna un float i cal fer mod()
        int x = int(gl_FragCoord.x); 
        int y = int(gl_FragCoord.y);

        float factor = ilum;

        if (x % 2 == 0 && y % 2 == 0) {
            factor -= 0.50;
        } else if (x % 2 == 0 && y % 2 == 1) {
            factor += 0.35;
        } else if (x % 2 == 1 && x % 2 == 1) {
            factor -= 0.25;
        }
        fragColor = (factor < 0.5) ? BLACK : WHITE;
    }
    else {
        fragColor = RED * ilum;
    }
}
