#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float speed = 0.5; // rad/s
uniform float time;
void main()
{
    vec3 N = normalize(normalMatrix * normal);
    // multiplicar frontcolor per N.z deixa colors foscos (brillen les normals)
    frontColor = vec4(color,1.0);
    vtexCoord = texCoord;
    //𝜃=speed×time=rad/s×s=radians
    float theta = speed*time;
    								//COMPTE
    mat3 rotationMatrix = mat3( cos(theta),0.0,-sin(theta), //columna 0
    				0.0,1.0,0.0,		    //columna 1
    				sin(theta),0.0,cos(theta)); //columna 2
				   
    vec3 rotatedVertex = rotationMatrix*vertex;
    gl_Position = modelViewProjectionMatrix * vec4(rotatedVertex,1.0);
}

