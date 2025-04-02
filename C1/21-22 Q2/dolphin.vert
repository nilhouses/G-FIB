#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform float time;
const float PI = 3.1416;

float pos(float percentatge) {
    return (boundingBoxMax.y - boundingBoxMin.y) * percentatge  + boundingBoxMin.y;
}

void main() //Està mig malament
{
    //Càlcul rotacions
    vec3 v = vertex;
    float RD = pos(0.65);
    float RT = pos(0.35);

    if (v.y >= RD) {
        float TD1 = pos(0.55);
        float TD2 = pos(0.75);
        float t = smoothstep(TD1, TD2, v.y);
        float A = PI/32.0*sin(time+0.25);
        mat4 RMatrix = mat4(1,0,0,0,
                            0,cos(A),sin(A),0,
                            0,-sin(A),cos(A),0,
                            0,0,0,1);
        vec3 vnou = (RMatrix * vec4(v,1.0)).xyz;
        v = mix(v, vnou,t);
    } else if (v.y <= RT) {
        float TT1 = pos(0.5);
        float TT2 = pos(0.05);
        float t = smoothstep(TT1, TT2, v.y);
        float A =  min(-PI/4.0*sin(time),0); 
        mat4 RMatrix = mat4(1,0,0,0,
                            0,cos(A),sin(A),0,
                            0,-sin(A),cos(A),0,
                            0,0,0,1);
        vec3 vnou = (RMatrix * vec4(v,1.0)).xyz;
        v = mix(v, vnou, t);
    }

    //Color i posicions
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(vec3(0.8),1.0) * N.z;
    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
