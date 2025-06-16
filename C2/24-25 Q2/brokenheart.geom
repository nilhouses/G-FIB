#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
in vec2 vtexCoord[];
out vec4 gfrontColor;
out vec2 gtexCoord;

uniform float time;
uniform mat4 modelViewProjectionMatrix;

vec3 baricentre(vec3 v1, vec3 v2, vec3 v3) {
	return (v1 + v2 + v3) / 3.0;
}

// Moviments
float t = smoothstep(0.0, 1.0, min(1.0, mod(time,5.0)/5.0));

//Rotació
mat3 rotationMatrix(float a) { return mat3( cos(a), sin(a), 0,
									-sin(a), cos(a), 0,
									0, 0, 1);}
//Translació							
vec3 translate = vec3(0.75*t, 0, 0);

void main( void )
{


	// Variables del VS
	vec3 v0 =  gl_in[0].gl_Position.xyz;
	vec4 col0 = vfrontColor[0];

	vec3 v1 =  gl_in[1].gl_Position.xyz;
	vec4 col1 = vfrontColor[1];

	vec3 v2 =  gl_in[2].gl_Position.xyz;
	vec4 col2 = vfrontColor[2];

	vec3 m0 = mix(v0,v1, 0.4);
	vec3 m1 = mix(v1,v2, 0.4);
	vec3 m2 = mix(v2,v0, 0.4);

	//Punt central de cada triangle
	vec3 C;

// Triangles

// T1 (v0, m0, m2)
	C = baricentre(v0,m0,m2);
	mat3 rot = (C.x < 0) ? rotationMatrix(t) : rotationMatrix(-t);
	vec3 trans = (C.x < 0) ? -translate : translate;

	//V0 (color, textura i coordenades)
	gfrontColor = col0;
	gtexCoord = vtexCoord[0];
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*v0, 1.0);
	EmitVertex();

	//m0 (color, textura i coordenades)
	gfrontColor = mix(col0, col1, 0.4);
	gtexCoord = mix(vtexCoord[0], vtexCoord[1], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m0, 1.0);
	EmitVertex();
	
	//m2 (color, textura i coordenades)
	gfrontColor = mix(col2, col0, 0.4);
	gtexCoord = mix(vtexCoord[2], vtexCoord[0], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m2, 1.0);
	EmitVertex();
	EndPrimitive();

// T2 (m0, v1, m1)
	C = baricentre(m0,v1,m1);
	rot = (C.x < 0) ? rotationMatrix(t) : rotationMatrix(-t);
	trans = (C.x < 0) ? -translate : translate;

	//m0 (color, textura i coordenades)
	gfrontColor = mix(col0, col1, 0.4);
	gtexCoord = mix(vtexCoord[0], vtexCoord[1], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m0, 1.0);
	EmitVertex();
	
	//V1 (color, textura i coordenades)
	gfrontColor = col1;
	gtexCoord = vtexCoord[1];
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*v1, 1.0);
	EmitVertex();

	//m1 (color, textura i coordenades)
	gfrontColor = mix(col1, col2, 0.4);
	gtexCoord = mix(vtexCoord[1], vtexCoord[2], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m1, 1.0);
	EmitVertex();
	EndPrimitive();

// T3 i T4 Donen problemes
// T3 (m2, m1, v2)
	C = baricentre(m2,m1,v2);
	rot = (C.x < 0) ? rotationMatrix(t) : rotationMatrix(-t);
	trans = (C.x < 0) ? -translate : translate;

	//m2 (color, textura i coordenades)
	gfrontColor = mix(col2, col0, 0.4);
	gtexCoord = mix(vtexCoord[2], vtexCoord[0], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m2, 1.0);
	EmitVertex();

	//m1 (color, textura i coordenades)
	gfrontColor = mix(col1, col2, 0.4);
	gtexCoord = mix(vtexCoord[1], vtexCoord[2], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m1, 1.0);
	EmitVertex();
	
	//V2 (color, textura i coordenades)
	gfrontColor = col2;
	gtexCoord = vtexCoord[2];
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*v2, 1.0);
	EmitVertex();
	EndPrimitive();
	
// T4 (m0,m1,m2)
	C = baricentre(m0,m1,m2);
	rot = (C.x < 0) ? rotationMatrix(t) : rotationMatrix(-t);
	trans = (C.x < 0) ? -translate : translate;
	
	//m0 (color, textura i coordenades)
	gfrontColor = mix(col0, col1, 0.4);
	gtexCoord = mix(vtexCoord[0], vtexCoord[1], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m0, 1.0);
	EmitVertex();

	//m1 (color, textura i coordenades)
	gfrontColor = mix(col1, col2, 0.4);
	gtexCoord = mix(vtexCoord[1], vtexCoord[2], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m1, 1.0);
	EmitVertex();
	
	//m2 (color, textura i coordenades)
	gfrontColor = mix(col2, col0, 0.4);
	gtexCoord = mix(vtexCoord[2], vtexCoord[0], 0.4);
	gl_Position = modelViewProjectionMatrix * vec4(trans+rot*m2, 1.0);
	EmitVertex();
}

