// *************************************************
class Palette
{
  // palette parameters
  PImage[] pages;
  int px, py;
  int numPages;
  color c0, c1, c2;
  String pm;
  int idx;

  // palette variables
  int pageWidth, pageHeight;
  color currentCol;

  // constructor
  Palette(PImage[] _pages, int _x, int _y, int _numP, color _c0, color _c1, color _c2,
          String _m, int _idx)
  {
    numPages =_numP; // number of palette pages
    pages = _pages;
    px = _x;    // palette x position (upper left x)
    py = _y;    // palette y position  (upper left y)
    c0 = _c0;   // text color
    c1 = _c1;   // stroke color
    c2 = _c2;   // fill color
    pm = _m;    // method name (function)
    idx = _idx; // palette index

    pageWidth = pages[0].width;
    pageHeight = pages[0].height;
    activePalettePage = idx;
    currentCol = color(166,130,180);
  }

  boolean isOver()
  {
    return(mouseX > px && mouseX < px + pageWidth && mouseY > py && mouseY < py + pageHeight);
  }

  void onClick()
  {
    if (isOver() && !pm.equals(""))
    {
      // check click on slider --> change palette page
      if (mouseX > px+5 && mouseX < px+149 && mouseY > py+9 && mouseY < py+21)
      {
        idx = int(map(mouseX, px+5, px+149, 0, 13));
        activePalettePage = idx;
        currentCol = brushCol;
      }
      else
      // check click on colors --> pick color
      {
        if (mouseY > py+21)
        {
          currentCol = get(mouseX, mouseY);
          method(pm); // set brushCol to currentCol + alfa
        }
      }
    }
  }

  void show()
  {
    // no transparency for menu
    noTint();
    image(pages[activePalettePage], px, py);
  }

}