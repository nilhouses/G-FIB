#include "showdegree.h"
#include "glwidget.h"

void Showdegree::onPluginLoad()
{
	Scene* scn = scene();
	const vector<Object> &objects = scn->objects();
	//(assumir que l'escena conté un objecte)
	const Object &obj = objects[0]; 
	int numVertices = obj.vertices().size();
	
	int sumNumVerticesFaces = 0;
	const vector<Face> &faces = obj.faces();
	for (const Face &f : faces) 
		sumNumVerticesFaces += f.numVertices();
	//compto un vertex tantes vegades com cares uneixi

	degree = (float) sumNumVerticesFaces / numVertices;
}

void Showdegree::postFrame()
{
	QFont font;
	font.setPixelSize(32);
	painter.begin(glwidget());
	painter.setFont(font);
	int x = 15;
	int y = 40;
	QString text = QString::number(degree, 'f', 5); //decimals
	painter.drawText(x, y, text);    
	painter.end();
}

void Showdegree::preFrame()
{
	
}

void Showdegree::onObjectAdd()
{
	
}

bool Showdegree::drawScene()
{
	return false; // return true only if implemented
}

bool Showdegree::drawObject(int)
{
	return false; // return true only if implemented
}

bool Showdegree::paintGL()
{
	return false; // return true only if implemented
}

void Showdegree::keyPressEvent(QKeyEvent *)
{
	
}

void Showdegree::mouseMoveEvent(QMouseEvent *)
{
	
}

