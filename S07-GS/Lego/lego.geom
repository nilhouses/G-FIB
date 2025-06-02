#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];

out vec2 vtexCoord;
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float step = 0.2;

const vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 G = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 B = vec4(0.0, 0.0, 1.0, 1.0);
const vec4 C = vec4(0.0, 1.0, 1.0, 1.0);
const vec4 Y = vec4(1.0, 1.0, 0.0, 1.0);

vec4 nearestColor(vec4 color) {
    float dR = distance(color, R);
    float dG = distance(color, G);
    float dB = distance(color, B);
    float dC = distance(color, C);
    float dY = distance(color, Y);
    float minDist = min(min(min(dR, dG), min(dB, dC)), dY);

    if (minDist == dR) return R;
    if (minDist == dG) return G;
    if (minDist == dB) return B;
    if (minDist == dC) return C;
    return Y;
}

vec3 centre(vec3 v1, vec3 v2, vec3 v3) {
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

	for (int i = 0; i < 6; i++) { // Cara
		for (int j = 0; j < 6; j++) { // Els dos triangles que formen la cara
			gl_Position = modelViewProjectionMatrix * vec4(v[faces[i*6 + j]], 1.0);

			// Coordenades per qualsevol cara diferent de +Y
			vtexCoord = vec2(-1.0, -1.0);

			if (i == 5) { // Cara + Y
				if (j == 0) vtexCoord = vec2(1.0, 0.0);
				else if (j == 1) vtexCoord = vec2(0.0, 0.0);
				else if (j == 2) vtexCoord = vec2(0.0, 1.0);
				else if (j == 3) vtexCoord = vec2(1.0, 1.0);
				else if (j == 4) vtexCoord = vec2(1.0, 0.0);
				else if (j == 5) vtexCoord = vec2(0.0, 1.0);
			}
			gfrontColor = nearestColor(vec4(centre(vfrontColor[0].xyz, vfrontColor[1].xyz, vfrontColor[2].xyz), 1.0));
			EmitVertex();
			if (j == 2 || j == 5) EndPrimitive(); // Pinto els dos triangles
		}
	}
}

void main( void )
{
	// Centre real
	vec3 C = centre( gl_in[0].gl_Position.xyz, gl_in[1].gl_Position.xyz, gl_in[2].gl_Position.xyz );
	// Centre ja aproximat
	C = step * floor(C / step + 0.5); //el 0.5 es per evitar arrodonir cap avall sempre
	float side = step;
	printCube(C, side);
}

