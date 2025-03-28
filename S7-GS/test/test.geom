#version 330 core
        
layout(triangles) in; //Ens arriben triangles com a primitives
layout(triangle_strip, max_vertices = 36) out; //2)

in vec4 vfrontColor[]; //vector perquè tenim un color per cada vèrtex del triangle del VS
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;
/* COSES A ENTENDRE

	1 ) glPosition del geometry shader està en Clip Space, ara el glposition del VS podria no sortir en CS.
	2 ) Triangle strip -> genera triangulo con los 2 últimos vértices el actual
		Optimització es fer molts emit vertexs i després un endPrimitive
*/
void main( void ) //fa....
{
//Pinta copa normal
	for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		vec4 v= gl_in[i].gl_Position;
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
    
    if (gl_PrimitiveIDIn < 900*time) { //Només els primers x triangles
		gfrontColor = vec4(0,1,0,1);
		for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
		{
			vec4 v = gl_in[i].gl_Position;
			v += vec4(3,0,0,0);
			gl_Position = modelViewProjectionMatrix * v;
			EmitVertex();
		}
		EndPrimitive();
	}
}


/*
void main( void ) //Pinta uns triangles
{
//Pinta copa normal
//rellenar tdos los outs antes de hacer un emit vertex
	for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		vec4 v= gl_in[i].gl_Position;
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
    
    if (gl_PrimitiveIDIn < 3) { //Només els primers x triangles
		gfrontColor = vec4(0,1,0,1);
		for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
		{
			vec4 v = gl_in[i].gl_Position;
			v += vec4(3,0,0,0);
			gl_Position = modelViewProjectionMatrix * v;
			EmitVertex();
		}
		EndPrimitive();
	}
}
*/
/* MAIN 3
void main( void ) //fa ombra amb la sgona copa
{
	for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		vec4 v= gl_in[i].gl_Position;
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
    
	gfrontColor = vec4(0);
    for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		vec4 v = gl_in[i].gl_Position;
		v.y = -2.5;
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
}*/

/* MAIN 2
void main( void ) //Pinta 2 copes
{
	for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		vec4 v= gl_in[i].gl_Position;
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
    
    for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		vec4 v = gl_in[i].gl_Position;
		v+= vec4(3,0,0,0);
		gl_Position = modelViewProjectionMatrix * v;
		EmitVertex();
	}
    EndPrimitive();
}*/

/* MAIN 1
void main( void )
{
	for( int i = 0 ; i < 3 ; i++ ) //cada vèrtex de la primitiva
	{
		gfrontColor = vfrontColor[i];
		gl_Position = modelViewProjectionMatrix*gl_in[i].gl_Position;
		EmitVertex();
	}
    EndPrimitive();
}*/
