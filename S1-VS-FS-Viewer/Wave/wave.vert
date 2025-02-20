#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

const float pi = 3.141592;
uniform float amp = 0.5;
uniform float freq = 0.25;

uniform float time;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0) * N.z;
    vtexCoord = texCoord;
    
    float d = amp*sin(2.0*pi*freq*time + vertex.y);
        
    mat3 rotationMatrix = mat3(1, 0, 0,
    			       0, cos(d), sin(d),
    			       0, -sin(d), cos(d));
    			   
    gl_Position = modelViewProjectionMatrix * vec4(rotationMatrix*vertex, 1.0);
}
