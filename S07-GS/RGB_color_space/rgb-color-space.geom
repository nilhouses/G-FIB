#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

out vec4 gfrontColor;
out vec2 vtexCoord;

// gl_in[i].gl_Position està en OS, caldrà passar a NDC
uniform mat4 modelViewProjectionMatrix;

uniform int mode = 1;
out int Mode;

vec3 baricentre(vec3 v1, vec3 v2, vec3 v3) {
	return (v1 + v2 + v3) / 3.0;
}

void printCube(vec3 C, float side) {

	vec3 v[8];
	v[0] = C + vec3(-side/2.0, -side/2.0, -side/2.0);
	v[1] = C + vec3( side/2.0, -side/2.0, -side/2.0);
	v[2] = C + vec3( side/2.0,  side/2.0, -side/2.0);
	v[3] = C + vec3(-side/2.0,  side/2.0, -side/2.0);
	v[4] = C + vec3(-side/2.0, -side/2.0,  side/2.0);
	v[5] = C + vec3( side/2.0, -side/2.0,  side/2.0);
	v[6] = C + vec3( side/2.0,  side/2.0,  side/2.0);
	v[7] = C + vec3(-side/2.0,  side/2.0,  side/2.0);

	// DISTRIBUCIÓ ÍNDEXS

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
		4, 5, 6, 4, 6, 7, // +Z
		7, 4, 0, 3, 7, 0, // -X
		1, 5, 6, 2, 1, 6, // +X
		4, 5, 1, 0, 4, 1, // -Y
		6, 3, 7, 6, 2, 3  // +Y
	);

	vec2 texCoords[6] = vec2[6](
		vec2(1.0, 0.0),       // -Z
		vec2(0.0, 1.0),      // +Z
		vec2(0.0, 0.0),     // -X
		vec2(1.0, 0.0),    // +X
		vec2(1.0, 1.0),   // -Y
		vec2(0.0, 1.0)   // +Y
	);
	//Debug
	vec4 faceColors[6] = vec4[6](
	vec4(1,0,0,1), // -Z
	vec4(0,1,0,1), // +Z
	vec4(0,0,1,1), // -X
	vec4(1,1,0,1), // +X
	vec4(1,0,1,1), // -Y
	vec4(0,1,1,1)  // +Y
);

	for (int i = 0; i < 6; i++) { // Cara
		vec3 color = C; // [-1, 1]
		color = color/2 + vec3(0.5); // [0,1]
		gfrontColor = faceColors[i]; //vec4(color, 1.0);
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara
			if(j == 2 || j == 5) EndPrimitive(); //Pinto els dos triangles
			if (mode == 2 || mode == 3){
				//Per cada cara assigno coordenades de textura a cada vèrtex
				vtexCoord = texCoords[j];
				if (mode == 3) {
					//CUT
				}
				
			}
			gl_Position = modelViewProjectionMatrix * vec4(v[faces[i * 6 + j]], 1.0);
			EmitVertex();

		}
	}

}

void main( void )
{
	Mode = mode;
	// Centre real
	vec3 C = baricentre( gl_in[0].gl_Position.xyz, gl_in[1].gl_Position.xyz, gl_in[2].gl_Position.xyz );
	// Printeja cub
	printCube(C, 0.16);
}


//Default main
// void main( void )
// {
// 	for( int i = 0 ; i < 3 ; i++ )
// 	{
// 		gfrontColor = vfrontColor[i];
// 		gl_Position = gl_in[i].gl_Position;
// 		EmitVertex();
// 	}
//     EndPrimitive();
// }