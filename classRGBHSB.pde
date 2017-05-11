class RGB_HSB
{
  // parameters
  int x, y, w, h;
  color cc;
  color c0, c1, c2;
  String m;

  // variables
  float s; //increment value
  float rr, gg, bb;
  float hh, ss, vv;
  final int step;
  color oldCol; // old color - right swatch
  float rrx,rry,ggx,ggy,bbx,bby;
  float hhx,hhy,ssx,ssy,vvx,vvy;
  // constructor
  RGB_HSB(int ix, int iy, int iw, int ih, color icc, color ic0, color ic1, color ic2, String im)
  {
    x=ix; // start x
    y=iy; // start y
    w=iw; // width
    h=ih; // height
    cc=icc; // current color
    c0=ic0; // stroke color
    c1=ic1; // fill color
    c2=ic2; // text color
    m=im; // method

    s = 1.0;
    colorMode(RGB,255,255,255);
    rr = red(cc); gg = green(cc); bb = blue(cc);
    colorMode(HSB,360,100,100);
    hh = hue(cc);
    ss = saturation(cc);
    vv = brightness(cc);
    colorMode(RGB,255,255,255);
    oldCol = cc;
    step = 18;
  }

  void show()
  {
    pushStyle();
    stroke(c0);
    fill(c1);
    rect(x, y, w, h);
    // lines
    line(x+step,y,x+step,y+step*4);
    line(x+step*3,y,x+step*3,y+step*4);
    //line(x+step*4,y-step/2,x+step*4,y+step*4.5);
    line(x+step*5,y,x+step*5,y+step*4);
    line(x+step*7,y,x+step*7,y+step*4);
    //line(x+step*8,y-step/2,x+step*8,y+step*4.5);
    line(x+step*9,y,x+step*9,y+step*4);
    line(x+step*11,y,x+step*11,y+step*4);
    stroke(c2);
    line(x+step*4,y-step/2,x+step*4,y+step*4.5);
    line(x+step*8,y-step/2,x+step*8,y+step*4.5);

    // write text
    textAlign(CENTER,CENTER);
    fill(c2);
    // rgb hsb text
    text("Red",x+step*2, y-step/2);
    text("Green",x+step*6, y-step/2);
    text("Blue",x+step*10, y-step/2);
    text("Hue",x+step*2, y+step*4.5-2);
    text("Saturation",x+step*6, y+step*4.5-2);
    text("Brightness",x+step*10, y+step*4.5-2);
    // rgb and hsb value
    text(round(rr),x+step*2, y+step/2-1);
    text(round(gg),x+step*6, y+step/2-1);
    text(round(bb),x+step*10, y+step/2-1);
    text(round(hh),x+step*2, y+step*3.5-2);
    text(round(ss),x+step*6, y+step*3.5-2);
    text(round(vv),x+step*10, y+step*3.5-2);
    // rgb -+
    fill(c0);
    text("-", x+step/2, y+step/2-1);
    text("+", x+step*3.5, y+step/2-1);
    text("-", x+step*4.5, y+step/2-1);
    text("+", x+step*7.5, y+step/2-1);
    text("-", x+step*8.5, y+step/2-1);
    text("+", x+step*11.5, y+step/2-1);
    // hsb -+
    text("-", x+step/2, y+step*3.5-2);
    text("+", x+step*3.5, y+step*3.5-2);
    text("-", x+step*4.5, y+step*3.5-2);
    text("+", x+step*7.5, y+step*3.5-2);
    text("-", x+step*8.5, y+step*3.5-2);
    text("+", x+step*11.5, y+step*3.5-2);
    // draw new color swatch
    stroke(c0);
    fill(cc);
    rect(x,y+step,step*6,step*2);
    // draw current color swatch
    fill(oldCol);
    rect(x+step*6,y+step,step*6,step*2);
    popStyle();
  }

  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h);
  }

  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
      if ((mouseX>x+step*6+4)&&(mouseX<x+step*12-3)&&(mouseY>=y+step+4)&&(mouseY<y+step*3-3)) //press old color (right)
      {
        if(keyPressed && keyCode == CONTROL) // input HSB
        {
          String valHSB = JOptionPane.showInputDialog("Enter HSB (ex. 30,24,35 or 30 24 35)...");
          if (valHSB != null) // Not cancel and valid string
          {
            String[] val = splitTokens(valHSB, ", ");
            if (val.length == 3)
            {
              try
              {
                int Hv = Integer.parseInt(val[0]);
                int Sv = Integer.parseInt(val[1]);
                int Vv = Integer.parseInt(val[2]);
                hh = constrain(Hv,0,360);
                ss = constrain(Sv,0,100);
                vv = constrain(Vv,0,100);
              }
              catch (NumberFormatException e)
              {
                println("Error: wrong HSB values");
              }
              updateRGB();
            }
            else { println("Error: wrong HSB values"); }
          }
          keyPressed = false;
          mousePressed = false;
        }
        else // set active color as old color
        {
          color pressCol = get(mouseX,mouseY);
          setRGBHSB(pressCol);
          method(m);
        }
      }
      else if ((mouseX>x+4)&&(mouseX<x+step*6-3)&&(mouseY>=y+step+4)&&(mouseY<y+step*3-3)) //press active color (left)
      {
        if(keyPressed && keyCode == CONTROL) // input RGB
        {
          String valRGB = JOptionPane.showInputDialog("Enter RGB (ex. 30,24,35 or 30 24 35)...");
          if (valRGB != null) // Not cancel and valid string
          {
            String[] val = splitTokens(valRGB, ", ");
            if (val.length == 3)
            {
              try
              {
                int Rv = Integer.parseInt(val[0]);
                int Gv = Integer.parseInt(val[1]);
                int Bv = Integer.parseInt(val[2]);
                rr = constrain(Rv,0,255);
                gg = constrain(Gv,0,255);
                bb = constrain(Bv,0,255);
              }
              catch (NumberFormatException e)
              {
                println("Error: wrong RGB values");
              }
              updateHSB();
            }
            else { println("Error: wrong RGB values"); }
          }
          keyPressed = false;
          mousePressed = false;
        }
      }
      else if ((mouseX>x)&&(mouseX<x+step)&&(mouseY>=y)&&(mouseY<y+step)) // - r
      {
        if(keyPressed && keyCode == CONTROL)
        { rr = constrain(rr-s*10, 0, 255); }
        else if(keyPressed && keyCode == ALT)
        { rr = constrain(rr-s*100, 0, 255);  }
        else
        { rr = constrain(rr-s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x+step*3)&&(mouseX<x+step*4)&&(mouseY>=y)&&(mouseY<=y+step)) // + r
      {
        if(keyPressed && keyCode == CONTROL)
        { rr = constrain(rr+s*10, 0, 255);  }
        else if(keyPressed && keyCode == ALT)
        { rr = constrain(rr+s*100, 0, 255);  }
        else
        { rr = constrain(rr+s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x+step*4)&&(mouseX<x+step*5)&&(mouseY>=y)&&(mouseY<y+step)) // - g
      {
        if(keyPressed && keyCode == CONTROL)
        { gg = constrain(gg-s*10, 0, 255);  }
        else if(keyPressed && keyCode == ALT)
        { gg = constrain(gg-s*100, 0, 255);  }
        else
        { gg = constrain(gg-s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x+step*7)&&(mouseX<x+step*8)&&(mouseY>=y)&&(mouseY<=y+step)) // + g
      {
        if(keyPressed && keyCode == CONTROL)
        { gg = constrain(gg+s*10, 0, 255);  }
        else if(keyPressed && keyCode == ALT)
        { gg = constrain(gg+s*100, 0, 255);  }
        else
        { gg = constrain(gg+s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x+step*8)&&(mouseX<x+step*9)&&(mouseY>=y)&&(mouseY<y+step)) // - b
      {
        if(keyPressed && keyCode == CONTROL)
        { bb = constrain(bb-s*10, 0, 255);  }
        else if(keyPressed && keyCode == ALT)
        { bb = constrain(bb-s*100, 0, 255);  }
        else
        { bb = constrain(bb-s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x+step*11)&&(mouseX<x+step*12)&&(mouseY>=y)&&(mouseY<=y+step)) // + b
      {
        if(keyPressed && keyCode == CONTROL)
        { bb = constrain(bb+s*10, 0, 255);  }
        else if(keyPressed && keyCode == ALT)
        { bb = constrain(bb+s*100, 0, 255);  }
        else
        { bb = constrain(bb+s, 0, 255);  }
        updateHSB();
      }
      else if ((mouseX>x)&&(mouseX<x+step)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // - h
      {
        if(keyPressed && keyCode == CONTROL)
        { hh = constrain(hh-s*10, 0, 360); }
        else if(keyPressed && keyCode == ALT)
        { hh = constrain(hh-s*100, 0, 360);  }
        else
        { hh = constrain(hh-s, 0, 360);  }
        updateRGB();
      }
      else if ((mouseX>x+step*3)&&(mouseX<x+step*4)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // + h
      {
        if(keyPressed && keyCode == CONTROL)
        { hh = constrain(hh+s*10, 0, 360);  }
        else if(keyPressed && keyCode == ALT)
        { hh = constrain(hh+s*100, 0, 360);  }
        else
        { hh = constrain(hh+s, 0, 360);  }
        updateRGB();
      }
      else if ((mouseX>x+step*4)&&(mouseX<x+step*5)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // - s
      {
        if(keyPressed && keyCode == CONTROL)
        { ss = constrain(ss-s*10, 0, 100);  }
        else if(keyPressed && keyCode == ALT)
        { ss = constrain(ss-s*100, 0, 100);  }
        else
        { ss = constrain(ss-s, 0, 100);  }
        updateRGB();
      }
      else if ((mouseX>x+step*7)&&(mouseX<x+step*8)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // + s
      {
        if(keyPressed && keyCode == CONTROL)
        { ss = constrain(ss+s*10, 0, 100);  }
        else if(keyPressed && keyCode == ALT)
        { ss = constrain(ss+s*100, 0, 100);  }
        else
        { ss = constrain(ss+s, 0, 100);  }
        updateRGB();
      }
      else if ((mouseX>x+step*8)&&(mouseX<x+step*9)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // - v
      {
        if(keyPressed && keyCode == CONTROL)
        { vv = constrain(vv-s*10, 0, 100);  }
        else if(keyPressed && keyCode == ALT)
        { vv = constrain(vv-s*100, 0, 100);  }
        else
        { vv = constrain(vv-s, 0, 100);  }
        updateRGB();
      }
      else if ((mouseX>x+step*11)&&(mouseX<x+step*12)&&(mouseY>=y+step*3)&&(mouseY<y+step*4)) // + v
      {
        if(keyPressed && keyCode == CONTROL)
        { vv = constrain(vv+s*10, 0, 100);  }
        else if(keyPressed && keyCode == ALT)
        { vv = constrain(vv+s*100, 0, 100);  }
        else
        { vv = constrain(vv+s, 0, 100);  }
        updateRGB();
      }
    }
  }

  void updateHSB()
  {
    colorMode(RGB,255.0,255.0,255.0);
    color tc = color(rr,gg,bb);
    colorMode(HSB,360.0,100.0,100.0);
    hh = hue(tc); ss = saturation(tc); vv = brightness(tc);
    colorMode(RGB,255.0,255.0,255.0);
    cc = color(rr,gg,bb);
    method(m);
  }

  void updateRGB()
  {
    colorMode(HSB,360.0,100.0,100.0);
    color tc = color(hh,ss,vv);
    colorMode(RGB,255.0,255.0,255.0);
    rr = red(tc); gg = green(tc); bb = blue(tc);
    colorMode(RGB,255.0,255.0,255.0);
    cc = color(rr,gg,bb);
    method(m);
  }

  void setRGBHSB(color c)
  {
    oldCol = cc;
    colorMode(RGB,255.0,255.0,255.0);
    rr = red(c); gg = green(c); bb = blue(c);
    colorMode(HSB,360.0,100.0,100.0);
    hh = hue(c); ss = saturation(c); vv = brightness(c);
    colorMode(RGB,255.0,255.0,255.0);
    cc = color(rr,gg,bb);
  }
}