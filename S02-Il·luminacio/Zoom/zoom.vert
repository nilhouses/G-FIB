#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float time;

vec4 zoom(vec4 v) {
	float e = 0.5 + abs(sin(time));
	return vec4(v.x * e,v.y * e,v.z,v.w);	
}

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0) * N.z;
    vec4 clipping = modelViewProjectionMatrix * vec4(vertex, 1.0);
    //ndc = clipping.xyz / clipping.w;
    gl_Position = zoom(clipping);
}
