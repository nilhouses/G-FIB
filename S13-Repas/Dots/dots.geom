#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec3 N[];// Eye space
in vec4 vfrontColor[];

out vec4 gfrontColor;
out vec4 P; // Vèrtex en Object Space
out vec4 C; // Centre del triangle en OS

//Eliminar cares backface
uniform bool culling = true;
uniform mat4 modelViewProjectionMatrix;

void main()
{
	// Backface culling:	
	// si culling és cert i tots els vèrtexs del triangle tenen la normal amb Z negativa, el
	// GS no emetrà cap primitiva
    if (culling) {
        bool zPositiva = false;
        for (int i = 0; i < 3; i++) {
            if (N[i].z >= 0.0) {
                zPositiva = true;
                break;
            }
        }
        if (!zPositiva)
            return;
    }
	//Calculo el centre
    vec4 v[3];
    for (int i = 0; i < 3; i++)
        v[i] = gl_in[i].gl_Position;

    vec4 centre = (v[0] + v[1] + v[2]) / 3.0;
	//Per cada vèrtex emeto P i C, i la resta...
    for (int i = 0; i < 3; i++) {
		// 1) Color
        gfrontColor = vfrontColor[i];
		// 2) Emeto els Vertex (OS -> NDC)
        gl_Position = modelViewProjectionMatrix * v[i];
		// 3) Coordenades del vèrtex en OS (P)
        P = v[i];
 		// 4) Centre del triangle en OS (C)
        C = centre;
        EmitVertex(); 
    }

    EndPrimitive();
}