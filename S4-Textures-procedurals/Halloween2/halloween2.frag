#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const vec4 ORANGE = vec4(1.0,0.66,0.0,1.0);
const vec4 BLACK = vec4(vec3(0.0),1.0);


void main()
{
    vec2 center = vec2(0.5, 0.5);
    //BackGround
    float d = distance(vtexCoord, center);
    float alpha = smoothstep(0.1, 0.6, d);
    fragColor = mix(ORANGE, BLACK, alpha);
    //Pumpkin
    if (distance(vtexCoord,center) <= 0.3) fragColor = BLACK;
	//Peduncle
	if  (vtexCoord.s > 0.47 && vtexCoord.s < 0.53 && 
		 vtexCoord.t > 0.75 && vtexCoord.t < 0.9)
		 	fragColor = BLACK;
	//Eyes
	if (distance(vtexCoord, vec2(0.4,0.6)) < 0.08) 
		fragColor = mix(ORANGE, BLACK, alpha);
	if (distance(vtexCoord, vec2(0.6,0.6)) < 0.08) 
		fragColor = mix(ORANGE, BLACK, alpha);
	//Mouth
	if (distance(vtexCoord, center) < 0.2 && vtexCoord.t < 0.5) 
		//inside outer circle
		if (distance(vtexCoord,center+vec2(0.0,0.05)) > 0.2)
			//outside inner circle
			fragColor = mix(ORANGE, BLACK, alpha);
}

