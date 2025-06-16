# Instruccions d'instal·lació (CAT)

El viewer (GLarena) es pot instal·lar en una màquina amb linux, windows i MacOs.

A. Instal.lació en Ubuntu (recomanada)
B. Instal.lació en Windows (via VirtualBox)
C. Instal.lació en MacOS (sense suport)

A. Instal.lació en Ubuntu
--------------------------------------

1. Instal.lar requeriments previs de Qt, OpenGL i GLU:

  sudo apt-get install build-essential libgl1-mesa-dev libglu1-mesa-dev

2. Descarregar Qt 5 o bé Qt 6

La darrera versió del viewer és compatible amb Qt5 (>=Qt5.15) i Qt6 (>=Qt6.7).

Recomanació:
  - Si ja teniu instal·lada Qt5.15, useu aquesta versió.
  - Si el vostre Ubuntu usa Wayland en comptes de X11 (ho podeu saber fent "echo $XDG_SESSION_TYPE"), millor useu Qt5.15 (sembla que un bug del Wayland amb Qt6 fa que sigui imprescindible que el FS escrigui fragments amb opacitat 1; altrament el resultat no serà l'esperat).
 - Si no teniu Qt, o bé el vostre Ubuntu no usa Wayland, podeu triar indistintament Qt5.15 o Qt6.7+.


  https://www.qt.io/download-open-source
  Qt online installer for linux (*)
  (*) Nota amb Qt5: és possible que necessiteu activar la casella "Archive" i tornar al filtrar per veure algunes versions de Qt5, veure figura adjunta.

3. Instal.lar Qt (canvieu el que calgui segons la versió que hagueu descarregat)

  chmod +x qt-unified-linux-x64-3.0.6-online.run sudo ./qt-unified-linux-x64-3.0.6-online.run

  Si en executar la comanda dona error per carregar les llibreries libxcb-xinerama0 o libxcb-cursor0, s'han d'instal·lar les dependències:

  sudo apt install libxcb-xinerama0 libxcb-cursor0

  Completar la instal.lació:
    Registrar-se i entrar amb un compte de Qt.
    Folder: /opt/Qt
    Components: seleccionar una versió a instal.lar (exemple: 5.15.1)

 Opcional: editar ~/.bashrc i afegir la linia (5.15.1 és un exemple)

       alias qmake-qt5='/opt/Qt/5.15.1/gcc_64/bin/qmake'

4. Descarregar i descomprimir la darrera versió del viewer.

  http://www.cs.upc.edu/~virtual/G/index.php?dir=2.%20Laboratori/viewer

  (ex. 2024-04-28/)
  tar -xzvf...

5. Descarregar models, textures i fitxers de test:

  http://www.cs.upc.edu/~virtual/G/index.php?dir=2.%20Laboratori/viewer/
   -> models.tgz
   -> tests.tgz
   -> Textures.tgz

 Descomprimir els fitxers anteriors (models, textures i tests), en els directoris

   /assig/grau-g/models
   /assig/grau-g/tests
   /assig/grau-g/Textures

o bé penjant de NewViewer_******:

   NewViewer_*******/models
   NewViewer_*******/tests
   NewViewer_*******/Textures

Nota: la versions més actualitzades dels models, tests i textures les podeu copiar (ex. tar) directament dels laboratoris de la FIB ~/assig/grau-g/{models, Textures, tests}

6. Compilar el viewer

  cd NewViewer_******* (el codi pot variar segons la versió)
  qmake6 o qmake-qt5 segons la versió
  make -j

7. Executar viewer

  ./GLarenaSL (per provar shaders; primera part del curs)
  ./GLarenaPL (per provar plugins; segona part del curs)

B. Instal.lació en Windows (via VirtualBox)
----------------------------------------------------------

1. Descarregar i instal.lar VirtualBox per windows hosts.   https://www.virtualbox.org/

2. Descarregar Ubuntu Desktop. Hem provat 17.04 però hauria de funcionar amb versions recents.
  https://www.ubuntu.com/download/desktop
   --> ubuntu-17.04-desktop-amd64.iso

3. Crear una màquina virtual (VirtualBox) amb aquests paràmetres; els [] només indiquen valors de referència:

  Tipus: Linux
  Versió: Ubuntu (64-bit)
  En algunes màquines pot ser necessari activar VT (Virtualization Technologies) a la BIOS per poder usar MVs de 64 bits.
  Memòria: >2 GB [8 GB]
  Disc dur: >25 GB [32 GB, VDI, dinàmic]

4. Configurar la resta de paràmetres de la MV:
  Pantalla: Habilitar aceleración 3D (proveu activar-ho, però depenent del vostre hardware ho haureu de desactivar, especialment a la segona part del curs)

5. Iniciar la màquina virtual. Quan demani el disc d'inici, caldrà indicar-li el ubuntu-17.04-desktop-amd64.iso En algunes màquines pot ser necessari activar VT (Virtualization Technologies) a la BIOS.

6. Seguir els passos per instal.lar Ubuntu a la màquina virtual:
Instal.la Ubuntu -> Descarrega actualitzacions; instal.la programari de tercers Esborra el disc i instal.la ubuntu (ei! a la màquina virtual!) Completar la instal.lació i re-iniciar la MV

7. Continuar amb els passos d'instal.lació en Ubuntu C.

C. Instal.lació en MacOS (sense suport per part del professorat)
----------------------------------------------------------------------------------
Requeriments:
* Qt 5 (l'hem provat amb Qt5.9) o Qt6
* Cal que el vostre mac suporti OpenGL 3.3 (almenys). Podeu comprovar si és el cas, sabent la targeta gràfica que teniu i la versió del SO, i consultant https://developer.apple.com/opengl/capabilities/

Instal·lació: El procediment és com en el cas de Linux, però hi ha algunes consideracions especials.

Quan completeu el qmake...make (ignoreu un warning en la compilació de glwidget.cpp), us haurà creat dins de NewViewer*****/viewer/bin una aplicació viewerd.app. Tanmateix, tingueu en compte que:

1. L'aplicació buscarà els plugins en un path relatiu a aquesta posició. Per tant, si moveu l'app a un altre lloc (a /Applications, per exemple), deixarà de trobar-los.

2. El binari tindrà uns valors definits per a variables d'entorn adequats per a un Mac, quan es compili a un Mac. En particular per defecte farà servir com a editor de shaders el /Applications/TextEditor.app, i per a veure imatges (textures, tests,...) farà servir /Applications/Preview.app.

3. Podeu definir altres aplicacions com en el cas de Linux. Per exemple amb export VEDITOR=/Applications/Xcode.app per a fer servir l'editor de l'Xcode pels shaders (molt més pesant, però us colorarà el codi...). Tanmateix, aquestes variables s'heretaran a l'entorn del procés (i per tant tindran efecte) SOLS si des del mateix terminal l'executeu, sigui fent open viewer/bin/viewerd.app o (millor) viewer/bin/viewerd.app/Contents/MacOS/viewerd Però NO si l'obriu amb doble click al finder!

4. la segona forma d'engegar un viewer al punt anterior us permetrà veure els missatges que aquest escrigui en stdout.

5. Amb les mateixes consideracions d'abans, podeu definir, com a la versió linux, una variable d'entorn VPLUGINS amb uns plugins que vulgueu carregar per defecte en arrancar el programa. Però recordeu que no heu de fer servir els noms ".so" sinó ".dylib":

export VPLUGINS="libdraw-vbo-ext.dylib;libshaderloader.dylib;libnavigatedefault.dylib" 

[Només per alguns Mac's] En alguns Mac's, en executar "Run test", surt un error indicant que les imatges a comparar tenen mides diferents. Una solució és editar plugins/shaderLoader/shaderLoader.cpp, buscar el fragment de codi:

        else if (cmd=="grab")
        {
            f >> s; 
           glwidget()->update();
           QImage img = g.grabFramebuffer();

i afegir després del grabFramebuffer() la línia:

    img = img.scaled(img.width()/2, img.height()/2);

(i després tornar a fer el make).
