#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform float time;
uniform sampler2D fons;
uniform sampler2D noise1;

void main()
{
	
	vec2 st = vtexCoord;
	
	vec2 noiseCoords = vec2(st.s +0.08*time, st.t +0.07*time);
	vec4 rg = texture(noise1,noiseCoords);
	
	vec2 pertorb = vec2(rg.x,rg.y) * vec2(.003,-.005);

    fragColor = texture(fons,st+pertorb);
}
