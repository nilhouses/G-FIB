#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec4 frontColor;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec2 mousePosition;
uniform float mouseOverrideX = -1;
uniform vec2 viewport = vec2(800,600);  // width & height

void main()
{
    //Angle
    float xWS = (mouseOverrideX < 0) ? mousePosition.x : mouseOverrideX;
    float a = (xWS / viewport.x)*2.0-1.0;//[0,1]->[0,2]->[-1,1] 
    
    //t
    vec3 P = vertex;
    float t;
    t = smoothstep(1.45,1.55, P.y);

    //Rotació i vèrtex de sortida en funció de t
    mat4 MRot = mat4(cos(a),0,-sin(a),0,0,1,0,0,sin(a),0,cos(a),0,0,0,0,1);
    vec3 Pprima = (MRot * vec4(P,1.0)).xyz;
    P = mix(P, Pprima, t);

    //Normal i Color
    vec3 N = normalize(normalMatrix * normal.xyz);
    vec3 NColl = normalize(normalMatrix * (MRot * vec4(normal,0)).xyz);
    N = mix(N,NColl,t);
    frontColor = vec4(vec3(N.z),1.0);
    
    //Output
    gl_Position = modelViewProjectionMatrix * vec4(P, 1.0);
}
