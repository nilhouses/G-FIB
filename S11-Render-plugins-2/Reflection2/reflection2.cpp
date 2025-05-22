#include "reflection2.h"
#include <QCoreApplication>
#include <cmath>

const int IMAGE_WIDTH = 512;
const int IMAGE_HEIGHT = IMAGE_WIDTH;

void Reflection2::createMirrors() {
    GLWidget & g = *glwidget();
    g.makeCurrent();

    GLuint VBO[3];
    const Point & min = g.scene()->boundingBox().min();
    const Point & max = g.scene()->boundingBox().max();

    float coords[3][12] = {
        // Mirall 0 -> y = min.y() 
        { min.x(), min.y(), min.z(),  max.x(), min.y(), min.z(),
          min.x(), min.y(), max.z(),  max.x(), min.y(), max.z() },
        // Mirall 1 -> z = min.z()
        { min.x(), min.y(), min.z(),  max.x(), min.y(), min.z(),
          min.x(), max.y(), min.z(),  max.x(), max.y(), min.z() },
        // Mirror 2 -> x = min.x()
        { min.x(), min.y(), min.z(),  min.x(), min.y(), max.z(),
          min.x(), max.y(), min.z(),  min.x(), max.y(), max.z() }
    };

    g.glGenVertexArrays(3, mirrorId); //Genera VAOs i els guarda a mirrorId
    g.glGenBuffers(3, VBO); //Genera VBOs i els guarda a VBO

    // Per cada mirall:
    for (int i = 0; i < 3; ++i) {
        g.glBindVertexArray(mirrorId[i]);            // Assigna VAO
        g.glBindBuffer(GL_ARRAY_BUFFER, VBO[i]);     // Assigna VBO 
        g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords[i]), coords[i], GL_STATIC_DRAW); //Passa vertexs  mirall al buffer de la GPU
        g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0); // Interpreta les dades del buffer per  posició (layout location 0)
        g.glEnableVertexAttribArray(0);              // Enable vertex attribute array
        g.glBindVertexArray(0);                      // Desactiva VAO
    }
}

void Reflection2::onPluginLoad()
{
    GLWidget & g = *glwidget();
    g.makeCurrent();
    // Carregar shader, compile & link
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile(g.getPluginPath()+"/../reflection2/Reflection.vert");

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile(g.getPluginPath()+"/../reflection2/Reflection.frag");

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();

    //Setup texture (mirall)
    g.glActiveTexture(GL_TEXTURE0);
    g.glGenTextures(3, textureId); // -> Guardem a textureId l'id de les textures creades

    for (int i = 0; i < 3; ++i) {
        g.glBindTexture(GL_TEXTURE_2D, textureId[i]);
        g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); //GL_REPEAT si volguessim repetir
        g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
        g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, IMAGE_WIDTH, IMAGE_HEIGHT, 0, GL_RGB, GL_FLOAT, NULL); //sense mapa de buts (NULL) configura la textura sense contingut
    }
    g.glBindTexture(GL_TEXTURE_2D, 0);
    // Resize viewport
    g.resize(IMAGE_WIDTH, IMAGE_HEIGHT); // Finestra de 512x512 pixels

    createMirrors();
}

QMatrix4x4 Reflection2::reflectionMatrix(float a, float b, float c, float d) {
    return QMatrix4x4(
        1 - 2 * pow(a, 2), -2 * a * b, -2 * a * c, -2 * a * d,
        -2 * a * b, 1 - 2 * pow(b, 2),   -2 * b * c, -2 * b * d,
        -2 * a * c,   -2 * b * c, 1 - 2 * pow(c, 2), -2 * c * d,
        0, 0, 0, 1
    );
}

void Reflection2::drawMirror(GLuint VAO) //mirall reflectit a partir de la textura
{
    GLWidget & g = *glwidget();
    g.makeCurrent();
    g.glBindVertexArray(VAO);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    g.glBindVertexArray(0);
}

bool Reflection2::paintGL()
{
    GLWidget & g = *glwidget();
    g.makeCurrent();

    program->bind();
    program->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());

    // Estructura que representa els plans dels miralls
    struct MirrorPlane {
        float a, b, c, d;
    };
    // ------------------------------------------------------------------
    // FASE 1. Dibuixar l'escena reflectida respecte el pla del mirall.
    //         Guardar la imatge resultant en una textura
    // ------------------------------------------------------------------
    const Point & min = g.scene()->boundingBox().min();
    const Point & max = g.scene()->boundingBox().max();
    MirrorPlane planes[3] = {
        {0, -1, 0, min.y()}, // y = min.y()
        {0, 0, -1, min.z()}, // z = min.z()
        {-1, 0, 0, min.x()}  // x = min.x()
    };

    // Guardar a la textura l'imatge de l'escena reflectida
    for (int i = 0; i < 3; ++i) {
        program->setUniformValue("mirror", false);
        g.glClearColor(1, 1, 1, 0);
        g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

        // Apliquem la matriu de reflecxió respecte al pla y = minY
        program->setUniformValue("reflectionMatrix", reflectionMatrix(planes[i].a, planes[i].b, planes[i].c, planes[i].d));
        //Dibuixem l'escena reflectida
        if (drawPlugin()) drawPlugin()->drawScene();

        // Copiem el contingut del framebuffer a la textura
        g.glBindTexture(GL_TEXTURE_2D, textureId[i]);
        g.glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
        g.glGenerateMipmap(GL_TEXTURE_2D);
    }

    // ------------------------------------------------------------------
    // FASE 2. Esborrar el framebuffer i dibuixar l'escena en la posició real.
    // ------------------------------------------------------------------
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    program->setUniformValue("reflectionMatrix", QMatrix4x4());
    if (drawPlugin()) drawPlugin()->drawScene();

    // ------------------------------------------------------------------
    // FASE 3. Dibuixar el quad del mirall, texturat amb la textura del primer pas.
    // ------------------------------------------------------------------
    for (int i = 0; i < 3; ++i) {
        g.glBindTexture(GL_TEXTURE_2D, textureId[i]);
        program->setUniformValue("colorMap", 0);// Textura a usar
        program->setUniformValue("size", QVector2D(float(IMAGE_WIDTH), float(IMAGE_HEIGHT)));
        program->setUniformValue("mirror", true); // Activa mode mirall al shader
        drawMirror(mirrorId[i]); // Mirall reflectit
    }

    g.glBindTexture(GL_TEXTURE_2D, 0); // Desactivem la textura
    g.defaultProgram()->bind(); // Torenm al shader per defecte

    return true;
}
