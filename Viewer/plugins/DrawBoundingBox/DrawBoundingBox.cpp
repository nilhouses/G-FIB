#include "DrawBoundingBox.h"
#include "glwidget.h"

/*
 Funcions privades usades

    configureShaders() // Compila i linka
    configureBox() //Seteja el VAO i VBOs
    drawBox() //Dibuixa la caixa
 */
void DrawBoundingBox::configureShaders() // Compila i linka
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    bool ok = true;

    // VS
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    ok = vs->compileSourceFile(g.getPluginPath() + "/../DrawBoundingBox/DrawBoundingBox.vert");
    cout << "VS log:" << vs->log().toStdString() << endl;
    if (!ok) cout << "Error in VS " << endl;

    // FS
    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    ok = fs->compileSourceFile(g.getPluginPath() + "/../DrawBoundingBox/DrawBoundingBox.frag");
    cout << "FS log:" << fs->log().toStdString() << endl;
    if (!ok) cout << "Error in FS " << endl;

    // Link
    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    ok = program->link();
    cout << "Link log:" << program->log().toStdString() << endl;
    if (!ok) cout << "Error linking shader program: " << endl;
}

void DrawBoundingBox::configureBox(GLWidget &g) { // Seteja el VAO i VBOs
    // Create & bind empty VAO
    g.glGenVertexArrays(1, &VAO_box);
    g.glBindVertexArray(VAO_box);

    
    float vertices[] = {
        // +Z 
        0, 0, 1, // Bottom-Left
        1, 0, 1, // Bottom-Right
        1, 1, 1, // Top-Right
        0, 1, 1, // Top-Left

        // -Z 
        0, 0, 0, // Bottom-Left
        1, 0, 0, // Bottom-Right
        1, 1, 0, // Top-Right
        0, 1, 0  // Top-Left
    };

    GLuint indices[] = { // Triangle format
        0, 1, 2, // -Z
        2, 3, 0, // -Z
    
        5, 4, 7, // +Z
        7, 6, 5, // +Z
    
        4, 0, 3, // -X
        3, 7, 4, // -X
    
        1, 5, 6, // +X
        6, 2, 1, // +X
    
        3, 2, 6, // +Y
        6, 7, 3, // +Y
    
        4, 5, 1, // -Y
        1, 0, 4  // -Y
    };

    // VBO
    GLuint VBO_coords;
    g.glGenBuffers(1, &VBO_coords);
    g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
    g.glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    g.glEnableVertexAttribArray(0);

    // EBO
    GLuint VBO_indices;
    g.glGenBuffers(1, &VBO_indices);
    g.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, VBO_indices);
    g.glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    // Disable VAO
	g.glBindVertexArray(0);
}


void DrawBoundingBox::drawBox(GLWidget &g, const Box& box) {
    
    const Point &translate = box.min();
    const Point &scale = box.max() - box.min();
    program->bind();
    
    // Uniforms
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
    QMatrix4x4 TM;
    TM.translate(translate.x(), translate.y(), translate.z());
    TM.scale(scale.x(), scale.y(), scale.z());
    
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    program->setUniformValue("normalMatrix",  NM);
    program->setUniformValue("transformMatrix", TM);
    // 2. Draw
    g.glBindVertexArray(VAO_box);
    g.glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
    // 3. Unbind VAO
    g.glBindVertexArray(0);
}

void DrawBoundingBox::onPluginLoad()
{
    GLWidget &g = *glwidget();
	g.makeCurrent();
	configureBox(g);
	configureShaders();
	for (Object & object : g.scene()->objects())
		object.computeBoundingBox();
}

void DrawBoundingBox::postFrame()
{
    //Recorrer els objectes i pintar la seva bounding box
    GLWidget &g = *glwidget();
	g.makeCurrent();
    GLint prevPolygonMode;
    g.glGetIntegerv(GL_POLYGON_MODE, &prevPolygonMode);
    g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE); //arestes triangles

	for (const Object &obj : g.scene()->objects()) 
		drawBox(g,obj.boundingBox());

    g.glPolygonMode(GL_FRONT_AND_BACK, prevPolygonMode); // Restore previous mode   
}


void DrawBoundingBox::preFrame()
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

