#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

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

uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform int mode = 2;

void main()
{
    if (mode == 0) {
        if (distance(vtexCoord, vec2(0.0)) < 1) fragColor = vec4(vec3(0.0),1.0);
        else discard;   
    } 

    else if (mode == 1) {
        if (distance(vtexCoord, vec2(0.0)) < 1) {
            vec3 N = vec3(vtexCoord.s, vtexCoord.t, sqrt(1-pow(vtexCoord.s,2)-pow(vtexCoord.t,2)));
            fragColor = vec4(vec3(N.z),1.0);
        }
        else discard; 
    }
    else { //mode == 2
        if (distance(vtexCoord, vec2(0.0)) < 1) {
            vec3 P = vec3(vtexCoord.s, vtexCoord.t, sqrt(1-pow(vtexCoord.s,2)-pow(vtexCoord.t,2)));
            vec3 N = normalize(normalMatrix*P); //eye space
            //Passar P a eye space
            P = (modelViewMatrix * vec4(P,1.0)).xyz;
            //Il·luminació
            vec3 V = normalize(-P);
            vec3 L = normalize(lightPosition.xyz - P);
            fragColor = Phong(N,V,L);
        }
        else discard; 
    }
}