#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 18) out;

in vec3 N[];
out vec3 NES;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float d = 1.0;

vec3 mean(vec3 a, vec3 b, vec3 c) {
    return normalize((a + b + c) / 3.0);
}

void emitTriangle(vec3 v0, vec3 v1, vec3 v2, vec3 normal) {
    NES = normalize(normalMatrix * normal);
    gl_Position = modelViewProjectionMatrix * vec4(v0, 1.0);
    EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v1, 1.0);
    EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v2, 1.0);
    EmitVertex();
    EndPrimitive();
}


void emitQuad(vec3 v0, vec3 v1, vec3 v2, vec3 v3) {
    // Triangle 1: v0, v1, v2
    vec3 normal = normalize(cross(v1 - v0, v2 - v0));
    NES = normalize(normalMatrix * normal);
    gl_Position = modelViewProjectionMatrix * vec4(v0, 1.0); EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v1, 1.0); EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v2, 1.0); EmitVertex();
    EndPrimitive();

    // Triangle 2: v1, v3, v2
    gl_Position = modelViewProjectionMatrix * vec4(v1, 1.0); EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v3, 1.0); EmitVertex();
    gl_Position = modelViewProjectionMatrix * vec4(v2, 1.0); EmitVertex();
    EndPrimitive();
}



void main() {
    vec3 V[3];
    for (int i = 0; i < 3; ++i)
        V[i] = vec3(gl_in[i].gl_Position);

    vec3 N_avg = mean(N[0], N[1], N[2]);
    vec3 top[3];
    for (int i = 0; i < 3; ++i)
        top[i] = V[i] + d * N_avg;

    // Triangle base
    emitTriangle(V[0], V[1], V[2], N_avg);

    // Triangle tapa
    emitTriangle(top[0], top[1], top[2], N_avg);

    // Cares laterals
    for (int i = 0; i < 3; ++i) {
        int next = (i + 1) % 3;
        emitQuad(V[i], V[next], top[i], top[next]);
    }
}