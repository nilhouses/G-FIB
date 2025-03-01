#version 330 core

in vec4 frontColor;
out vec4 fragColor;

in vec3 N;
in vec3 P;

//Llum
//uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition; //eye space

//Material
//uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

uniform float time;
in vec2 vtexCoord;
uniform sampler2D objectMapper;

vec4 LDiffuse() {
	if (mod(time, 2.0) == 0)
		return vec4(vec3(mix(0,0.8,fract(time))),1.0);
	else 
		return vec4(vec3(mix(0.8,0,fract(time))),1.0);
}

vec4 MDiffuse() {
	int cicle = int(time)/2;
	float s = (cicle/3 % 4 + vtexCoord.s)/4.0;
	float t = (2 - (cicle % 3) + vtexCoord.t)/3.0;
	return texture(objectMapper, vec2(s, t));
}

vec4 Phong(vec3 N, vec3 V,vec3 L) {
	vec3 R = normalize(2.0*dot(N,L)*N-L);
	float NdotL = max (0.0, dot(N,L));
	float RdotV = max (0.0, dot(R,V));
	float Idiff = NdotL;
	float Ispec = 0;
	if (NdotL > 0 ) Ispec = pow(RdotV,matShininess);
	
	vec4 lightDiffuse = LDiffuse();
	vec4 matDiffuse = MDiffuse();
	
	return   matDiffuse * lightDiffuse * Idiff +
		     matSpecular * lightSpecular * Ispec;	  
}

void main()
{
	vec3 N = normalize(N);
	vec3 V = normalize(-P);
	vec3 L = normalize(lightPosition.xyz - P);
    fragColor = Phong(N,V,L);
}

