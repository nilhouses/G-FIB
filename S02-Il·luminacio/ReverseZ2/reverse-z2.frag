#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = frontColor;
    gl_FragDepth = 1 - gl_FragCoord.z;
    //gl_FragDepth € [0,1], per això és 1 - coord
}
