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

#include "objectSelect.h"
#include <QCoreApplication>

// ||||||||||||||||||||||||||||||||||||||| Codi que em donen ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||1

void ObjectSelect::encodeID(const unsigned int i, GLubyte * color) {
	// complete this method to encode the object index (i) as a color
    GLubyte R = (GLubyte)((i & 0x00FF0000)   >> 16);
    GLubyte G = (GLubyte)((i & 0x0000FF00) >> 8);
    GLubyte B = (GLubyte)(i & 0x000000FF);
    color[0] = R;
    color[1] = G;
    color[2] = B;
    color[3] = 255;
}

void ObjectSelect::decodeID(const GLubyte *color, unsigned int &i) {
	// complete this method to decode the object index from the color 
    unsigned int R = (unsigned int) color[0];
    unsigned int G = (unsigned int) color[1];
    unsigned int B = (unsigned int) color[2];
	// compute i from R, G, B
    i = (R << 16) | (G << 8) | B;
}

void ObjectSelect::onPluginLoad() {
    std::cout << "[ObjectSelect plugin] Ctrl + Right Click - Select object" << std::endl;

    GLWidget &g = *glwidget();
    g.makeCurrent();

    // Carregar shader, compile & link
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile(g.getPluginPath() + "/../objectSelect/objectSelect.vert");

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile(g.getPluginPath() + "/../objectSelect/objectSelect.frag");

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    if (!program->isLinked())
        std::cout << "Shader link error" << std::endl;
    else
        std::cout << "Shader linked" << std::endl;

    // Bounding box code
    configureBoxShaders();
    configureBox(g);
    for (Object & object : g.scene()->objects())
        object.computeBoundingBox();
}

void ObjectSelect::selectDraw(GLWidget & g) {
    // (b)
    g.glEnable(GL_DEPTH_TEST);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

    if (!program->bind()) {
        std::cerr << "Failed to bind shader program" << std::endl;
        return;
    }
    program->bind();

    // (d)
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);

    // (e)
    for (unsigned int i=0; i<scene()->objects().size(); ++i){
        GLubyte color[4];
        encodeID(i, color);
        program->setUniformValue("color", QVector4D(color[0]/255.0, color[1]/255., color[2]/255., 1.0));
        cout << "Object " << i << " Color: (" 
                  << (int)color[0] << ", " 
                  << (int)color[1] << ", " 
                  << (int)color[2] << ", " 
                  << (int)color[3] << ")" << std::endl;
        drawPlugin()->drawObject(i);
    }
}

void ObjectSelect::mouseReleaseEvent(QMouseEvent* e) {
    // (a)
    if (!(e->button() & Qt::RightButton)) return;
    if (e->modifiers() & (Qt::ShiftModifier)) return;
    if (!(e->modifiers() & Qt::ControlModifier)) return;

    GLWidget &g = *glwidget();
    g.makeCurrent();

    // (b) through (e)
    selectDraw(g);

    // (f)
    int x = e->x();
    int y = g.height() - e->y();
    GLubyte read[4];
    glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, read);

    // (g)
    if(read[3] == 255){
        // Not the background, thus an object has been selected
        unsigned int tmp;
        decodeID(read, tmp);
        scene()->setSelectedObject((int) tmp);
        std::cout << "Selected Object index: " <<tmp << std::endl;
    } else {
        scene()->setSelectedObject(-1);
        std::cout << -1 << std::endl;
    }

    // (h)
    g.update();
}

// ||||||||||||||||||||||||||||||||||||||| Codi que em donen ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||1

void ObjectSelect::configureBoxShaders() {
    GLWidget &g = *glwidget();
    g.makeCurrent();

    vsBox = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vsBox->compileSourceFile(g.getPluginPath() + "/../objectSelect/boundingBox.vert");
    if (!vsBox->isCompiled())
        std::cerr << "Vertex shader compilation error: " << vsBox->log().toStdString() << std::endl;

    fsBox = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fsBox->compileSourceFile(g.getPluginPath() + "/../objectSelect/boundingBox.frag");
    if (!fsBox->isCompiled())
        std::cerr << "Fragment shader compilation error: " << fsBox->log().toStdString() << std::endl;

    programBox = new QOpenGLShaderProgram(this);
    programBox->addShader(vsBox);
    programBox->addShader(fsBox);
    programBox->link();
    if (!programBox->isLinked())
        std::cerr << "Bounding box shader program link error: " << programBox->log().toStdString() << std::endl;
}

// Funció per configurar el VAO i VBO de la bounding box
void ObjectSelect::configureBox(GLWidget &g) { // Seteja el VAO i VBOs
    // Create & bind empty VAO
    g.glGenVertexArrays(1, &VAO_box);
    g.glBindVertexArray(VAO_box);

    
    float vertices[] = {
        // +Z 
        0, 0, 1, // Bottom-Left
        1, 0, 1, // Bottom-Right
        1, 1, 1, // Top-Right
        0, 1, 1, // Top-Left

        // -Z 
        0, 0, 0, // Bottom-Left
        1, 0, 0, // Bottom-Right
        1, 1, 0, // Top-Right
        0, 1, 0  // Top-Left
    };

    GLuint indices[] = { // Triangle format
        0, 1, 2, // -Z
        2, 3, 0, // -Z
    
        5, 4, 7, // +Z
        7, 6, 5, // +Z
    
        4, 0, 3, // -X
        3, 7, 4, // -X
    
        1, 5, 6, // +X
        6, 2, 1, // +X
    
        3, 2, 6, // +Y
        6, 7, 3, // +Y
    
        4, 5, 1, // -Y
        1, 0, 4  // -Y
    };

    // VBO
    GLuint VBO_coords;
    g.glGenBuffers(1, &VBO_coords);
    g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
    g.glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    g.glEnableVertexAttribArray(0);

    // EBO
    GLuint VBO_indices;
    g.glGenBuffers(1, &VBO_indices);
    g.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, VBO_indices);
    g.glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    // Disable VAO
	g.glBindVertexArray(0);
}

// Funció per dibuixar la bounding box
void ObjectSelect::drawBoundingBox(GLWidget &g, const Box &box) {
    
    const Point &translate = box.min();
    const Point &scale = box.max() - box.min();
    programBox->bind();
    
    // Uniforms
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
    QMatrix4x4 TM;
    TM.translate(translate.x(), translate.y(), translate.z());
    TM.scale(scale.x(), scale.y(), scale.z());
    
    programBox->setUniformValue("modelViewProjectionMatrix", MVP);
    programBox->setUniformValue("normalMatrix",  NM);
    programBox->setUniformValue("transformMatrix", TM);
    // 2. Draw
    g.glBindVertexArray(VAO_box);
    g.glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
    // 3. Unbind VAO
    g.glBindVertexArray(0);
}

void ObjectSelect::postFrame()
{
    int selectedObject = scene()->selectedObject();
    if (selectedObject != -1) {
        GLWidget &g = *glwidget();
        g.makeCurrent();
        GLint prevPolygonMode;
        g.glGetIntegerv(GL_POLYGON_MODE, &prevPolygonMode);
        g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

        const Object &obj = scene()->objects()[selectedObject];
        drawBoundingBox(g, obj.boundingBox());

        g.glPolygonMode(GL_FRONT_AND_BACK, prevPolygonMode); // Restore previous mode
    }
}