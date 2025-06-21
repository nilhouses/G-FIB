#version 330 core

out vec4 fragColor;

//Llum
uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition; //eye space

//Material
uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;


uniform mat4 viewMatrixInverse; // ES-> WS

in vec3 NE;
in vec3 PE;

in vec3 NW;

uniform bool world = true;


vec4 light(vec3 N, vec3 V, vec3 L)
{
    N=normalize(N);V=normalize(V);L=normalize(L);
    vec3 R = normalize( 2.0*dot(N,L)*N-L );
    float NdotL = max( 0.0,dot(N,L) );
    float RdotV = max( 0.0,dot(R,V) );
    float Idiff = NdotL;
    float Ispec = 0;
    if (NdotL > 0) Ispec=pow( RdotV,matShininess );
    return 
    	matAmbient * lightAmbient + 
        matDiffuse * lightDiffuse * Idiff + 
        matSpecular * lightSpecular * Ispec;
}

void main() {
    // Eye space (per defecte)
	vec3 LE = (lightPosition.xyz - PE);
	vec3 VE = -PE;
	fragColor = light(NE,VE,LE); 
	if (world) { //World space
    	vec3 LW = (viewMatrixInverse*vec4(LE,0)).xyz;
    	vec3 VW = (viewMatrixInverse*vec4(VE,0)).xyz; 
    	fragColor = light(NW,VW,LW);
    }
}


