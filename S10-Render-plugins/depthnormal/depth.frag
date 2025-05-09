#version 330 core

out vec4 fragColor;

// in vec3 NDC;

void main()
{
    // float zWS = (NDC.z * 0.5) + 0.5;
    fragColor = vec4(vec3(gl_FragCoord.z/2.0), 1.0);
}
