#ifndef _SKYPLANE_H
#define _SKYPLANE_H

#include "plugin.h" 

#include <QOpenGLShaderProgram>
#include <QCoreApplication>
#include <QOpenGLTexture>
#include <QImage>

class Skyplane: public QObject, public Plugin
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
	// add private methods and attributes here
	QOpenGLShaderProgram *skyProgram, *mirrorProgram;
	QOpenGLShader *vsSky, *fsSky, *vsMirror, *fsMirror;
	GLuint VAO, VBO, textureId;
	QOpenGLTexture* skyTexture;
};

#endif
