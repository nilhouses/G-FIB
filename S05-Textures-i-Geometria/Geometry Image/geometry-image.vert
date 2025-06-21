#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform sampler2D positionMap; //bunny-geo.png (a Viewer/textures)
uniform sampler2D normalMap1; //bunny-norm.png (a Viewer/textures)

uniform int mode = 3; 

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

uniform mat4 modelViewMatrix; 

vec4 Phong(vec3 N, vec3 V,vec3 L, vec4 P) {
	vec3 R = normalize(2.0*dot(N,L)*N-L);
	float NdotL = max (0.0, dot(N,L));
	float RdotV = max (0.0, dot(R,V));
	float Idiff = NdotL;
	float Ispec = 0;
	if (NdotL > 0 ) Ispec = pow(RdotV,matShininess);
	
	vec4 Llum =  matAmbient * lightAmbient + 
	       		 matSpecular * lightSpecular * Ispec;	 
	if (mode == 2) return Llum + matDiffuse * lightDiffuse * Idiff;
	else return Llum + P * lightDiffuse * Idiff; 
}

void main() // Cal ignorar el test en aquest exercici, que no té el model actualitzat
{
	//(x,y) = [-1,1] -> (s,t) = [0.004, 0.996] 
	vec2 st =  vertex.xy * vec2((0.966 - 0.004)/2) + 0.5;
	// Vertex en object space
   	vec4 P = texture(positionMap, st); 
    vec4 NObjectSpace = texture(normalMap1, st);
    vec4 NOS = (NObjectSpace - 0.5) * 2; // [0,1] -> [-1, 1]
    
    vec3 N = normalize(normalMatrix * NOS.xyz);
    if (mode == 0) frontColor = P;
    else if (mode == 1) frontColor = P * N.z;
   	else if (mode == 2 || mode == 3)  {
   		vec3 PL = (modelViewMatrix * vec4(vertex.xyz,1.0)).xyz;
   		vec3 V = normalize(-PL);
   		vec3 L = normalize(lightPosition.xyz - PL);
   		frontColor = Phong(N,V,L,P);
   	}

    gl_Position = modelViewProjectionMatrix * P;
}
