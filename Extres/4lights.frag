#version 330 core

uniform mat4 modelViewMatrixInverse;
//in vec4 frontColor;
out vec4 fragColor;

in vec3 N; //Object Space
in vec3 P; //Object Space


uniform vec3 pG = vec3(0,10,0);
uniform vec3 pY = vec3(0,-10,0);
uniform vec3 pB = vec3(10,0,0);
uniform vec3 pR = vec3(-10,0,0);

const vec3 GREEN = vec3(0,1,0);
const vec3 YELLOW = vec3(1,1,0);
const vec3 BLUE = vec3(0,0,1);
const vec3 RED = vec3(1,0,0);

uniform float time;
uniform bool rotate = true;

vec4 light(vec3 V, vec3 N, vec3 P, vec3 lightPos, vec3 lightColor)
{
	const float shininess = 100.0;
	const float Kd = 0.5;
	N = normalize(N);
	vec3 L = normalize(lightPos - P);
	vec3 R = reflect(-L, N);
	float NdotL = max(0.0, dot(N,L));
	float RdotV = max(0.0, dot(R,V));
	float spec =  pow( RdotV, shininess);
	return vec4(Kd*lightColor*NdotL + vec3(spec),0);
}

void main()
{
	float a = 0; //angle
	if (rotate) a = time;
	mat3 R = mat3(vec3(cos(a), sin(a), 0),
				  vec3(-sin(a), cos(a), 0),
				  vec3(    0  ,   0   , 1));
	
	//Calcul posicions de les llums
	vec3 p1 = vec3(modelViewMatrixInverse * vec4(R * pG,1.0)).xyz;
	vec3 p2 = vec3(modelViewMatrixInverse * vec4(R * pY,1.0)).xyz;
	vec3 p3 = vec3(modelViewMatrixInverse * vec4(R * pB,1.0)).xyz;
	vec3 p4 = vec3(modelViewMatrixInverse * vec4(R * pR,1.0)).xyz;

	vec3 V = normalize(modelViewMatrixInverse[3].xyz - P);
	
	fragColor = light(V,N,P,p1,GREEN) + light(V,N,P,p2,YELLOW) + light(V,N,P,p3,BLUE) + light(V,N,P,p4,RED);
}

