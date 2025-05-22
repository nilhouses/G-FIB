#version 330 core

in vec4 frontColor;
out vec4 fragColor;

in vec3 VeyeSpace;

void main()
{
	vec3 N = normalize(cross(dFdx(VeyeSpace), dFdy(VeyeSpace))); 
    fragColor = frontColor*N.z;
}
