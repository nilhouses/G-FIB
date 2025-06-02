#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float step = 0.2;


vec3 baricentre(vec3 v1, vec3 v2, vec3 v3) {
	return (v1 + v2 + v3) / 3.0;
}

void printCube(vec3 C, float side) {
	//Escala de grisos per cada cara
	vec3 colors[6] = vec3[6](
		vec3(0.2), 
		vec3(0.3), 
		vec3(0.4), 
		vec3(0.5), 
		vec3(0.6), 
		vec3(0.7) 
	);

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
		5, 6, 1, 2, 6, 1, // +X
		1, 5, 4, 0, 1, 4, // -Y
		3, 7, 6, 2, 3, 6  // +Y
	);

	for (int i = 0; i < 6; i++) { // Cara
		gfrontColor = vec4(colors[i], 1.0);
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara
			gl_Position = modelViewProjectionMatrix * vec4(v[faces[i * 6 + j]], 1.0);
			EmitVertex();
			if(j == 2 || j == 5) EndPrimitive(); //Pinto els dos triangles
		}
		EndPrimitive();
	}
}

void main( void )
{	
	vec3 v0 = gl_in[0].gl_Position.xyz;
	vec3 v1 = gl_in[1].gl_Position.xyz;
	vec3 v2 = gl_in[2].gl_Position.xyz;

	vec3 centreExacte = (v0 + v1 + v2) / 3.0;
	vec3 centreCuadricula = round(centreExacte / step) * step;

	printCube(centreCuadricula, step);
}
