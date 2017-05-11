// *************************************************
// Spinner with bounded values
class SpinBound
{
  float x, y, w, h;
  String t;
  float v, s;
  float minv, maxv;
  color c0, c1, ct;
  String m;

  SpinBound(float ix, float iy, float iw, float ih, String it, float iv, float is, float imin, float imax, color ic0, color ic1, color ict, String im)
  {
    x=ix; // start x
    y=iy; // start y
    w=iw; // width
    h=ih; // height
    t=it; // text
    v=iv; // start value
    s=is; // step value
    minv = imin; // min value
    maxv = imax; // max value
    c0 = ic0; // stroke color
    c1 = ic1; // fill color
    ct = ict; // text color
    m = im;   // method
  }
  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h);
  }

  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
      if ((mouseX>x)&&(mouseX<x+w/4)&&(mouseY>=y)&&(mouseY<=y+h)) //left press
      {
        if(keyPressed && keyCode == CONTROL)
        {
          v = constrain(v-s*10, minv, maxv); method(m);
        }
        else if(keyPressed && keyCode == ALT)
        {
          v = constrain(v-s*100, minv, maxv); method(m);
        }
        else
        {
          v = constrain(v-s, minv, maxv); method(m);
        }
      }
      if ((mouseX>x+3*w/4)&&(mouseX<x+w)&&(mouseY>=y)&&(mouseY<=y+h)) //right press
      {
        if(keyPressed && keyCode == CONTROL)
        {
          v = constrain(v+s*10, minv, maxv); method(m);
        }
        else if(keyPressed && keyCode == ALT)
        {
          v = constrain(v+s*100, minv, maxv); method(m);
        }
        else
        {
          v = constrain(v+s, minv, maxv); method(m);
        }
      }
    }
  }

  void setValue(float u) { v = u; }
  float getValue() { return(v);  }

  void show()
  {
    pushStyle();
    stroke(c0);
    fill(c1);
    rect(x, y, w, h);
    line(x+w/4,y,x+w/4,y+h);
    line(x+3*w/4,y,x+3*w/4,y+h);
    fill(ct);
    textAlign(CENTER, CENTER);
    text(nf(v,0,0),x+w/2.0,y+h/2.0-1);
    if (t != "") { text(t, x-17, y+6); }
    fill(20);
    text("-",x+w/8.0,y+h/2.0-2);
    text("+",x+7*w/8.0,y+h/2.0-2);
    popStyle();
  }
}

// *************************************************
// Button (click)
class Button
{
  // parameters
  float x, y;
  PImage icon;
  String t;
  color ct;
  String m;

  // variables
  int ww; // icon width
  int hh; // icon height

  // constructor
  Button(float ix, float iy, PImage _icon, String it, color ict, String im)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    icon = _icon; // icon tool
    t = it; // text string
    ct = ict; // text color
    m = im; // method (function)

    // variables
    ww = icon.width;
    hh = icon.height;
  }

  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+ww&&mouseY>=y&&mouseY<=y+hh);
  }

  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
      method(m);
    }
  }

  void show()
  {
    pushStyle();
    image(icon, x, y);
    if (t != "")
    {
      fill(ct);
      textAlign(CENTER);
      text(t,x+ww/2,y+hh+12);
    }
    popStyle();
  }
}

// *************************************************
// ButtonColor
class ButtonColor
{
  // parameters
  int x, y;
  int w, h;
  color c0;
  color c1;
  String t;
  color ct;
  String m;

  // constructor
  ButtonColor(int ix, int iy, int iw, int ih, color ic0, color ic1, String it, color ict, String im)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    w = iw; // weight
    h = ih; // height
    c0 = ic0; // stroke button
    c1 = ic1; // fill button
    t = it; // text string
    ct = ict; // text color
    m = im; // method (function)
  }

  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h);
  }

  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
      method(m);
    }
  }

  void show()
  {
    pushStyle();
    stroke(c0);
    fill(c1);
    rect(x,y,w,h);
    if (t != "")
    {
      fill(ct);
      textAlign(CENTER);
      text(t,x+w/2,y+h+12);
    }
    popStyle();
  }
}

// *************************************************
// Button ON/OFF
class ButtonIMG
{
  // parameters
  float x, y;
  PImage iconON, iconOFF;
  boolean s;
  String t;
  color ct;
  String m;

  // variables
  int ww; // icon width
  int hh; // icon height

  // constructor
  ButtonIMG(float ix, float iy, PImage _iconON, PImage _iconOFF, boolean is, String it, color ict, String im)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    iconOFF = _iconOFF; // icon tool OFF
    iconON = _iconON; // icon tool ON
    s = is; // status on-true/off-false
    t = it; // text string
    ct = ict; // text color
    m = im; // method (function)

    ww = iconOFF.width;
    hh = iconOFF.height;
  }

  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+ww&&mouseY>=y&&mouseY<=y+hh);
  }

  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
      method(m);
    }
  }

  void show()
  {
    pushStyle();
    if (s) { image(iconON,x,y); }
    else   { image(iconOFF,x,y); }
    if (t != "")
    {
      fill(ct);
      textAlign(CENTER);
      text(t,x+ww/2,y+hh+12);
    }
    popStyle();
  }
}

// *************************************************
// Slider
class Slider
{
  float x1, y1, x2, y2;
  int p;
  String t;
  float v, v1, v2;
  color c0, c1, cl, ct;
  String m;

  boolean locked;

  // constructor
  Slider(float ix1, float iy1, float ix2, float iy2, int ip, String it, float iv1, float iv2, float iv, color ic0, color ic1, color icl, color ict, String im)
  {
    x1=ix1; // start x
    y1=iy1; // start y
    x2=ix2; // end x
    y2=iy2; // end y
    p=ip;   // pad space
    t=it;   // text
    v1=iv1; // min value
    v2=iv2; // max value
    v=iv;   // value
    c0=ic0; // stroke color
    c1=ic1; // fill color
    cl=icl; // line color
    ct=ict; // text color
    m=im;   // method name

    locked = false;
  }

  boolean isOver()
  {
    return(mouseX>=x1-p && mouseX<=x2+p && mouseY>=y1-p && mouseY<=y2+p);
  }

  void onClick()
  {
    if (isOver())
    {
       locked = true;
       v = constrain(int(map(mouseX,x1,x2,v1,v2)),v1,v2);
       method(m);
    }
  }

  void onDrag()
  {
    if (isOver() || locked)
    {
       v = constrain(int(map(mouseX,x1,x2,v1,v2)),v1,v2);
       method(m);
    }
  }

  void show()
  {
    pushStyle();
    stroke(cl);
    line(x1,y1,x2,y2);
    int pos = int(map(v,v1,v2,x1,x2));
    stroke(c0);
    fill(c1);
    rectMode(CENTER);
    rect(pos, y2, 6, 6);
    textSize(12);
    textAlign(CENTER);
    fill(ct);
    text(nf(v,0,0), pos, y1+14);
    //textAlign(LEFT);
    textAlign(RIGHT);
    //text(t, (x1+x2)/2, y1-6);
    text(t, x2, y1-6);
    popStyle();
  }
}

// *************************************************
class Checkbox
{
  float x, y, w, h;
  String t;
  boolean s;
  color c0, c1, c2, c3 ,ct;
  String m;

  // constructor
  Checkbox(float ix, float iy, float iw, float ih, String it, boolean is, color ic0, color ic1, color ic2, color ic3, color ict, String im)
  {
    x=ix; // start x
    y=iy; // start y
    w=iw; // width
    h=ih; // height
    t=it; // text
    s=is; // status
    c0=ic0; // stroke color
    c1=ic1; // fill color
    c2=ic2; // fill color on
    c3=ic3; // fill color off
    ct=ict; // text color
    m=im; // method
  }
  boolean isOver()
  {
    return(mouseX>=x&&mouseX<=x+w&&mouseY>=y&&mouseY<=y+h);
  }
  void onClick()
  {
    if (isOver() && !m.equals(""))
    {
       s=!(s);
       method(m);
    }
  }
  void show()
  {
    pushStyle();
    stroke(c0);
    fill(c1);
    rect(x, y, w, h);
    noStroke();
    if (s==true) { fill(c2); }//253,246,227); }
    else { fill(c3); };
    rect(x+3, y+3, w-5, h-5);
    fill(ct);
    textAlign(LEFT,CENTER);
    text(t,x+w+5,y+h/2-1);
    popStyle();
  }
}