// #version 330 core

// in vec4 cubeColor;
// out vec4 fragColor;

// in vec2 vtexCoord;
// uniform sampler2D colorMap;

// const vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
// const vec4 G = vec4(0.0, 1.0, 0.0, 1.0);
// const vec4 B = vec4(0.0, 0.0, 1.0, 1.0);
// const vec4 C = vec4(0.0, 1.0, 1.0, 1.0);
// const vec4 Y = vec4(1.0, 1.0, 0.0, 1.0);

// vec4 nearestColor(vec4 color) {
//     float dR = distance(color, R);
//     float dG = distance(color, G);
//     float dB = distance(color, B);
//     float dC = distance(color, C);
//     float dY = distance(color, Y);
//     float minDist = min(min(min(dR, dG), min(dB, dC)), dY);

//     if (minDist == dR) return R;
//     if (minDist == dG) return G;
//     if (minDist == dB) return B;
//     if (minDist == dC) return C;
//     return Y;
// }

// void main() {
//     vec4 color  = nearestColor(cubeColor);
    
//     color *= texture(colorMap, vtexCoord);
    
//     fragColor = vec4(color.r, color.g, color.b, 1.0); 
    
// } AIXÒ HO FA PER FRAGMENT, PREGUNTEN PER VÈRTEX



#version 330 core

in vec4 gfrontColor;
out vec4 fragColor;

in vec2 vtexCoord;
uniform sampler2D colorMap;


void main() {
    fragColor = gfrontColor * texture(colorMap, vtexCoord);
}

