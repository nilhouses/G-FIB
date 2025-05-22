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

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0);//Sense il·luminació  N.z;
    vtexCoord = texCoord;
    
    vec4 v = vec4(vertex, 1.0);
    
    float A = (v.y-0.5)*sin(time);
    
    mat4 translateDownMatrix = mat4(1,0,0,0,
    		 		    0,1,0,0,
    				    0,0,1,0,
    				    0,-1,0,1); //Baixa la Y 1 unitat

    mat4 rotationMatrix =    mat4(1,0,0,0, //eix X
    				  0,cos(A),sin(A),0,
    				  0,-sin(A),cos(A),0,
    				  0,0,0,1); //si afegeixo la coordenada x aquí estic fent un translate
    				  
    mat4 translateUpMatrix = mat4(1,0,0,0,
    				  0,1,0,0,
    				  0,0,1,0,
    				  0,1,0,1); //Puja la Y 1 unitat
    				  
    v = vec4(vertex, 1.0);
    if (v.y >= 0.5) {
        v = translateUpMatrix*rotationMatrix*translateDownMatrix*v;
    }

    gl_Position = modelViewProjectionMatrix * v;
}
