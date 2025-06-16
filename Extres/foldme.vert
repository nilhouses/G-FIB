#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float time;
const vec3 BLUE = vec3(0,0,1);

void main() {
    float a = -time * texCoord.s;
    mat3 MatRotation = mat3(cos(a), 0, -sin(a),
                            0,      1,       0,
                            sin(a), 0, cos(a));
    
    vec3 N = normalize(normalMatrix * normal);
    vtexCoord = texCoord;
    frontColor = vec4(BLUE,1.0);
    gl_Position = modelViewProjectionMatrix * vec4(MatRotation*vertex, 1.0);
}
