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

vec3 paint(vec3 v) {
	float y = v.y;
   	if (y <= -1.0) return R;
   	else if (y >= 1.0) return B;
   	else { 
   		y = (y + 1)*2; // passo a [0, 4]
   		if (y < 1) return mix(R, Y, fract(y));
		else if (y < 2) return mix(Y, G, fract(y));
		else if (y < 3) return mix(G, C, fract(y));
		else return mix(C,B, fract(y)); 
   	}
}

void main() {
    vtexCoord = texCoord;
    vec3 N = normalize(normalMatrix * normal); 
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    
    vec3 ndc = gl_Position.xyz / gl_Position.w;
	frontColor = vec4(paint(ndc), 1.0);
}
