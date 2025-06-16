# G-FIB
This repository contains GLSL programs using Qt and OpenGL from the graphics (G) course at FIB-UPC

## Content

- `S01`..`S13` Shaders and plugins, ordered from the 1st to the 13th session
- `C1` (First computer exam preparation)
- `C2` (Second computer exam preparation)
- `Extres` Some other exercises
- `Examens.pdf` (Final quizz preparation)

## Usage

To execute both shaders and plugins, you must have Qt >=5.15 installed as well as the `GLarena` viewer, which can be found in [Releases](https://github.com/nilhouses/G-FIB/releases).

After decompressing the viewer, it can be compiled with:

```bash
  qmake-qt5
  make -j
```

To execute it, you try shaders using the following command: 

```bash
  .{$VIEWER_PATH}/GLarenaSL
```

Plugins will be executed using:

```bash
  .{$VIEWER_PATH}/GLarenaPL
```