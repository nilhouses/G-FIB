#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform float size = 0.07;
uniform float depth = -0.01;

const vec4 WHITE = vec4(1.0, 1.0, 1.0, 1.0);

out vec2 gTexCoord;

void printLabel(vec3 C){
	// La pinto blanca i al FS li assigno el color que toqui proceduralment
	gfrontColor = WHITE; // Al fs si es blanc pintaré la F
	
	vec4 label[4];
	vec2 tex[4];
	label[0] = vec4(C.x - size, C.y - size, C.z + depth, 1.0); // bottom-left
	label[1] = vec4(C.x + size, C.y - size, C.z + depth, 1.0); // bottom-right
	label[2] = vec4(C.x + size, C.y + size, C.z + depth, 1.0); // top-right
	label[3] = vec4(C.x - size, C.y + size, C.z + depth, 1.0); // top-left

	tex[0] = vec2(0.0, 0.0); // bottom-left
	tex[1] = vec2(7.0, 0.0); // bottom-right
	tex[2] = vec2(7.0, 7.0); // top-right
	tex[3] = vec2(0.0, 7.0); // top-left

	// Triangle 1 (bottom)
	gl_Position = label[0];
	gTexCoord = tex[0];
	EmitVertex();
	gl_Position = label[1];
	gTexCoord = tex[1];
	EmitVertex();
	gl_Position = label[2];
	gTexCoord = tex[2];
	EmitVertex();
	EndPrimitive();

	// Triangle 2 (top)
	gl_Position = label[2];
	gTexCoord = tex[2];
	EmitVertex();
	gl_Position = label[3];
	gTexCoord = tex[3];
	EmitVertex();
	gl_Position = label[0];
	gTexCoord = tex[0];
	EmitVertex();
	EndPrimitive();
}

void main( void )
{
	vec3 v[3];
	for( int i = 0 ; i < 3 ; i++ )
	{
		// Tasques per defecte
		gfrontColor = vfrontColor[i];
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
		// Em guardo el vèrtex en NDC 
		v[i] = gl_in[i].gl_Position.xyz / gl_in[i].gl_Position.w;
		// Clipping -> NDC
	}
    EndPrimitive();
	// Label
	vec3 C = (v[0] + v[1] + v[2]) / 3.0; //Center
	printLabel(C);
}
