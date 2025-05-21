#include "skyplane.h"
#include "glwidget.h"

#include <QOpenGLShader>
#include <QOpenGLShaderProgram>
#include <QImage>
#include <QOpenGLTexture>
#include <QMatrix4x4>

void Skyplane::onPluginLoad()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
	// Shaders
	skyProgram = new QOpenGLShaderProgram();
	skyProgram->addShaderFromSourceFile(QOpenGLShader::Vertex, g.getPluginPath() + "/../skyplane/sky.vert");
	skyProgram->addShaderFromSourceFile(QOpenGLShader::Fragment, g.getPluginPath() + "/../skyplane/sky.frag");
	skyProgram->link();

	mirrorProgram = new QOpenGLShaderProgram();
	mirrorProgram->addShaderFromSourceFile(QOpenGLShader::Vertex, g.getPluginPath() + "/../skyplane/mirror.vert");
	mirrorProgram->addShaderFromSourceFile(QOpenGLShader::Fragment, g.getPluginPath() + "/../skyplane/mirror.frag");
	mirrorProgram->link();

	g.glActiveTexture(GL_TEXTURE0);
    // Imatge + textura
    QImage img(g.getPluginPath() + "/../skyplane/sky.jpg");
    skyTexture = new QOpenGLTexture(img.mirrored());
    skyTexture->setMinificationFilter(QOpenGLTexture::LinearMipMapLinear);
    skyTexture->setMagnificationFilter(QOpenGLTexture::Linear);
    skyTexture->setWrapMode(QOpenGLTexture::Repeat);
    skyTexture->generateMipMaps();

    // Crear VAO + VBO 
    g.glGenVertexArrays(1, &VAO);
    g.glBindVertexArray(VAO);
    
    float vertices[] = {
        -1.0f, -1.0f, 1.0f,
         1.0f, -1.0f, 1.0f,
        -1.0f,  1.0f, 1.0f,
         1.0f,  1.0f, 1.0f
    };    
    
    g.glGenBuffers(1, &VBO);
    g.glBindBuffer(GL_ARRAY_BUFFER, VBO);
    g.glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    g.glEnableVertexAttribArray(0); // posició
    g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    // No hi ha atribut de coordenades de textura!
    
    g.glBindVertexArray(0);
}

bool Skyplane::paintGL()
{
    GLWidget &g = *glwidget();
	g.makeCurrent();

    // 1. RECTANGLE TEXTURAT (sky background)
    skyProgram->bind();
	skyTexture->bind(0);// Activa la textura 0

	// Clear screen
	g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	//Uniforms
	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	QMatrix4x4 MVM = camera()->viewMatrix();
	skyProgram->setUniformValue("sampler0", 0);
	skyProgram->setUniformValue("modelViewProjectionMatrix", MVP);
	skyProgram->setUniformValue("modelViewMatrix", MVM);

	// Pinta el rectangle
    g.glDisable(GL_DEPTH_TEST);//Que no el tapi l'escena
	g.glBindVertexArray(VAO);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	g.glBindVertexArray(0);
    g.glEnable(GL_DEPTH_TEST);

    skyTexture->release();
    skyProgram->release();

    // 2.ESCENA
    mirrorProgram->bind();
	skyTexture->bind(0);// Activa la textura 0

	mirrorProgram->setUniformValue("sampler0", 0);
	mirrorProgram->setUniformValue("modelViewProjectionMatrix", MVP);
	mirrorProgram->setUniformValue("modelViewMatrix", MVM);

    if (drawPlugin()) drawPlugin()->drawScene();

    mirrorProgram->release();

	return true;
}

void Skyplane::preFrame()
{

}

void Skyplane::postFrame()
{
    
}

void Skyplane::onObjectAdd()
{

}

bool Skyplane::drawScene()
{
    return false;
}

bool Skyplane::drawObject(int)
{
    return false;
}

void Skyplane::keyPressEvent(QKeyEvent *)
{

}

void Skyplane::mouseMoveEvent(QMouseEvent *)
{

}