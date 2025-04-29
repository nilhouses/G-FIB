#include "resaltat.h"
#include "glwidget.h"
#include <cstddef> // For offsetof

/*
Funcions privades usades

	configureShaders() // Compila i linka
	configureBox() //Seteja el VAO i VBOs
	drawBox() //Dibuixa la caixa
*/
void resaltat::configureShaders() // Compila i linka
{
	GLWidget &g = *glwidget();
	g.makeCurrent();

	bool ok = true;

	// VS
	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	ok = vs->compileSourceFile(g.getPluginPath() + "/../resaltat/resaltat.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	if (!ok) cout << "Error in VS " << endl;

	// FS
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	ok = fs->compileSourceFile(g.getPluginPath() + "/../resaltat/resaltat.frag");
	cout << "FS log:" << fs->log().toStdString() << endl;
	if (!ok) cout << "Error in FS " << endl;

	// Link
	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	ok = program->link();
	cout << "Link log:" << program->log().toStdString() << endl;
	if (!ok) cout << "Error linking shader program: " << endl;
}

void resaltat::configureBox(GLWidget &g) { // Seteja el VAO i VBOs
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

void resaltat::drawBox(GLWidget &g, const Box& box) {
	const Point &translate = box.min();
	const Point &scale = box.max() - box.min();
	program->bind();
	
	// Uniforms
	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
	QMatrix3x3 NM = camera()->viewMatrix().normalMatrix();
	QMatrix4x4 TM;
	TM.translate(translate.x(), translate.y(), translate.z());
	TM.scale(scale.x(), scale.y(), scale.z());
	
	program->setUniformValue("modelViewProjectionMatrix", MVP);
	program->setUniformValue("normalMatrix",  NM);
	program->setUniformValue("transformMatrix", TM);
	// 2. Draw
	g.glBindVertexArray(VAO_box);
	g.glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
	// 3. Unbind VAO
	g.glBindVertexArray(0);
}

void resaltat::onPluginLoad() //Prepara shaders que pinten la capsa
{
	GLWidget &g = *glwidget();
	g.makeCurrent();
	configureShaders();
}

void resaltat::postFrame() // Pinta la capsa de l'objecte seleccionat
{
	GLWidget &g = *glwidget();
	g.makeCurrent();

	int seleccionat = scene()->selectedObject();
	if (seleccionat == -1) return; // No hi ha cap objecte seleccionat
	else { // Pinta la capsa de l'objecte seleccionat

		GLint prevPolygonMode; 
		g.glGetIntegerv(GL_POLYGON_MODE, &prevPolygonMode); //guardar mode anterior

		g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);  //Aplicar línees

		Object &obj = g.scene()->objects()[seleccionat];
		configureBox(g);
		obj.computeBoundingBox();
		drawBox(g, obj.boundingBox());

		g.glPolygonMode(GL_FRONT_AND_BACK, prevPolygonMode); // Restaurar el mode anterior
	}
}

void resaltat::preFrame() //Selecciono l'últim objecte i printejo debug, NO ÉS NECESSARI
{
	//Ho forço perquè no seleccioni sempre el primer objecte
	qDebug() << "Selected object: " << scene()->selectedObject();
	if (scene()->selectedObject() != -1) scene()->setSelectedObject(scene()->objects().size() - 1);

}

void resaltat::onObjectAdd() { //Pinta l'objecte
	drawObject(glwidget()->scene()->objects().size() - 1);
}

bool resaltat::drawScene()
{
	return false; // return true only if implemented
}

bool resaltat::drawObject(int objectId)
{
	GLWidget &g = *glwidget();
	g.makeCurrent();

	const Object &obj = g.scene()->objects()[objectId];
	const vector<Face> &faces = obj.faces();
	const vector<Vertex> &vertices = obj.vertices();

	// Generate and bind VAO
	GLuint VAO, VBO, EBO;
	g.glGenVertexArrays(1, &VAO);
	g.glBindVertexArray(VAO);

	// Generate and bind VBO
	g.glGenBuffers(1, &VBO);
	g.glBindBuffer(GL_ARRAY_BUFFER, VBO);

	// Create a flat array of vertex coordinates
	vector<float> vertexCoords;
	for (const Vertex &v : vertices) {
		vertexCoords.push_back(v.coord().x());
		vertexCoords.push_back(v.coord().y());
		vertexCoords.push_back(v.coord().z());
	}
	g.glBufferData(GL_ARRAY_BUFFER, vertexCoords.size() * sizeof(float), vertexCoords.data(), GL_STATIC_DRAW);

	// Generate and bind EBO
	vector<GLuint> indices;
	for (const Face &face : faces) {
		for (int i = 0; i < face.numVertices(); ++i) {
			indices.push_back(face.vertexIndex(i));
		}
	}
	g.glGenBuffers(1, &EBO);
	g.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	g.glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(GLuint), indices.data(), GL_STATIC_DRAW);

	// Set vertex attribute pointers
	g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
	g.glEnableVertexAttribArray(0);

	// Draw the object
	g.glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);

	// Unbind VAO
	g.glBindVertexArray(0);

	// Cleanup
	g.glDeleteBuffers(1, &VBO);
	g.glDeleteBuffers(1, &EBO);
	g.glDeleteVertexArrays(1, &VAO);

	return true; // Indicate that the object was drawn
}

bool resaltat::paintGL()
{
	return false; // return true only if implemented
}

void resaltat::keyPressEvent(QKeyEvent *)
{
	
}

void resaltat::mouseMoveEvent(QMouseEvent *)
{
	
}
