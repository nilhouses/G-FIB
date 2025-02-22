#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec3 boundingBoxMax;
uniform vec3 boundingBoxMin;

const vec3 R = vec3(1.0,0.0,0.0);
const vec3 Y = vec3(1.0,1.0,0.0);
const vec3 G = vec3(0.0,1.0,0.0);
const vec3 C = vec3(0.0,1.0,1.0);
const vec3 B = vec3(0.0,0.0,1.0);


vec3 paint() {
    float top = boundingBoxMax.y;   
    float bottom = boundingBoxMin.y;
    float height = top - bottom;
   
    //valor y a l'intèrval [0,4]
    float y = 4*(vertex.y - bottom) / height;  
    if (y == 0.0) return R;
    else if (y < 1) return mix(R, Y, fract(y));
    else if (y < 2) return mix(Y, G, fract(y));
    else if (y < 3) return mix(G, C, fract(y));
    else if (y < 4) return mix(C,B, fract(y));
	else return B;
	//Agafar la mateixa y pels ifs i mix és un error -> el mix esta limitat entre 0.25 i 0.5, 
}

void main() {
    vec3 N = normalize(normalMatrix * normal); 
    frontColor = vec4(paint(),1.0);
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
