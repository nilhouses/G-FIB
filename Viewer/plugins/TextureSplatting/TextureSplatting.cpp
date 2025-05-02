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

#include "TextureSplatting.h"
#include <QFileDialog>
 
void TextureSplatting::onPluginLoad()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    bool ok = true;

    // VS
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    ok = vs->compileSourceFile(g.getPluginPath() + "/../TextureSplatting/splatting.vert");
    cout << "VS log:" << vs->log().toStdString() << endl;
    if (!ok) {cout << "Error in VS " << endl; return;}

    // FS
    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    ok = fs->compileSourceFile(g.getPluginPath() + "/../TextureSplatting/splatting.frag");
    cout << "FS log:" << fs->log().toStdString() << endl;
    if (!ok) {cout << "Error in FS " << endl; return;}

    // Link
    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    ok = program->link();
    cout << "Link log:" << program->log().toStdString() << endl;
    if (!ok) {cout << "Error linking shader program: " << endl; return;}

	// Load Texture 0
	QString filename0 = QFileDialog::getOpenFileName(0, "Open Image 0 (Noise)", "/assig/grau-g/Textures", "Image file (*.png *.jpg)");	
	QImage img0(filename0);	//path que indica l'usuari
	QImage im0 = img0.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
        g.makeCurrent(); // Assegura el context OpenGL actual
	g.glActiveTexture(GL_TEXTURE0);
	g.glGenTextures( 1, &textureId0);
	g.glBindTexture(GL_TEXTURE_2D, textureId0);
	g.glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB, im0.width(), im0.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, im0.bits());
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	g.glBindTexture(GL_TEXTURE_2D, 0);

	// Load Texture 1 (el mateix que amb la textura anterior)
	QString filename1 = QFileDialog::getOpenFileName(0, "Open Image 1 (Rock)", "/assig/grau-g/Textures", "Image file (*.png *.jpg)");	
	QImage img1(filename1);	
	QImage im1 = img1.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
        g.makeCurrent();
	g.glActiveTexture(GL_TEXTURE1);
	g.glGenTextures( 1, &textureId1);
	g.glBindTexture(GL_TEXTURE_2D, textureId1);
	g.glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB, im1.width(), im1.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, im1.bits());
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	g.glBindTexture(GL_TEXTURE_2D, 0);

    	// Load Texture 2 (el mateix que amb la textura anterior)
	QString filename2 = QFileDialog::getOpenFileName(0, "Open Image 2 (Grass)", "/assig/grau-g/Textures", "Image file (*.png *.jpg)");	
	QImage img2(filename2);	
	QImage im2 = img2.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
        g.makeCurrent();
	g.glActiveTexture(GL_TEXTURE2);
	g.glGenTextures( 1, &textureId2);
	g.glBindTexture(GL_TEXTURE_2D, textureId2);
	g.glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB, im2.width(), im2.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, im2.bits());
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	g.glBindTexture(GL_TEXTURE_2D, 0);
}

void TextureSplatting::preFrame() 
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    //bind textures
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, textureId0);
    g.glActiveTexture(GL_TEXTURE1);
    g.glBindTexture(GL_TEXTURE_2D, textureId1);
    g.glActiveTexture(GL_TEXTURE2);
    g.glBindTexture(GL_TEXTURE_2D, textureId2);
    
    //bind shader and define uniforms
    program->bind();
    program->setUniformValue("noise0", 0);  // texture unit del primer sampler 
    program->setUniformValue("rock1", 1);  // texture unit del segon  sampler 
    program->setUniformValue("grass2", 2);  // texture unit del tercer  sampler 
    program->setUniformValue("radius", float(scene()->boundingBox().radius()));  // radi d'una esfera que engloba l'escena
    program->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());
}

void TextureSplatting::postFrame() 
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    // bind default shaders
    g.defaultProgram()->bind();
    // unbind textures
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, 0);
    g.glActiveTexture(GL_TEXTURE1);
    g.glBindTexture(GL_TEXTURE_2D, 0);
    g.glActiveTexture(GL_TEXTURE2);
    g.glBindTexture(GL_TEXTURE_2D, 0);
}

