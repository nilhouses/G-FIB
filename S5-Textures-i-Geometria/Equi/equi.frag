#version 330 core


in vec2 vtexCoord;
in vec3 P;

out vec4 fragColor;

uniform sampler2D panorama;
const float PI = 3.141592;

void main()
{

    float psi = asin(P.y); // ψ
	float theta = atan(P.z,P.x); // θ  
	    
    float s = theta/(2*PI);
    float t = psi/PI + 0.5;    
    
    fragColor = texture(panorama,vec2(s,t));
}
