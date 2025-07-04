#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D colormap;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec2 st = 2*vtexCoord;
	vec3 RGB = texture(colormap, st).xyz;
    vec3 HSV = rgb2hsv(RGB);
    //(H,S) dins de [0,1]
 	HSV.y = clamp(HSV.y * 2.0,0.0,1.0);  
    if (st.s > 1.0 && st.t > 1.0) 
        HSV.x = mod(HSV.x + 0.8, 1.0);
    else if (st.s > 1.0 && st.t < 1.0) 
        HSV.x = mod(HSV.x + 0.6, 1.0);
    else if (st.s < 1.0 && st.t < 1.0) 
        HSV.x = mod(HSV.x + 0.2, 1.0);
    else if (st.s < 1.0 && st.t > 1.0) 
        HSV.x = mod(HSV.x + 0.4, 1.0);
    
    fragColor = vec4(hsv2rgb(HSV), 1.0);
}


