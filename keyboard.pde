//*********************************
//*********************************
void keyPressed()
{
  // Toggle selection
  if (keyCode==114) // F3
  {
    //aSelection = !aSelection;
    //cbSELECT.s = aSelection;
    if ((x1sel == x2sel) || (y1sel == y2sel)) { aSelection = false; }
    else { aSelection = !aSelection; }
    cbSELECT.s = aSelection;
  }

  // Toggle stencil
  if (keyCode==115) // F4
  {
    stencil = !stencil;
    cbSTENCIL.s = stencil;
  }

  // draw palette on active layer from brushCol to oldCol (the colors on rgbhsb tool)
  if ((key=='j') || (key=='J'))
  {
    int x0 = mouseX;
    int y0 = mouseY;
    float step = 0.1;
    color c;
    color toCol = rgbhsb.oldCol;
    // store layer for undo
    storeUNDO();
    // draw palette from brushCol to oldCol
    livelli[activeLyr].pg.beginDraw();
    for(int i=0; i<11; i++)
    {
      c = lerpColor(brushCol, toCol, i*step);
      livelli[activeLyr].pg.fill(c);
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.rect(x0+22*i,y0,20,20);
    }
    livelli[activeLyr].pg.endDraw();
    // update swatch of current layer
    livelli[activeLyr].updateLayerSwatch();
  }

  // MENU on/off
  if (key==' ')
  {
    toolHSB = !toolHSB;
  }

  // Layer GUI on/off
  if (key=='.')
  {
    showLayerGUI = !showLayerGUI;
  }

  // color palette
  if (keyCode==TAB)
  {
    menu = !menu;
  }

  // POINTER COLOR: white <--> black
  if (keyCode==ESC)
  {
    key = 0;
    if (pointerCol == white) { pointerCol = black; }
    else { pointerCol = white; }
  }

  // OPEN HELP
  if (keyCode==112) // F1
  {
    launch(dataPath("LAYERS.PDF"));
  }

  if (keyCode==113) // F2
  {
    if (onTop)
    {
      surface.setAlwaysOnTop(false);
      onTop = false;
    }
    else
    {
     surface.setAlwaysOnTop(true);
      onTop = true;
    }
  }

  // SELECT TOOL
  // select Stamp tool
  if ((key=='t') || (key =='T'))  { selectTool("Stamp"); }
  // select Pencil tool
  if ((key=='p') || (key =='P'))  { selectTool("Pencil"); }
  // select Liner tool
  if ((key=='l') || (key =='L'))  { selectTool("Liner"); }
  // select Quad tool
  if ((key=='q') || (key =='Q'))  { selectTool("Quad"); }
  // select Quad tool
  if ((key=='c') || (key =='C'))  { selectTool("Circle"); }
  // select Eraser tool
  if ((key=='e') || (key =='E'))  { selectTool("Eraser"); }
  // select Vernice tool
  if ((key=='v') || (key =='V'))  { selectTool("Vernice"); }
  // select Ink tool
  if ((key=='i') || (key =='I'))  { selectTool("Ink"); }
  // select Dyna tool
  if ((key=='d') || (key =='D'))  { selectTool("Dyna"); }
  // select Filler tool
  if ((key=='f') || (key =='F'))  { selectTool("Filler"); }
  // select Mixer tool
  if ((key=='m') || (key =='M'))  { selectTool("Mixer"); }
  // select Clone tool
  if ((key=='n') || (key =='N'))  { selectTool("Clone"); }
  // select Web tool
  if ((key=='b') || (key =='B'))  { selectTool("Web"); }
  // select Select tool
  if (key=='0') { selectTool("Select"); }
  // select Stencil tool
  if (key=='9') { selectTool("Stencil"); }

  // set grid on/off
  if ((key=='w') || (key=='W'))
  {
    grid = !grid;
    cbGRID.s = grid;
  }
  // brushSize +/-
  if (key=='[')
  {
    brushSize = constrain(--brushSize, brushSizeMin, brushSizeMax);
    slSIZE.v = brushSize;
  }
  if (key==']')
  {
    brushSize = constrain(++brushSize, brushSizeMin, brushSizeMax);
    slSIZE.v = brushSize;
  }
  // Zoom or Alpha +/-
  if (key=='+')
  {
    if (zoom)
    { magnify = constrain(++magnify, 2, 32); }
    else
    {
      alfa = constrain(++alfa,1,255);
      slALFA.v = alfa; // update ALFA slider
      //brushCol = color(red(brushCol),green(brushCol),blue(brushCol),alfa);
      brushCol = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, alfa);
    }
  }
  if (key=='-')
  {
    if (zoom)
    { magnify = constrain(--magnify, 2, 32); }
    else
    {
      alfa = constrain(--alfa,1,255);
      slALFA.v = alfa; // update ALFA slider
      brushCol = color(red(brushCol),green(brushCol),blue(brushCol),alfa);
      //brushCol = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, alfa);
    }
  }

  // toggle antialiasing glitch
  if ((key=='a') || (key=='A'))
  {
    noGlitch = !noGlitch;
    cbGLITCH.s = noGlitch;
  }

  // redo
  if ((key=='r') || (key=='R'))
  {
    redo();
  }
  // undo
  if ((key=='u') || (key=='U'))
  {
    undo();
  }

  // zoom on/off
  if ((key=='z') || (key=='Z'))
  {
    zoom = !zoom;
  }

  // X mirror
  if ((key=='x') || (key=='X'))
  {
    symX = !symX;
    cbSYMX.s = symX;
  }

  // Y mirror
  if ((key=='y') || (key=='Y'))
  {
    symY = !symY;
    cbSYMY.s = symY;
  }

  // move active layer UP
  if (keyCode == UP)
  {
    if (stencil && aSelection)
    {
      if (tool == "Stencil") { ysten--; }
      else if (tool == "Select") { y1sel--; y2sel--; }
      else { y1sel--; y2sel--; }
    }
    else if (stencil) { ysten--; }
    else if (aSelection) { y1sel--; y2sel--; }
    else if ((menu) && (activeLyr != 0))
    {
      swapLayers(activeLyr,activeLyr-1);
      activeLyr = activeLyr - 1;
    }
  }
  // move active layer DOWN
  if (keyCode == DOWN)
  {
    if (stencil && aSelection)
    {
      if (tool == "Stencil") { ysten++; }
      else if (tool == "Select") { y1sel++; y2sel++; }
      else { y1sel++; y2sel++; }
    }
    else if (stencil) { ysten++; }
    else if (aSelection) { y1sel++; y2sel++; }
    else if ((menu) && (activeLyr != numLayers-1))
    {
      // move current layer down
      swapLayers(activeLyr,activeLyr+1);
      activeLyr = activeLyr + 1;
    }
  }

  // previous palette page
  if (keyCode == LEFT)
  {
    if (stencil && aSelection)
    {
      if (tool == "Stencil") { xsten--; }
      else if (tool == "Select") { x1sel--; x2sel--; }
      else { x1sel--; x2sel--; }
    }
    else if (stencil) { xsten--; }
    else if (aSelection) { x1sel--; x2sel--; }
    else if (menu)
    {
      // move current layer up
      activePalettePage = constrain(--activePalettePage,0,12);
    }
  }
  // next palette page
  if (keyCode == RIGHT)
  {
    if (stencil && aSelection)
    {
      if (tool == "Stencil") { xsten++; }
      else if (tool == "Select") { x1sel++; x2sel++; }
      else { x1sel++; x2sel++; }
    }
    else if (stencil) { xsten++; }
    else if (aSelection) { x1sel++; x2sel++; }
    else if (menu)
    {
      activePalettePage = constrain(++activePalettePage,0,12);
    }
  }

  // clear current layer or current selection
  if (key==BACKSPACE)
  {
      // store layer for undo
      storeUNDO();
      if (aSelection)
      {
        //x1sel = constrain(x1sel, 0, width-1);
        //y1sel = constrain(y1sel, 0, height-1);
        //x2sel = constrain(x2sel, 0, width-1);
        //y2sel = constrain(y2sel, 0, height-1);
        // delete pixels inside selection
        //int xmin = (x1sel > x2sel) ? x2sel : x1sel;
        //int xmax = (x2sel > x1sel) ? x2sel : x1sel;
        //int ymin = (y1sel > y2sel) ? y2sel : y1sel;
        //int ymax = (y2sel > y1sel) ? y2sel : y1sel;
        
        int xmin = x1sel+1;
        int xmax = x2sel-1;
        int ymin = y1sel+1;
        int ymax = y2sel-1;
        int loc = 0;
        livelli[activeLyr].pg.beginDraw();
        livelli[activeLyr].pg.loadPixels();
        for (int x = xmin; x <= xmax; x++)
        {
          for (int y = ymin; y <= ymax; y++)
          {
            loc = x + y*width;
            livelli[activeLyr].pg.pixels[loc] = 0X0;
          }
        }
        livelli[activeLyr].pg.updatePixels();
        livelli[activeLyr].pg.endDraw();
      }
      else // delete entire canvas of active layer
      {
        livelli[activeLyr].delete();
      }

      // update swatch of current layer
      livelli[activeLyr].updateLayerSwatch();
  }

  // highlight cursor
  if (key=='h')
  {
    highlightCursor = !highlightCursor;
  }

  // Activate a layer (1..numLayers)
  if ((key > '0') && (key <= (char) (numLayers+48)))
  {
    livelli[activeLyr].la = false;
    activeLyr = key - 49;
    livelli[activeLyr].la = true;
    livelli[activeLyr].lv = true;  // set layer active --> visible
    // update swatch of current layer
    livelli[activeLyr].updateLayerSwatch(); // turn on the first time :)
  }

  // set random DynaDraw parameters
  if (key=='8')
  {
    if (tool == "Dyna")
    {
      myDD.preset08();
      setDynaSlider(8);
    }
  }

  // show a dialog window to open an image file as layer
  if (key=='o'||key=='O')
  {
    selectFolderOpenDialog();
  }

  // save image
  if (key=='s'||key=='S')
  {
    selectFolderSaveDialog();
  }

  // force to draw square and circle
  if (key=='k'||key=='K')
  {
    quadLock = !quadLock;
    circleLock = !circleLock;
    btnLOCK.s = !btnLOCK.s;
  }

  // snap to grid
  if (key=='g'||key=='G')
  {
    snap2Grid = !snap2Grid;
    cbSNAP.s = !cbSNAP.s;
  }

  // test key
  if (key==';')
  {
    //invertStencil();
    //color c = livelli[activeLyr].pg.get(mouseX,mouseY);
    //println(c);
    //println(red(c),green(c),blue(c),alpha(c));
    //println(brushCol);
    //println(red(brushCol),green(brushCol),blue(brushCol),alpha(brushCol));
    //println(pts.size());
    //println(dataPath("LAYERS.PDF"));
    //println(cobweb.size());
    //println("pointsW = ", pointsW);
    //println("eraseW = ", eraseW);
    //println("tool = ",tool);

    //String lista="", riga="";
    //// get data from griglia matrix
    //if (cobweb.size() > 0)
    //{
    //  for (int p=0; p < cobweb.size(); p++)
    //  {
    //    PVector v = cobweb.get(p);
    //    riga = str((int)v.x) + "," + str((int)v.y) + "\n";
    //    lista=lista+riga;
    //  }
    //  String[] outTXT = split(lista, "\n");
    //  saveStrings(dataPath("cobweb.web"), outTXT);
    //}
    //createStencil();
    //createStencilFromSelection();
    pastePixels();
  }

  if (key==',')
  {
    //String lista[] = loadStrings(dataPath("cobweb.web"));
    //cobweb.clear();
    //int numPoints = lista.length - 1;
    //println(numPoints);
    //for (int i=0; i < numPoints; i++)
    //{
    //  String[] punto = split(lista[i], ",");
    //  int x = int(punto[0]);
    //  int y = int(punto[1]);
    //  PVector v = new PVector(x, y, 0);
    //  cobweb.add(0, v);
    //}
    //println(cobweb.size());
    //updateWeb = true;
    //int pick = stencilIMG.get(mouseX,mouseY*stencilIMG.width));
    //int a = stencilIMG.get(mouseX-xsten,mouseY-ysten);
    //println(mouseX, mouseY, a);
    //stencil = !stencil;
    copyPixels();
  }
  
}

//*********************************
void keyReleased()
{
  picker = false;
  if (startAction) // started an action who modify the active layer
  {
    startAction = false;
    // reset redo
    for( int i=0; i< numRedo; i++)
    { redoLyr[i] = -1; }
  }

  // update undo/redo button
  if (undoLyr[0] == -1) { btnUNDO.s = false; }
  else { btnUNDO.s = true; }
  if (redoLyr[0] == -1) { btnREDO.s = false; }
  else { btnREDO.s = true; }

  keyPressed = false; // per sicurezza
}