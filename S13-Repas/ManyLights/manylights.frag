#version 330 core

/////////////////////  Phong  //////////////////////////////
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

///////////////////////////////////////////////////////////

uniform mat4 modelViewMatrix; //Per passar L d'object space a eye space

uniform int NUM = 5;
uniform float decay = 6.0;

uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

void main() {
    int n = (NUM + 1);
    vec3 NEye = normalize(N);
    vec3 VEye = normalize(-P); // vector cap a l'observador

    vec4 color = vec4(0.0);
    // X
    for (int i = 0; i < n; ++i) { 
        float tx = float(i) / float(NUM);
        float x = mix(boundingBoxMin.x, boundingBoxMax.x, tx);
        // Y
        for (int j = 0; j < n; ++j) { 
            float ty = float(j) / float(NUM);
            float y = mix(boundingBoxMin.y, boundingBoxMax.y, ty);
            // Z
            for (int k = 0; k < n; ++k) {
                float tz = float(k) / float(NUM);
                float z = mix(boundingBoxMin.z, boundingBoxMax.z, tz);
                //Passar la posició de OS a ES
                vec3 lightPosObject = vec3(x, y, z);
                vec3 lightPosEye = (modelViewMatrix * vec4(lightPosObject, 1.0)).xyz;

                vec3 L = normalize(lightPosEye - P);
                float d = length(lightPosEye - P);

                vec4 llum = Phong(NEye, VEye, L) * exp(-decay * d);
                color += llum;
            }
        }
    }

    fragColor = color;
}