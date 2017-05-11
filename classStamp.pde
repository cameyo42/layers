class StampBrushes
{
  // parameters
  int x, y;
  PImage stampBrushes;
  //String m;

  // variables
  int ww; // image width
  int hh; // image height
  int idx; // button pressed index (0..9)
  int posX, posY; // highlight rect upper left coords
  int[] pX = new int[10];
  int[] pY = new int[10];

  // constructor
  StampBrushes(int ix, int iy, PImage _stampBrushes)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    stampBrushes = _stampBrushes; // image of brushes
    //m = im; // method (function)

    // variables
    ww = stampBrushes.width;
    hh = stampBrushes.height;
    idx = 0;
    for(int i = 0; i<10; i++)
    {
      pX[i] = x + 16*i;
      pY[i] = y;
    }
    // highlight current "stampino"
    posX = pX[idx];
    posY = pY[idx];
  }

  boolean isOver()
  {
    return(mouseX>x&&mouseX<x+ww-16&&mouseY>y&&mouseY<y+hh);
  }

  void onClick()
  {
    if (isOver())
    {
      idx = int(map(mouseX, x, x+ww-16, 0, 10));
      userStamp = false;
    }
  }

  void show()
  {
    image(stampBrushes, x, y);
    // highlight selected stamp
    if (userStamp)
    {
      posX = ww - 7;
      posY = y;
    }
    else
    {
      posX = (int)pX[idx];
      posY = (int)pY[idx];
    }
    fill(highLight,128);
    noStroke();
    rect(posX+1,posY+1,15,15);
  }

  void createStampBrush()
  {
    stampPG = createGraphics(brushSize, brushSize);
    stampPG.noSmooth();
    stampPG.beginDraw();
    stampPG.clear();
    stampPG.rectMode(CENTER);
    stampPG.noStroke();
    stampPG.noFill();

    if (idx == 0) // circle filled
    {
      stampPG.fill(brushCol);
      stampPG.ellipse(brushSize/2,brushSize/2,brushSize-1,brushSize-1);
    }
    else if (idx == 1) // circle empty
    {
      stampPG.stroke(brushCol);
      stampPG.ellipse(brushSize/2,brushSize/2,brushSize-1,brushSize-1);
    }
    else if (idx == 2) // rect filled
    {
      stampPG.fill(brushCol);
      stampPG.rect(brushSize/2,brushSize/2,brushSize-1,brushSize-1);
    }
    else if (idx == 3) //rect empty
    {
      stampPG.stroke(brushCol);
      stampPG.rect(brushSize/2,brushSize/2,brushSize-1,brushSize-1);
    }
    else if (idx == 4) // "-" variable
    {
      stampPG.stroke(brushCol);
      // always draw a line at center of brush
      stampPG.line(0, brushSize/2 , brushSize-1, brushSize/2);
      int d = (int)round(map(slSTAMP2.v,1,100,32,2));
      int y1 = brushSize/2 + d;
      int y2 = brushSize/2 - d;
      while(y1 < brushSize)
      {
        stampPG.line(0, y1 , brushSize-1, y1);
        stampPG.line(0, y2 , brushSize-1, y2);
        y1 = y1 + d;
        y2 = y2 - d;
      }
    }
    else if (idx == 5) // "|" variable
    {
      stampPG.stroke(brushCol);
      // always draw a line at center of brush
      stampPG.line(brushSize/2, 0, brushSize/2, brushSize-1);
      int d = (int)round(map(slSTAMP2.v,1,100,32,2));
      int x1 = brushSize/2 + d;
      int x2 = brushSize/2 - d;
      while(x1 < brushSize)
      {
        stampPG.line(x1, 0, x1, brushSize-1);
        stampPG.line(x2, 0, x2, brushSize-1);
        x1 = x1 + d;
        x2 = x2 - d;
      }
    }
    else if (idx == 6) // "/" variable
    {
      stampPG.stroke(brushCol);
      // always draw a line at center of brush
      stampPG.line(brushSize-1,0,0,brushSize-1);
      int d = (int)round(map(slSTAMP2.v,1,100,64,2));
      int x1 = brushSize-1 - d;
      int y1 = 0;
      int x2 = 0;
      int y2 = brushSize-1 - d;
      int x3 = brushSize-1;
      int y3 = d;
      int x4 = d;
      int y4 = brushSize-1;
      while(x1 > 0)
      {
        stampPG.line(x1,y1, x2,y2);
        stampPG.line(x3,y3, x4,y4);
        x1 = x1 - d;
        y2 = y2 - d;
        y3 = y3 + d;
        x4 = x4 + d;
      }
    }
    else if (idx == 7) // "\" variable
    {
      stampPG.stroke(brushCol);
      // always draw a line at center of brush
      stampPG.line(0,0,brushSize-1,brushSize-1);
      int d = (int)round(map(slSTAMP2.v,1,100,64,2));
      int x1 = d;
      int y1 = 0;
      int x2 = brushSize-1;
      int y2 = brushSize-1 - d;
      int x3 = 0;
      int y3 = d;
      int x4 = brushSize-1 - d;
      int y4 = brushSize-1;
      while(x1 < brushSize)
      {
        stampPG.line(x1,y1, x2,y2);
        stampPG.line(x3,y3, x4,y4);
        x1 = x1 + d;
        y2 = y2 - d;
        y3 = y3 + d;
        x4 = x4 - d;
      }
    }
    else if (idx == 8) // random points circle
    {
      // point dimension
      //int r = (int)round(map(brushSize, 1, 64, 1, 4));
      int r=1;
      // density of points (%)
      float d = slSTAMP2.v;
      int numPoint = (int) max(1, 1.5*brushSize*brushSize*d/100.0);
      // println(brushSize,numPoint);
      stampPG.noStroke();
      stampPG.fill(brushCol);
      // always draw an ellipse on the center
      stampPG.ellipse(brushSize/2, brushSize/2,r,r);
      for(int i=0; i<numPoint; i++)
      {
        float x = random(0,brushSize);
        float y = random(0,brushSize);
        if (dist(x,y, brushSize/2.0, brushSize/2.0) < brushSize/2.0 - r)
        { stampPG.ellipse(x,y,r,r); }
      }
    }
    else if (idx == 9) // random points square
    {
      // point dimension
      //int r = (int)round(map(brushSize, 1, 64, 1, 4));
      int r=1;
      // density of points (%)
      float d = slSTAMP2.v;
      int numPoint = (int) max(1, brushSize*brushSize*d/100.0);
      // println(brushSize,numPoint);
      stampPG.noStroke();
      stampPG.fill(brushCol);
      // always draw an ellipse on the center
      stampPG.ellipse(brushSize/2, brushSize/2,r,r);
      for(int i=0; i<numPoint; i++)
      {
        float x = random(0,brushSize);
        float y = random(0,brushSize);
        stampPG.ellipse(x,y,r,r);
      }
    }
    else { println("ERROR: wrong stamp brush index: ", idx); }

    stampPG.rectMode(CORNER);
    stampPG.endDraw();
  }

}