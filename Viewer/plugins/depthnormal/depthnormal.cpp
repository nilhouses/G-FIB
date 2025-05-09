#include "depthnormal.h"
#include "glwidget.h"

void Depthnormal::onPluginLoad() // Configure shaders
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    bool ok = true;

    // Shader 1
    vs1 = new QOpenGLShader(QOpenGLShader::Vertex, this);
    ok = vs1->compileSourceFile(g.getPluginPath() + "/../depthnormal/depth.vert");
    cout << "vs1 log:" << vs1->log().toStdString() << endl;
    if (!ok) {cout << "Error in vs1" << endl; return;}

    fs1 = new QOpenGLShader(QOpenGLShader::Fragment, this);
    ok = fs1->compileSourceFile(g.getPluginPath() + "/../depthnormal/depth.frag");
    cout << "fs1 log:" << fs1->log().toStdString() << endl;
    if (!ok) {cout << "Error in fs1" << endl; return;}

    program1 = new QOpenGLShaderProgram(this);
    program1->addShader(vs1);
    program1->addShader(fs1);
    ok = program1->link();
    cout << "Program1 link log:" << program1->log().toStdString() << endl;
    if (!ok) {cout << "Error linking program1" << endl; return;}

    // Shader 2
    vs2 = new QOpenGLShader(QOpenGLShader::Vertex, this);
    ok = vs2->compileSourceFile(g.getPluginPath() + "/../depthnormal/normal.vert");
    cout << "vs2 log:" << vs2->log().toStdString() << endl;
    if (!ok) {cout << "Error in vs2" << endl; return;}

    fs2 = new QOpenGLShader(QOpenGLShader::Fragment, this);
    ok = fs2->compileSourceFile(g.getPluginPath() + "/../depthnormal/normal.frag");
    cout << "fs2 log:" << fs2->log().toStdString() << endl;
    if (!ok) {cout << "Error in fs2" << endl; return;}

    program2 = new QOpenGLShaderProgram(this);
    program2->addShader(vs2);
    program2->addShader(fs2);
    ok = program2->link();
    cout << "Program2 link log:" << program2->log().toStdString() << endl;
    if (!ok) {cout << "Error linking program2" << endl; return;}
}


bool Depthnormal::paintGL()
{
	GLWidget &g = *glwidget();
	g.makeCurrent();
	
	int w = g.width();
	int h = g.height();
	
	// Clear the screen with a black background
	g.glClearColor(0.0, 0.0, 0.0, 1.0);
	g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
	
	// PASS 1:  Depth
	//cout << "Pinto depth" << endl;
	program1->bind();
	// Viewport esquerre
	glViewport(0, 0, w / 2, h); // Left half of the screen
	camera()->setAspectRatio(float(w) / 2.0f / float(h));
	
	// Uniforms
	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	program1->setUniformValue("modelViewProjectionMatrix", MVP);

	// Dibuixa l'escena
	if (drawPlugin()) drawPlugin() -> drawScene();
	// Desactiva el shader
	program1->release(); 
	
	// PASS 2: Render Normals
	//cout << "Pinto normal" << endl;
	program2->bind();
	// Viewport dret
	glViewport(w / 2, 0, w / 2, h); // Right half of the screen
	camera()->setAspectRatio(float(w) / 2.0f / float(h));

	// Uniforms
	QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
	MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	program2->setUniformValue("modelViewProjectionMatrix", MVP);
	program2->setUniformValue("normalMatrix", NM);

	// Dibuixa l'escena
	if (drawPlugin()) drawPlugin() -> drawScene();
	// Desactiva el shader
	program2->release();

	// Fi
	return true;
}


void Depthnormal::preFrame()
{

}


void Depthnormal::postFrame()
{

}
void Depthnormal::onObjectAdd()
{
	
}

bool Depthnormal::drawScene() {
	return false;
}


bool Depthnormal::drawObject(int) {
	return false;
}



void Depthnormal::keyPressEvent(QKeyEvent *)
{
	
}

void Depthnormal::mouseMoveEvent(QMouseEvent *)
{
	
}