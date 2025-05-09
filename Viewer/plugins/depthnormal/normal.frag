#version 330 core

in vec3 nOS;
out vec4 fragColor;

void main()
{
    vec3 color = (nOS) * 0.5 + 0.5; // [-1,1] -> [0,1]
    fragColor = vec4(color, 1.0);
}
