class Point
// class Point
{
  int x, y;
  public Point(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
}

// floodFill algorithm
// adapted and enhanced from processing forum code
void floodFill(PGraphics buffer, int orgX, int orgY, int newColor)
{
  float fillTolerance = 0.0;
  int pw = buffer.width;
  int ph = buffer.height;
  buffer.beginDraw();
  buffer.loadPixels();
  int [] pxl = buffer.pixels;
  int orgColor = pxl[orgX + orgY * pw];
  // Do not fill if same colors and stop
  if ((newColor == orgColor))
    return;
  // Proceed with flood fill
  //println("Fill: proceed...");
  Point p = new Point(orgX, orgY);
  // calculate max color tolerance
  fillTolMax = colorDist(orgColor,newColor)-0.1;
  //fillTolMax = colorDist(orgColor,newColor);
  fillTolerance = map(slFILLER.v,0,100,0,fillTolMax);
  //println(fillTolMax,slFILLER.v,fillTolerance);
  q.add(p);
  int west, east;
  while (!q.isEmpty ())
  {
    p = q.removeFirst();
    if (isToFill(p.x, p.y, pxl, pw, ph, orgColor, fillTolerance))
    {
      west = east = p.x;
      while (isToFill(--west, p.y, pxl, pw, ph, orgColor, fillTolerance));
      while (isToFill(++east, p.y, pxl, pw, ph, orgColor, fillTolerance));
      for (int x = west + 1; x < east; x++)
      {
        pxl[x + p.y * pw] = newColor;
        //pxl[x + p.y * pw] = 0x0;
        if (isToFill(x, p.y - 1, pxl, pw, ph, orgColor, fillTolerance))
          q.add(new Point(x, p.y - 1));
        if (isToFill(x, p.y + 1, pxl, pw, ph, orgColor, fillTolerance))
          q.add(new Point(x, p.y + 1));
      }
    }
  }
  buffer.updatePixels();
  buffer.endDraw();
}

// eraseFill: floodFill algorithm used to erase
void eraseFill(PGraphics buffer, int orgX, int orgY, int newColor)
{
  newColor = 0x0;
  float fillTolerance = 0.0;
  int pw = buffer.width;
  int ph = buffer.height;
  buffer.beginDraw();
  buffer.loadPixels();
  int [] pxl = buffer.pixels;
  int orgColor = pxl[orgX + orgY * pw];
  // Do not fill if same colors and stop
  if ((newColor == orgColor))
    return;
  // Proceed with flood fill
  //println("Fill: proceed...");
  Point p = new Point(orgX, orgY);
  // calculate max color tolerance
  fillTolMax = colorDist(orgColor,newColor)-1;
  //fillTolMax = colorDist(orgColor,newColor);
  fillTolerance = map(slFILLER.v,0,100,0,fillTolMax);
  //println(fillTolMax,slFILLER.v,fillTolerance);
  q.add(p);
  int west, east;
  while (!q.isEmpty ())
  {
    p = q.removeFirst();
    if (isToFill(p.x, p.y, pxl, pw, ph, orgColor, fillTolerance))
    {
      west = east = p.x;
      while (isToFill(--west, p.y, pxl, pw, ph, orgColor, fillTolerance));
      while (isToFill(++east, p.y, pxl, pw, ph, orgColor, fillTolerance));
      for (int x = west + 1; x < east; x++)
      {
        pxl[x + p.y * pw] = newColor;
        //pxl[x + p.y * pw] = 0x0;
        if (isToFill(x, p.y - 1, pxl, pw, ph, orgColor, fillTolerance))
          q.add(new Point(x, p.y - 1));
        if (isToFill(x, p.y + 1, pxl, pw, ph, orgColor, fillTolerance))
          q.add(new Point(x, p.y + 1));
      }
    }
  }
  buffer.updatePixels();
  buffer.endDraw();
}

// Returns true if the specified pixel requires filling
boolean isToFill(int px, int py, int[] pxl, int pw, int ph, int orgColor, float fillTol)
{
  float d;
  if ((aSelection) && (px<=x1sel || px>=x2sel || py<=y1sel || py>=y2sel)) // check active selection
    return false;
  if (px < 0 || px >= pw || py < 0 || py >= ph)
    return false;
  if (px < 0 || px >= pw || py < 0 || py >= ph)
    return false;
  // same colors ?
  if (pxl[px + py * pw] == orgColor) { return true; }

  // similar colors ?
  d = colorDist(pxl[px + py * pw], orgColor);
  if (d < fillTol)
  { return true;  }
  else
  { return false; }
}

// calculate distance between two colors
float colorDist(color c1, color c2)
{
  float rmean =(red(c1) + red(c2)) / 2;
  float r = red(c1) - red(c2);
  float g = green(c1) - green(c2);
  float b = blue(c1) - blue(c2);
  return sqrt((int(((512+rmean)*r*r))>>8)+(4*g*g)+(int(((767-rmean)*b*b))>>8));
}
// check if a double is Not a Number (NaN)
boolean isNaN(double x)
{
  return (x != x);
}