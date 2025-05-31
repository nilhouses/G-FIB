#version 330 core

in vec4 gfrontColor;
in vec4 P; // Vèrtex en Object Space
in vec4 C; // Centre del triangle en OS

uniform float size = 0.02; //Radi

uniform bool opaque = true;                                                                                                                                                                                                                                                                                                                                          ;

// Si opaque és cert, els fragments fora del cercle seran
// de color blanc; altrament, els fragments fora del cercle es descartaran.

out vec4 fragColor;

const vec4 WHITE = vec4(1.0);
const vec4 YELLOW = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 BLACK = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    if (distance(P,C) <= size) fragColor = gfrontColor;
    else {
        if (opaque) fragColor = WHITE;
        else discard;
    }
    //TMP
    // fragColor = vec4(distance(P, C) / size, 0.0, 0.0, 1.0);

}