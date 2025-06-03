#version 330 core

in vec3 NOS;
in vec3 gPos; //OS
in vec2 gtexCoord;

out vec4 fragColor;

uniform sampler2D colorMap0; //grass_side
uniform sampler2D colorMap1; //grass_top

void main() {

    if (NOS.z == 0) { //fragment de cara vertical
        vec4 c =  texture2D(colorMap0, gtexCoord);
        if (c.a < 0.1) discard;
        else fragColor = c;

    } else { //fragment amb cara horitzontal
        fragColor = texture2D(colorMap1, 4*normalize(gPos).xy);
    }
}
    

