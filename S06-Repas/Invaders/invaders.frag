#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap;

const float n = 15;
const float spriteSize = 4.0; 

const vec2 BLUE1  = vec2(2.0,0.0);
const vec2 GREEN1  = vec2(1.0,3.0);
const vec2 PURPLE1  = vec2(1.0,2.0);
const vec2 BLUE2  = vec2(1.0,1.0);
const vec2 RED1  = vec2(1.0,0.0);
const vec2 BLUE3  = vec2(0.0,3.0);
const vec2 GREEN2  = vec2(0.0,2.0);
const vec2 YELLOW1  = vec2(0.0,1.0);
const vec2 RED2  = vec2(0.0,0.0);
const vec2 SHIELD  = vec2(3.0,0.0);
const vec2 CANON  = vec2(3.0,1.0);

void main() {
    vec2 grid = vtexCoord * n; // float [0,15]
    vec2 cell = vec2(floor(grid.x), floor(grid.y));// int [0,15]
    vec2 localCoord = vec2(fract(grid.x), fract(grid.y)); // float [0,1]
   
    // Background
    vec2 offset = vec2(0.0);

    if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-2)))
        offset = BLUE1;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-3)))
        offset = GREEN1;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-4)))
        offset = PURPLE1;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-5)))
        offset = BLUE2;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-6)))
        offset = RED1;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-7)))
        offset = BLUE3;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-8)))
        offset = GREEN2;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-9)))
        offset = YELLOW1;
    else if (cell.x > 0 && cell.x < int(n-1) && (cell.y == int(n-10)))
        offset = RED2;
    else if (mod(cell.x, 4) == 1  && (cell.y == int(n-12)))
        offset = SHIELD;
    else if (cell == vec2(6,n-14))
        offset = CANON;
    else {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return; // per evitar tornar a pintar sprites 
    }

    vec2 board = (offset + localCoord) / spriteSize;
    fragColor = texture(colorMap, board);
}



