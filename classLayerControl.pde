class LayerControl
{
  // parameters
  float x, y;
  PImage lyrControl;
  //String m;

  // variables
  int ww; // image width
  int hh; // image height
  int idx; // button pressed index (0..5)

  // constructor
  LayerControl(float ix, float iy, PImage _lyrControl)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    lyrControl = _lyrControl; // image of controls
    //m = im; // method (function)

    // variables
    ww = lyrControl.width;
    hh = lyrControl.height;
    idx = -1;
  }

  boolean isOver()
  {
    return(mouseX>x&&mouseX<x+ww&&mouseY>y&&mouseY<y+hh);
  }

  void onClick()
  {
    if (isOver())
    {
      idx = int(map(mouseX, x, x+ww, 0, 6));
      switch(idx)
      {
        case 0: // merge layers down
          mergeLayers();
          break;
        case 1: //clear layer
          clearLayer();
          break;
        case 2: // move layer down
          layerDOWN();
          break;
        case 3: // move layer up
          layerUP();
          break;
        case 4: // set all layer invisible, but active layer
          allLayersInvisible();
          break;
        case 5: // set all layer visible
          allLayersVisible();
          break;
        default:
          break;
      }
    }
  }

  void show()
  {
    image(lyrControl, x, y);
  }

  void mergeLayers() // merge current layer with the layer below and clear active layer
  {
    if (activeLyr != (numLayers-1))
    {
      startAction = true;
      PGraphics tempPG = createGraphics(width, height);
      //tempPG.noSmooth();
      tempPG.beginDraw();
      tempPG.clear();

      // Prepare antialias...
      tempPG.loadPixels();
      premultiply(tempPG.pixels, 0, tempPG.pixels.length);
      tempPG.updatePixels();

      // make one PGraphics of two layers
      // Prepare and Finalize antialias remove the effects 
      // of antialias routine performed by processing core.
      // Try to remove those (Prepare and Finalize) to see the effects.
      tempPG.image(livelli[activeLyr+1].pg,0,0);
      tempPG.image(livelli[activeLyr].pg,0,0);
      tempPG.endDraw();
      
      // ...Finalize antialias      
      tempPG.beginDraw();
      tempPG.loadPixels();
      unpremultiply(tempPG.pixels, 0, tempPG.pixels.length);
      tempPG.updatePixels();
      tempPG.endDraw();      

      // Undo action
      grabLyr = livelli[activeLyr+1].pos;  // copy active layer number on grabLyr
      // push the undo array
      for(int i = numUndo-1; i > 0; i--)
      {
        copyPG2PG(undoPG[i-1], undoPG[i]);
        undoLyr[i] = undoLyr[i-1];
      }
      // copy the active layer on first item of undo array
      copyPG2PG(livelli[activeLyr+1].pg,undoPG[0]);
      // copy the pos of the active layer on first item of undo index array
      undoLyr[0] = livelli[activeLyr+1].pos;
      // merge layers
      copyPG2PG(tempPG, livelli[activeLyr+1].pg);
      clearLayer(); // clear current layer
      // set merged layer as current layer
      livelli[activeLyr].la = false;
      livelli[activeLyr+1].la = true;
      activeLyr = activeLyr + 1;
    }
  }

  void clearLayer() // clear active layer
  {
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
    copyPG2PG(livelli[activeLyr].pg,undoPG[0]);
    // copy the pos of the active layer on first item of undo index array
    undoLyr[0] = livelli[activeLyr].pos;
    // delete the canvas of active layer
    livelli[activeLyr].delete();
    // update swatch of current layer
    livelli[activeLyr].updateLayerSwatch();
  }

  void layerDOWN() // move current layer down
  {
    if (activeLyr != numLayers-1)
    {
      swapLayers(activeLyr,activeLyr+1);
      activeLyr = activeLyr + 1;
    }
  }

  void layerUP() // move current layer up
  {
    if (activeLyr != 0)
    {
      swapLayers(activeLyr,activeLyr-1);
      activeLyr = activeLyr - 1;
    }
  }

  void allLayersVisible() // make all layers visible
  {
    for(int i=0; i<numLayers; i++)
    {
      livelli[i].lv = true;
    }
  }

  void allLayersInvisible() // make all layers invisible, but current layer
  {
    for(int i=0; i<numLayers; i++)
    {
      livelli[i].lv = false;
    }
    livelli[activeLyr].lv = true;
  }
}