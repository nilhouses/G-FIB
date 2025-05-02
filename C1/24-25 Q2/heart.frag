#version 330 core

const vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 W = vec4(1.0);
const vec4 B = vec4(vec3(0.0),1.0);

const float r1 = 0.225;
const vec2 C1 = vec2(0.35, 0.6);
const vec2 C2 = vec2(0.65, 0.6);
const float r2 = 0.45;
const vec2 C3 = vec2(0.5, 0.13);
const float PI = 3.14159265359;

in vec2 st;
out vec4 fragColor;

uniform int mode;

bool insideCircle(vec2 C, float r) {
    return distance(st, C) <= r;
}

bool withinAngleRange(vec2 C, float s, float e) { //centre, start, end
    vec2 dir = normalize(st - C); // C -> st
    float angle = atan(dir.y, dir.x); // Respecte x
    return angle >= s && angle <= e;
}

float aastep(float threshold, float x) {
    float width = 0.7*length(vec2(dFdx(x), dFdy(x)));
    return smoothstep(threshold - width, threshold + width, x);
}



void mode0() {
    if (insideCircle(C1, r1)) {
        fragColor = R;
    } else if (insideCircle(C2, r1)) {
        fragColor = R;
    } else if(distance(vec2(0.5,0.13), st) < 0.45 && acos(distance(vec2(0.5, st.y), st)/distance(vec2(0.5,0.13),st)) > PI/4 && st.y > 0.13) fragColor = R;
        /*
    } else if (insideCircle(C3, r2)) { 
        float s = atan(C3.y, C3.x) + PI / 5.9; //dreta
        float e = atan(0.0, -r2) - PI/4.0; //esquerra
        if (withinAngleRange(C3,s,e)) fragColor = R;
        else fragColor = W;
    }
        */
    else fragColor = W;
}

void mode1() {
    if (insideCircle(C1, r1)) {
        fragColor = mix(R, R, aastep(0.01, r1 - distance(st, C1)));
    } else if (insideCircle(C2, r1)) {
        fragColor = mix(R, R, aastep(0.01, r1 - distance(st, C2)));
    } else if (insideCircle(C3, r2)) { 
        float s = atan(C3.y, C3.x) + PI / 5.9; //dreta
        float e = atan(0.0, -r2) - PI/4.0; //esquerra
        if (withinAngleRange(C3,s,e)) fragColor = mix(R, R, aastep(0.01, r2 - distance(st, C3)));
        else fragColor = W;
    } else fragColor = W;
}

void mode2() {
    float d = distance(st,C2);
    float f = max(1.1 - d / 0.75, 0);
    if (insideCircle(C1, r1)) {
        fragColor = f * mix(R, R, aastep(0.01, r1 - distance(st, C1)));
    } else if (insideCircle(C2, r1)) {
        fragColor = f * mix(R, R, aastep(0.01, r1 - distance(st, C2)));
    } else if (insideCircle(C3, r2)) { 
        float s = atan(C3.y, C3.x) + PI / 5.9; //dreta
        float e = atan(0.0, -r2) - PI/4.0; //esquerra
        if (withinAngleRange(C3,s,e)) fragColor = f * mix(R, R, aastep(0.01, r2 - distance(st, C3)));
        else fragColor = W;
    } else fragColor = W;
}

void mode3() {
    float d = distance(st, C2);
    float specular = smoothstep(0.04, 0.005, d);
    vec4 taca = specular * W; 

    float f = max(1.1 - d / 0.75, 0);
    if (insideCircle(C1, r1)) {
        fragColor = f * mix(R, R, aastep(0.01, r1 - distance(st, C1))) + taca;
    } else if (insideCircle(C2, r1)) {
        fragColor = f * mix(R, R, aastep(0.01, r1 - distance(st, C2))) + taca;
    } else if (insideCircle(C3, r2)) { 
        float s = atan(C3.y, C3.x) + PI / 5.9; //dreta
        float e = atan(0.0, -r2) - PI / 4.0; //esquerra
        if (withinAngleRange(C3, s, e)) {
            fragColor = f * mix(R, R, aastep(0.01, r2 - distance(st, C3))) + taca;
        } else {
            fragColor = W + taca;
        }
    } else {
        fragColor = W + taca;
    }
}

void main()
{
    if (mode == 0) mode0();
    else if (mode == 1) mode1(); //Incorrecte
    else if (mode == 2) mode2();
    else if (mode > 2) mode3();
}
