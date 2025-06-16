#version 330 core

in vec3 NWS;
in vec2 st;
out vec4 fragColor;

in vec3 N;
in vec3 V;

uniform sampler2D front0;
uniform sampler2D back1;
uniform sampler2D mask2;

uniform int mode = 1;

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
    vec4 albedo = vec4(0.0);
    if (mode == 0) {

        if (N.z > 0.0) albedo = texture(front0,st);
        else albedo = texture(back1, vec2(-st.s, st.t));
        fragColor = albedo;

    } else if (mode == 1) {

        if (N.z > 0.0)  {
            albedo = texture(front0,st);

            vec2 foilMotion = V.xy * vec2(0.5,0.3);
            vec2 foilTexCoordOffset = st + foilMotion;
            float hue = fract(foilTexCoordOffset.x + foilTexCoordOffset.y);

            vec3 foil = foilColor(hue);

            float reflectiveAngle = dot(V, vec3(0.0,0.0,1.0));
            float reflectiveFactor = 1.4 - reflectiveAngle;
            reflectiveFactor = pow(reflectiveFactor, 0.5);
            reflectiveFactor = clamp(reflectiveFactor, 0.0, 1.0);
            fragColor =  1.0 - (1.0 - albedo) * (1.0 - vec4(foil, 1.0) * reflectiveFactor);   
        }
        else fragColor = texture(back1, vec2(-st.s, st.t));

    } else if (mode == 3) {
        //codi a fer
    }
   
}//
