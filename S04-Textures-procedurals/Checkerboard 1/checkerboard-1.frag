#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const int size = 8; // Nombre de quadres per fila/columna

void main()
{    
    int x = int(floor(mod(vtexCoord.x * size, 2.0)));
    int y = int(floor(mod(vtexCoord.y * size, 2.0)));

    if (x == y) fragColor = vec4(0.8, 0.8, 0.8, 1.0);
    else fragColor = vec4(0.0, 0.0, 0.0, 1.0); 
}

