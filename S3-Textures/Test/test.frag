#version 330 core

uniform sampler2D colorMap0; //si no diem res busquem la textura 0
uniform sampler2D colorMap1;
uniform float time;

in vec2 vtexCoord;
in vec4 frontColor;
out vec4 fragColor;

void main() {
	vec4 colTex0 = texture(colorMap0,vtexCoord);
	vec4 colTex1 = texture(colorMap1,vtexCoord);
	 
	//1 textura
    //fragColor = texture(colorMap0,vtexCoord);
    
    // 1 textura repetida (4 instàncies)
    //fragColor = texture(colorMap0,2*vtexCoord);
    
    //2 textures
    fragColor = mix(colTex0, colTex1, 0.5*sin(time)+0.5);
}
