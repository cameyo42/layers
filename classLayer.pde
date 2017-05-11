// *************************************************
class Layer
{
  // layer parameters
  PGraphics pg;  // layer PGraphics canvas
  int lw, lh;    // canvas width and height
  int lx, ly;    // canvas upper left corner
  boolean lv;    // layer visible
  boolean la;    // layer active
  boolean ll;    // layer locked
  String ln;     // layer name (modifiable)
  int lt;        // layer transparency
  String lf;     // layer fusion mode
  int lix, liy, liw, lih; // layer rect button start point, width and height
  color c0, c1, c2;       // text color, stroke color, fill color
  String lm;     // layer method name
  int idx;       // layer index position on within Layers array
  int pos;       // layer absolute position (constant)

  // transparency slider
  int tx1;    // start x
  int ty1;    // start y
  int tx2;    // end x
  int ty2;    // end y
  int tp;     // pad space
  int tv1;    // min value
  int tv2;    // max value
  int tv;     // transparency value
  int xpos;   // x value of slider

  // layer canvas icon
  int cix; // x layer swatch
  int ciy; // y layer swatch
  int ciw; // layer swatch width
  //float ciwf // layer swatch width
  int cih; // layer swatch height
  PGraphics cig; // PGraphics layer swatch
  PImage scaledCanvas; // Temporary PImage for layer swatch

  // constructor
  Layer(PGraphics _pg, int _w, int _h, int _x, int _y, boolean _v, boolean _a, boolean _l, String _n, int _t, String _f,
        int _lix, int _liy, int _liw, int _lih, color _c0, color _c1, color _c2,
        String _m, int _idx, int _pos)
  {
    lw = _w; // layer width
    lh = _h; // layer height
    pg = createGraphics(lw, lh);
    lx = _x; // layer x position (upper left)
    ly = _y; // layer y position  (upper left)
    lv = _v; // layer visible flag
    la = _a; // layer active flag
    ll = _l; // layer locked flag
    ln = _n; // layer name
    lt = _t; // layer transparency;
    lf = _f; // layer fusion mode

    lix = _lix; // icon x position
    liy = _liy; // icon y position
    liw = _liw; // icon width
    lih = _lih; // icon height
    c0 = _c0;   // icon text color
    c1 = _c1;   // icon stroke color
    c2 = _c2;   // icon fill color

    lm = _m;    // method name (function)
    idx = _idx; // layer index
    pos = _pos; // layer internal name

    cix = lix + liw;    // x layer swatch
    ciy = liy;          // y layer swatch
    cih = lih + lih/2;  // height layer swatch
    //ciw = lih + lih/2;  // width layer swatch
    ciw = int(cih*(lw/(1.0*lh)));  // width layer swatch

    // layer swatch
    scaledCanvas = createImage(lw,lh,ARGB); // Temp PImage for layer swatch
    cig = createGraphics(ciw, cih);
    cig.beginDraw();
    cig.clear();
    cig.endDraw();
    // initialize layer canvas PGraphics (100% transparent)
    //pg.noSmooth();
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
  }

  void delete() // clear layer canvas (100% transparent)
  {
    pg = createGraphics(lw, lh);
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
  }


  //void show() // show layer on canvas
  //{
  //  if (lv)
  //  {
  //    // set layer transparency
  //    if (lt != 255.0)
  //    { tint(255, lt); }
  //    else { noTint(); }
  //    image(pg, lx, ly);
  //  }
  //}

  void show() // show layer on canvas
  {
    if (lv)
    {
      // set layer transparency
      if (lt != 255)
      { tint(255, lt); }
      else { noTint(); }
      image(pg, lx, ly);
    }
    //noTint();
  }

  boolean isOverIcon()
  {
    return(mouseX >= lix && mouseX <= lix+liw && mouseY >= liy && mouseY <= liy+lih);
  }

  void onClickIcon()
  {
    if (isOverIcon())
    {
      if (mouseX > (lix + lih) && mouseX <= lix+5*lih && mouseY >= liy && mouseY <= liy+lih)
      // clicked on layer icon name --> activate || rename
      {
        if (keyPressed && keyCode == CONTROL) // Ctrl-Click --> rename layer
        {
          String layer = JOptionPane.showInputDialog("Enter layer name...");
          if (layer != null) // Not cancel and valid string
          {
            if (layer.length() > 0)
            {
              boolean found = false;
              for(int i=0; i<numLayers; i++)
              {
                if (layer.equals(livelli[i].ln)) { found = true; }
              }
              if (!found) { ln = layer; }
            }
          }
          keyPressed = false;
          mousePressed = false;
        }
        else
        // click --> active layer on/off
        {
          activeLyr = idx;
          // set active layer --> visible layer
          la = true;
          lv = true;
          // deactivate active flag of other layers
          for(int i=0; i<numLayers; i++)
          {
            if (livelli[i].idx != activeLyr)
            {
              livelli[i].la = false;
            }
          }
        }
      }
      else if (mouseX > (lix + 5*lih) && mouseX <= lix+6*lih && mouseY >= liy && mouseY <= liy+lih)
      // click --> layer lock on/off
      {
        ll = !ll;
      }
      else // clicked on layer visibility icon --> visible On/Off
      {
        lv = !lv;
      }
    }
  }

  void showIcon()
  {
    pushStyle();
    stroke(c1);
    if (la) { fill(highLight); }
    else { fill(c2); }
    rect(lix, liy, liw, lih);
    line(lix+lih, liy, lix+lih, liy+lih);
    line(lix+5*lih, liy, lix+5*lih, liy+lih);
    // draw visible icon
    if (lv) { fill(c0); }
    else { noFill(); }
    ellipse(lix+lih/2, liy+lih/2.0, 12, 12);
    // draw layer name
    fill(c0);
    textAlign(CENTER, CENTER);
    text(ln,lix+3*lih,liy+lih/2.0-1);
    // draw locked icon
    if (ll) { fill(c0); }
    else { noFill(); }
    rectMode(CENTER);
    rect(lix+5.5*lih,liy+lih/2.0,11,11);
    rectMode(CORNER);
    // draw transparency slider
    noFill();
    rect(lix, liy+lih, liw, lih/2);
    tx1 = lix + 4;              // start x
    ty1 = liy + lih + lih/4;    // start y
    tx2 = lix + liw - 4 - lih;  // end x
    ty2 = liy + lih + lih/4;    // end y
    // draw slider line
    stroke(c0);
    line(tx1,ty1,tx2,ty2);
    tp=lih/4;                   // pad space
    tv1=0;                      // min value
    tv2=255;                    // max value
    tv=lt;                      // transparency value
    // draw transparency text value
    fill(c0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text(lt, lix+5.5*lih, ty2-1);
    // draw transp rect
    stroke(c1);
    xpos = int(map(tv,tv1,tv2,tx1,tx2));
    rectMode(CENTER);
    if (la) { fill(highLight); }
    else { fill(c0); }
    rect(xpos, ty2, 6, 6);
    // draw layer canvas icon
    noTint();
    image(cig, cix+2, ciy);
    popStyle();
  }

  boolean isOverTransp()
  {
    return(mouseX>=tx1-4 && mouseX<=tx2+4 && mouseY>=ty1-4 && mouseY<=ty2+4);
  }

  void onClickTransp()
  {
    if (isOverTransp())
    {
       lt = constrain(int(map(mouseX,tx1,tx2,tv1,tv2)),tv1,tv2);
    }
  }

  void onDragTransp()
  {
    if (isOverTransp())
    {
       lt = constrain(int(map(mouseX,tx1,tx2,tv1,tv2)),tv1,tv2);
    }
  }

  // If you want to resize PGraphics content, first get a copy of its image data using the get() method,
  // and call resize() on the PImage that is returned.
  void updateLayerSwatch()
  {
    // update layer swatch
    scaledCanvas = pg.get(0, 0, width, height);
    scaledCanvas.resize(ciw,cih);
    cig.beginDraw();
    cig.clear();
    cig.noStroke();
    cig.fill(255);
    cig.rectMode(CORNER);
    cig.rect(0, 0, ciw, cih);
    cig.image(scaledCanvas, 0, 0, ciw, cih);
    cig.endDraw();
    //copyIMG2PGfast(scaledCanvas,cig);
  }
}