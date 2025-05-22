#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

void main( void )
{
	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vfrontColor[i];
		gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
		EmitVertex();
	}
    EndPrimitive();

	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vec4(vec3(0.0),1.0);
		vec4 pos = gl_in[i].gl_Position;
		pos.y = boundingBoxMin.y;
		gl_Position = modelViewProjectionMatrix * pos;
		EmitVertex();
	}
    EndPrimitive();

	// Pla Cian
	if (gl_PrimitiveIDIn == 0) {
		float R = distance(boundingBoxMax, boundingBoxMin) / 2.0;
		float y = boundingBoxMin.y - 0.01;
		vec3 C = (boundingBoxMax + boundingBoxMin) / 2.0; // Center of the bounding box

		// Rectangle cian
		gfrontColor = vec4(vec3(0.0, 1.0, 1.0), 1.0);

		// Triangle 1
		vec4 v1 = vec4(C.x + R, y, C.z + R, 1.0);
		gl_Position = modelViewProjectionMatrix * v1;
		EmitVertex();

		vec4 v2 = vec4(C.x + R, y, C.z - R, 1.0);
		gl_Position = modelViewProjectionMatrix * v2;
		EmitVertex();

		vec4 v3 = vec4(C.x - R, y, C.z - R, 1.0);
		gl_Position = modelViewProjectionMatrix * v3;
		EmitVertex();
		
		EndPrimitive();

		// Triangle 2
		gl_Position = modelViewProjectionMatrix * v1;
		EmitVertex();

		gl_Position = modelViewProjectionMatrix * v3;
		EmitVertex();

		vec4 v4 = vec4(C.x - R, y, C.z + R, 1.0);
		gl_Position = modelViewProjectionMatrix * v4;
		EmitVertex();

		EndPrimitive();
	}
}
