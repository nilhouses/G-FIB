#version 330 core

in vec2 st;
out vec4 fragColor;

const float epsilon = 1.0/128;

uniform sampler2D heightMap;
uniform float smoothness = 25.0;
uniform mat3 normalMatrix;

void main()	
{
    /* Càlcul del gradient (forward differences) (Tx és increment, epsilon) 
  	 			
  	 			f'(x) = (f(x + Tx) - f(x)) / Tx
  	 	f = f(x)
  	 	fx = f(x + epsilon)
  	 	fy = f(y - epsilon)

  	*/
    float f = texture(heightMap, st).r;
    float fx = texture(heightMap, st + vec2(epsilon, 0.0)).r; //
    float fy = texture(heightMap, st + vec2(0.0, epsilon)).r;

    vec2 G = vec2((fx - f) / epsilon, (fy - f) / epsilon);

    
    vec3 NObjectSpace = normalize(vec3(-G.x, -G.y, smoothness));
    vec3 NEyeSpace = normalize(normalMatrix * NObjectSpace);
    fragColor = vec4(NEyeSpace.z);
}

