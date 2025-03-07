#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;
uniform float time;

void main()
{
	vec2 st = vtexCoord;
	vec2 center = vec2(0.5,0.5);
	vec2 center2 = vec2(0.25,0.25);
	float d = distance(st,center);
	float d2 = distance(st,center2);
	
    fragColor = vec4(st.x,st.y,0.0,0.0);
    
    if (d2 < 0.05) {
		fragColor = vec4(1,0,0,0);
	}
	if (d < 0.1+sin(time)*0.1) {
		fragColor = vec4(0,1,0,0);
	}
}
