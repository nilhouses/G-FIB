#version 330 core

in vec4 frontColor;
out vec4 fragColor;

in vec3 N;
in vec3 P;

//Llum
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition; //eye space

//material
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

uniform int n =5;
;
const float pi = 3.141592;

// Phong (sense ambient i dividint difusa per sqrt(n))
vec4 llum(vec3 N, vec3 V,vec3 L) { 
	vec3 R = normalize(2.0*dot(N,L)*N-L);
	float NdotL = max (0.0, dot(N,L));
	float RdotV = max (0.0, dot(R,V));
	float Idiff = NdotL;
	float Ispec = 0;
	if (NdotL > 0 ) Ispec = pow(RdotV,matShininess);
	
	return (matDiffuse * lightDiffuse * Idiff)/sqrt(n) + 
		    matSpecular * lightSpecular * Ispec;	   
}

void main()
{
	vec3 N = N;
	vec3 V = normalize(-P);
	fragColor = vec4(0.0);
    for(int i = 0; i < n; ++i) {
    	//angle -> x = r⋅cos(a) i 𝑦 = r·sin(a)
    	float a = 2.0 * pi * float(i) / n;
        vec3 Lpos = vec3(10 * cos(a), 10 * sin(a), 0.0);
        vec3 L = normalize(Lpos - P);
		fragColor += llum(N, V, L);		    	
    }
}

