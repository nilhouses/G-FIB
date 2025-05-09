#version 330 core

out vec4 fragColor;

in vec3 NDC;

void main()
{
    float zWS = (NDC.z * 0.5) + 0.5;
    fragColor = vec4(vec3(zWS), 1.0); //Hauria de ser gris i es blanc
}
