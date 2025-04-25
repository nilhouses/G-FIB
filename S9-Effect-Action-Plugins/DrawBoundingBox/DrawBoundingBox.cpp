#include "DrawBoundingBox.h"
#include "glwidget.h"

void DrawBoundingBox::onPluginLoad()
{
	//VAO i VBO del cub
	    static bool created = false;
    static GLuint VAO_rect;
    GLWidget &g = *glwidget();
    g.makeCurrent();

    // 1. Create VBO Buffers
    if (!created)
    {
        created = true;        

        // Create & bind empty VAO
        g.glGenVertexArrays(1, &VAO_rect); //donar una direcció de memòria a l'array
        g.glBindVertexArray(VAO_rect); //activem el vao VAO_rect, le sseguents crides l'usaràn

        // Create VBO with (x,y,z) coordinates
		float p0[] = {0,0,0};
		float p1[] = {0,0,1};
		float p2[] = {0,1,0};
		float p3[] = {1,0,0};
		float p4[] = {1,0,1};
		float p5[] = {1,1,0};
		float p6[] = {1,0,1};
		float p7[] = {1,1,1};
		
		//per aquí
        float coords[] = {p0.x(), p0.y(), p0.z(), p1.x(), p1.y(), p1.z(), p3.x(), p3.y(), p3.z(), p2.x(), p2.y(), p2.z()};

        GLuint VBO_coords;
        g.glGenBuffers(1, &VBO_coords); //generem el buffer amb coordenades
        g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
        g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW); //passa dades de la RAM a la GPU
        g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0); //les dades que he passat aniran de 3 en 3
        g.glEnableVertexAttribArray(0);
        //glBindVertexArray(0);

		//layout (location = 1) normal;
        float normals[] = { 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0};

        GLuint VBO_normals;
        g.glGenBuffers(1, &VBO_normals);
        g.glBindBuffer(GL_ARRAY_BUFFER, VBO_normals);
        g.glBufferData(GL_ARRAY_BUFFER, sizeof(normals), normals, GL_STATIC_DRAW);
        g.glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, 0);
        g.glEnableVertexAttribArray(1);

        //Create FBO with indices <-- Afegit a la demo de la sessió 9
        GLuint indices[]= { 0, 1, 2, 3 };
        GLuint VBO_indices;
        g.glGenBuffers(1, &VBO_indices);
        g.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, VBO_indices);
        g.glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
        
	    g.glBindVertexArray(0);
    }
    // 2. Draw
    g.glBindVertexArray(VAO_rect);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); // Cada 4 vèrtexs fer els dos triangles
    g.glBindVertexArray(0);

 
 	//Pintar les línees dels triangles per pintar la bounding 
	g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	//glDrawArrays() OR gldrawelements(...)
	g.glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
}

void DrawBoundingBox::preFrame()
{
	
}

void DrawBoundingBox::postFrame()
{
	
}

void DrawBoundingBox::onObjectAdd()
{
	
}

bool DrawBoundingBox::drawScene()
{
	return false; // return true only if implemented
}

bool DrawBoundingBox::drawObject(int)
{
	return false; // return true only if implemented
}

bool DrawBoundingBox::paintGL()
{
	return false; // return true only if implemented
}

void DrawBoundingBox::keyPressEvent(QKeyEvent *)
{
	
}

void DrawBoundingBox::mouseMoveEvent(QMouseEvent *)
{
	
}

