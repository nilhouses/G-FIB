#include "ModelInfo2.h"
#include "glwidget.h"

void ModelInfo2::onPluginLoad()
{
	
}

void ModelInfo2::preFrame()
{
	
}

void ModelInfo2::postFrame()
{
	Scene* scn = scene();
	
	nObj = scn->objects().size();
	nVert = 0;
	nPolyg = 0;
	int nTrianglPolyg = 0;
	
	const vector<Object> & objects = scn->objects();
	for (const Object &obj : objects) {
		nPolyg += obj.faces().size();
		nVert += obj.vertices().size();
		for (const Face &face : obj.faces()) {
			if (face.numVertices() == 3) nTrianglPolyg++;
		}
	}
	
	percentTrianglPolyg = (nPolyg > 0) ? (nTrianglPolyg * 100.0f / nPolyg) : 0.0f;
	// Escriure a la pantalla
	QFont font;
	font.setPixelSize(14);
	painter.begin(glwidget());
	painter.setFont(font);
	int x = 15;
	int y = 40;
	// No he sabut usar \n
	QString text = QString("Objectes carregats: ") + QString::number(nObj);
	painter.drawText(x, y, text);
	y += 20;
	text = QString("Vèrtexs carregats: ") + QString::number(nVert);
	painter.drawText(x, y, text);
	y+= 20;
	text =  QString("Polígons carregats: ") + QString::number(nPolyg);
	painter.drawText(x, y, text);
	y+= 20;
	text = QString("Triangles: ") + QString::number(percentTrianglPolyg, 'f', 0) + " %";
	painter.drawText(x, y, text);
	painter.end();
}

void ModelInfo2::onObjectAdd()
{
	
}

bool ModelInfo2::drawScene()
{
	return false; // return true only if implemented
}

bool ModelInfo2::drawObject(int)
{
	return false; // return true only if implemented
}

bool ModelInfo2::paintGL()
{
	return false; // return true only if implemented
}

void ModelInfo2::keyPressEvent(QKeyEvent *)
{
	
}

void ModelInfo2::mouseMoveEvent(QMouseEvent *)
{
	
}

