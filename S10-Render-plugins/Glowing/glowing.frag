#version 330 core
out vec4 fragColor;

uniform sampler2D colorMap;

uniform float SIZE;

const int W = 4; // Amplada del filter en textels 

void main()
{ //S'activa quan dibuixem un quad texturat amb la copa

    vec2 st = gl_FragCoord.xy / SIZE;

    fragColor = texture2D(colorMap, st);

    fragColor = vec4(max(max(fragColor.r, fragColor.g), fragColor.b));
    if (length(fragColor.rgb) == 0.0)
    {
        float a = 2.0/SIZE; //Exagerar el glow

        vec4 sum=vec4(0.0);
        float count = 0.0;
        for (int i=-W; i<=W; ++i)
        for (int j=-W; j<=W; ++j)
        {
            vec4 tmp = texture(colorMap, st+vec2(a*float(i), a*float(j)));
            if (length(tmp.rgb)>0.0) // assumes background is black 
                count++; //comptem el nombre de pixels que no son negres
        }
        count /= (2*W +1)*(2*W+1);//Normalitzem el nombre de pixels que no son negres
            
        fragColor = vec4(2*count, 2*count, 0, 1); //Color de l'efecte glow
    }    
}


// CODI INICIAL (SENSE EXAGERAR EL GLOW)
// #version 330 core
// out vec4 fragColor;

// uniform sampler2D colorMap;

// uniform float SIZE;

// const int W = 4; // filter size: 2W*2W

// void main()
// {
//     vec2 st = (gl_FragCoord.xy - vec2(0.5)) / SIZE;
//     float a = 1.0/SIZE;

//     vec4 sum=vec4(0.0);
//     float count = 0.0;
//     for (int i=-W; i<W; ++i)
//     for (int j=-W; j<W; ++j)
//     {
//         vec4 tmp = texture(colorMap, st+vec2(a*float(i), a*float(j)));
//         if (length(tmp.rgb)>0.0) // assumes background is black 
//         {
//             float w = max(0.0, float(W) - length(vec2(float(i), float(j))));
//             count += w;
//             sum += w*tmp;
//         } 
//     }
//     sum /= count;
//     sum = pow(sum, vec4(5.0));
        
//     fragColor = mix(texture2D(colorMap, st), sum, 0.8);
    
// }
