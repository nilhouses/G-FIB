#version 330 core

in vec4 frontColor;
out vec4 fragColor;

in vec3 N;
in vec3 P;

//Llum
uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition; //eye space

//material
uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;


vec4 Phong(vec3 N, vec3 V,vec3 L) {
	vec3 R = normalize(2.0*dot(N,L)*N-L);
	float NdotL = max (0.0, dot(N,L));
	float RdotV = max (0.0, dot(R,V));
	float Idiff = NdotL;
	float Ispec = 0;
	if (NdotL > 0 ) Ispec = pow(RdotV,matShininess);
	
	return matAmbient * lightAmbient + 
	       matDiffuse * lightDiffuse * Idiff +
	       matSpecular * lightSpecular * Ispec;	   
}

void main()
{
	vec3 N = normalize(N); // Ja estava normalitzada al VS
	vec3 V = normalize(-P);
	vec3 L = normalize(lightPosition.xyz - P);
    fragColor = Phong(N,V,L);
}

