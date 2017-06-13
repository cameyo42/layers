//int a = (brushCol >> 24) & 0xFF;
//int r = (brushCol >> 16) & 0xFF;
//int g = (brushCol >> 8)  & 0xFF;
//int b =  brushCol & 0xFF;

//*********************************
// swap livello[i] with livello [j]
// idx remain the same!
void swapLayers(int i, int j)
{
  // copy actual layer to temp layer
  PGraphics tpg = livelli[i].pg;
  int tw = livelli[i].lw;
  int th = livelli[i].lh;
  int tx = livelli[i].lx;
  int ty = livelli[i].ly;
  boolean tv = livelli[i].lv;
  boolean ta = livelli[i].la;
  boolean tl = livelli[i].ll;
  String tn = livelli[i].ln;
  int tt = livelli[i].lt;
  String tf = livelli[i].lf;
  int tix = livelli[i].lix;
  int tiw = livelli[i].liw;
  int tih = livelli[i].lih;
  color tc0 = livelli[i].c0;
  color tc1 = livelli[i].c1;
  color tc2 = livelli[i].c2;
  String tm = livelli[i].lm;
  //int tidx = livelli[i]idx
  int tpos = livelli[i].pos;
  PGraphics tcig = livelli[i].cig;
  // copy previous layer on actual layer
  livelli[i].pg  = livelli[j].pg;
  livelli[i].lw  = livelli[j].lw;
  livelli[i].lh  = livelli[j].lh;
  livelli[i].lx  = livelli[j].lx;
  livelli[i].ly  = livelli[j].ly;
  livelli[i].lv  = livelli[j].lv;
  livelli[i].la  = livelli[j].la;
  livelli[i].ln  = livelli[j].ln;
  livelli[i].lt  = livelli[j].lt;
  livelli[i].ll  = livelli[j].ll;
  livelli[i].lf  = livelli[i].lf;
  livelli[i].lix = livelli[j].lix;
  livelli[i].liw = livelli[j].liw;
  livelli[i].lih = livelli[j].lih;
  livelli[i].c0  = livelli[j].c0;
  livelli[i].c1  = livelli[j].c1;
  livelli[i].c2  = livelli[j].c2;
  livelli[i].lm  = livelli[j].lm;
  //livelli[i].idx = livelli[j].idx;
  livelli[i].pos = livelli[j].pos;
  livelli[i].cig = livelli[j].cig;
  // copy temp layer on previous layer
  livelli[j].pg  = tpg;
  livelli[j].lw  = tw;
  livelli[j].lh  = th;
  livelli[j].lx  = tx;
  livelli[j].ly  = ty;
  livelli[j].lv  = tv;
  livelli[j].la  = ta;
  livelli[j].ln  = tn;
  livelli[j].lt  = tt;
  livelli[j].ll  = tl;
  livelli[i].lf  = tf;
  livelli[j].lix = tix;
  livelli[j].liw = tiw;
  livelli[j].lih = tih;
  livelli[j].c0  = tc0;
  livelli[j].c1  = tc1;
  livelli[j].c2  = tc2;
  livelli[j].lm  = tm;
  //livelli[j].idx = tidx;
  livelli[j].pos = tpos;
  livelli[j].cig = tcig;
}

//*********************************
// Prepare active layer for glitch
void prepareGlitch()
{
  // start antialias glitch. Prepare for draw
  // needed for drawing on transparent PGraphics without antialiasing glitch
  startGlitch = true;
  //stopGlitch = true;
  livelli[activeLyr].pg.loadPixels();
  premultiply(livelli[activeLyr].pg.pixels, 0, livelli[activeLyr].pg.pixels.length);
  livelli[activeLyr].pg.updatePixels();
}

//*********************************
void finalizeGlitch()
{
  // ...terminate antialias glitch
  livelli[activeLyr].pg.beginDraw();
  livelli[activeLyr].pg.loadPixels();
  unpremultiply(livelli[activeLyr].pg.pixels, 0, livelli[activeLyr].pg.pixels.length);
  livelli[activeLyr].pg.updatePixels();
  livelli[activeLyr].pg.endDraw();
  startGlitch = false;
  //stopGlitch = true;
}

//*********************************
// allow to draw on transparent PGraphics without the antialiasing glitch
// must be used BEFORE drawing
void premultiply( int[] p, int offset, int _length )
{
  _length += offset;
  for ( int i = offset; i < _length; i ++ )
  {
    int rgb = p[i];
    int a = (rgb >> 24) & 0xff;
    int r = (rgb >> 16) & 0xff;
    int g = (rgb >> 8) & 0xff;
    int b = rgb & 0xff;
    float f = a * (1.0f / 255.0f);
    r *= f;
    g *= f;
    b *= f;
    p[i] = (a << 24) | (r << 16) | (g << 8) | b;
  }
}

//*********************************
// allow to draw on transparent PGraphics without the antialiasing glitch
// must be used AFTER drawing
void unpremultiply( int[] p, int offset, int _length )
{
  _length += offset;
  for ( int i = offset; i < _length; i ++ )
  {
    int rgb = p[i];
    int a = (rgb >> 24) & 0xff;
    int r = (rgb >> 16) & 0xff;
    int g = (rgb >> 8) & 0xff;
    int b = rgb & 0xff;
    if ( a != 0 && a != 255 )
    {
      float f = 256.0f / a;
      r *= f;
      g *= f;
      b *= f;
      if ( r > 255 )
        r = 255;
      if ( g > 255 )
        g = 255;
      if ( b > 255 )
        b = 255;
      p[i] = (a << 24) | (r << 16) | (g << 8) | b;
    }
  }
}

//*********************************
// show grid on top of layers (starting from 0,0)
// fps intensive with small x and y values :(
void showGrid(int spaceX, int spaceY, color gridCol)
{
  gridCol = black;
  stroke(gridCol);
  for(int x = 0; x < width; x=x+spaceX)
  {
    line(x,0,x,height);
  }
  for(int y = 0; y < height; y=y+spaceY)
  {
     line(0,y,width,y);
  }
  // highlight center point
  noStroke();
  fill(highLight);
  ellipse(centerX,centerY,6,6);
}

//*********************************
// draw grid on active layer (starting from 0,0)
void drawGrid()
{
  // store layer for undo
  storeUNDO();
  // draw the grid
  // open PGraphics
  livelli[activeLyr].pg.beginDraw();
  int spaceX = int(sbGRIDX.v);
  int spaceY = int(sbGRIDY.v);
  livelli[activeLyr].pg.stroke(brushCol);
  livelli[activeLyr].pg.strokeWeight(1);
  for(int x = 0; x < width; x=x+spaceX)
  {
    livelli[activeLyr].pg.line(x,0,x,height);
  }
  for(int y = 0; y < height; y=y+spaceY)
  {
     livelli[activeLyr].pg.line(0,y,width,y);
  }
  livelli[activeLyr].pg.endDraw(); // close PGraphics
  livelli[activeLyr].updateLayerSwatch(); // update swatch of current layer
}

//*********************************
void storeUNDO()
{
  // UNDO action
  startAction = true;
  // Undo action
  grabLyr = livelli[activeLyr].pos;  // copy active layer number on grabLyr
  // push the undo array
  for(int i = numUndo-1; i > 0; i--)
  {
    copyPG2PG(undoPG[i-1], undoPG[i]);
    undoLyr[i] = undoLyr[i-1];
  }
  // copy the active layer on first item of undo array
  copyPG2PG(livelli[activeLyr].pg, undoPG[0]);
  // copy the pos of the active layer on first item of undo index array
  undoLyr[0] = livelli[activeLyr].pos;
}

//*********************************
// Grab layer image for undo
void grabLayer()
{
  // before start drawing: grab the active layer image for undo
  // copy active layer canvas on grabPG
  copyPG2PG(livelli[activeLyr].pg, grabPG);
  // copy active layer number on grabLyr
  // take the "pos" of active layer
  grabLyr = livelli[activeLyr].pos;
  grab = false;
}

//*********************************
void undo()
{
  if (undoLyr[0] != -1)
  {
    // UNDO
    // copyPG2PG(undoPG[0]) su quel livello i-esimo (u) che ha livelli[i].pos==undoLyr[0]
    int u=-1;
    for (int i=0; i < numLayers; i++)
    {
      if (livelli[i].pos == undoLyr[0])
        { u = i; break; }
    }
    if (u == -1) { println( "Error: wrong UNDO"); }
    else
    {
      // before UNDO ACTION we must update redoPG array (PUSH REDO)
      // push livelli[u].pg on redoPG array
      for(int i = numRedo-1; i > 0; i--)
      {
        copyPG2PG(redoPG[i-1], redoPG[i]);
        redoLyr[i] = redoLyr[i-1];
      }
      // copy layer to undo on top of redo array
      copyPG2PG(livelli[u].pg,redoPG[0]);
      redoLyr[0] = undoLyr[0];

      // UNDO ACTION
      // copy undo image on layer
      copyPG2PG(undoPG[0],livelli[u].pg);
      // update swatch of current layer
      livelli[u].updateLayerSwatch();

      // UPDATE UNDO ARRAY (POP)
      // pop undoed image from undoPG array
      for(int i=0; i<numUndo-1; i++)
      {
        copyPG2PG(undoPG[i+1], undoPG[i]);
        undoLyr[i] = undoLyr[i+1];
      }
      undoLyr[numUndo-1] = -1;
    }
  }

  // update undo/redo button
  if (undoLyr[0] == -1) { btnUNDO.s = false; }
  else { btnUNDO.s = true; }
  if (redoLyr[0] == -1) { btnREDO.s = false; }
  else { btnREDO.s = true; }
}

//*********************************
void redo()
{
  if (redoLyr[0] != -1)
  {
    // REDO
    // copyPG2PG(undoPG[0]) su quel livello i-esimo (r) che ha livelli[i].pos == redoLyr[0]
    int r=-1;
    for (int i=0; i < numLayers; i++)
    {
      if (livelli[i].pos == redoLyr[0])
        { r = i; break; }
    }
    if (r == -1) { println( "Error: wrong REDO"); }
    else
    {
      // before REDO ACTION we must update undoPG array (PUSH UNDO)
      // push livelli[r].pg on undoPG array
      for(int i = numUndo-1; i > 0; i--)
      {
        copyPG2PG(undoPG[i-1], undoPG[i]);
        undoLyr[i] = undoLyr[i-1];
      }
      // copy livelli[redoLyr[0]].pg on undoPG[0]
      copyPG2PG(livelli[r].pg, undoPG[0]);
      undoLyr[0] = redoLyr[0];

      // REDO ACTION
      // copy redo image on layer
      copyPG2PG(redoPG[0],livelli[r].pg);
      // update swatch of layer
      livelli[r].updateLayerSwatch();

      // UPDATE REDO ARRAY (POP)
      // pop image from redoPG array
      for(int i=0; i<numRedo-1; i++)
      {
        copyPG2PG(redoPG[i+1], redoPG[i]);
        redoLyr[i] = redoLyr[i+1];
      }
      redoLyr[numRedo-1] = -1;
    }
  }
  // update undo/redo button
  if (undoLyr[0] == -1) { btnUNDO.s = false; }
  else { btnUNDO.s = true; }
  if (redoLyr[0] == -1) { btnREDO.s = false; }
  else { btnREDO.s = true; }
}

//*********************************
void resetUNDO_REDO()
{
  for(int i=0; i<numUndo; i++)
  {
    // create new PGraphics
    undoPG[i] = createGraphics(width,height);
    undoPG[i].beginDraw();
    undoPG[i].clear();
    undoPG[i].endDraw();
    undoLyr[i] = -1;
    redoPG[i] = createGraphics(width,height);
    redoPG[i].beginDraw();
    redoPG[i].clear();
    redoPG[i].endDraw();
    redoLyr[i] = -1;
  }
  if (undoLyr[0] == -1) { btnUNDO.s = false; }
  else { btnUNDO.s = true; }
  if (redoLyr[0] == -1) { btnREDO.s = false; }
  else { btnREDO.s = true; }
}

//*********************************
void copyPG2PG(PGraphics a, PGraphics b)
// must be same dimension
{
  // copy a on b (b = a;)
  a.loadPixels();
  b.loadPixels();
  b.beginDraw();
  arrayCopy(a.pixels,b.pixels);
  //a.updatePixels(); // there are no changes !!!
  b.updatePixels();
  b.endDraw();
}

//*********************************
void copyIMG2PGfast(PImage a, PGraphics b)
// must be same dimension
{
  // copy a on b (b = a;)
  a.loadPixels();
  b.loadPixels();
  b.beginDraw();
  arrayCopy(a.pixels,b.pixels);
  //a.updatePixels(); // there are no changes !!!
  b.updatePixels();
  b.endDraw();
}

void copyPG2IMG2fast(PGraphics a, PImage b)
// must be same dimension
{
  // copy a on b (b = a;)
  a.loadPixels();
  a.beginDraw();
  b.loadPixels();
  // for (int i = 0; i < b.pixels.length; i++)
  // {
  //   b.pixels[i] = a.pixels[i];
  // }
  arrayCopy(a.pixels,b.pixels);
  //a.updatePixels(); // there are no changes !!!
  b.updatePixels();
  a.endDraw();
}

//*********************************
void copyIMG2IMGfast(PImage a, PImage b)
// must be same dimension
{
  // copy a on b (b = a;)
  a.loadPixels();
  b.loadPixels();
  // for (int i = 0; i < b.pixels.length; i++)
  // {
  //   b.pixels[i] = a.pixels[i];
  // }
  arrayCopy(a.pixels,b.pixels);
  //a.updatePixels(); // there are no changes !!!
  b.updatePixels();
}

//*********************************
void copyIMG2PG(PImage a, PGraphics b)
{
  // copy a on b (b = a;)
  a.loadPixels();
  b.loadPixels();
  b.beginDraw();
  int ww = min(a.width,b.width);
  int hh = min(a.height,b.height);
  // Loop through every pixel column
  for (int x = 0; x < ww; x++)
  {
    // Loop through every pixel row
    for (int y = 0; y < hh; y++)
    {
      // Use formula to find the 1D location
      int loca = x + y * a.width;
      int locb = x + y * b.width;
      b.pixels[locb] = a.pixels[loca];
    }
  }
  //a.updatePixels;
  b.updatePixels();
  b.endDraw();
}

//*********************************
// calculate X symmetry
void calcSymX(float px1, float py1, float px2, float py2)
{
  s1x = int(px1);
  s1y = int(-py1+2*centerY);
  s2x = int(px2);
  s2y = int(-py2+2*centerY);
}
// calculate Y symmetry point
void calcSymY(float px1, float py1, float px2, float py2)
{
  s1x = int(-px1+2*centerX);
  s1y = int(py1);
  s2x = int(-px2+2*centerX);
  s2y = int(py2);
}
// calculate XY symmetry point (opposite)
void calcSymXY(float px1, float py1, float px2, float py2)
{
  s1x = int(round(2*centerX-px1));
  s1y = int(round(2*centerY-py1));
  s2x = int(round(2*centerX-px2));
  s2y = int(round(2*centerY-py2));
}

//*********************************
// draw web point
void drawWebPoint()
{
  if (cobweb.size() > 0)
  {
    if (updateWeb)
    {
      updateWeb = false;
      web.beginDraw();
      web.clear();
      web.loadPixels();
      int maxV = width*height;
      for (int p=0; p < cobweb.size(); p++)
      {
        PVector v = cobweb.get(p);
        int loc = (int)v.x + (int)v.y*width;
        if (loc <= maxV && loc >= 0)
        { web.pixels[loc] = webPointCol; }
      }
      web.updatePixels();
      web.endDraw();
    }
    image(web,0,0);
  }
}

//*********************************
void createSetofPoints()
{
  pts.clear();
  stencilIMG.loadPixels();
  livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
  livelli[activeLyr].pg.loadPixels();
  for (int x = 0; x < stencilIMG.width; x++)
  {
    for (int y = 0; y < stencilIMG.height; y++)
    {
      //println(x,y,x+xsten,y+ysten,stencilIMG.pixels[x+y*stencilIMG.width]);
      //if (stencilIMG.pixels[x+y*stencilIMG.width] == 0x0)
      if (stencilIMG.pixels[x+y*stencilIMG.width] == 0) //transparent
      {
        int xx = x + xsten;
        int yy = y + ysten;
        int loc = xx + yy*width;
        String newPt = String.valueOf(loc);
        pts.add(newPt);
        //println(x,y,x+xsten,y+ysten,stencilIMG.pixels[x+y*stencilIMG.width]);
      }
    }
  }
  livelli[activeLyr].pg.updatePixels();
  livelli[activeLyr].pg.endDraw(); // open active layer PGraphics
}

//*********************************
void createStencilFromSelection()
{
  if (aSelection)
  {
    stencilIMG = null;
    stencilIMG = createImage(x2sel - x1sel - 1, y2sel - y1sel -1 , ARGB);
    stencilIMG.loadPixels();
    livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
    livelli[activeLyr].pg.loadPixels();
    int loc = 0;
    for (int x = 0; x < (x2sel - x1sel)-1; x++)
    {
      for (int y = 0; y < (y2sel-y1sel)-1; y++)
      {
        loc = ((x + x1sel+1) + (y + y1sel+1)*width);
        stencilIMG.pixels[x+y*stencilIMG.width] = livelli[activeLyr].pg.pixels[loc];
      }
    }
    stencilIMG.updatePixels();
    livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    //center stencil
    ysten = height/2 - stencilIMG.height/2;
    xsten = width/2 - stencilIMG.width/2;
    // activate stencil
    stencil = true;
    cbSTENCIL.s = stencil;
  }
  else { println("ERROR: no selection"); }
}

//*********************************
// Invert colored <--> transparent pixels
void invertStencil()
{
  stencilIMG.loadPixels();
  int loc = 0;
  for (int x = 0; x < stencilIMG.width; x++)
  {
    for (int y = 0; y < stencilIMG.height; y++)
    {
      loc = (x + y*stencilIMG.width);
      if (((stencilIMG.pixels[loc] >> 24) & 0xff ) == 0) // transparent
      {
        stencilIMG.pixels[loc] = brushCol;
      }
      else
      {
        stencilIMG.pixels[loc] = 0x0;
      }
    }
  }
  stencilIMG.updatePixels();
  //center stencil
  ysten = height/2 - stencilIMG.height/2;
  xsten = width/2 - stencilIMG.width/2;
}

//*********************************
// copy a pixels selection
void copyPixels()
{
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
    // activate PASTE
    layerPaste = false;
    pixelPaste = true;
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
    // activate PASTE
    pixelPaste = true;
    layerPaste = true;
  }
}

//*********************************
// paste a pixels selection
void pastePixels()
{
  if (pixelPaste)
  {
    int pasteX = mouseX - (x2sel-x1sel)/2;
    int pasteY = mouseY - (y2sel-y1sel)/2;
    if (layerPaste)
    {
      pasteX = 0;
      pasteY = 0;
    }
    // store layer for undo
    storeUNDO();
    // Paste image
    pixelCopyIMG.loadPixels();
    livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
    livelli[activeLyr].pg.loadPixels();
    int loc = 0;
    int locLyr = 0;
    for (int x = 0; x < pixelCopyIMG.width; x++)
    {
      for (int y = 0; y < pixelCopyIMG.height; y++)
      {
        loc = (x + y*pixelCopyIMG.width);
        locLyr = ((x + pasteX) + (y + pasteY)*width);
        if (((x+pasteX) > 0) && ((x+pasteX) < width) && ((y+pasteY) > 0) && ((y+pasteY) < height))
        {
          if (((pixelCopyIMG.pixels[loc] >> 24) & 0xff ) != 0) // not transparent
          {
            livelli[activeLyr].pg.pixels[locLyr] = pixelCopyIMG.pixels[loc];
          }
        }
      }
    }
    //pixelCopyIMG.updatePixels();
    livelli[activeLyr].pg.updatePixels();
    livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
  }
  else { println("ERROR: no selection"); }
}

//*********************************
// draw selection contour
void selectionContour()
{
  if (aSelection)
  {
    // store layer for undo
    storeUNDO();
    livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
    livelli[activeLyr].pg.stroke(brushCol);
    livelli[activeLyr].pg.noFill();
    livelli[activeLyr].pg.rect(x1sel,y1sel,(x2sel-x1sel),(y2sel-y1sel));
    livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
  }
}

//*********************************
// random color
color randomColor()
{
  return ((color) random(#000000));
}