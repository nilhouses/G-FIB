// GLarena, a plugin based platform to teach OpenGL programming
// © Copyright 2012-2018, ViRVIG Research Group, UPC, https://www.virvig.eu
// 
// This file is part of GLarena
//
// GLarena is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include "Reflection.h"
#include <QCoreApplication>
#include <cmath>

const int IMAGE_WIDTH = 512; // 512x512 pixels viewport
const int IMAGE_HEIGHT = IMAGE_WIDTH;

void Reflection::createMirror() {

	GLWidget & g = *glwidget();
    g.makeCurrent();

    GLuint VBO;
    const Point & min = g.scene()->boundingBox().min();
	const Point & max = g.scene()->boundingBox().max();
	float coords[] = {
		min.x(), min.y(), min.z(), 
		max.x(), min.y(), min.z(),
		min.x(), min.y(), max.z(),
		max.x(), min.y(), max.z()
	};
	g.glGenVertexArrays(1, &mirrorId);
	g.glBindVertexArray(mirrorId);
	g.glGenBuffers(1, &VBO);
	g.glBindBuffer(GL_ARRAY_BUFFER, VBO);
	g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW);
	g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
	g.glEnableVertexAttribArray(0);
	g.glBindVertexArray(0);
}

void Reflection::onPluginLoad()
{
    GLWidget & g = *glwidget();
    g.makeCurrent();
    // Carregar shader, compile & link 
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile(g.getPluginPath()+"/../Reflection/Reflection.vert");

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile(g.getPluginPath()+"/../Reflection/Reflection.frag");

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();

    // Setup texture (mirall)
    g.glActiveTexture(GL_TEXTURE0);
    g.glGenTextures( 1, &textureId); // -> Guardem a textureId el id de la textura creada
    g.glBindTexture(GL_TEXTURE_2D, textureId);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); //GL_REPEAT si volguessim repetir
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, IMAGE_WIDTH, IMAGE_HEIGHT, 0, GL_RGB, GL_FLOAT, NULL); //sense mapa de bits (NULL) configura la textura sense contingut 
    g.glBindTexture(GL_TEXTURE_2D, 0);
    // Resize viewport
    g.resize(IMAGE_WIDTH,IMAGE_HEIGHT); //Finestra de 512x512 pixels

    createMirror();
}

QMatrix4x4 Reflection::reflectionMatrix(float a, float b, float c, float d) {
    return QMatrix4x4(
        1 - 2 * pow(a, 2), -2 * a * b, -2 * a * c, -2 * a * d,
        -2 * a * b, 1 - 2 * pow(b, 2),   -2 * b * c, -2 * b * d,
        -2 * a * c,   -2 * b * c, 1 - 2 * pow(c, 2), -2 * c * d,
        0, 0, 0, 1
    );
}

void Reflection::drawMirror() //mirall reflectit a partir de la textura
{
    GLWidget & g = *glwidget();
    g.makeCurrent();
	g.glBindVertexArray(mirrorId);
	g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	g.glBindVertexArray(0);
}

bool Reflection::paintGL() 
{
    GLWidget & g = *glwidget();
    g.makeCurrent();

    program->bind();
    program->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());

    // ------------------------------------------------------------------
    // FASE 1. Dibuixar l'escena reflectida respecte el pla del mirall.
    //         Guardar la imatge resultant en una textura
    // ------------------------------------------------------------------

    program->setUniformValue("mirror", false); // No estem dibuixant el mirall encara
    g.glClearColor(1, 1, 1, 0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT); // Esborrem el framebuffer

    // Apliquem la matriu de reflexió respecte al pla y = minY
    program->setUniformValue("reflectionMatrix", reflectionMatrix(0, -1, 0, g.scene()->boundingBox().min().y()));

	// Dibuixem l’escena reflectida
    if (drawPlugin()) drawPlugin()->drawScene(); 

    // Copiem el contingut del framebuffer a la textura
    g.glBindTexture(GL_TEXTURE_2D, textureId);
    g.glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    g.glGenerateMipmap(GL_TEXTURE_2D);

    // ------------------------------------------------------------------
    // FASE 2. Esborrar el framebuffer i dibuixar l'escena en la posició real.
    // ------------------------------------------------------------------
	
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT); // Esborrem framebuffer 
    program->setUniformValue("reflectionMatrix", QMatrix4x4()); // Eliminem la reflexió
    if (drawPlugin()) drawPlugin()->drawScene(); // Dibuixem l’escena tal com és

    // ------------------------------------------------------------------
    // FASE 3. Dibuixar el quad del mirall, texturat amb la textura del primer pas.
    // ------------------------------------------------------------------

    program->setUniformValue("colorMap", 0); // Textura a usar
    program->setUniformValue("size", QVector2D(float(IMAGE_WIDTH), float(IMAGE_HEIGHT)));
    program->setUniformValue("mirror", true); // Activa mode mirall al shader

    drawMirror(); // Mirall reflectit

    g.glBindTexture(GL_TEXTURE_2D, 0); // Desactivem la textura
    g.defaultProgram()->bind(); // Tornem al shader per defecte

    return true;
}
