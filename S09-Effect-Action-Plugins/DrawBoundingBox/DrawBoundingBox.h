#ifndef _DRAWBOUNDINGBOX_H
#define _DRAWBOUNDINGBOX_H

#include "plugin.h" 

class DrawBoundingBox: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	 void onPluginLoad();
	 void preFrame();
	 void postFrame();

	 void onObjectAdd();
	 bool drawScene();
	 bool drawObject(int);

	 bool paintGL();

	 void keyPressEvent(QKeyEvent *);
	 void mouseMoveEvent(QMouseEvent *);
  private:
  	void configureShaders(); 
  	void configureBox(GLWidget &g); // crea la Box a (0,0,0) de mida 1x1x1
	void drawBox(GLWidget &g, const Box& box);					 
  	GLuint VAO_box;
	// Atributs per carregar els shaders
	QOpenGLShader* vs;
    QOpenGLShader* fs;
	QOpenGLShaderProgram* program;
};

#endif
