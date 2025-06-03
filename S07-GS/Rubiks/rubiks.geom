#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

out vec4 gfrontColor;
out vec2 vtexCoord;

// gl_in[i].gl_Position està en OS, caldrà passar a CS, després es passa entre shaders a NDC
uniform mat4 modelViewProjectionMatrix;
uniform float time;

const vec4 ORANGE = vec4(1.0, 0.6, 0.0, 1.0);
const vec4 GREEN = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 WHITE = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 RED = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 BLUE = vec4(0.0, 0.0, 1.0, 1.0);
const vec4 YELLOW = vec4(1.0, 1.0, 0.0, 1.0);

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


	vec4 colors[6] = vec4[6](
		WHITE, // -Z
		YELLOW, // +Z
		GREEN, // -X 
		BLUE, // +X
		ORANGE, // -Y
		RED  // +Y
	);

	vec2 texCoords[6] = vec2[6](
		vec2(0.0, 1.0),
		vec2(0.0, 0.0),
		vec2(1.0, 0.0),
		vec2(1.0, 1.0),
		vec2(0.0, 1.0),
		vec2(1.0, 0.0)
	);
	mat3 rotationMatrix = mat3(
								cos(time), sin(time), 0,
								-sin(time), cos(time), 0,
								0, 0, 1);
	for (int i = 0; i < 6; i++) { // Cara
		gfrontColor = colors[i];
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara

			//Per cada cara assigno coordenades de textura a cada vèrtex
			vtexCoord = texCoords[j];
			if (gl_PrimitiveIDIn >= 4)
				gl_Position = modelViewProjectionMatrix * vec4( rotationMatrix * (v[faces[i * 6 + j]]), 1.0);
			else
				gl_Position = modelViewProjectionMatrix * vec4(v[faces[i * 6 + j]], 1.0);
			EmitVertex();
			if(j == 2 || j == 5) EndPrimitive(); //Pinto els dos triangles

		}
	}

}

void main( void )
{	 
	vec3 C = vec3(0.0);
	if (gl_PrimitiveIDIn == 0) C = vec3(-1.0);
	else if (gl_PrimitiveIDIn == 1) C = vec3(1.0,-1.0,-1.0);
	else if (gl_PrimitiveIDIn == 2) C = vec3(-1.0,1.0,-1.0);
	else if (gl_PrimitiveIDIn == 3) C = vec3(1.0,1.0,-1.0);
	else if (gl_PrimitiveIDIn == 4) C = vec3(-1.0,-1.0,1.0);
	else if (gl_PrimitiveIDIn == 5) C = vec3(1.0,-1.0,1.0);
	else if (gl_PrimitiveIDIn == 6) C = vec3(-1.0,1.0,1.0);
	else if (gl_PrimitiveIDIn == 7) C = vec3(1.0);
	else if (gl_PrimitiveIDIn >= 8) return;
	// Printeja cub de costat 2
	printCube(C, 2.0);
}