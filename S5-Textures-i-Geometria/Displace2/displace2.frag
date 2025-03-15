#version 330 core

in vec2 st;
out vec4 fragColor;

const float epsilon = 1.0/128;

uniform sampler2D heightMap;
uniform float smoothness = 25.0;
uniform mat3 normalMatrix;

void main()	
{
    float h = texture(heightMap, st).r;
    float hx = texture(heightMap, st + vec2(epsilon, 0.0)).r;
    float hy = texture(heightMap, st + vec2(0.0, epsilon)).r;

    // Càlcul del gradient (forward differences) (T representa increment) 
  	// f'(x) = (f(x + Tx) - f(x)) / Tx
    vec2 G = vec2((hx - h) / epsilon, (hy - h) / epsilon);

    
    vec3 NObjectSpace = normalize(vec3(-G.x, -G.y, smoothness));
    vec3 NEyeSpace = normalize(normalMatrix * NObjectSpace);
    fragColor = vec4(NEyeSpace.z);
}

