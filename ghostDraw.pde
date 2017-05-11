//*********************************
void ghostLine()
{
  noFill();
  stroke(pointerCol);
  if (snap2Grid)
  {
    x1L = gridX * (int)round((float)x1L / gridX);
    y1L = gridY * (int)round((float)y1L / gridY);
    x2L = gridX * (int)round((float)x2L / gridX);
    y2L = gridY * (int)round((float)y2L / gridY);
  }
  //println(x1L,y1L,x2L,y2L);
  line(x1L, y1L, x2L, y2L);
  if (symX) // draw symmetry from X axis
  {
    calcSymX(x1L,y1L,x2L,y2L);
    line(s1x, s1y, s2x, s2y);
  }
  if (symY) // draw symmetry from Y axis
  {
    calcSymY(x1L,y1L,x2L,y2L);
    line(s1x, s1y, s2x, s2y);
  }
  if(symX && symY) // draw symmetry from center point (diagonal)
  {
    calcSymXY(x1L,y1L,x2L,y2L);
    line(s1x, s1y, s2x, s2y);
  }
  fill(pointerCol);
  textAlign(CENTER,CENTER);
  int dd = int(round(dist(x1L, y1L, x2L, y2L)));
  //text(dd, (x1L+x2L)/2, (y1L+y2L)/2 - 10);
  // angle aa: 0 -> 360 ccw
  int aa = -int(round(degrees(atan2(y2L-y1L, x2L-x1L))));
  if (aa < 0) { aa += 360; }
  text(dd + " [" + aa + "]", (x1L+x2L)/2, (y1L+y2L)/2 - 10);
}
//*********************************
void ghostQuad()
{
  noFill();
  stroke(pointerCol);
  if (quadLock) // draw ghost square
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
    rect(qx1,qy1, qx2 - qx1, qy2 - qy1);
    if (symX) // draw symmetry from X axis
    {
      calcSymX(qx1,qy1,qx2,qy2);
      rect(s1x, s1y, s2x - s1x, s2y - s1y);
    }
    if (symY) // draw symmetry from Y axis
    {
      calcSymY(qx1,qy1,qx2,qy2);
      rect(s1x, s1y, s2x - s1x, s2y - s1y);
    }
    if(symX && symY) // draw symmetry from center point (diagonal)
    {
      calcSymXY(qx1,qy1,qx2,qy2);
      rect(s1x, s1y, s2x - s1x, s2y - s1y);
    }
    fill(pointerCol);
    if (x2L>x1L)
    {
      textAlign(RIGHT);
      text(int(round(dd)), x1L - 10, y1L);
    }
    else
    {
      textAlign(LEFT);
      text(int(round(dd)) , x1L + 10, y1L);
    }
  }
  else // draw ghost rectangle
  {
    if (snap2Grid)
    {
      x1L = gridX * (int)round((float)x1L / gridX);
      y1L = gridY * (int)round((float)y1L / gridY);
      x2L = gridX * (int)round((float)x2L / gridX);
      y2L = gridY * (int)round((float)y2L / gridY);
    }
    rect(x1L,y1L,x2L-x1L,y2L-y1L);
    if (symX) // draw symmetry from X axis
    {
      calcSymX(x1L,y1L,x2L,y2L);
      rect(s1x, s1y, s2x-s1x, s2y-s1y);
    }
    if (symY) // draw symmetry from Y axis
    {
      calcSymY(x1L,y1L,x2L,y2L);
      rect(s1x, s1y, s2x-s1x, s2y-s1y);
    }
    if(symX && symY) // draw symmetry from center point (diagonal)
    {
      calcSymXY(x1L,y1L,x2L,y2L);
      rect(s1x, s1y, s2x-s1x, s2y-s1y);
    }
    fill(pointerCol);
    int dd1 = x2L - x1L;
    int dd2 = y2L - y1L;
    textAlign(CENTER,CENTER);
    text(dd1, (x1L+x2L)/2, y1L - 10);
    text(dd2, x2L + 16, (y2L+y1L)/2);
    textAlign(LEFT);
  }
}
//*********************************
void ghostCircle()
{
  noFill();
  stroke(pointerCol);
  if (circleLock) // draw ghost circle
  {
    if (snap2Grid)
    {
      x1L = gridX * (int)round((float)x1L / gridX);
      y1L = gridY * (int)round((float)y1L / gridY);
      x2L = gridX * (int)round((float)x2L / gridX);
      y2L = gridY * (int)round((float)y2L / gridY);
    }
    int dd = int(round(dist(x1L,y1L,x2L,y2L)));
    line(x1L,y1L,x2L,y2L);
    ellipse(x1L, y1L, dd*2, dd*2);
    if (symX) // draw symmetry from X axis
    {
      calcSymX(x1L,y1L,x2L,y2L);
      ellipse(s1x, s1y, dd*2, dd*2);
    }
    if (symY) // draw symmetry from Y axis
    {
      calcSymY(x1L,y1L,x2L,y2L);
      ellipse(s1x, s1y, dd*2, dd*2);
    }
    if(symX && symY) // draw symmetry from center point (diagonal)
    {
      calcSymXY(x1L,y1L,x2L,y2L);
      ellipse(s1x, s1y, dd*2, dd*2);
    }
    fill(pointerCol);
    textAlign(CENTER,CENTER);
    text(dd, (x1L+x2L)/2, (y1L + y2L)/2 - 10);
    textAlign(LEFT);
  }
  else // draw ghost ellipse
  {
    if (snap2Grid)
    {
      x1L = gridX * (int)round((float)x1L / gridX);
      y1L = gridY * (int)round((float)y1L / gridY);
      x2L = gridX * (int)round((float)x2L / gridX);
      y2L = gridY * (int)round((float)y2L / gridY);
    }
    ellipse((x1L+x2L)/2, (y1L+y2L)/2, (x1L-x2L), (y1L-y2L));
    if (symX) // draw symmetry from X axis
    {
      calcSymX(x1L,y1L,x2L,y2L);
      ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
    }
    if (symY) // draw symmetry from Y axis
    {
      calcSymY(x1L,y1L,x2L,y2L);
      ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
    }
    if(symX && symY) // draw symmetry from center point (diagonal)
    {
      calcSymXY(x1L,y1L,x2L,y2L);
      ellipse((s1x+s2x)/2, (s1y+s2y)/2, (s1x-s2x), (s1y-s2y));
    }
    fill(pointerCol);
    int dd1 = x2L - x1L;
    int dd2 = y2L - y1L;
    textAlign(CENTER,CENTER);
    text(dd1, (x1L+x2L)/2, y1L - 10);
    text(dd2, x2L + 16, (y2L+y1L)/2);
    textAlign(LEFT);
  }
}

//*********************************
void ghostSelect()
{
  fill(color(83,114,142,50)); //highLight
  stroke(highLight);
  if (snap2Grid)
  {
    x1L = gridX * (int)round((float)x1L / gridX);
    y1L = gridY * (int)round((float)y1L / gridY);
    x2L = gridX * (int)round((float)x2L / gridX);
    y2L = gridY * (int)round((float)y2L / gridY);
  }
  rect(x1L,y1L,x2L-x1L,y2L-y1L);
  fill(pointerCol);
  int dd1 = x2L - x1L;
  int dd2 = y2L - y1L;
  textAlign(CENTER,CENTER);
  text(dd1, (x1L+x2L)/2, y1L - 10);
  text(dd2, x2L + 16, (y2L+y1L)/2);
  textAlign(LEFT);

}
//*********************************