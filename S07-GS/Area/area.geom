#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

out vec4 gfrontColor;

uniform mat4 projectionMatrix;

const float areamax = 0.0005;

const vec3 R = vec3(1.0, 0.0, 0.0); // Red
const vec3 Y = vec3(1.0, 1.0, 0.0); // Yellow

void main()
{
    // Coordenades en ES
    vec3 v0 = gl_in[0].gl_Position.xyz;
    vec3 v1 = gl_in[1].gl_Position.xyz;
    vec3 v2 = gl_in[2].gl_Position.xyz;

    vec3 u = v1 - v0;
    vec3 v = v2 - v0;

    float area = 0.5 * length(cross(u, v)); //  0.5 * |u x v|
    float areaNorm = clamp(area / areamax, 0.0, 1.0); // Normalitzat

    vec3 color = mix(R, Y, areaNorm);
    gfrontColor = vec4(color, 1.0);

    // Vèrtexs en cs
    for (int i = 0; i < 3; ++i) {
        gl_Position = projectionMatrix * gl_in[i].gl_Position; // Passa d’eye a clip space
        EmitVertex();
    }
    EndPrimitive();
}
