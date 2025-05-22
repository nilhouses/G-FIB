#include "ModelInfo1.h"
#include "glwidget.h"

void ModelInfo1::onPluginLoad()
{
	
}

void ModelInfo1::preFrame()
{
	
}

void ModelInfo1::postFrame()
{
	Scene* scn = scene();
	
	int nObj = scn->objects().size();
	int nVert = 0;
	int nPolyg = 0;
	int nTrianglPolyg = 0;
	
	const vector<Object> & objects = scn->objects();
	for (const Object &obj : objects) {
		nPolyg += obj.faces().size();
		nVert += obj.vertices().size();
		for (const Face &face : obj.faces()) {
			if (face.numVertices() == 3) nTrianglPolyg++;
		}
	}
	
	float percentTrianglPolyg = (nPolyg > 0) ? (nTrianglPolyg * 100.0f / nPolyg) : 0.0f;
	
	cout << "Objectes carregats: " << nObj << endl;
	cout << "Polígons totals carregats: " << nPolyg << endl;
	cout << "Vèrtexs totals carregats: " << nVert << endl;
	// cout << "Polígons: " << nPolyg << endl;
	// cout << "Polígons que són triangles: " << nTrianglPolyg << endl;
	cout << "Percentatge de polígons que son triangles: " << percentTrianglPolyg <<" %"<< endl;
}

void ModelInfo1::onObjectAdd()
{
	
}

bool ModelInfo1::drawScene()
{
	return false; // return true only if implemented
}

bool ModelInfo1::drawObject(int)
{
	return false; // return true only if implemented
}

bool ModelInfo1::paintGL()
{
	return false; // return true only if implemented
}

void ModelInfo1::keyPressEvent(QKeyEvent *)
{
	
}

void ModelInfo1::mouseMoveEvent(QMouseEvent *)
{
	
}


