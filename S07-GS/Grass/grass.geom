#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 18) out;

in vec3 N[];
out vec3 NOS;
out vec3 gPos; //posició del fragment en OS
out vec2 gtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform float d = 0.5;

vec3 mean(vec3 a, vec3 b, vec3 c) {
    return normalize((a + b + c) / 3.0);
}

void emitTriangle(vec3 v0, vec3 v1, vec3 v2, vec3 normal) {

    NOS = normalize(normal);
    gtexCoord = vec2(0.0);
    gPos = v0;
    gl_Position = modelViewProjectionMatrix * vec4(v0, 1.0); EmitVertex();
    gtexCoord = vec2(1.0, 0.0);
    gPos = v1;
    gl_Position = modelViewProjectionMatrix * vec4(v1, 1.0); EmitVertex();
    gtexCoord = vec2(0.0, 1.0);
    gPos = v2;
    gl_Position = modelViewProjectionMatrix * vec4(v2, 1.0); EmitVertex();
    //gPos = mean(v0,v1,v2); Dona un color llis
    EndPrimitive();
}

void emitQuad(vec3 v0, vec3 v1, vec3 v2, vec3 v3) { 
    // Aquí he fet directament, 3 vèrtex i el 4t s'uneix amb els 2 anteriors
	NOS = cross(v1-v0,v2-v0);

	gPos = v0;
    gtexCoord = vec2(0.0);
    gl_Position = modelViewProjectionMatrix * vec4(v0,1); EmitVertex();
	gPos = v1;
    gtexCoord = vec2(1.0,0.0);
	gl_Position = modelViewProjectionMatrix * vec4(v1,1); EmitVertex();
	gPos = v2;
    gtexCoord = vec2(0.0, 0.99); //Error a la textura 
	gl_Position = modelViewProjectionMatrix * vec4(v2,1); EmitVertex();
	gPos = v3;
    gtexCoord = vec2(1.0, 0.99); //Error a la textura 
	gl_Position = modelViewProjectionMatrix * vec4(v3,1); EmitVertex();

    EndPrimitive();
}



void main() {
    if (gl_PrimitiveIDIn == 0) { // Vull veure un triangle de l'objecte plane
        vec3 V[3];
        for (int i = 0; i < 3; ++i)
            V[i] = vec3(gl_in[i].gl_Position);

        vec3 N_avg = mean(N[0], N[1], N[2]);
        vec3 top[3];
        for (int i = 0; i < 3; ++i)
            top[i] = V[i] + d * N_avg;

        // Triangle base
        emitTriangle(V[0], V[1], V[2], N_avg);

        // Cares laterals
        for (int i = 0; i < 3; ++i) {
            int next = (i + 1) % 3;
            emitQuad(V[i], V[next], top[i], top[next]);
        }
    }
}