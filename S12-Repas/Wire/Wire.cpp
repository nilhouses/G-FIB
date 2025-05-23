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

#include "Wire.h"

void Wire::onPluginLoad()
{
    // Carregar shader, compile & link 
    // SI NO VA PROVAR []
    // layout (location = 0) in vec3 vertex;
    // layout (location = 1) in vec3 normal;

    QString vs_src =
      "#version 330 core\n"
      "uniform mat4 modelViewProjectionMatrix;"
      "uniform mat3 normalMatrix;"
      "in vec3 vertex;"
      "in vec3 normal;"
      "out vec4 frontColor;"
      "void main() {"
      "vec3 N = normalize(normalMatrix * normal);"
      "frontColor = vec4(vec3(N.z),1.0);"
      "  gl_Position = modelViewProjectionMatrix * vec4(vertex,1.0);"
      "}";

    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceCode(vs_src);
    cout << "VS log:" << vs->log().toStdString() << endl;

    QString fs_src =
      "#version 330 core\n"
      "out vec4 fragColor;"
      "in vec4 frontColor;"
      "uniform bool gris;"
      "void main() {"
      " fragColor = (gris) ? frontColor : vec4(vec3(0.0),1.0);"
      "}";

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceCode(fs_src);
    cout << "FS log:" << fs->log().toStdString() << endl;

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    cout << "Link log:" << program->log().toStdString() << endl;
}

bool Wire::paintGL() {

  program->bind();

  // Set uniforms
  QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
  program->setUniformValue("normalMatrix", NM);
  QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
  program->setUniformValue("modelViewProjectionMatrix", MVP);

  // 1) Passada que pinta l'escena amb objectes grisos
  program->setUniformValue("gris", true);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
  glDisable(GL_POLYGON_OFFSET_FILL);
  if (drawPlugin()) drawPlugin()->drawScene();

  // 2) Passada que pinta les línees negres
  program->setUniformValue("gris", false);
  // Config linees
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
  glEnable(GL_POLYGON_OFFSET_LINE);
  glPolygonOffset(-1.0f, 1.0f);
  if (drawPlugin()) drawPlugin()->drawScene();

  // //Restaura estat No cal, quan es torni a cridar es seteja l'estat inicial
  // glDisable(GL_POLYGON_OFFSET_LINE);
  // glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
  program->release();
  
  return true;
}



// Tema uniforms, es podria posar al preframe i posframe però al paintgl ja és vàlid 

void Wire::preFrame() 
{
    // bind shader and define uniforms
    // program->bind();
    // QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
    // program->setUniformValue("normalMatrix", NM);
    // QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    // program->setUniformValue("modelViewProjectionMatrix", MVP); 
}

void Wire::postFrame() 
{
    // unbind shader
    // program->release();
}


