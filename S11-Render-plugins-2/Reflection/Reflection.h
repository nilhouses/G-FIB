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

#ifndef _REFLECTION_H
#define _REFLECTION_H

#include "plugin.h"
#include <QCoreApplication>
#include <QOpenGLShader>
#include <QOpenGLShaderProgram>


class Reflection : public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin")   
	Q_INTERFACES(Plugin)

	public:
		void onPluginLoad();
		bool paintGL();

	private:
		void createMirror();
		void drawMirror();
		QMatrix4x4 reflectionMatrix(float a, float b, float c, float d);
		QOpenGLShaderProgram * program;
		QOpenGLShader * vs, * fs;  
		GLuint textureId, mirrorId;
 };
 
 #endif
