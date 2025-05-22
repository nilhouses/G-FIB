#include "test.h"
#include "glwidget.h"

void Test::onPluginLoad()
{
	
}

void Test::preFrame() //Se ejecuta antes de cada frame
{
	//cout << "hola" << endl;
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
}

void Test::postFrame() //Se ejecuta después de cada frame
{ //desactivar al postframe el que haguem activat el pre-frame
	glDisable(GL_BLEND);
}//Si no veig canvis tancar i tornar a obrir el viewer

void Test::onObjectAdd()
{
	cout << "Has afegit un objecte, mestre Object added: " << scene()->objects().size() << endl;
	Scene* scn = scene();
	Box box = scn->boundingBox();
	Point min = box.min();
	Point M = box.max();
	cout << "BB: " << endl;
	cout << "min: " << min << endl;
	cout << "max: " << M << endl;
	
	const vector<Object>& objs = scene()->objects();
	cout << "Numero de objetos: " << objs.size() << endl;
	for (int i = 0; i < objs.size(); i++)
	{
		cout << "Obj " << i << ": " << endl;
		const Object& obj = objs[i];
		cout << "Num vertices: " << obj.vertices().size() << endl;
	}
}

bool Test::drawScene()
{
	return false; // return true only if implemented
}

bool Test::drawObject(int)
{
	return false; // return true only if implemented
}

bool Test::paintGL()
{
	return false; // return true only if implemented
}

void Test::keyPressEvent(QKeyEvent *)
{
	
}

void Test::mouseMoveEvent(QMouseEvent *)
{
	
}

