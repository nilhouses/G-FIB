#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(vec3(N.z),1.0);

    float cycle = mod(time, 3.5);
    
    vec3 v = vec3 (0.0,0.0,0.0);
    vec3 origen = vec3(0.0,0.0,0.0);
    if (cycle < 0.5) { //expansió
        float t = mod(time,0.5);
        v = mix(origen,vertex, (t/0.5)*(t/0.5)*(t/0.5));
    } else { //compressió
        float t = mod(time,3.5); // [0.5,3.5)
        t = (t-0.5)/3.0; // [0,1]
        v = mix(vertex,origen, t);
    }

    gl_Position = modelViewProjectionMatrix * vec4(v, 1.0);
}
