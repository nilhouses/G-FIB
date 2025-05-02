#version 330 core
out vec4 fragColor;

uniform sampler2D colorMap;
uniform float SIZE;
uniform float time;

void main() { //S'activa quan dibuixem un quad texturat amb la copa 
    
    vec2 st = gl_FragCoord.xy / SIZE;
    float offset =  0.01*sin(10*time + 30.0*st.s);  
    fragColor = texture2D(colorMap, st + vec2(offset));
}


