#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform float n = 10; 

void main()
{    
    int x = int(floor(mod(vtexCoord.x * n, 2.0)));
    int y = int(floor(mod(vtexCoord.y * n, 2.0)));

    if (x == y) fragColor = vec4(0.8, 0.8, 0.8, 1.0);
    else fragColor = vec4(0.0, 0.0, 0.0, 1.0); 
}

