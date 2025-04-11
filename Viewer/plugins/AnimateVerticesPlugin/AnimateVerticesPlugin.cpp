#include "AnimateVerticesPlugin.h"
#include "glwidget.h"

void AnimateVerticesPlugin::onPluginLoad()
{ 
	/*Compila i linka*/

	GLWidget* g = glwidget();
	g->makeCurrent();
	// 1) Compilar

	//VS
	bool ok = true;
	
	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	// Plugin Path es plugin/bin, i necessito anar a ../AnimateVerticesPlugin
	ok = vs->compileSourceFile(g->getPluginPath()+"/../AnimateVerticesPlugin/animate-vertices1.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	if (!ok) cout << "Error in VS " << endl; 

	//FS
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	ok = fs->compileSourceFile(g->getPluginPath()+"/../AnimateVerticesPlugin/animate-vertices1.frag");
	cout << "FS log:" << fs->log().toStdString() << endl;
	if (!ok) cout << "Error in FS " << endl; 

	// 2) Linka
	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	ok = program->link();
	cout << "Link log:" << program->log().toStdString() << endl;
	if (!ok) cout << "Error linking shader program: " << endl;

	elapsedTimer.start();
}

void AnimateVerticesPlugin::preFrame()
{
	/*Activa shaders i dona un valor apropiat als uniforms*/
	program->bind();
	//Uniforms
	float f = elapsedTimer.elapsed() /1000.0f; //ms -> seg
	program->setUniformValue("time", f);

	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	program->setUniformValue("modelViewProjectionMatrix", MVP);
	QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
	program->setUniformValue("normalMatrix",  NM);
	/* (amplitude, freq i fase ja setejats al shader) */
}

void AnimateVerticesPlugin::postFrame()
{	
	/*Desactiva shaders*/
	program->release();
}

void AnimateVerticesPlugin::onObjectAdd()
{
	
}

bool AnimateVerticesPlugin::drawScene()
{
	return false; // return true only if implemented
}

bool AnimateVerticesPlugin::drawObject(int)
{
	return false; // return true only if implemented
}

bool AnimateVerticesPlugin::paintGL()
{
	return false; // return true only if implemented
}

void AnimateVerticesPlugin::keyPressEvent(QKeyEvent *)
{
	
}

void AnimateVerticesPlugin::mouseMoveEvent(QMouseEvent *)
{
	
}

