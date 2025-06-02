#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

out vec4 gfrontColor;
out vec2 vtexCoord;

// gl_in[i].gl_Position està en OS, caldrà passar a NDC
uniform mat4 modelViewProjectionMatrix;

uniform int mode = 3;
uniform float cut = 0.03;

vec3 baricentre(vec3 v1, vec3 v2, vec3 v3) {
	return (v1 + v2 + v3) / 3.0;
}

void printCube(vec3 C, float side) {

	if (mode == 3 && (C.x >= cut && C.y >= cut && C.z >= cut)) return;

	vec3 v[8];
	v[0] = C + vec3(-side/2.0, -side/2.0, -side/2.0);
	v[1] = C + vec3( side/2.0, -side/2.0, -side/2.0);
	v[2] = C + vec3( side/2.0,  side/2.0, -side/2.0);
	v[3] = C + vec3(-side/2.0,  side/2.0, -side/2.0);
	v[4] = C + vec3(-side/2.0, -side/2.0,  side/2.0);
	v[5] = C + vec3( side/2.0, -side/2.0,  side/2.0);
	v[6] = C + vec3( side/2.0,  side/2.0,  side/2.0);
	v[7] = C + vec3(-side/2.0,  side/2.0,  side/2.0);

	
	//			3_________2
    //		   /         /|
	//        /         / |
	//		7_________6	  |
	//		|	0	  |	  1
	//		|		  |	 /
	//		|		  |	/
	//		4_________5


	int faces[36] = int[36](
		2, 1, 0, 3, 2, 0, // -Z
		7, 4, 5, 6, 7, 5, // +Z
		3, 0, 4, 7, 3, 4, // -X
		6, 5, 1, 2, 6, 1, // +X
		1, 5, 4, 0, 1, 4, // -Y
		3, 7, 6, 2, 3, 6  // +Y
	);

	vec2 texCoords[6] = vec2[6](
		vec2(0.0, 1.0),
		vec2(0.0, 0.0),
		vec2(1.0, 0.0),
		vec2(1.0, 1.0),
		vec2(0.0, 1.0),
		vec2(1.0, 0.0)
	);

	for (int i = 0; i < 6; i++) { // Cara
		vec3 color = C; // [-1, 1]
		color = color/2 + vec3(0.5); // [0,1]
		gfrontColor = vec4(color, 1.0);
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara
			if (mode == 2 || mode == 3){
				//Per cada cara assigno coordenades de textura a cada vèrtex
				vtexCoord = texCoords[j];
			}
			gl_Position = modelViewProjectionMatrix * vec4(v[faces[i * 6 + j]], 1.0);
			EmitVertex();
			if(j == 2 || j == 5) EndPrimitive(); //Pinto els dos triangles

		}
	}

}

void main( void )
{
	// Centre
	vec3 C = baricentre( gl_in[0].gl_Position.xyz, gl_in[1].gl_Position.xyz, gl_in[2].gl_Position.xyz );
	// Printeja cub
	printCube(C, 0.16);
}