#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

uniform float time;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform bool eyespace;
const float PI = 3.141592;

void main()
{ 
    frontColor = vec4(color,1.0);

    vec4 vEye = modelViewMatrix * vec4(vertex, 1.0);

    float y = eyespace ? vEye.y : vertex.y;
    float r = distance(boundingBoxMax,boundingBoxMin)/2;
    float d = (r / 10.0) * y;

    vec3 v = vertex + normal * d*sin(time); 
    //Demanen 2*PI*time, però no passa el test
    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
