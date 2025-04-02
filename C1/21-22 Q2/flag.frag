#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

const vec4 GREEN = vec4(0.0, 0.9, 0.3, 1.0);
const vec4 BLUE = vec4(0.0, 0.3, 1.0, 1.0);
const vec4 YELLOW = vec4(0.95, 0.95, 0.0, 1.0);

bool insideCircle(vec2 C, float r) {
    vec2 v = vtexCoord - C;
    v = vec2(v.s, v.t / 2); // Adjust for aspect ratio
    return length(v) <= r;
}

bool insideSquare(vec2 minCoord, vec2 maxCoord) {
    vec2 v = vtexCoord;
    return v.x >= minCoord.x && v.x <= maxCoord.x &&
           v.y >= minCoord.y && v.y <= maxCoord.y;
}

void main()
{
    if (insideCircle(vec2(0.5), 0.15))  {
        vec4 color = BLUE;
        if (!insideCircle(vec2(0.52, 0.7), 0.17) && insideCircle(vec2(0.52, 0.65),0.17))
            color = YELLOW;
        fragColor = color;
    }
    else if (insideSquare(vec2(0.075,0.15), vec2(0.925,0.85))) fragColor = YELLOW; 
    else fragColor = GREEN;
}
