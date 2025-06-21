#version 330 core

in vec2 st;
out vec4 fragColor;

in vec3 N;
in vec3 V;

uniform sampler2D front0; //picachu.jpg
uniform sampler2D back1;  //picachu_back.jpg
uniform sampler2D mask2;  //pikachu_foil.jpg

uniform int mode = 2;

vec3 foilColor(float hue) {
    float saturation = 1.0;
    float value = 1.0;
    vec3 hsv = vec3(hue, saturation, value);
    // Convert HSV to RGB
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(hsv.xxx + K.xyz) * 6.0 - K.www);
    vec3 rgb = hsv.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);
    return rgb;
}

void main()
{
    vec4 albedo = vec4(0.0); //Color acumilat
    if (mode == 0) {
        // Carta bàsica
        if (N.z > 0.0) albedo = texture(front0,st);
        else albedo = texture(back1, vec2(-st.s, st.t));
        fragColor = albedo;
    } else if (mode == 1 || mode == 2) {
        // Efecte de foil
        vec2 foilMotion, foilTexCoordOffset;
        float hue, reflectiveFactor, reflectiveAngle;
        vec3 foil;
        if(mode == 1) { 
            // Mode 1: Foil simple
            if (N.z > 0.0)  {
                albedo = texture(front0,st);
                // Foil
                foilMotion = V.xy * vec2(0.5,0.3);
                foilTexCoordOffset = st + foilMotion;
                // Hue
                hue = fract(foilTexCoordOffset.x + foilTexCoordOffset.y);
                foil = foilColor(hue);
                // Angle
                reflectiveAngle = dot(V, vec3(0.0,0.0,1.0));
                reflectiveFactor = 1.4 - reflectiveAngle;
                reflectiveFactor = pow(reflectiveFactor, 0.5);
                reflectiveFactor = clamp(reflectiveFactor, 0.0, 1.0);
                // Color
                fragColor =  1.0 - (1.0 - albedo) * (1.0 - vec4(foil, 1.0) * reflectiveFactor);   
            }
            else fragColor = texture(back1, vec2(-st.s, st.t));
        
        }
        else {//(mode == 2)
            //Mode 2: Foil amb textura amb punts
            if (N.z > 0.0) {
                albedo = texture(front0,st);
                // Foil
                foilMotion = V.xy * vec2(0.5,0.3);
                foilTexCoordOffset = st + foilMotion;
                // Hue
                vec4 p1 = texture(mask2, st);
                vec4 p2 = texture(mask2, st * 0.5);
                vec4 p3 = texture(mask2, st * 0.25);
                foilMotion = V.xy * vec2(0.5, 0.3);
                foilTexCoordOffset = st + foilMotion;
                hue = fract(foilTexCoordOffset.x + foilTexCoordOffset.y);
                vec3 f1 = foilColor(fract(hue + 0.25));
                vec3 f2 = foilColor(fract(hue + 0.5));
                vec3 f3 = foilColor(fract(hue + 0.75));
                vec3 foil = foilColor(hue);
                foil = foil * 0.7 + f1 * p1.rgb + f2 * p2.rgb + f3 * p3.rgb;
                // Escala
                float mask = texture(front0, st).r; 
                float scale = mix(1.0, 0.75, step(0.90, mask)); // 0.75 si blanc, 1.0 si negre
                foil *= scale;
                // Angle
                reflectiveAngle = dot(V, vec3(0.0,0.0,1.0));
                reflectiveFactor = 1.4 - reflectiveAngle;
                reflectiveFactor = pow(reflectiveFactor, 0.5);
                reflectiveFactor = clamp(reflectiveFactor, 0.0, 1.0);
                // Color
                fragColor =  1.0 - (1.0 - albedo) * (1.0 - vec4(foil, 1.0) * reflectiveFactor); 
            } else {
                fragColor = texture(back1, vec2(-st.s, st.t));
            }

        }
    }   
}
