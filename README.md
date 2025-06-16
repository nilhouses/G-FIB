# G-FIB

This repository contains GLSL shaders and plugins developed using Qt and OpenGL for the Graphics ("G") course at FIB-UPC.

## Contents

- `S01` to `S13`: Shaders and plugins organized by session
- `C1`: First lab exams
- `C2`: Second lab exams
- `Extres`: Extra exercises
- `Final`: Final exam preparation

## Usage

### Installation

To use both shaders and plugins, you must have Qt >= 5.15 installed, as well as the `GLarena` viewer. You have two options:

#### Option 1: Pre-packaged version

Download the pre-configured version I used, which includes all necessary textures and models.  
You can find it under [Releases](https://github.com/nilhouses/G-FIB/releases).

After extracting the viewer, compile it with:

```bash
qmake-qt5
make -j
```

#### Option 2: Clone from ViRVIG

Alternatively, you can clone the official viewer from the [ViRVIG](https://www.virvig.eu/) (Visualization, Virtual Reality, and Graphics Interaction) research group:

```bash
git clone https://gitrepos.virvig.eu/docencia/newviewer
cd newviewer
qmake
make -j
```

### Execution
To launch the viewer for shader development, run:

```bash
  .{$VIEWER_PATH}/GLarenaSL
```

To run with plugins, use:

```bash
  .{$VIEWER_PATH}/GLarenaPL
```

Make sure to replace `{$VIEWER_PATH}` with the actual path to your compiled viewer binary.

## License

This project is licensed under the [MIT License](https://opensource.org/license/mit/).

© 2025 Nil Casas Duatis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is provided to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The Software is provided without any warranty of any kind, either express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the Software or the use or other dealings in the Software.


