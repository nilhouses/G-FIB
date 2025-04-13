#version 330 core

const vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 W = vec4(1.0);
const float r1 = 0.225;
const vec2 C1 = vec2(0.35, 0.6);
const vec2 C2 = vec2(0.65, 0.6);
const float r2 = 0.45;
const vec2 C3 = vec2(0.5, 0.13);
const float PI = 3.14159265359;
in vec2 st;
out vec4 fragColor;

uniform int mode = 0;

bool insideCircle(vec2 C, float r) {
    return distance(st, C) <= r;
}

bool withinAngleRange(vec2 C, float s, float e) { //centre, start, end
    vec2 dir = normalize(st - C); // C -> st
    float angle = atan(dir.y, dir.x); // Respecte x
    return angle >= s && angle <= e;
}


void main()
{
    if (mode == 0) {
        if (insideCircle(C1, r1)) {
            fragColor = R;
        } else if (insideCircle(C2, r1)) {
            fragColor = R;
        } else if (insideCircle(C3, r2)) { 
            float s = atan(C3.y, C3.x) + PI / 5.9; //dreta
            float e = atan(0.0, -r2) - PI/4.0; //esquerra
            if (withinAngleRange(C3,s,e)) fragColor = R;
            else fragColor = W;
        } else {
            fragColor = W;
        }
    }
}
