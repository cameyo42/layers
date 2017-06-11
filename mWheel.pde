void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  println(e); // -1.0 or 1.0
  if (e > 0)
  {
    if (zoom) // change zoom
    { magnify = constrain(++magnify, 2, 32); }
    else // change brush size
    {
      brushSize = constrain(--brushSize, brushSizeMin, brushSizeMax);
      slSIZE.v = brushSize;
    }
  }
  else // e < 0
  {
    if (zoom)
    { magnify = constrain(--magnify, 2, 32); }
    else
    {
      brushSize = constrain(++brushSize, brushSizeMin, brushSizeMax);
      slSIZE.v = brushSize;
    }  
  }
}