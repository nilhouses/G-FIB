#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float time;
const float PI = 2.0*asin(1.0); //Ja que [sin(pi/2) = 1]. Alternativament: 3.141592;  
uniform float amplitude = 0.1;
uniform float freq = 1.0;
uniform float fase = 0.0;

void main()
{
    float d = amplitude * sin(2.0*PI*freq*time + fase); 
    //Efecte "expansió" en direcció a la normal del fragment en qüestió
    vec3 newVertex = vertex + vec3(d)*normal; 
    vec3 N = normalize(normalMatrix * normal);
    // Gris
    // Les normals que em miren tenen component z = 1 (blanc) 
    // La resta de normals va tenint menor z a mesura que no miren cap a mi 
    frontColor = vec4(N.z); 
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(newVertex, 1.0);
}
