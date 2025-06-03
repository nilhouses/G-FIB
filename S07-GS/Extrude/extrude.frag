#version 330 core

in vec3 NES;
out vec4 fragColor;

void main() {
    fragColor = vec4(vec3(normalize(NES).z), 1);
}

