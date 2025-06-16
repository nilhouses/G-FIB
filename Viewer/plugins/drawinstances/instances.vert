#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform bool oneInstance;

void main()
{
    if (oneInstance) {
        gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
        vec3 N = normalize(normalMatrix * normal);
        frontColor = vec4(vec3(N.z), 1.0);
    } else {
        vec3 offset = vec3(0.0);
        int row = gl_InstanceID / 3;
        int col = gl_InstanceID % 3;
        offset = vec3((col - 1) * 2.0, 0.0, (row - 1) * 2.0);
        vec4 displacedVertex = vec4(vertex + offset, 1.0);
        gl_Position = modelViewProjectionMatrix * displacedVertex;
        vec3 N = normalize(normalMatrix * normal);
        frontColor = vec4(vec3(N.z), 1.0);
    }
}
