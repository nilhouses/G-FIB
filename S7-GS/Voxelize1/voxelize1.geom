#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float step = 0.1;


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
	v[0] = C + vec3(-side, -side, -side);
	v[1] = C + vec3( side, -side, -side);
	v[2] = C + vec3( side,  side, -side);
	v[3] = C + vec3(-side,  side, -side);
	v[4] = C + vec3(-side, -side,  side);
	v[5] = C + vec3( side, -side,  side);
	v[6] = C + vec3( side,  side,  side);
	v[7] = C + vec3(-side,  side,  side);

	// Escullo el vèrtex corresponent, vull evitar hardcodejar-ho...
	int faces[36] = int[36](
		0, 1, 2, 0, 2, 3, // -Z 
		4, 5, 6, 4, 6, 7, // +Z 
		0, 4, 7, 0, 7, 3, // -X 
		1, 5, 6, 1, 6, 2, // +X 
		0, 1, 5, 0, 5, 4, // -Y 
		3, 2, 6, 3, 6, 7  // +Y 
	);

	for (int i = 0; i < 6; i++) { // Cara
		gfrontColor = vec4(colors[i], 1.0);
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara
			gl_Position = modelViewProjectionMatrix * vec4(v[faces[i * 6 + j]], 1.0);
			EmitVertex();
			if(j == 2 || j == 5) EndPrimitive(); //Pinto els dos triangles
		}
	}
}

void main( void )
{
	// Centre real
	vec3 C = baricentre( gl_in[0].gl_Position.xyz, gl_in[1].gl_Position.xyz, gl_in[2].gl_Position.xyz );
	// Centre ja aproximat
	C = step * floor(C / step + 0.5); //el 0.5 es per evitar arrodonir cap avall sempre
	float side = step;
	printCube(C, side);
	
}
