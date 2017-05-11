class HSBcontrol
{
  // parameters
  float x, y;
  color c;
  String m;

  // variables
  int ww; // image width
  int hh; // image height
  float h; // hue
  float s; // saturation
  float b; // brightness
  PGraphics hsbPG;  // hsb PGraphics image

  // constructor
  HSBcontrol(float ix, float iy, color ic, String im)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    c = ic; // current color
    m = im; // method (function)

    // variables
    ww = 201; // width
    hh = 231; // height

    // create HSB base image
    colorMode(HSB,ww-1,ww-1,ww-1);
    hsbPG = createGraphics(ww,hh);
    hsbPG.noSmooth();
    hsbPG.beginDraw();
    hsbPG.clear();
    hsbPG.colorMode(HSB,ww-1,ww-1,ww-1);
    h = hue(c);
    s = saturation(c);
    b = brightness(c);
    // draw square saturation/brightness
    for(int i=0; i<ww; i++)
    {
      for(int j=0; j<ww; j++)
      {
        hsbPG.stroke((int) round(h),i,j);
        hsbPG.point(i,j);
      }
    }
    // draw hues baseline
    for(int i=0; i<ww; i++)
    {
      hsbPG.stroke(i,ww-1,ww-1);
      hsbPG.line(i,ww,i,hh-1);
    }
    hsbPG.noFill();
    hsbPG.stroke(white);
    hsbPG.line((int) round(h),ww,(int) round(h),hh-1); // hue line
    hsbPG.line((int) round(s),0,(int) round(s),ww-1); // saturation line
    hsbPG.line(0,(int) round(b),ww-1,(int) round(b)); // brightness line
    hsbPG.endDraw();
    colorMode(RGB,255,255,255);
  }

  boolean isOver()
  {
    return(mouseX>x&&mouseX<x+ww&&mouseY>y&&mouseY<y+hh);
  }

  void onClick()
  {
    if (isOver())
    {
      if ((keyPressed && keyCode==SHIFT && mousePressed && mouseButton==LEFT) || (mouseButton==RIGHT && !keyPressed))
      {
        if (mouseY > y+ww-1) { updateHSB("H"); } //click on hues
        else { updateHSB("SB"); } // click on saturation/brightness
        method(m);
      }
    }
  }

  void onDrag()
  {
    if (isOver())
    {
      if (keyPressed && keyCode==SHIFT && mousePressed)
      {
        if(mouseButton==RIGHT)
        {
          x -= (pmouseX-mouseX);
          y -= (pmouseY-mouseY);
        }
        if(mouseButton==LEFT)
        {
          if (c != white)
          {
            if (mouseY > y+ww-1) { updateHSB("H"); } //click on hues
            else { updateHSB("SB"); } // click on saturation/brightness
            //brushCol = color(red(c),green(c),blue(c), alfa);
            method(m);
          }
        }
      }
    }
  }

  void show()
  {
    pushStyle();
    noTint();
    image(hsbPG, x, y);
    stroke(black);
    fill(c);
    rect(x, y-23, ww-1, 21);
    popStyle();
  }

  void updateHSB(String type)
  {
    colorMode(HSB,ww-1,ww-1,ww-1);
    hsbPG.beginDraw();
    hsbPG.colorMode(HSB,ww-1,ww-1,ww-1);
    if (type=="H") // change hues
    {
      //h = hue(c);
      h = mouseX-x;
      c = color(h,s,b);
      //println("cambia H: " + h,s,b);
    }
    else if (type=="SB")
    {
      //s = saturation(c);
      //b = brightness(c);
      s = mouseX-x;
      b = mouseY-y;
      c = color(h,s,b);
      //println("cambia SB: " + h,s,b);
    }
    else if (type=="HSB") // execute only when called from outside (HBScontrol.updateHSB("HSB");
    {
      //h = mouseX-x;
      //s = mouseX-x;
      //b = mouseY-y;
      h = hue(brushCol);
      s = saturation(brushCol);
      b = brightness(brushCol);
      c = color(h,s,b);
      //println("cambia HSB: " + h,s,b);
    }
    // draw square saturation/brightness
    hsbPG.loadPixels();
    for(int i=0; i<ww; i++)
    {
      for(int j=0; j<hh; j++)
      {
        //hsbPG.stroke(h,i,j);
        //hsbPG.point(i,j);
        hsbPG.pixels[i+j*ww] = color(h,i,j);
      }
    }
    hsbPG.updatePixels();
    // draw hues baseline
    for(int i=0; i<ww; i++)
    {
      hsbPG.stroke(i,ww-1,ww-1);
      hsbPG.line(i,ww,i,hh-1);
    }
    // draw line on current h,s,b
    hsbPG.noFill();
    hsbPG.stroke(white);
    hsbPG.line((int) round(h),ww,(int) round(h),hh-1); // hue line
    hsbPG.line((int) round(s),0,(int) round(s),ww-1); // saturation line
    hsbPG.line(0,(int) round(b),ww-1,(int) round(b)); // brightness line
    hsbPG.endDraw();
    colorMode(RGB,255,255,255);
  }

}