#include "boundary.h"
#include "glwidget.h"
#include <set>


void Boundary::printInfo() {

	Scene* scn = scene();
	
	cout << "----------------------------------------" << endl;

	const vector <Object>& objects = scn->objects();
	int nObj = scn->objects().size();
	int E, Border = 0;
	// Itero objectes de l'escena
	for (int i = 0; i < nObj; ++i) {
		
		const auto& faces = objects[i].faces();
		
		// Nombre total d'arestes (E)
		map<pair<int, int>, int> edgeCount;

		for (const auto& face : faces) {
			int n = face.numVertices();
			for (int j = 0; j < n; ++j) {
				int v1 = face.vertexIndex(j);
				int v2 = face.vertexIndex((j + 1) % n);
				if (v1 > v2) swap(v1, v2);
				edgeCount[{v1, v2}]++;
			}
		}

		E = edgeCount.size();
		
		for (const auto& edge : edgeCount) 
			if (edge.second == 1) 
				Border++;
			
		cout << "E=" << E << endl;
		cout << "Border=" << Border << endl;
	}
}

void Boundary::onPluginLoad()
{
	printInfo();
}

void Boundary::preFrame()
{
	
}

void Boundary::postFrame()
{
	
}

void Boundary::onObjectAdd()
{
	printInfo();
}

bool Boundary::drawScene()
{
	return false; // return true only if implemented
}

bool Boundary::drawObject(int)
{
	return false; // return true only if implemented
}

bool Boundary::paintGL()
{
	return false; // return true only if implemented
}

void Boundary::keyPressEvent(QKeyEvent *)
{
	
}

void Boundary::mouseMoveEvent(QMouseEvent *)
{
	
}

