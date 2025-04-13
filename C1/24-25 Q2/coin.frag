#version 330 core

in vec4 frontColor;

in vec3 N;
in vec3 P;
in vec2 st; // Coordenades de textura

const vec3 golden = vec3(1.0, 0.84, 0.0);
const float shininess = 5.0;

//Llum
uniform vec4 lightAmbient = vec4(vec3 (0.2), 1.0);
uniform vec4 lightDiffuse = vec4(vec3 (0.7), 1.0);;
uniform vec4 lightSpecular = vec4(vec3(1.0),shininess); // blanca
uniform vec4 lightPosition; // NO s'usa (eye space)
//material
uniform vec4 matAmbient = vec4(golden, 1.0);
uniform vec4 matDiffuse = vec4(golden, 1.0);
uniform vec4 matSpecular = vec4(vec3(1.0),shininess);  // blanc
uniform float matShininess;

out vec4 fragColor;

vec4 Phong(vec3 N, vec3 V, vec3 L) {
    vec3 R = normalize(2.0 * dot(N, L) * N - L);
    float NdotL = max(0.0, dot(N, L));
    float RdotV = max(0.0, dot(R, V));
    float Idiff = NdotL;
    float Ispec = 0.0;
    if (NdotL > 0.0) Ispec = pow(RdotV, matShininess);

    if (st.s >= 0.5) 
        Ispec *= 0.5;
    
    return matAmbient * lightAmbient + 
           matDiffuse * lightDiffuse * Idiff +
           matSpecular * lightSpecular * Ispec;	   
}

void main()
{
    vec3 N = normalize(N); // Ja estava normalitzada al VS
    vec3 V = normalize(-P);
    vec3 L = normalize(lightPosition.xyz - P); // SURT MOLT FOSC normalize(vec3(-1.0));
    fragColor = frontColor * Phong(N, V, L);
}
