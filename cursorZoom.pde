//*********************************
void showCursor(int x, int y, boolean zoom, float zoomFactor)
{
  noFill();
  stroke(pointerCol);
  if (zoom) // draw zoom window at mouse cursor
  {
    showZoom(zoomFactor);
  }
  // PICK COLOR cursor
  if (keyPressed && keyCode==SHIFT) // pressed SHIFT key to Pick Color
  {
    // warning: the color of pick cursor center (mouseX, mouseY) must be uncolored
    // (otherwise when picking color we grab the cursor center color)
    // Pick Color cursor
    rectMode(CENTER);
    rect(mouseX,mouseY, 14, 14);
    rectMode(CORNER);
    line(mouseX-7,mouseY-7,mouseX-12,mouseY-12);
    line(mouseX+7,mouseY-7,mouseX+12,mouseY-12);
    line(mouseX+7,mouseY+7,mouseX+12,mouseY+12);
    line(mouseX-7,mouseY+7,mouseX-12,mouseY+12);
    line(mouseX,mouseY-7,mouseX,mouseY-18);
    line(mouseX+7,mouseY,mouseX+18,mouseY);
    line(mouseX,mouseY+7,mouseX,mouseY+18);
    line(mouseX-7,mouseY,mouseX-18,mouseY);
    picker = true;
  }
  else if ((menu) && (mouseX < menuX)) // MENU cursor
  {
    rectMode(CENTER);
    rect(mouseX,mouseY, 16, 16);
    rectMode(CORNER);
    line(mouseX,mouseY-8,mouseX,mouseY-16);
    line(mouseX+8,mouseY,mouseX+16,mouseY);
    line(mouseX,mouseY+8,mouseX,mouseY+16);
    line(mouseX-8,mouseY,mouseX-16,mouseY);
  }
  else if (tool == "Pencil" || tool == "Ink" || tool == "Mixer" || tool == "Confetti" ||
           tool == "Alpha" || tool == "RGB" || tool == "HSB" || tool == "RND" || tool == "BACK") // PENCIL, INK, MIXER cursor
  {
    if (zoom)
    {
      ellipse(mouseX,mouseY, brushSize*zoomFactor, brushSize*zoomFactor);
    }
    else
    {
      ellipse(mouseX,mouseY, brushSize, brushSize);
    }
  }
  else if (tool == "Clone") // CLONE cursor
  {
    if (zoom)
    {
      ellipse(mouseX,mouseY, brushSize*zoomFactor, brushSize*zoomFactor);
      line(mouseX,mouseY-zoomFactor*brushSize/2,mouseX,mouseY+zoomFactor*brushSize/2);
      line(mouseX-zoomFactor*brushSize/2,mouseY,mouseX+zoomFactor*brushSize/2,mouseY);
      if (!cloneGap)
      {
        ellipse(mouseX-gapX*zoomFactor,mouseY-gapY*zoomFactor, brushSize*zoomFactor, brushSize*zoomFactor);
        line(mouseX-gapX*zoomFactor,mouseY-(gapY-10)*zoomFactor,mouseX-gapX*zoomFactor,mouseY-(gapY+10)*zoomFactor);
        line(mouseX-(gapX-10)*zoomFactor,mouseY-gapY*zoomFactor,mouseX-(gapX+10)*zoomFactor,mouseY-gapY*zoomFactor);
      }
      else
      {
        ellipse(mouseX-(mouseX-cloneX)*zoomFactor, mouseY-(mouseY-cloneY)*zoomFactor, brushSize*zoomFactor, brushSize*zoomFactor);
        line(mouseX-(mouseX-cloneX)*zoomFactor,mouseY-(mouseY-cloneY-10)*zoomFactor,mouseX-(mouseX-cloneX)*zoomFactor,mouseY-(mouseY-cloneY+10)*zoomFactor);
        line(mouseX-(mouseX-cloneX-10)*zoomFactor,mouseY-(mouseY-cloneY)*zoomFactor,mouseX-(mouseX-cloneX+10)*zoomFactor,mouseY-(mouseY-cloneY)*zoomFactor);
      }
    }
    else
    {
      // mouse position
      ellipse(mouseX,mouseY, brushSize, brushSize);
      line(mouseX,mouseY-brushSize/2,mouseX,mouseY+brushSize/2);
      line(mouseX-brushSize/2,mouseY,mouseX+brushSize/2,mouseY);
      // clone mouse position
      if (!cloneGap) //if (!cloneGap&&gapX!=0&&gapY!=0)
      {
        ellipse(mouseX-gapX,mouseY-gapY, brushSize, brushSize);
        line(mouseX-gapX,mouseY-gapY-10,mouseX-gapX,mouseY-gapY+10);
        line(mouseX-gapX-10,mouseY-gapY,mouseX-gapX+10,mouseY-gapY);
      }
      else
      {
        ellipse(cloneX, cloneY, brushSize, brushSize);
        line(cloneX-10,cloneY,cloneX+10,cloneY);
        line(cloneX,cloneY-10,cloneX,cloneY+10);
      }
    }
  }
  else if (tool == "Stamp" || tool == "Web") // STAMP, WEB cursor
  {
    stroke(pointerCol);
    if (zoom)
    {
      rect(mouseX-(brushSize*zoomFactor)/2,mouseY-(brushSize*zoomFactor)/2,(brushSize*zoomFactor),(brushSize*zoomFactor));
    }
    else
    {
      rect(mouseX-brushSize/2,mouseY-brushSize/2,brushSize,brushSize);
    }
  }
  else if (tool == "Dyna") // DYNA cursor
  {
    if (zoom)
    {
      ellipse(mouseX,mouseY, myDD.max_brush*zoomFactor, myDD.max_brush*zoomFactor);
      ellipse(mouseX,mouseY, myDD.min_brush*zoomFactor, myDD.min_brush*zoomFactor);
    }
    else
    {
      ellipse(mouseX,mouseY, myDD.max_brush, myDD.max_brush);
      ellipse(mouseX,mouseY, myDD.min_brush, myDD.min_brush);
    }
  }
  else if (tool == "Eraser") // ERASE cursor
  {
    if (zoom)
    {
      ellipse(mouseX,mouseY, brushSize*zoomFactor, brushSize*zoomFactor);
      ellipse(mouseX,mouseY, brushSize*zoomFactor+10, brushSize*zoomFactor+10);
    }
    else
    {
      ellipse(mouseX,mouseY, brushSize, brushSize);
      ellipse(mouseX,mouseY, brushSize+10, brushSize+10);
    }
  }
  else if (tool == "Vernice" || tool == "Stencil") // VERNICE cursor
  {
    if (zoom)
    {
      ellipse(mouseX,mouseY, brushSize*zoomFactor, brushSize*zoomFactor);
      line(mouseX,mouseY-brushSize*zoomFactor/2,mouseX,mouseY-brushSize*zoomFactor);
      line(mouseX+brushSize*zoomFactor/2,mouseY,mouseX+brushSize*zoomFactor,mouseY);
      line(mouseX,mouseY+brushSize*zoomFactor/2,mouseX,mouseY+brushSize*zoomFactor);
      line(mouseX-brushSize*zoomFactor/2,mouseY,mouseX-brushSize*zoomFactor,mouseY);
    }
    else
    {
      ellipse(mouseX,mouseY, brushSize, brushSize);
      line(mouseX,mouseY-brushSize/2-4,mouseX,mouseY-brushSize);
      line(mouseX+brushSize/2+4,mouseY,mouseX+brushSize,mouseY);
      line(mouseX,mouseY+brushSize/2+4,mouseX,mouseY+brushSize);
      line(mouseX-brushSize/2-4,mouseY,mouseX-brushSize,mouseY);
    }
  }
  else if (tool == "Liner" || tool == "Select" || tool == "Shape") // LINER, SELECT cursor
  {
    stroke(pointerCol);
    if (zoom)
    {
      line(mouseX,mouseY-(brushSize*zoomFactor)/2,mouseX,mouseY+(brushSize*zoomFactor)/2);
      line(mouseX-(brushSize*zoomFactor)/2,mouseY,mouseX+(brushSize*zoomFactor)/2,mouseY);
    }
    else
    {
      line(mouseX,mouseY-brushSize/2,mouseX,mouseY+brushSize/2);
      line(mouseX-brushSize/2,mouseY,mouseX+brushSize/2,mouseY);
    }
  }
  else if (tool == "Quad") // QUAD cursor
  {
    stroke(pointerCol);
    if (zoom)
    {
      rect(mouseX-(brushSize*zoomFactor)/2,mouseY-(brushSize*zoomFactor)/2,(brushSize*zoomFactor),(brushSize*zoomFactor));
      line(mouseX,mouseY-(brushSize*zoomFactor)/2,mouseX,mouseY+(brushSize*zoomFactor)/2);
      line(mouseX-(brushSize*zoomFactor)/2,mouseY,mouseX+(brushSize*zoomFactor)/2,mouseY);
    }
    else
    {
      rect(mouseX-brushSize/2,mouseY-brushSize/2,brushSize,brushSize);
      line(mouseX,mouseY-brushSize/2,mouseX,mouseY+brushSize/2);
      line(mouseX-brushSize/2,mouseY,mouseX+brushSize/2,mouseY);
    }
  }
  else if (tool == "Circle") // CIRCLE cursor
  {
    stroke(pointerCol);
    if (zoom)
    {
      ellipse(mouseX,mouseY,(brushSize*zoomFactor),(brushSize*zoomFactor));
      line(mouseX,mouseY-(brushSize*zoomFactor)/2,mouseX,mouseY+(brushSize*zoomFactor)/2);
      line(mouseX-(brushSize*zoomFactor)/2,mouseY,mouseX+(brushSize*zoomFactor)/2,mouseY);
    }
    else
    {
      ellipse(mouseX,mouseY,brushSize,brushSize);
      line(mouseX,mouseY-brushSize/2,mouseX,mouseY+brushSize/2);
      line(mouseX-brushSize/2,mouseY,mouseX+brushSize/2,mouseY);
    }

  }
  else if (tool == "Filler") // FILLER cursor
  {
    rectMode(CENTER);
    stroke(white);
    rect(mouseX,mouseY,8,8);
    rect(mouseX,mouseY,12,12);
    rect(mouseX,mouseY,16,16);
    stroke(black);
    rect(mouseX,mouseY,6,6);
    rect(mouseX,mouseY,10,10);
    rect(mouseX,mouseY,14,14);
    rect(mouseX,mouseY,18,18);
    rectMode(CORNER);
  }
  else if (tool == "TEST") // TEST cursor
  {
    stroke(0);
    rectMode(CENTER);
    rect(mouseX,mouseY,brushSize, brushSize);
    rect(mouseX,mouseY,brushSize+4, brushSize+4);
    rectMode(CORNER);
  }
  else
  { println("cursor ERROR"); }

  // Highlight cursor
  if (highlightCursor)
  {
    stroke(highLight);
    strokeWeight(3);
    ellipse(mouseX,mouseY,brushSize+16,brushSize+16);
    strokeWeight(1);
  }
}
//*********************************
void showZoom(float zoomFactor)
{
  // draw zoom window at mouse cursor
  int x = mouseX;
  int y = mouseY;
  int u, v;
  int xsize = 250;
  int ysize = 250;
  canvasIMG = get(0,0,width,height);
  for (int vd = - ysize; vd < ysize; vd++)
  {
    for (int ud = - xsize; ud < xsize; ud++)
    {
        u = floor(ud/zoomFactor) + mouseX;
        v = floor(vd/zoomFactor) + mouseY;
        if (u >= 0 && u < canvasIMG.width && v >=0 && v < canvasIMG.height)
          { set(ud + x, vd + y, canvasIMG.get(u, v)); }
    }
  }
  // draw zoom window border
  rectMode(CENTER);
  rect(mouseX,mouseY,2*xsize,2*ysize);
  rectMode(CORNER);
}