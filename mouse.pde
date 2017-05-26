//*********************************
void mousePressed()
//*********************************
{
  x2 = mouseX;
  y2 = mouseY;
  x1 = pmouseX;
  y1 = pmouseY;

  if (mouseButton == LEFT)
  {
    // WEB PRESSED
    if ((!keyPressed) && (tool=="Web") && (!eraseW) && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noFill();
      livelli[activeLyr].pg.stroke(brushCol);
      livelli[activeLyr].pg.strokeWeight(brushSize);
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      attractionW = slWEBA.v;
      densityW = slWEBD.v/100.0;
      typeW = (int) sbWEBT.v;
      jitterW = (int) sbWEBJ.v;
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // WEB ERASE PRESSED
    else if ((!keyPressed) && (tool=="Web") && (eraseW) && ((!menu) || (x1 > menuX)))
    {
      for (int p=cobweb.size()-1; p >= 0 ; p--) // erase point from cobweb
      {
        PVector v = cobweb.get(p);
        if ((v.x > x2-brushSize/2) && (v.x < x2+brushSize/2) && (v.y > y2-brushSize/2) && (v.y < y2+brushSize/2))
        {
          if ((!aSelection) || (aSelection && v.x>x1sel && v.x<x2sel+1 && v.y>y1sel && v.y<y2sel+1)) // check active selection
          {
            cobweb.remove(p);
          }
        }
      }
    }

    // CONFETTI PRESSED
    else if ((!keyPressed) && (tool=="Confetti") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      // reset Confetti arrayList
      confettiThings.clear();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // DYNA PRESSED
    else if ((!keyPressed) && (tool=="Dyna") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      // reset Dyna parameters
      myDD.px = mouseX;
      myDD.py = mouseY;
      myDD.ppx = mouseX;
      myDD.ppy = mouseY;
      myDD.vx = 0;
      myDD.vy = 0;
      myDD.old_brush = myDD.min_brush;
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // LINER PRESSED
    else if ((!keyPressed) && (tool=="Liner") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      lineDown = true;
      x1L = x2;   y1L = y2;
      x2L = x1L;  y2L = y1L;
    }

    // QUAD PRESSED
    else if ((!keyPressed) && (tool=="Quad") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      quadDown = true;
      x1L = x2;   y1L = y2;
      x2L = x1L;  y2L = y1L;
    }

    // CIRCLED PRESSED
    else if ((!keyPressed) && (tool=="Circle") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      circleDown = true;
      x1L = x2;  y1L = y2;
      x2L = x1L;  y2L = y1L;
    }

    // SELECTION PRESSED
    else if ((!keyPressed) && (tool=="Select") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      selectDown = true;
      aSelection = false;
      x1L = x2;  y1L = y2;
      x2L = x1L;  y2L = y1L;
    }

    // PENCIL PRESSED
    else if ((!keyPressed) && (tool=="Pencil") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      drawLine(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg); // draw on active layer
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // SHAPE PRESSED
    else if ((!keyPressed) && (tool=="Shape") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      livelli[activeLyr].pg.stroke(brushCol);
      livelli[activeLyr].pg.noFill();
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection

      color shColor;
      int numItems = (int) slSHitems.v;
      livelli[activeLyr].pg.rectMode(CENTER);
      livelli[activeLyr].pg.shapeMode(CENTER);
      for (int i = 0; i < numItems; i++)
      {
        int posX = x2 + (int) (round(random(-slSHposD.v, +slSHposD.v)));
        int posY = y2 + (int) (round(random(-slSHposD.v, +slSHposD.v)));
        int bSizeH = brushSize + (int) (round(random(-slSHsizeD.v, +slSHsizeD.v)));
        int bSizeV = brushSize + (int) (round(random(-slSHsizeD.v, +slSHsizeD.v)));
        int bAlfa = alfa + (int) (round(random(-slSHalfaD.v, +slSHalfaD.v)));
        if (cbSHcolorRND.s)
        {
          shColor = randomColor();
          shColor = color((shColor >> 16) & 0xFF, (shColor >> 8)  & 0xFF, shColor & 0xFF, bAlfa);
        }
        else
        {
          shColor = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, bAlfa);
        }
        livelli[activeLyr].pg.stroke(shColor);
        // draw on active layer
        switch((int)sbSHtype.v)
        {
          case 1: // rectangle
            livelli[activeLyr].pg.rect(posX, posY, bSizeH, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            break;
          case 2: // square
            livelli[activeLyr].pg.rect(posX, posY, bSizeH, bSizeH);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            break;
          case 3: // ellipse
            livelli[activeLyr].pg.ellipse(posX, posY, bSizeH, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            break;
          case 4: // circle
            livelli[activeLyr].pg.ellipse(posX, posY, bSizeV, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            break;
          case 5: // user svg
            int dimX = (int) aShape.width*bSizeH/brushSizeMax;
            int dimY = (int) aShape.height*bSizeH/brushSizeMax;
            livelli[activeLyr].pg.shape(aShape, posX, posY, dimX, dimY);
            break;
        } //end switch
      }

      livelli[activeLyr].pg.rectMode(CORNER);
      livelli[activeLyr].pg.shapeMode(CORNER);
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // ERASER PRESSED
    else if ((!keyPressed) && (tool=="Eraser") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      if (grab) { grabLayer(); }  // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(0,0,0,0);
      livelli[activeLyr].pg.blendMode(REPLACE);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      drawLine(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg); // draw/erase on active layer
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLine(s1x,s1y,s2x,s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLine(s1x,s1y,s2x,s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLine(s1x,s1y,s2x,s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // VERNICE PRESSED
    else if ((!keyPressed) && (tool=="Vernice" || tool == "Stencil") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      int x0 = mouseX;
      int y0 = mouseY;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      // if (noGlitch) { prepareGlitch(); } // No antialias with this tool :-)
      livelli[activeLyr].pg.loadPixels();
      drawLinePIXEL(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg);
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
      livelli[activeLyr].pg.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // INK PRESSED
    else if ((!keyPressed) && (tool=="Ink") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      int x0 = mouseX;
      int y0 = mouseY;
      if (grab) { grabLayer(); } // grab layer for Undo
      //livelli[activeLyr].pg.noSmooth();
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      myIB.clear();
      myIB.clearPolys();
      myIB.addPoint(x0, y0);
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // STAMP PRESSED
    else if ((!keyPressed) && (tool=="Stamp") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      xs0 = mouseX;
      ys0 = mouseY;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      if (!userStamp) { mySB.createStampBrush(); }
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      livelli[activeLyr].pg.image(stampPG, xs0-brushSize/2,ys0-brushSize/2);
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // MIXER PRESSED
    else if ((!keyPressed) && (tool=="Mixer") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      xs0 = mouseX;
      ys0 = mouseY;
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      // create mixer brush
      mixer_alpha = (int)slMIXERA.v;
      mixer_decay = (int)slMIXERD.v;
      mixer = livelli[activeLyr].pg.get(xs0-brushSize/2,ys0-brushSize/2,brushSize,brushSize);
      if (noGlitch) { prepareGlitch(); } // Start antialias...
      // create mixer brush
      mixer.loadPixels();
      int cx = mixer.width/2;
      int cy = mixer.height/2;
      int loc = 0;
      for (int x = 0; x < brushSize; x++)
      {
        for (int y = 0; y < brushSize; y++)
        {
          if (dist(x,y,cx,cy) >= brushSize/2)
          {
            loc = x + y * mixer.width;
            mixer.pixels[loc] = 0x0;
          }
        }
      }
      mixer.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // FILLER PRESSED
    else if ((!keyPressed) && (tool=="Filler") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      if (!cbFILLERASE.s) // fill area
      {
        // do not fill if same colors
        if (brushCol != livelli[activeLyr].pg.get(mouseX,mouseY))
        {
          startAction = true;
          if (grab) { grabLayer(); }  // grab layer for Undo
          // Flood fill area of active layer with current color
          floodFill(livelli[activeLyr].pg, mouseX, mouseY, brushCol);
          mousePressed = false;
        }
        else { println("no fill: SAME COLORS"); }
      }
      else // erase area
      {
          if (((livelli[activeLyr].pg.get(mouseX,mouseY) >> 24) & 0xff ) != 0) // not transparent
          {
            startAction = true;
            if (grab) { grabLayer(); }  // grab layer for Undo
            // Flood fill area of active layer with current color
            floodFill(livelli[activeLyr].pg, mouseX, mouseY, 0x0);
            mousePressed = false;
          }
          else { println("no erase: ALREADY ERASED"); }
      }
    }

    // CLONE PRESSED (LEFT BUTTON)
    else if ((!keyPressed) && (tool=="Clone") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      startAction = true;
      x2 = mouseX;
      y2 = mouseY;
      if (cloneGap)
      {
        gapX = x2 - cloneX;
        gapY = y2 - cloneY;
        cloneGap = true;
      }
      if (grab) { grabLayer(); } // grab layer for Undo
    }
  } // LEFT mouse if

  else if (mouseButton == RIGHT)
  {
    // CLONE PRESSED (RIGHT BUTTON)
    if ((!keyPressed) && (tool=="Clone") && (!livelli[activeLyr].ll) && !myHSB.isOver() && ((!menu) || (x1 > menuX)))
    {
      cloneX = mouseX;
      cloneY = mouseY;
      cloneGap = true;
      gapX = mouseX - cloneX;
      gapY = mouseY - cloneY;
    }
    // STAMP PRESSED (RIGHT BUTTON) (userStamp)
    else if ((!keyPressed) && (tool=="Stamp") && (!livelli[activeLyr].ll) && !myHSB.isOver() && ((!menu) || (x1 > menuX)))
    {
      xs0 = mouseX;
      ys0 = mouseY;
      userStamp = true;
      int locLyr, locStamp;
      int locLyrMax = width*height;
      int locStampMax = brushSize*brushSize;
      stampPG = createGraphics(brushSize, brushSize);
      stampPG.noSmooth();
      stampPG.beginDraw();
      stampPG.clear();
      stampPG.loadPixels();
      livelli[activeLyr].pg.loadPixels();

      // clone image under cursor on stampPG
      for (int y = ys0-brushSize/2; y < ys0+brushSize/2; y++)
      {
        for (int x = xs0-brushSize/2; x < xs0+brushSize/2; x++)
        {
          locLyr = x + y*width;
          locStamp = (x - (xs0-brushSize/2)) + (y- (ys0-brushSize/2))*brushSize;
          if (locLyr > 0 && locLyr < locLyrMax && locStamp > 0 && locStamp < locStampMax)
          {
            if (livelli[activeLyr].pg.pixels[locLyr] != 0x0)
            {
              { stampPG.pixels[locStamp] = livelli[activeLyr].pg.pixels[locLyr]; }
            }
          }
        }
      }
      //livelli[activeLyr].pg.updatePixels();
      stampPG.updatePixels();
      stampPG.endDraw();
    }
  } // RIGHT mouse if

  // PICK COLOR PRESSED
  if (keyPressed && mousePressed && picker && !myHSB.isOver()) // pick color from active layer
  {
    color pickCol;
    if (mouseButton == RIGHT)
    {
     pickCol = livelli[activeLyr].pg.get(mouseX,mouseY);
    }
    else
    {
      pickCol = get(mouseX,mouseY);
    }
    brushCol = color(pickCol,alfa);
    rgbhsb.setRGBHSB(brushCol);
    myHSB.updateHSB("HSB");
    picker = false;
  }

  // MENU PRESSED
  if (menu)
  {
    // check layer icons pressed
    for(int i = 0; i < livelli.length; i++)
    {
      livelli[i].onClickIcon();
      livelli[i].onClickTransp();
    }
    controlloLivelli.onClick();
    // check pressed on RGB-SHB control
    rgbhsb.onClick();
    // check on palette page pressed
    tavolozza.onClick();
    // check button tools
    btnPENCIL.onClick();
    btnLINER.onClick();
    btnLOCK.onClick();
    btnQUAD.onClick();
    btnCIRCLE.onClick();
    btnERASER.onClick();
    btnSELECT.onClick();
    btnSTENCIL.onClick();
    btnVERNICE.onClick();
    btnINK.onClick();
    btnSTAMP.onClick();
    btnMIXER.onClick();
    btnDYNA.onClick();
    btnFILLER.onClick();
    btnCLONE.onClick();
    btnWEB.onClick();
    btnCONFETTI.onClick();
    btnSHAPE.onClick();
    btGRID.onClick();
    // open & save
    btOPENLYR.onClick();
    btOPEN.onClick();
    btSAVE.onClick();
    // undo/redo
    btnUNDO.onClick();
    btnREDO.onClick();
    // check Brush size slider
    slSIZE.onClick();
    // check Alfa slider
    slALFA.onClick();
    // check X,Y symmetry checkbox
    cbSYMX.onClick();
    cbSYMY.onClick();
    // check no Glitch checkbox
    cbGLITCH.onClick();
    // check grid checkbox
    sbGRIDX.onClick();
    sbGRIDY.onClick();
    cbGRID.onClick();
    cbSNAP.onClick();

    // check Filler options
    if (tool == "Filler")
    {
      slFILLER.onClick();
      cbFILLERASE.onClick();
    }
    // check Clone options
    else if (tool == "Clone")
    {
      cbCLONE.onClick();
    }
    // check Mixer options
    else if (tool == "Mixer")
    {
      slMIXERA.onClick();
      slMIXERD.onClick();
    }
    // check Stamp options
    else if (tool == "Stamp")
    {
      mySB.onClick();
      slSTAMP.onClick();
      slSTAMP2.onClick();
    }
    // check Web options
    else if (tool == "Web")
    {
      slWEBA.onClick();
      slWEBD.onClick();
      btWEB.onClick();
      sbWEBT.onClick();
      sbWEBJ.onClick();
      cbWEBE.onClick();
      cbWEBP.onClick();
    }
    // check dyna options
    else if (tool == "Dyna")
    {
      dslHOOKE.onClick();
      dslDAMPING.onClick();
      dslDUCTUS.onClick();
      dslMASS.onClick();
      dslMINB.onClick();
      dslMAXB.onClick();
      btnPRE01.onClick();
      btnPRE02.onClick();
      btnPRE03.onClick();
      btnPRE04.onClick();
      btnPRE05.onClick();
      btnPRE06.onClick();
      btnPRE07.onClick();
      btnPRE08.onClick();
    }
    // check Select options
    else if (tool == "Select")
    {
      cbSELECT.onClick();
      btSELCOPY.onClick();
      btSELPASTE.onClick();
      btSELDRAW.onClick();
      cbSELOUT.onClick();
    }
    // check Stencil options
    else if (tool == "Stencil")
    {
      cbSTENCIL.onClick();
      btSTENLOAD.onClick();
      btSTENCENTER.onClick();
      btSTENCREA.onClick();
      btSTENINVERT.onClick();
    }
    // check Confetti Options
    else if (tool == "Confetti")
    {
      cbCONFSCALE.onClick();
      cbCONFRND.onClick();
      slCONFVEL.onClick();
      slCONFDVEL.onClick();
    }
    // check Shape Options
    else if (tool == "Shape")
    {
      slSHitems.onClick();
      slSHsizeD.onClick();
      slSHalfaD.onClick();
      slSHposD.onClick();
      cbSHcolorRND.onClick();
      cbSHstyle.onClick();
      sbSHtype.onClick();
    }

    // check background button
    btcBACKCOL.onClick();
  }

  // HSB pressed
  if (toolHSB)
  {
    myHSB.onClick();
  }
}

//*********************************
void mouseDragged()
//*********************************
{
  x2 = mouseX;
  y2 = mouseY;
  x1 = pmouseX;
  y1 = pmouseY;

  if (mouseButton == LEFT)
  {
    // CHANGE BRUSH SIZE
    if (keyPressed && (keyCode==CONTROL || keyCode==ALT)) // use ALT for mac OSX
    {
      if ((!menu || (menu && mouseX > menuX)) && (pmouseX < mouseX))
      {
        brushSize = constrain(++brushSize, brushSizeMin, brushSizeMax);
        slSIZE.v = brushSize; // update slider SIZE
      }
      if ((!menu || (menu && mouseX > menuX)) && (pmouseX > mouseX))
      {
        brushSize = constrain(--brushSize, brushSizeMin, brushSizeMax);
        slSIZE.v = brushSize; // update slider SIZE
      }
    }

    // WEB DRAGGED
    else if ((!keyPressed) && (tool=="Web") && (!eraseW) && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      if (typeW == 0) // simple pencil
      {
        livelli[activeLyr].pg.line(x1, y1, x2,y2);
        if (symX) // draw symmetry from X axis
        {
          calcSymX(x1,y1,x2,y2);
          livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
        }
        if (symY) // draw symmetry from Y axis
        {
          calcSymY(x1,y1,x2,y2);
          livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
        }
        if(symX && symY) // draw symmetry from center point (opposite)
        {
          calcSymXY(x1,y1,x2,y2);
          livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
        }
      }
      else
      {
        // add the current mouse point
        PVector d = new PVector(x2, y2, 0);
        cobweb.add(0, d);
        updateWeb = true;
        // draw web
        for (int p=0; p<cobweb.size(); p++)
        {
          //PVector v = (PVector) cobweb.get(p);
          PVector v = cobweb.get(p);
          float joinchance = p/cobweb.size() + d.dist(v)/attractionW;
          if (jitterW != 0)
          {
            d.x = d.x + random(-jitterW, jitterW);
            d.y = d.y + random(-jitterW, jitterW);
            v.x = v.x + random(-jitterW, jitterW);
            v.y = v.y + random(-jitterW, jitterW);
          }
          if (joinchance < random(densityW))
          {
            if (typeW == 1) // line web
            {
              livelli[activeLyr].pg.line(d.x, d.y, v.x, v.y);
              if (symX) // draw symmetry from X axis
              {
                calcSymX(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
              }
              if (symY) // draw symmetry from Y axis
              {
                calcSymY(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
              }
              if(symX && symY) // draw symmetry from center point (opposite)
              {
                calcSymXY(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.line(s1x, s1y, s2x, s2y);
              }
            }
            else if (typeW == 2) // quad web
            {
              livelli[activeLyr].pg.quad(d.x, d.y, v.x,d.y, v.x,v.y, d.x,v.y);
              if (symX) // draw symmetry from X axis
              {
                calcSymX(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.quad(s1x, s1y, s2x, s1y, s2x, s2y, s1x, s2y);
              }
              if (symY) // draw symmetry from Y axis
              {
                calcSymY(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.quad(s1x, s1y, s2x, s1y, s2x, s2y, s1x, s2y);
              }
              if(symX && symY) // draw symmetry from center point (opposite)
              {
                calcSymXY(d.x, d.y, v.x, v.y);
                livelli[activeLyr].pg.quad(s1x, s1y, s2x, s1y, s2x, s2y, s1x, s2y);
              }
            }
            else if (typeW == 3) // ellipse web
            {
              float dd = dist(d.x,d.y,v.x,v.y);
              livelli[activeLyr].pg.ellipse((d.x+v.x)/2,(d.y+v.y)/2,dd,dd);
              if (symX) // draw symmetry from X axis
              {
                calcSymX(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                livelli[activeLyr].pg.ellipse((s1x+s2x)/2,(s1y+s2y)/2,ss,ss);
                //drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
              }
              if (symY) // draw symmetry from Y axis
              {
                calcSymY(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                livelli[activeLyr].pg.ellipse((s1x+s2x)/2,(s1y+s2y)/2,ss,ss);
                //drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
              }
              if(symX && symY) // draw symmetry from center point (opposite)
              {
                calcSymXY(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                livelli[activeLyr].pg.ellipse((s1x+s2x)/2,(s1y+s2y)/2,ss,ss);
                //drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
              }
            }
            else if (typeW == 4) //bezier web
            {
              livelli[activeLyr].pg.bezier(d.x,d.y, v.x,d.y, d.x,v.y, v.x,v.y);
              livelli[activeLyr].pg.bezier(d.x,d.y, d.x,v.y, v.x,d.y, v.x,v.y);
              livelli[activeLyr].pg.bezier(d.x,d.y, d.x,v.y, v.x,v.y, v.x,d.y);
              if (symX) // draw symmetry from X axis
              {
                calcSymX(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                //livelli[activeLyr].pg.ellipse((s1x+s2x)/2,(s1y+s2y)/2,ss,ss);
                livelli[activeLyr].pg.bezier(s1x,s1y, s2x,s1y, s1x,s2y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s1y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s2y, s2x,s1y);
                //drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
              }
              if (symY) // draw symmetry from Y axis
              {
                calcSymY(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s2x,s1y, s1x,s2y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s1y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s2y, s2x,s1y);
                //drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
              }
              if(symX && symY) // draw symmetry from center point (opposite)
              {
                calcSymXY(d.x,d.y,v.x,v.y);
                float ss = dist(s1x, s1y, s2x, s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s2x,s1y, s1x,s2y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s1y, s2x,s2y);
                livelli[activeLyr].pg.bezier(s1x,s1y, s1x,s2y, s2x,s2y, s2x,s1y);
              }
            }
          }
        }
      }
      //livelli[activeLyr].pg.strokeWeight(1);      
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // WEB ERASE DRAGGED
    else if ((!keyPressed) && (tool=="Web") && (eraseW) && ((!menu) || (x1 > menuX)))
    {
      for (int p=cobweb.size()-1; p >= 0 ; p--)
      {
        PVector v = cobweb.get(p);
        if ((v.x > x2-brushSize/2) && (v.x < x2+brushSize/2) && (v.y > y2-brushSize/2) && (v.y < y2+brushSize/2))
        {
          if ((!aSelection) || (aSelection && v.x>x1sel && v.x<x2sel+1 && v.y>y1sel && v.y<y2sel+1)) // check active selection
          {
            cobweb.remove(p);
          }
        }
      }
      updateWeb = true;
    }

    // STAMP DRAGGED
    else if ((!keyPressed) && (tool=="Stamp") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      xs1 = mouseX;
      ys1 = mouseY;
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      float curDist = dist(xs0,ys0,xs1,ys1);
      int gap = (int) slSTAMP.v;
      if (curDist > gap)
      {
        // calculate correct stamp position
        // Given a segment with start point A (S0) and end point C (S1),
        // how do I find the point B (xx,yy) on the line segment between A and C
        // that is located at a distance dd (gap) from A?
        // A-----------B--------C
        //  <---dd---->
        int xx = (int)round(xs0 + (gap * (xs1 - xs0)/curDist));
        int yy = (int)round(ys0 + (gap * (ys1 - ys0)/curDist));
        //println(xx,yy,xs1,ys1);
        livelli[activeLyr].pg.image(stampPG, xx-brushSize/2,yy-brushSize/2);
        xs0 = xx;
        ys0 = yy;
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // MIXER DRAGGED
    else if ((!keyPressed) && (tool=="Mixer") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      xs1 = mouseX;
      ys1 = mouseY;
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      float curDist = dist(xs0,ys0,xs1,ys1);
      int gap = 1;
      if (curDist > gap)
      {
        int xx = (int)round(xs0 + (gap * (xs1 - xs0)/curDist));
        int yy = (int)round(ys0 + (gap * (ys1 - ys0)/curDist));
        mixer_alpha = constrain(mixer_alpha - mixer_decay, 0, 255);
        mixer.loadPixels();
        for(int i=0; i<mixer.pixels.length; i++)
        {
          if (mixer.pixels[i] != 0x0)
          {
            color c = mixer.pixels[i];
            int a = (c >> 24) & 0xFF;
            int r = (c >> 16) & 0xFF;
            int g = (c >> 8) & 0xFF;
            int b = c & 0xFF;
            a = a*mixer_alpha/255;
            //println(a, mixer_alpha);
            mixer.pixels[i] = color(r,g,b,a);
          }
        }
        mixer.updatePixels();
        if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
        // draw mixer brush
        livelli[activeLyr].pg.image(mixer, xx-brushSize/2, yy-brushSize/2);
        xs0 = xx;
        ys0 = yy;
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // INK DRAGGED
    else if ((!keyPressed) && (tool=="Ink") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      int x0 = mouseX;
      int y0 = mouseY;
      int minMove = 3; // Minimum distance for a new point of Ink brush
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      if (myIB.distToLast(x0, y0) > minMove && x0 > 0 && x0 < width && y0 > 0 && y0 <height)
      {
        myIB.addPoint(x0, y0);
        myIB.smoothPoints();
        myIB.path2Polys();
        renderInkBrushPG(myIB, width, height, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // DYNA DRAGGED
    else if ((!keyPressed) && (tool=="Dyna") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      // The paint of Dyna brush is coded within draw() function
    }

    // CONFETTI DRAGGED
    else if ((!keyPressed) && (tool=="Confetti") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      spawn();
      // confetti tool drawing
      if (confettiThings.size() > 0)
      {
        //println("dragged");
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

    // PENCIL DRAGGED
    else if ((startAction) && (!keyPressed) && (tool=="Pencil") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(brushCol);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      drawLine(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg);  // draw on active layer
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // SHAPE DRAGGED
    else if ((startAction) && (!keyPressed) && (tool=="Shape") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.stroke(brushCol);
      livelli[activeLyr].pg.noFill();
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection

      color shColor;
      int numItems = (int) slSHitems.v;
      livelli[activeLyr].pg.rectMode(CENTER);
      livelli[activeLyr].pg.shapeMode(CENTER);
      for (int i = 0; i < numItems; i++)
      {
        int posX = x2 + (int) (round(random(-slSHposD.v, +slSHposD.v)));
        int posY = y2 + (int) (round(random(-slSHposD.v, +slSHposD.v)));
        int bSizeH = brushSize + (int) (round(random(-slSHsizeD.v, +slSHsizeD.v)));
        int bSizeV = brushSize + (int) (round(random(-slSHsizeD.v, +slSHsizeD.v)));
        int bAlfa = alfa + (int) (round(random(-slSHalfaD.v, +slSHalfaD.v)));
        if (cbSHcolorRND.s)
        {
          shColor = randomColor();
          shColor = color((shColor >> 16) & 0xFF, (shColor >> 8)  & 0xFF, shColor & 0xFF, bAlfa);
        }
        else
        {
          shColor = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, bAlfa);
        }
        livelli[activeLyr].pg.stroke(shColor);
        // draw on active layer
        switch((int)sbSHtype.v)
        {
          case 1: // rectangle
            livelli[activeLyr].pg.rect(posX, posY, bSizeH, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeV);
            }
            break;
          case 2: // square
            livelli[activeLyr].pg.rect(posX, posY, bSizeH, bSizeH);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.rect(s1x, s1y, bSizeH, bSizeH);
            }
            break;
          case 3: // ellipse
            livelli[activeLyr].pg.ellipse(posX, posY, bSizeH, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeH, bSizeV);
            }
            break;
          case 4: // circle
            livelli[activeLyr].pg.ellipse(posX, posY, bSizeV, bSizeV);
            if (symX)
            {
              calcSymX(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            if (symY) // draw symmetry from Y axis
            {
              calcSymY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            if(symX && symY) // draw symmetry from center point (opposite)
            {
              calcSymXY(posX, posY, posX, posY);
              livelli[activeLyr].pg.ellipse(s1x, s1y, bSizeV, bSizeV);
            }
            break;
          case 5: // user svg
            int dimX = (int) aShape.width*brushSize/brushSizeMax;
            int dimY = (int) aShape.height*brushSize/brushSizeMax;
            livelli[activeLyr].pg.shape(aShape, posX, posY, dimX, dimY);
            break;
        } //end switch
      }

      livelli[activeLyr].pg.rectMode(CORNER);
      livelli[activeLyr].pg.shapeMode(CORNER);
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // LINER DRAGGED
    else if ((!keyPressed) && (tool=="Liner") && (lineDown) && ((!menu) || (x1 > menuX)))
    {
      x2L = mouseX;
      y2L = mouseY;
    }

    // QUAD DRAGGED
    else if ((!keyPressed) && (tool=="Quad") && (quadDown) && ((!menu) || (x1 > menuX)))
    {
      x2L = mouseX;
      y2L = mouseY;
    }

    // CIRCLE DRAGGED
    else if ((!keyPressed) && (tool=="Circle") && (circleDown) && ((!menu) || (x1 > menuX)))
    {
      x2L = mouseX;
      y2L = mouseY;
    }

    // SELECT DRAGGED
    else if ((!keyPressed) && (tool=="Select") && (selectDown) && ((!menu) || (x1 > menuX)))
    {
      x2L = mouseX;
      y2L = mouseY;
    }

    // VERNICE DRAGGED
    if ((!keyPressed) && (tool=="Vernice" || tool == "Stencil") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      int x0 = mouseX;
      int y0 = mouseY;
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.loadPixels();
      drawLinePIXEL(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg);
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLinePIXEL(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // ERASER DRAGGED
    else if ((startAction) && (!keyPressed) && (tool=="Eraser") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      // erase at mouse cursor (no alpha channel)
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.noStroke();
      livelli[activeLyr].pg.fill(0,0,0,0);
      livelli[activeLyr].pg.blendMode(REPLACE);
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      drawLine(x1,y1,x2,y2, brushSize, livelli[activeLyr].pg);
      if (symX) // draw symmetry from X axis
      {
        calcSymX(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if (symY) // draw symmetry from Y axis
      {
        calcSymY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      if(symX && symY) // draw symmetry from center point (opposite)
      {
        calcSymXY(x1,y1,x2,y2);
        drawLine(s1x, s1y, s2x, s2y, brushSize, livelli[activeLyr].pg);
      }
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // CLONE DRAGGED
    else if ((!keyPressed) && (tool=="Clone") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      x2 = mouseX;
      y2 = mouseY;
      if (cloneGap)
      {
        gapX = x2 - cloneX;
        gapY = y2 - cloneY;
        cloneGap = false;
      }
      if (grab) { grabLayer(); } // grab layer for Undo
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      livelli[activeLyr].pg.loadPixels();
      int loc = 0;
      int locBase = 0;
      int lMax = width*height;
      for (int x = x2 - brushSize/2; x < x2 + brushSize/2; x++)
      {
        for (int y = y2 - brushSize/2; y < y2 + brushSize/2; y++)
        {
          if ((!aSelection) || (aSelection && x>x1sel && x<x2sel && y>y1sel && y<y2sel)) // check active selection
          {
            if (dist(x,y,x2,y2) <= brushSize/2)
            {
              loc = x + y*width;
              locBase = (x-gapX) + (y-gapY)*width;
              if (loc > 0 && loc < lMax && locBase >0 && locBase < lMax)
              {
                if (livelli[activeLyr].pg.pixels[locBase] != 0x0)
                {
                  {livelli[activeLyr].pg.pixels[loc] = livelli[activeLyr].pg.pixels[locBase];}
                }
              }
            }
          } // selection
        }
      }
      livelli[activeLyr].pg.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }
  } // LEFT mouse if

  // MENU DRAGGED
  if (menu)
  {
    // check Layer transparency slider
    for(int i = 0; i < livelli.length; i++)
    {
      livelli[i].onDragTransp();
    }
    // check Brush slider
    slSIZE.onDrag();
    // check Alfa slider
    slALFA.onDrag();
    // check Filler (threshold) slider
    if (tool == "Filler")
    {
      slFILLER.onDrag();
    }
    // check Dyna slider
    else if (tool == "Dyna")
    {
      dslHOOKE.onDrag();
      dslDAMPING.onDrag();
      dslDUCTUS.onDrag();
      dslMASS.onDrag();
      dslMINB.onDrag();
      dslMAXB.onDrag();
    }
    // check Mixer slider
    else if (tool == "Mixer")
    {
      slMIXERA.onDrag();
      slMIXERD.onDrag();
    }
    // check Stamp slider
    else if (tool == "Stamp")
    {
      slSTAMP.onDrag();
      slSTAMP2.onDrag();
    }
    // check Web slider
    else if (tool == "Web")
    {
      slWEBA.onDrag();
      slWEBD.onDrag();
    }
    // check Confetti Options
    else if (tool == "Confetti")
    {
      slCONFVEL.onDrag();
      slCONFDVEL.onDrag();
    }
    // check Shape Options
    else if (tool == "Shape")
    {
      slSHitems.onDrag();
      slSHsizeD.onDrag();
      slSHalfaD.onDrag();
      slSHposD.onDrag();
    }
  }

  // HSB dragged
  if (toolHSB)
  {
    myHSB.onDrag();
  }
}

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
