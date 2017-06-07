//*********************************
void mouseReleased()
//*********************************
{
  //int mx, my;
  //mx = mouseX;
  //my = mouseY;

  // terminate confetti tool render drawing
  if (tool == "Confetti")
  {
    while(confettiThings.size() > 0)
    {
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      for (int i=0, sz=confettiThings.size(); i<sz; i++)
      {
        ConfettiBase c = (ConfettiBase)confettiThings.get(i);
        c.move();
        if (c.alive()) { c.paint(); }
        else
        {
          confettiThings.remove(c);
          i--;
          sz--;
        }
      }
      livelli[activeLyr].pg.endDraw();
    }
  }

  if(startAction) // started an action who has modified the active layer --> reset REDO
  {
    startAction = false;
    // reset redo
    for( int i=0; i< numRedo; i++)
    { redoLyr[i] = -1; }
  }

  // unlock slider (size,alfa,gap,threshold,...)
  slSIZE.locked = false;
  slALFA.locked = false;
  slSTAMP.locked = false;
  slSTAMP2.locked = false;
  slFILLER.locked = false;
  slMIXERA.locked = false;
  slMIXERD.locked = false;
  slWEBA.locked = false;
  slWEBD.locked = false;
  slCONFVEL.locked = false;
  slCONFDVEL.locked = false;
  // unlock dyna slider
  dslHOOKE.locked = false;
  dslDAMPING.locked = false;
  dslDUCTUS.locked = false;
  dslMASS.locked = false;
  dslMINB.locked = false;
  dslMAXB.locked = false;
  // unlock SHape slider
  slSHitems.locked = false;
  slSHsizeD.locked = false;
  slSHalfaD.locked = false;
  slSHposD.locked = false;

  // check if drawing with Liner
  if ((lineDown) && (tool=="Liner"))
  {
    lineDown = false;
    if (grab) { grabLayer(); } // before start drawing: grab the canvas image for undo
    livelli[activeLyr].pg.beginDraw(); // open PGraphics
    //livelli[activeLyr].pg.strokeCap(SQUARE);
    livelli[activeLyr].pg.noFill();
    livelli[activeLyr].pg.stroke(brushCol);
    livelli[activeLyr].pg.strokeWeight(brushSize);
    if (noGlitch) { prepareGlitch(); } // Start antialias...
    if (snap2Grid)
    {
      x1L = gridX * (int)round((float)x1L / gridX);
      y1L = gridY * (int)round((float)y1L / gridY);
      x2L = gridX * (int)round((float)x2L / gridX);
      y2L = gridY * (int)round((float)y2L / gridY);
    }
    if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
    livelli[activeLyr].pg.line(x1L, y1L, x2L, y2L); // draw on active layer
    if (symX) // draw symmetry from X axis
    {
      calcSymX(x1L,y1L,x2L,y2L);
      livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
    }
    if (symY) // draw symmetry from Y axis
    {
      calcSymY(x1L,y1L,x2L,y2L);
      livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
    }
    if(symX && symY) // draw symmetry from center point (opposite)
    {
      calcSymXY(x1L,y1L,x2L,y2L);
      livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
    }
    livelli[activeLyr].pg.strokeWeight(1);
    livelli[activeLyr].pg.endDraw(); // close PGraphics
  }
  // check if drawing with Quad
  else if  ((quadDown) && (tool=="Quad"))
  {
    quadDown = false;
    if (grab) { grabLayer(); }  // before start drawing: grab the canvas image for undo
    livelli[activeLyr].pg.beginDraw(); // open PGraphics
    //livelli[activeLyr].pg.strokeJoin(ROUND);
    livelli[activeLyr].pg.noFill();
    livelli[activeLyr].pg.stroke(brushCol);
    livelli[activeLyr].pg.strokeWeight(brushSize);
    if (noGlitch) { prepareGlitch(); } // Start antialias...
    if (quadLock) // draw square
    {
      if (snap2Grid)
      {
        x1L = gridX * (int)round((float)x1L / gridX);
        y1L = gridY * (int)round((float)y1L / gridY);
        x2L = gridX * (int)round((float)x2L / gridX);
        y2L = gridY * (int)round((float)y2L / gridY);
      }
      int dd = max(abs(x2L-x1L), abs(y2L-y1L));
      int qx1 ,qy1, qx2, qy2;
      qx1 = 0; qy1 = 0; qx2 = 0; qy2 = 0;
      if (x2L > x1L)
      {
        if (y2L > y1L) { qx1 = x1L; qy1 = y1L; qx2 = x1L + dd; qy2 = y1L + dd; } // lower left
        else { qx1 = x1L; qy1 = y1L - dd; qx2 = x1L + dd; qy2 = y1L; } // upper left
      }
      else // (x1L > x2L)
      {
        if (y2L > y1L) { qx1 = x1L - dd; qy1 = y1L; qx2 = x1L; qy2 = y1L + dd; } // lower right
        else { qx1 = x1L - dd; qy1 = y1L - dd; qx2 = x1L ; qy2 = y1L; } // upper right
      }
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      livelli[activeLyr].pg.rect(qx1,qy1, qx2 - qx1, qy2 - qy1); // draw on active layer
      if (symX) // draw symmetry from X axis
      {
        calcSymX(qx1,qy1,qx2,qy2);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x - s1x, s2y - s1y);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(qx1,qy1,qx2,qy2);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x - s1x, s2y - s1y);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(qx1,qy1,qx2,qy2);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x - s1x, s2y - s1y);
      }
    }
    else // draw rect
    {
      if (snap2Grid)
      {
        x1L = gridX * (int)round((float)x1L / gridX);
        y1L = gridY * (int)round((float)y1L / gridY);
        x2L = gridX * (int)round((float)x2L / gridX);
        y2L = gridY * (int)round((float)y2L / gridY);
      }
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      livelli[activeLyr].pg.rect(x1L,y1L,x2L-x1L,y2L-y1L);
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x-s1x, s2y-s1y);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x-s1x, s2y-s1y);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.rect(s1x, s1y, s2x-s1x, s2y-s1y);
      }
    }
    livelli[activeLyr].pg.strokeWeight(1);
    livelli[activeLyr].pg.endDraw(); // close PGraphics
  }
  // check if drawing with Circle
  else if ((circleDown) && (tool=="Circle"))
  {
    circleDown = false;
    if (grab) { grabLayer(); }  // before start drawing: grab the canvas image for undo
    livelli[activeLyr].pg.beginDraw();
    livelli[activeLyr].pg.noFill();
    livelli[activeLyr].pg.stroke(brushCol);
    livelli[activeLyr].pg.strokeWeight(brushSize);
    if (noGlitch) { prepareGlitch(); } // Start antialias...
    if (circleLock) // draw circle
    {
      if (snap2Grid)
      {
        x1L = gridX * (int)round((float)x1L / gridX);
        y1L = gridY * (int)round((float)y1L / gridY);
        x2L = gridX * (int)round((float)x2L / gridX);
        y2L = gridY * (int)round((float)y2L / gridY);
      }
      float dd = dist(x1L,y1L,x2L,y2L)*2;
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      livelli[activeLyr].pg.ellipse(x1L, y1L, dd, dd);
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse(s1x, s1y, dd, dd);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse(s1x, s1y, dd, dd);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse(s1x, s1y, dd, dd);
      }
    }
    else // draw ellipse
    {
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      livelli[activeLyr].pg.ellipse((x1L+x2L)/2, (y1L+y2L)/2, (x1L-x2L), (y1L-y2L));
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1L,y1L,x2L,y2L);
        livelli[activeLyr].pg.ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
      }
    }
    livelli[activeLyr].pg.strokeWeight(1);
    livelli[activeLyr].pg.endDraw(); // close PGraphics
  }
  // check if drawing with Select
  else if  ((selectDown) && (tool=="Select"))
  {
    selectDown = false;
    if (snap2Grid)
    {
      x1L = gridX * (int)round((float)x1L / gridX);
      y1L = gridY * (int)round((float)y1L / gridY);
      x2L = gridX * (int)round((float)x2L / gridX);
      y2L = gridY * (int)round((float)y2L / gridY);
    }
    // reorder rect coords
    if (x1L < x2L) { x1sel = x1L; x2sel = x2L; }
    else { x1sel = x2L; x2sel = x1L; }
    if (y1L < y2L) { y1sel = y1L; y2sel = y2L; }
    else { y1sel = y2L; y2sel = y1L; }
    // check oustide coords
    x1sel = constrain(x1sel,0,width-1);
    x2sel = constrain(x2sel,0,width-1);
    y1sel = constrain(y1sel,0,height-1);
    y2sel = constrain(y2sel,0,height-1);
    // check null selection
    if ((x1sel == x2sel) || (y1sel == y2sel))
    { aSelection = false; }
    else { aSelection = true; }
    // update SELECT checkbox
    cbSELECT.s = aSelection;
  }

  // clone tool
  if (tool=="Clone")
  {
    // check null distance
    if (gapX!=0 && gapY!=0)
    {
      cloneGap = !cbCLONE.s;
    }
  }

  // UNDO ACTION - check if there is an UNDO image to memorize
  if (!grab) // push grabbed image on undoPG array
  {
    for(int i = numUndo-1; i > 0; i--)
    {
      copyPG2PG(undoPG[i-1], undoPG[i]);
      undoLyr[i] = undoLyr[i-1];
    }
    copyPG2PG(grabPG,undoPG[0]);
    undoLyr[0] = grabLyr;
    grab = true;
  }

  // ...terminate antialias glitch
  if (noGlitch && startGlitch) { finalizeGlitch(); }

  // update swatch of current layer
  livelli[activeLyr].updateLayerSwatch();

  // update undo/redo button
  if (undoLyr[0] == -1) { btnUNDO.s = false; }
  else { btnUNDO.s = true; }
  if (redoLyr[0] == -1) { btnREDO.s = false; }
  else { btnREDO.s = true; }
}
