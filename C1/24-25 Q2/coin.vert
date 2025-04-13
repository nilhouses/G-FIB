#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 st;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform float time;

const vec3 golden = vec3(1.0, 0.84, 0.0);
const float PI = 3.141592;

out vec3 N;
out vec3 P;
uniform int mode = 1;

void main()
{
    if (mode == 0) {
        N = normalize(normalMatrix * normal);
        P = (modelViewMatrix * vec4(vertex.xyz,1.0)).xyz;
        frontColor = vec4(golden,1.0) * N.z;
        st = texCoord;

        gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);

    } else if (mode == 1) {

        float cicle = mod(time, 3.0); // [0,3]
        float t = smoothstep(0.0, 1.0, cicle); //[0,1]

        float offY = 0.0;
        float a = 0.0;
        
        if (cicle <= 1.0) {
            offY = 0.5 * (1.0 - cos(t * PI)); //truc usar cosinus
            a = t * 2.0 * PI * 2.0; // dues rotacions al primer segon
        }
        
        mat4 rotationMatrix = mat4( // Sobre l'eix Y
            cos(a),  0.0, -sin(a), 0.0,
            0.0,     1.0,  0.0,    0.0,
            sin(a),  0.0,  cos(a), 0.0,
            0.0,     0.0,  0.0,    1.0
        );


        // Aplicar moviments
        vec4 V = vec4(vertex, 1.0);
        V = rotationMatrix * V;
        V.y += offY; 

        // Codi del mode 0
        vec3 transformedNormal = mat3(rotationMatrix) * normal;
        N = normalize(normalMatrix * transformedNormal);
        P = (modelViewMatrix * V).xyz;
        frontColor = vec4(golden, 1.0) * N.z;
        st = texCoord;
        gl_Position = modelViewProjectionMatrix * V;
    }
}
