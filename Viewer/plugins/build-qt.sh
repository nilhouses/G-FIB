#!/bin/bash

# Ruta del codi font de Qt
QT_SRC_DIR=~/qt-everywhere-src-5.15.2

# Ruta d'instal·lació final
QT_INSTALL_DIR=~/Qt/5.15.2

# Exporta GCC 11
export CC=/usr/bin/gcc-11
export CXX=/usr/bin/g++-11

# Assegura't que el compilador correcte s'està utilitzant
echo "Compilador CC: $CC"
echo "Compilador CXX: $CXX"

# Afegeix includes que falten (com <limits>) si calgués
# (només cal fer-ho un cop a mà si hi ha errors com el de numeric_limits)

cd "$QT_SRC_DIR"

# Configura Qt sense especificar el mkspec
./configure -prefix "$QT_INSTALL_DIR" -opensource -confirm-license -nomake tests -nomake examples

# Compila amb tots els cores disponibles
make -j"$(nproc)"
