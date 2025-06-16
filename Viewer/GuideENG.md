# Installation Instructions (EN)

The viewer (GLarena) can be installed on a Linux, Windows, or MacOS machine.

A. Installation on Ubuntu (recommended)  
B. Installation on Windows (via VirtualBox)  
C. Installation on MacOS (unsupported)

---

## A. Installation on Ubuntu
--------------------------------------

1. Install Qt, OpenGL, and GLU prerequisites:

    sudo apt-get install build-essential libgl1-mesa-dev libglu1-mesa-dev

2. Download Qt 5 or Qt 6

The latest viewer version is compatible with Qt5 (>= Qt5.15) and Qt6 (>= Qt6.7).

Recommendation:  
  - If you already have Qt5.15 installed, use it.  
  - If your Ubuntu uses Wayland instead of X11 (check with `echo $XDG_SESSION_TYPE`), it is better to use Qt5.15 (a Wayland bug with Qt6 requires the FS to write fragments with full opacity; otherwise, the result will not be correct).  
  - If you don’t have Qt, or your Ubuntu doesn’t use Wayland, you can choose either Qt5.15 or Qt6.7+.

    https://www.qt.io/download-open-source  
    Qt online installer for Linux (*)  
    (*) Note for Qt5: you may need to activate the "Archive" checkbox and filter again to see older Qt5 versions (see attached figure).

3. Install Qt (adapt as needed to your downloaded version):

    chmod +x qt-unified-linux-x64-3.0.6-online.run  
    sudo ./qt-unified-linux-x64-3.0.6-online.run

If running the command gives errors about missing libraries `libxcb-xinerama0` or `libxcb-cursor0`, install them:

    sudo apt install libxcb-xinerama0 libxcb-cursor0

Complete the installation:  
  - Register and log in with a Qt account  
  - Folder: /opt/Qt  
  - Components: select a version to install (e.g., 5.15.1)

Optional: edit `~/.bashrc` and add the line (5.15.1 is an example):

    alias qmake-qt5='/opt/Qt/5.15.1/gcc_64/bin/qmake'

4. Download and extract the latest version of the viewer:

    http://www.cs.upc.edu/~virtual/G/index.php?dir=2.%20Laboratori/viewer  
    (e.g., 2024-04-28/)  
    tar -xzvf...

5. Download models, textures, and test files:

    http://www.cs.upc.edu/~virtual/G/index.php?dir=2.%20Laboratori/viewer/  
     -> models.tgz  
     -> tests.tgz  
     -> Textures.tgz

Extract the above files (models, textures, tests) into the directories:

    /assig/grau-g/models  
    /assig/grau-g/tests  
    /assig/grau-g/Textures

or inside the viewer folder:

    NewViewer_*******/models  
    NewViewer_*******/tests  
    NewViewer_*******/Textures

Note: The most updated versions of models, tests, and textures can be copied (e.g., via tar) directly from the FIB lab at `~/assig/grau-g/{models, Textures, tests}`

6. Compile the viewer

    cd NewViewer_******* (name varies by version)  
    qmake6 or qmake-qt5 depending on the version  
    make -j

7. Run viewer

    ./GLarenaSL (for testing shaders; first part of the course)  
    ./GLarenaPL (for testing plugins; second part of the course)

---

## B. Installation on Windows (via VirtualBox)
----------------------------------------------------------

1. Download and install VirtualBox for Windows hosts:  
    https://www.virtualbox.org/

2. Download Ubuntu Desktop. Tested with 17.04, but newer versions should work:  
    https://www.ubuntu.com/download/desktop  
     -> ubuntu-17.04-desktop-amd64.iso

3. Create a Virtual Machine (VM) in VirtualBox with the following settings (values in [] are suggestions):

    Type: Linux  
    Version: Ubuntu (64-bit)  
    [Some machines may require enabling VT (Virtualization Technologies) in BIOS to use 64-bit VMs.]  
    RAM: >2 GB [8 GB]  
    Hard disk: >25 GB [32 GB, VDI, dynamically allocated]

4. Configure the rest of the VM:  
    Display: Enable 3D acceleration (try enabling it, but depending on your hardware, it may need to be disabled, especially for the second part of the course)

5. Start the VM. When prompted for the startup disk, select the `ubuntu-17.04-desktop-amd64.iso`.  
   [Again, VT may need to be enabled in BIOS.]

6. Follow the steps to install Ubuntu in the VM:  
   - Install Ubuntu  
   - Download updates; install third-party software  
   - Erase disk and install Ubuntu (make sure this is the virtual machine!)  
   - Complete installation and reboot the VM

7. Continue with the Ubuntu installation steps (section A).

---

## C. Installation on MacOS (unsupported by instructors)
----------------------------------------------------------------------------------
Requirements:  
* Qt 5 (tested with Qt5.9) or Qt6  
* Your Mac must support OpenGL 3.3 (at least). You can check based on your GPU and macOS version at: https://developer.apple.com/opengl/capabilities/

Installation: Similar to Linux, but with some special considerations.

After completing `qmake ... make` (ignore a warning compiling glwidget.cpp), it will create inside `NewViewer*****/viewer/bin` an app called `viewerd.app`. However, keep in mind:

1. The app will look for plugins in a relative path from that location. So if you move the app elsewhere (like `/Applications`), it won’t find them.

2. The binary will have environment variables suitable for macOS. By default, it will use `/Applications/TextEditor.app` as shader editor, and `/Applications/Preview.app` for images (textures, tests...).

3. You can define other applications like in Linux. For example, to use Xcode as the shader editor (heavier, but has syntax coloring):

    export VEDITOR=/Applications/Xcode.app

   However, these variables will only take effect **if you launch the app from the same terminal**, either using:

    open viewer/bin/viewerd.app  
    or better:  
    viewer/bin/viewerd.app/Contents/MacOS/viewerd

   But **not** if you launch it via double-click in Finder!

4. The second way above allows you to see the messages the app writes to stdout.

5. Similarly, you can define, like in Linux, an environment variable `VPLUGINS` with default plugins to load on startup. But remember to use `.dylib` (not `.so`) extensions:

    export VPLUGINS="libdraw-vbo-ext.dylib;libshaderloader.dylib;libnavigatedefault.dylib"

[Mac-specific issue] On some Macs, when running "Run test", an error appears indicating that the images to compare have different sizes. One solution is to edit `plugins/shaderLoader/shaderLoader.cpp`, find the code:

        else if (cmd=="grab")
        {
            f >> s; 
           glwidget()->update();
           QImage img = g.grabFramebuffer();

and add after `grabFramebuffer()` the line:

    img = img.scaled(img.width()/2, img.height()/2);

(then recompile with `make`).