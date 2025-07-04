 #version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec3 N; //Eye space
out vec3 V;

out vec2 st;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrixInverse;
uniform mat3 normalMatrix;

void main()
{
    st = texCoord;
    vec3 v = vec3(vertex.x * 3.0/4.0, vertex.y, vertex.z);
    N = normalize(normalMatrix * normal); // Eye Space
    vec4 eyeSpace_eye = vec4(vec3(0.0), 1.0);
    vec3 worldSpace_eye = (viewMatrixInverse * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
    V = normalize(worldSpace_eye -(modelMatrix * vec4(v,1.0)).xyz);
    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
