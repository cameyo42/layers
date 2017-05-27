//*********************************
// OPEN SHAPE
void openShapeDialog()
{
  noLoop();
  selectInput("Select a file SVG...", "loadShape");
}

//*********************************
void loadShape(File selection)
{
  if (selection == null) { println("No file selected."); }
  else
  {
    // get filename with full path: (c:\demo\draw.png)
    filename=selection.getAbsolutePath();
    // extract only filename (without ext)
    name = selection.getName();
    int pos = name.lastIndexOf(".");
    if (pos > 0) { name = name.substring(0, pos); }
    dummyFile = new File(selection.getName());
    loadingShape = true; // call openShape() from draw()
    //println(filename, name);
  }
  keyPressed = false; // needed !!
  mousePressed = false;
  loop();
}

//*********************************
void openShape()
{
  loadingShape = false;
  aShape = loadShape(filename);
  sbSHtype.v = 5;
  cbSHstyle.s = true;
  aShape.enableStyle(); // use SVG style
}

//*********************************
// OPEN STENCIL
void openStencilDialog()
{
  noLoop();
  selectInput("Select a file...", "loadStencil");
}
//*********************************
void loadStencil(File selection)
{
  if (selection == null) { println("No file selected."); }
  else
  {
    // get filename with full path: (c:\demo\draw.png)
    filename=selection.getAbsolutePath();
    // extract only filename (without ext)
    name = selection.getName();
    int pos = name.lastIndexOf(".");
    if (pos > 0) { name = name.substring(0, pos); }
    dummyFile = new File(selection.getName());
    loadingStencil = true; // call openStencil() from draw()
    //println(filename, name);
  }
  keyPressed = false; // needed !!
  mousePressed = false;
  loop();
}

//*********************************
void openStencil()
{
  loadingStencil = false;
  stencilIMG = loadImage(filename);
  ysten = height/2 - stencilIMG.height/2;
  xsten = width/2 - stencilIMG.width/2;
  stencil = true;
}

//*********************************
// OPEN LAYER
void openLayerDialog()
{
  noLoop();
  selectInput("Select a file...", "loadLayer");
}
//*********************************
void loadLayer(File selection)
{
  if (selection == null) { println("No file selected."); }
  else
  {
    // get filename with full path: (c:\demo\draw.png)
    filename=selection.getAbsolutePath();
    // extract only filename (without ext)
    name = selection.getName();
    int pos = name.lastIndexOf(".");
    if (pos > 0) { name = name.substring(0, pos); }
    dummyFile = new File(selection.getName());
    loadingLayer = true; // call openLayer() from draw()
    //println(filename, name);
  }
  keyPressed = false; // needed !!
  mousePressed = false;
  loop();
}
//*********************************
void openLayer()
{
  loadingLayer = false;
  PImage myLayer = loadImage(filename);
  // store layer for undo
  storeUNDO();
  //copyIMG2PG(myLayer, livelli[activeLyr].pg);
  livelli[activeLyr].pg.beginDraw();
  livelli[activeLyr].pg.imageMode(CENTER);
  livelli[activeLyr].pg.image(myLayer,width/2,height/2);
  livelli[activeLyr].pg.imageMode(CORNER);
  livelli[activeLyr].pg.endDraw();
  livelli[activeLyr].ln = name;  // update layer name
  livelli[activeLyr].updateLayerSwatch();  // update layer swatch
}

//*********************************
// OPEN DRAW
void selectFolderOpenDialog()
{
  noLoop();
  selectFolder("Select the folder draw to OPEN...", "folderOpenSelected", dummyFolder);
}
//*********************************
void folderOpenSelected(File selection)
{
  if (selection == null) { println("No folder selected."); }
  else
  {
    folder = selection.getAbsolutePath();
    dummyFolder = new File(selection.getAbsolutePath());
    filename = folder;
    //println("Folder selected " + folder);
    // set filename as folder name (not complete path)
    int pos = filename.lastIndexOf(folderSep);
    if (pos > 0) { filename = filename.substring(pos+1, filename.length()); }
    //println("Filename: " + filename);
    //println("Open file: " + folder + folderSep + filename + ".txt");
    // open layers
    loadingDraw = true; // call openDrawFromFolder() from draw()
  }
  keyPressed = false; // needed !!
  mousePressed = false;
  loop();
}

//*********************************
void openDrawFromFolder()
{
  loadingDraw = false;
  if (fileExists(folder + folderSep + filename + ".txt"))
  {
    String listLyrs[] = loadStrings(folder + folderSep + filename + ".txt");
    //println("There are " + listLyrs.length + " layers");
    //for (int i = 0 ; i < listLyrs.length; i++)
    //{ println(listLyrs[i]); }

    // open layers
    for(int i=0; i<listLyrs.length; i++)
    {
      String fileLyr = folder + folderSep + listLyrs[i];
      //println(fileLyr);
      if (fileExists(fileLyr))
      {
        if (listLyrs[i].length() > 0)
        {
          //println(listLyrs[i],listLyrs[i].length());
          PImage myLayer = loadImage(fileLyr);
          // store layer for undo
          //storeUNDO();
          copyIMG2PG(myLayer, livelli[i].pg);
          int pos = listLyrs[i].lastIndexOf(".");
          if (pos > 0) { listLyrs[i] = listLyrs[i].substring(0, pos); }
          livelli[i].ln = listLyrs[i];  // update layer name
          livelli[i].lv = true;  // set layer visible
          livelli[i].updateLayerSwatch();  // update layer swatch
        }
      }
      else
      {
        println("Layer " + folder + folderSep + listLyrs[i] + " not found.");
      }
    }
    resetUNDO_REDO();
  }
  else
  {
    println("File " + folder + folderSep + filename + ".txt" + " not found.");
  }
  // open cobweb point file
  if (fileExists(folder + folderSep + filename + ".web"))
  {
    String lista[] = loadStrings(folder + folderSep + filename + ".web");
    cobweb.clear();
    int numPoints = lista.length - 1;
    println(numPoints);
    for (int i=0; i < numPoints; i++)
    {
      String[] punto = split(lista[i], ",");
      int x = int(punto[0]);
      int y = int(punto[1]);
      PVector v = new PVector(x, y, 0);
      cobweb.add(0, v);
    }
    println(cobweb.size());
    updateWeb = true;
  }
}

//*********************************
// SAVE DRAW
void selectFolderSaveDialog()
{
  noLoop();
  selectFolder("Select the folder draw to SAVE...", "folderSaveSelected", dummyFolder);
}
//*********************************
void folderSaveSelected(File selection)
{
  if (selection == null) { println("No folder selected."); }
  else
  {
    cursor(WAIT);
    folder = selection.getAbsolutePath();
    dummyFolder = new File(selection.getAbsolutePath());
    filename = folder;
    //println("Folder selected " + folder);
    // set filename as folder name (not complete path)
    int pos = filename.lastIndexOf(folderSep);
    if (pos > 0) { filename = filename.substring(pos+1, filename.length()); }
    //println("Filename: " + filename);
    //println("Save file: " + folder + folderSep + filename);
    // save Draw;
    saveDrawOnFolder();
    noCursor();
  }
  keyPressed = false; // needed !!
  mousePressed = false;
  loop();
}

//*********************************
void saveDrawOnFolder()
{
  //cursor(WAIT);
  String layersStr = "";
  PGraphics outLYR = createGraphics(width, height);
  outLYR.beginDraw();
  outLYR.clear();
  outLYR.noStroke();
  outLYR.fill(backCol);
  outLYR.rect(0,0,width,height);
  for(int i=numLayers-1; i>=0; i--)
  {
    if (livelli[i].lv)
    {
      if (livelli[i].lt != 255)
      {
        outLYR.tint(255,livelli[i].lt); // transparency
      }
      else
      {
        outLYR.noTint();
      }
      outLYR.image(livelli[i].pg,0,0);
    }
  }
  outLYR.endDraw();
  // save a single file with all layers (flatten layers)
  outLYR.save(folder + folderSep + filename + ".png");
  // save all layers as separate files
  for(int i=0; i<numLayers; i++)
  {
    if (livelli[i].lv)
    {
      livelli[i].pg.save(folder + folderSep + livelli[i].ln + ".png");
      if (i==0) { layersStr = layersStr + livelli[i].ln + ".png"; }
      else { layersStr = layersStr + "|" + livelli[i].ln + ".png"; }
    }
  }
  //println(layersStr);
  // save cobweb points
  if (cobweb.size() > 0)
  {
    String lista="", riga="";
    for (int p=0; p < cobweb.size(); p++)
    {
      PVector v = cobweb.get(p);
      riga = str((int)v.x) + "," + str((int)v.y) + "\n";
      lista=lista+riga;
    }
    String[] outTXT = split(lista, "\n");
    saveStrings(folder + folderSep + filename + ".web", outTXT);
  }
  // save text file with all the name of the layers (each name on separate line)
  String[] layersList = split(layersStr, "|");
  saveStrings(folder + folderSep + filename + ".txt", layersList);
  // save current canvas (printscreen) (.tif)
  save(folder + folderSep + filename + ".tif");
  // save current canvas (printscreen) (.pdf)
  savePDF();
  // restore cursor
  noCursor();
}

//*********************************
void savePDF()
{
  PGraphics outPDF = createGraphics(width, height, PDF, folder + folderSep +  filename + ".pdf");
  outPDF.beginDraw();
  PGraphics outLYR = createGraphics(width, height);
  outLYR.beginDraw();
  outLYR.clear();
  outLYR.noStroke();
  outLYR.fill(backCol);
  outLYR.rect(0,0,width,height);
  for(int i=numLayers-1; i>=0; i--)
  {
    if (livelli[i].lv)
    {
      if (livelli[i].lt != 255)
      {
        outLYR.tint(255,livelli[i].lt); // transparency
      }
      else
      {
        outLYR.noTint();
      }
      outLYR.image(livelli[i].pg,0,0);
    }
  }
  outPDF.image(outLYR,0,0);
  outPDF.dispose();
  outPDF.endDraw(); // automatically save PDF
}

// SAVE SELECTION
void selectionSaveDialog()
{
  noLoop();
  selectOutput("Select a file...", "selectionSave");
}

void selectionSave(File selection)
{
  if (selection == null) { println("No file selected."); }
  else
  {
    cursor(WAIT);
    if (aSelection) //copy selection
    {
      pixelCopyIMG = null;
      pixelCopyIMG = createImage(x2sel - x1sel - 1, y2sel - y1sel - 1, ARGB);
      pixelCopyIMG.loadPixels();
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.loadPixels();
      int loc = 0;
      for (int x = 0; x < (x2sel - x1sel)-1; x++)
      {
        for (int y = 0; y < (y2sel-y1sel)-1; y++)
        {
          loc = ((x + x1sel+1) + (y + y1sel+1)*width);
          pixelCopyIMG.pixels[x+y*pixelCopyIMG.width] = livelli[activeLyr].pg.pixels[loc];
        }
      }
      pixelCopyIMG.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }
    else // copy layer
    {
      pixelCopyIMG = null;
      pixelCopyIMG = createImage(width, height, ARGB);
      pixelCopyIMG.loadPixels();
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.loadPixels();
      int loc = 0;
      for (int x = 0; x < width; x++)
      {
        for (int y = 0; y < height; y++)
        {
          loc = (x + y*width);
          pixelCopyIMG.pixels[loc] = livelli[activeLyr].pg.pixels[loc];
        }
      }
      pixelCopyIMG.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }
    // save selection as file
    pixelCopyIMG.save(selection + ".png");
    // restore cursor
    noCursor();
  }
  loop();
}

//*********************************
boolean fileExists(String path)
{
  File file=new File(path);
  boolean exists = file.exists();
  if (exists) { return true; }
  else { return false; }
}