#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform vec2 mousePosition;
uniform vec2 viewport;
uniform sampler2D jungla;
uniform float magnific = 3;

// adaptat de https://www.shadertoy.com/view/Xltfzj. 
// no és realment Gaussià
// **requereix** que hi hagi declarat un sampler2D jungla!
// retorna el color corresponent a les coordenades de textura coords.
vec4 blurImage( vec2 coords )
{
    float Pi = 6.28318530718; // Pi*2
    float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = 8.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = 10.0; // BLUR SIZE (Radius)
   
    vec2 Radius = Size/viewport;

    vec4 Color = texture(jungla, coords);
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
        float cd = cos(d);
        float sd = sin(d);
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture(jungla, coords+vec2(cd,sd)*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    return  Color;
}

void main()
{
    float radi = 100;
    vec2 c1 = mousePosition - vec2(80,0);
    vec2 c2 = mousePosition + vec2(80,0);
    float dc1 = distance(vtexCoord*viewport, c1); 
    float dc2 = distance(vtexCoord*viewport, c2);
     
	if(dc1 < radi || dc2 < radi) {  //binocle
		vec2 mouseTexCoord = mousePosition / viewport;
		vec2 zoomCoord = mix(mouseTexCoord, vtexCoord, 1/magnific);
		fragColor = texture(jungla, zoomCoord);
	}
	else if (( dc1 > radi && dc1 <= radi + 5) || ( dc2 > radi && dc2 <= radi + 5))	//vora negra
		fragColor = vec4(0.0,0.0,0.0,1.0);
	else  //borrós
		fragColor = blurImage(vtexCoord);
}




