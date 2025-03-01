#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main() { //No es veuen textures, només l'escena seleccionada
  fragColor=frontColor;
}
