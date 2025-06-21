#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

//Llum
uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition; // eye space

//material
uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

// Per P (model space -> eye space) 
uniform mat4 modelViewMatrix; 


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


void main() { 
    vec3 N = normalize(normalMatrix * normal);  		// N (Eye space)
    vec3 P = (modelViewMatrix * vec4(vertex, 1.0)).xyz; // P (Eye space)
    vec3 V = normalize(-P); 							// V (Punt -> Observador) 
    vec3 L = normalize(lightPosition.xyz - P); 			// L (Punt -> Llum)
    frontColor = Phong(N,V,L);
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
