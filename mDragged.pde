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

    // ALPHA DRAGGED
    else if ((startAction) && (!keyPressed) && (tool=="Alpha") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      int x0 = mouseX;
      int y0 = mouseY;
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      int ll = width*height;
      int dAlpha = (int) slALPHAT.v;
      livelli[activeLyr].pg.loadPixels();
      int rr = brushSize/2;
      for (int x = x0 - rr; x < x0 + rr; x++)
      {
        for (int y = y0 - rr; y < y0 + rr; y++)
        {
          int loc = x+y*width;
          String newPt = String.valueOf(loc);
          if (pts.contains(newPt))
          { } // do nothing (the point is already processed)
          else
          {
            if ((!aSelection) || (aSelection && x>x1sel && x<x2sel && y>y1sel && y<y2sel)) // check active selection
            {
              if ((loc >= 0) && (loc < ll) && ((x - x0)*(x - x0) + (y - y0)*(y - y0) < rr*rr))
              {
                // add new point to hashset
                pts.add(newPt);
                // process point
                color tc = livelli[activeLyr].pg.pixels[loc];
                int ta = (tc >> 24) & 0xff;
                if ( ((cbALPHATT.s) && (ta != 0)) || (!cbALPHATT.s) )
                {
                  ta = constrain(ta + dAlpha,1,255);
                  tc = color((tc >> 16) & 0xFF, (tc >> 8)  & 0xFF, tc & 0xFF, ta);
                  livelli[activeLyr].pg.pixels[loc] = tc;
                }
              }
            }
          }
        }
      }
      livelli[activeLyr].pg.updatePixels();
      livelli[activeLyr].pg.endDraw(); // close active layer PGraphics
    }

    // TOOL01 DRAGGED
    else if ((startAction) && (!keyPressed) && (tool=="Tool01") && (!livelli[activeLyr].ll) && ((!menu) || (x1 > menuX)))
    {
      int x0 = mouseX;
      int y0 = mouseY;
      livelli[activeLyr].pg.beginDraw(); // open active layer PGraphics
      int ll = width*height;
      livelli[activeLyr].pg.loadPixels();
      int rr = brushSize/2;
      for (int x = x0 - rr; x < x0 + rr; x++)
      {
        for (int y = y0 - rr; y < y0 + rr; y++)
        {
          int loc = x+y*width;
          String newPt = String.valueOf(loc);
          if (pts.contains(newPt))
          { } // do nothing (the point is already processed)
          else
          {
            //if ((loc <= ll) && (round(dist(x, y, x0, y0)) < round(brushSize/2.0)))
            if ((loc >= 0) && (loc < ll) && ((x - x0)*(x - x0) + (y - y0)*(y - y0) < rr*rr))
            {
              // add new point to hashset
              pts.add(newPt);
              // process point
              color tc = livelli[activeLyr].pg.pixels[loc];
              int ta = (tc >> 24) & 0xff;
              ta = constrain(ta-10,1,255);
              tc = color((tc >> 16) & 0xFF, (tc >> 8)  & 0xFF, tc & 0xFF, ta);
              livelli[activeLyr].pg.pixels[loc] = tc;
              //livelli[activeLyr].pg.point(x,y);
            }
          }
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

    // check delta alpha slider
    if (tool == "Alpha")
    {
      slALPHAT.onDrag();
    }
    // check delta value slider
    else if (tool == "RGB")
    {
      slRGBT.onDrag();
    }
    // check delta value slider
    else if (tool == "HSB")
    {
      slHSBT.onDrag();
    }
    // check Filler (threshold) slider
    else if (tool == "Filler")
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