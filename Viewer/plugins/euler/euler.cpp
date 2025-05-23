#include "euler.h"
#include "glwidget.h"
#include <set>

void Euler::printInfo() {

	Scene* scn = scene();
	

	cout << "----------------------------------------" << endl;

	const vector <Object>& objects = scn->objects();
	int nObj = scn->objects().size();
	int F, V, E, X = 0;
	// Itero objectes de l'escena
	for (int i = 0; i < nObj; ++i) {
		// Objecte
		const Object & obj = objects[i];
		//const Object & obj = objects[i];
		cout << "Objecte [" << i << "]: " << endl;
		// Nombre total de cares (F) de l'objecte
		F = obj.faces().size();
		cout << "F=" << F << endl;
		// Nombre total de vèrtexs (V) de l'objecte
		V = obj.vertices().size();
		cout << "V=" << V << endl;
		// Nombre total d'arestes (E), sense repetir
		set<pair<int, int>> uniqueEdges;
		const auto& faces = obj.faces();
		for (const auto& face : faces) {
			int n = face.numVertices();
			for (int j = 0; j < n; ++j) {
				int v1 = face.vertexIndex(j);
				int v2 = face.vertexIndex((j + 1) % n); // Següent vertex
				if (v1 > v2) swap(v1, v2); //std
				uniqueEdges.insert({v1, v2});
			}
		}
		E = uniqueEdges.size();
		cout << "E=" << E << endl;
		// Característica d'Euler (F+V-E)
		X = F + V - E;
		cout << "X=" << X << endl;
	}
}

void Euler::onPluginLoad()
{
	printInfo();
}

void Euler::preFrame()
{
	
}
void Euler::postFrame()
{
	
}

void Euler::onObjectAdd()
{
	printInfo();
}

bool Euler::drawScene()
{
	return false; // return true only if implemented
}

bool Euler::drawObject(int)
{
	return false; // return true only if implemented
}

bool Euler::paintGL()
{
	return false; // return true only if implemented
}

void Euler::keyPressEvent(QKeyEvent *)
{
	
}

void Euler::mouseMoveEvent(QMouseEvent *)
{
	
}
