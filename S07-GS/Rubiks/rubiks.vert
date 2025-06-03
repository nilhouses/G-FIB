 #version 330 core

layout (location = 0) in vec3 vertex;

uniform mat3 normalMatrix;

void main()
{
    gl_Position =  vec4(vertex, 1.0); //l'ignoraré però entenc que el vs necessita tenir algun ouput
}