#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

//uniforms nous i funció nova
uniform int test = 0;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform vec2 mousePosition;
uniform float radius = 300;
uniform vec2 viewport;

vec2 getMousePositionWindowSpace() {
    if(test == 0) return mousePosition;
    if(test == 1) return vec2(400,520);
    if(test == 2) return vec2(600,225);
    if(test == 3) return vec2(200,375);
    return vec2(400,300);
}

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    
    //1) diagonal caixa contenidora i P'
    float diagonal = length(boundingBoxMax-boundingBoxMin);
    vec3 P = vertex + N*(0.03*diagonal); //diu P però és P'
    
    //2) P en window space
    vec4 posClip = modelViewProjectionMatrix * vec4(vertex, 1.0);
    vec2 posNDC = posClip.xy / posClip.w;
    vec2 posWindow = (posNDC * 0.5 + 0.5) * viewport;
    
    //3) Distància del vèrtex al ratolí
    float d = length(posWindow - getMousePositionWindowSpace());
    float t = smoothstep(0.8 * radius, 0.05 * radius, d);
    
    //4) Vèrtex
    vec3 v = mix(vertex, P,t);
    
    // 5) Il·luminació
    vec3 colorInterpolat = mix(vec3(1.0), vec3(1.0, 0.0, 0.0), t);
    float iluminacio =  clamp(N.z, 0.1, 1.0);
    // Podria haver usat clamp(N.z, 0.1, 1.0), que retorna N.z si és dins l'interval [0.1,1.0] o el valor fitat que s'hagi superat.
    
    frontColor = vec4(colorInterpolat*iluminacio,1.0);
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
