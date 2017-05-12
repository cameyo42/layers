//*********************************
// draw line with bresenham algorithm (ELLIPSE)
void drawLine(int x1, int y1, int x2, int y2, int s, PGraphics pg)
{
  int dx = x2 - x1;
  int dy = y2 - y1;

  int incx = sign(dx);
  int incy = sign(dy);
  dx = abs(dx);
  dy = abs(dy);

  int  pdx, pdy, ddx, ddy, es, el;
  if (dx > dy)
  {
    pdx = incx;
    pdy = 0;
    ddx = incx;
    ddy = incy;
    es  = dy;
    el  = dx;
  }
  else
  {
    pdx = 0;
    pdy = incy;
    ddx = incx;
    ddy = incy;
    es  = dx;
    el  = dy;
  }

  int x = x1;
  int y = y1;
  int err = el/2;
  //if ((!selection) || (selection && x-brushSize/2>x1sel && x+brushSize/2<x2sel+1 && y-brushSize/2>y1sel && y+brushSize/2<y2sel+1)) // check active selection
  {
    pg.ellipse(x, y, s, s);
  }
  for (int k = 0; k < el; k++)
  {
    err -= es;
    if (err < 0)
    {
      err += el;
      x += ddx;
      y += ddy;
    }
    else
    {
      x += pdx;
      y += pdy;
    }
    //if ((!selection) || (selection && x-brushSize/2>x1sel && x+brushSize/2<x2sel+1 && y-brushSize/2>y1sel && y+brushSize/2<y2sel+1)) // check active selection
    {
      pg.ellipse(x, y, s, s);
    }
  }
}
//*********************************
int sign(int val)
{
  return (val > 0) ? 1 : ( (val < 0) ? -1 : 0);
}

//*********************************
// draw line with bresenham algorithm (IMAGES)
void drawLineIMG(int x1, int y1, int x2, int y2, int s, PGraphics pg, PImage img)
{
  int dx = x2 - x1;
  int dy = y2 - y1;

  int incx = sign(dx);
  int incy = sign(dy);
  dx = abs(dx);
  dy = abs(dy);

  int  pdx, pdy, ddx, ddy, es, el;
  if (dx > dy)
  {
    pdx = incx;
    pdy = 0;
    ddx = incx;
    ddy = incy;
    es  = dy;
    el  = dx;
  }
  else
  {
    pdx = 0;
    pdy = incy;
    ddx = incx;
    ddy = incy;
    es  = dx;
    el  = dy;
  }

  int x = x1;
  int y = y1;
  int err = el/2;

  pg.image(img,x-brushSize/2, y-brushSize/2);
  for (int k = 0; k < el; k++)
  {
    err -= es;
    if (err < 0)
    {
      err += el;
      x += ddx;
      y += ddy;
    }
    else
    {
      x += pdx;
      y += pdy;
    }
    pg.image(img,x-brushSize/2, y-brushSize/2);
  }
}

//*********************************
// draw line with bresenham algorithm (PIXELS)
void drawLinePIXEL(int x1, int y1, int x2, int y2, int s, PGraphics pg)
{
  int dx = x2 - x1;
  int dy = y2 - y1;

  int incx = sign(dx);
  int incy = sign(dy);
  dx = abs(dx);
  dy = abs(dy);

  int  pdx, pdy, ddx, ddy, es, el;
  if (dx > dy)
  {
    pdx = incx;
    pdy = 0;
    ddx = incx;
    ddy = incy;
    es  = dy;
    el  = dx;
  }
  else
  {
    pdx = 0;
    pdy = incy;
    ddx = incx;
    ddy = incy;
    es  = dx;
    el  = dy;
  }

  int x = x1;
  int y = y1;
  int err = el/2;
  // fill ellipse with points
  int ll = width*height;
  int rr = s/2;
  stencilIMG.loadPixels();
  for (int xi = x - rr; xi < x + rr; xi++)
  {
    for (int yi = y - rr; yi < y + rr; yi++)
    {
      if ((!selection) || (selection && xi>x1sel && xi<x2sel && yi>y1sel && yi<y2sel)) // check active selection
      {
        int loc = xi+yi*width;
        if ((loc < ll && loc > 0 && xi < width && xi > 0) && ((xi - x) * (xi - x) + (yi - y) * (yi - y) < rr*rr))
        {
          //pg.pixels[loc] = brushCol;

          if ( (stencil) && (xi >= xsten) && (xi < xsten+stencilIMG.width) && (yi >= ysten) && (yi < ysten+stencilIMG.height) )
          {
            //String pt = String.valueOf(loc);
            //if (pts.contains(pt))
            if (((stencilIMG.pixels[(xi-xsten)+(yi-ysten)*stencilIMG.width] >> 24) & 0xff ) == 0) //transparent )
            {
              pg.pixels[loc] = brushCol;
              //println((xi-xsten),(yi-ysten),stencilIMG.pixels[(xi-xsten)+(yi-ysten)*stencilIMG.width]);
              //println("contain");
            }
            //else {println("not contain"); }
          }
          else { pg.pixels[loc] = brushCol; }
        }
      }
    }
  }
  //pg.ellipse(x, y, s, s);
  for (int k = 0; k < el; k++)
  {
    err -= es;
    if (err < 0)
    {
      err += el;
      x += ddx;
      y += ddy;
    }
    else
    {
      x += pdx;
      y += pdy;
    }
    // fill ellipse with points
    for (int xi = x - rr; xi < x + rr; xi++)
    {
      for (int yi = y - rr; yi < y + rr; yi++)
      {
        if ((!selection) || (selection && xi>x1sel && xi<x2sel && yi>y1sel && yi<y2sel)) // check active selection
        {
          int loc = xi+yi*width;
          if ((loc < ll && loc > 0 && xi < width && xi > 0) && ((xi - x) * (xi - x) + (yi - y) * (yi - y) < rr*rr))
          {
            //pg.pixels[loc] = brushCol;
            if ( (stencil) && (xi >= xsten) && (xi < xsten+stencilIMG.width) && (yi >= ysten) && (yi < ysten+stencilIMG.height) )
            {
              //String pt = String.valueOf(loc);
              //if (pts.contains(pt))
              if (((stencilIMG.pixels[(xi-xsten)+(yi-ysten)*stencilIMG.width] >> 24) & 0xff ) == 0) //transparent )              
              {
                pg.pixels[loc] = brushCol;
                //println("contain");
              }
              //else {println("not contain"); }
            }
            else { pg.pixels[loc] = brushCol; }
          }
        }
      }
    }
    //pg.ellipse(x, y, s, s);
  }
}

