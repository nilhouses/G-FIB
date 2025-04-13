#include "ilumXfragment.h"
#include "glwidget.h"

void ilumXfragment::onPluginLoad()
{ 
	/*Compila i linka*/

	GLWidget* g = glwidget();
	g->makeCurrent();
	// 1) Compilar

	//VS
	bool ok = true;
	
	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	// Plugin Path es plugin/bin, i necessito anar a ../ilumXfragment
	ok = vs->compileSourceFile(g->getPluginPath()+"/../ilumXfragment/lighting4.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	if (!ok) cout << "Error in VS " << endl; 

	//FS
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	ok = fs->compileSourceFile(g->getPluginPath()+"/../ilumXfragment/lighting4.frag");
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

void ilumXfragment::preFrame()
{
	/*Activa shaders i dona un valor apropiat als uniforms*/
	program->bind();
	//Uniforms
	float f = elapsedTimer.elapsed() /1000.0f; //ms -> seg
	program->setUniformValue("time", f);

	//Uniforms VS
	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
	QMatrix4x4 MVM = camera()->viewMatrix();

	program->setUniformValue("modelViewProjectionMatrix", MVP);
	program->setUniformValue("normalMatrix",  NM);
	program->setUniformValue("modelViewMatrix", MVM);

	//Uniforms FS

	//Llum
	QVector4D lightAmbient(0.2f, 0.2f, 0.2f, 1.0f);
	QVector4D lightDiffuse(0.8f, 0.8f, 0.8f, 1.0f);
	QVector4D lightSpecular(1.0f, 1.0f, 1.0f, 1.0f);
	QVector4D lightPosition(0.0f, 0.0f, 10.0f, 1.0f);

	program->setUniformValue("lightAmbient", lightAmbient);
	program->setUniformValue("lightDiffuse", lightDiffuse);
	program->setUniformValue("lightSpecular", lightSpecular);
	program->setUniformValue("lightPosition", lightPosition);

	// Material
	Material mat = Material();
	QVector4D matAmbient(mat.ambient[0], mat.ambient[1], mat.ambient[2], mat.ambient[3]);
	QVector4D matDiffuse(mat.diffuse[0], mat.diffuse[1], mat.diffuse[2], mat.diffuse[3]);
	QVector4D matSpecular(mat.specular[0], mat.specular[1], mat.specular[2], mat.specular[3]);
	float matShininess = mat.shininess;

	program->setUniformValue("matAmbient", matAmbient);
	program->setUniformValue("matDiffuse", matDiffuse);
	program->setUniformValue("matSpecular", matSpecular);
	program->setUniformValue("matShininess", matShininess);

}

void ilumXfragment::postFrame()
{	
	/*Desactiva shaders*/
	program->release();
}

void ilumXfragment::onObjectAdd()
{
	
}

bool ilumXfragment::drawScene()
{
	return false; // return true only if implemented
}

bool ilumXfragment::drawObject(int)
{
	return false; // return true only if implemented
}

bool ilumXfragment::paintGL()
{
	return false; // return true only if implemented
}

void ilumXfragment::keyPressEvent(QKeyEvent *)
{
	
}

void ilumXfragment::mouseMoveEvent(QMouseEvent *)
{
	
}


