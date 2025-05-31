#version 330 core

in float ilum;
out vec4 fragColor;

uniform int mode = 2;

const vec4 WHITE = vec4(1.0);
const vec4 BLACK = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    if (mode == 1) {
        fragColor = (ilum < 0.5) ? BLACK : WHITE;
    }
    else if (mode == 2) {

        int x = int(gl_FragCoord.x); 
        int y = int(gl_FragCoord.y);

        float factor = ilum;

        if (mod(x, 2.0) == 0.0 && mod(y, 2.0) == 0.0) {
            factor -= 0.50;
        } else if (mod(x, 2.0) == 0.0 && mod(y, 2.0) == 0.0) {
            factor += 0.25;
        } else if (mod(x, 2.0) == 1.0 && mod(y, 2.0) == 1.0) {
            factor -= 0.25;
        }
        fragColor = (factor < 0.5) ? BLACK : WHITE;
    }
}
