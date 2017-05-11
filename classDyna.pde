// Dynadraw
// This is a rudimentary port of Paul Haeberli's
// legendary and monumentally influential program "Dynadraw",
// which is described at: http://www.sgi.com/grafica/dyna/index.html
// Originally created in June 1989 by Paul Haeberli
// Ported to Proce55ing January 2004 by Anonymous
// Modified, updated and adapted for Processing 3.x (layers.pde) 2017 by cameyo
// Paul wrote:
// Here's a really fun and useful hack.
// The program Dynadraw implements a dynamic drawing technique that applies
// a simple filter to mouse positions. Here the brush is modeled as a physical
// object with mass, velocity and friction. The mouse pulls on the brush with
// a synthetic rubber band. By changing the amount of friction and mass, various
// kinds of strokes can be made. This kind of dynamic filtering makes it easy
// to create smooth, consistent calligraphic strokes.

class DynaDraw
{
  float px, py;       // current position of spring
  float vx, vy;       // current velocity
  float ppx, ppy;     // previous position of spring

  float k;            // bounciness, stiffness of spring
  float damping;      // friction (smorzamento)
  float ductus;       // this constant relates stroke width to speed
  float mass;         // mass of simulated pen
  float max_brush;    // maximum stroke thickness
  float min_brush;    // minimum stroke thickness

  float old_brush = min_brush; // to change brush size smoothly

  DynaDraw()
  {
    // reset Dyna parameters
    px = mouseX;    // current position of spring
    py = mouseY;
    ppx = mouseX;   // previous position of spring
    ppy = mouseY;
    vx = 0;         // current velocity
    vy = 0;
    old_brush = min_brush; // to change brush size smoothly (+/- 1)

    k = 0.06;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.78;      // friction (smorzamento) (0.01, 1.00)
    ductus = 0.5;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 1.0;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 18.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 4.0;     // minimum stroke thickness (1 -> 64)
  }

  // reset Dyna parameters
  void resetDyna()
  {
    px = mouseX;
    py = mouseY;
    ppx = mouseX;
    ppy = mouseY;
    vx = 0;
    vy = 0;
    old_brush = min_brush;
  }

  // update Dyna physic parameters
  void updateDyna()
  {
    ppx = px;                 // Update the previous positions
    ppy = py;

    float dy = py - mouseY;   // Compute displacement from the cursor
    float dx = px - mouseX;
    float fx = -k * dx;       // Hooke's law, Force = - k * displacement
    float fy = -k * dy;
    float ay = fy / mass;     // Acceleration, computed from F = ma
    float ax = fx / mass;
    vx = vx + ax;             // Integrate once to get the next
    vy = vy + ay;             // velocity from the acceleration
    vx = vx * damping;        // Apply damping, which is a force
    vy = vy * damping;        // negatively proportional to velocity
    px = px + vx;             // Integrate a second time to get the
    py = py + vy;             // next position from the velocity
  }

// draw dyna brush
  void drawDyna()
  {
    float vh = sqrt(vx*vx + vy*vy);                       // Compute the (Pythagorean) velocity,
    float brush = max_brush - min(vh*ductus, max_brush);  // which we use (scaled, clamped and
    brush = max(min_brush, brush);                        // inverted) in computing...
    if (brush > old_brush) {brush = old_brush+1;}         // smooth the change (+/- 1) and
    if (brush < old_brush) {brush = old_brush-1;}         // ... set the brush size.
    old_brush = brush;
    //println(int(round(brush)));
    //strokeWeight(brush);
    // noStroke();
    // fill(30);
    // line (ppx, ppy, px,  py);
    drawLine((int) round(ppx), (int) round(ppy), (int) round(px),  (int) round(py), (int) round(brush), livelli[activeLyr].pg);
  }

// DynaDraw presets
  void preset01() // reset to default
  {
    k = 0.06;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.78;      // friction (smorzamento) (0.01, 1.00)
    ductus = 0.5;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 1.0;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 18.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 4.0;     // minimum stroke thickness (1 -> 64)
  }

  void preset02() // follow mouse (to ink drawing)
  {
    k = 0.06;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.4;       // friction (smorzamento) (0.01, 1.00)
    ductus = 0.5;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 2.0;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 8.0;     // maximum stroke thickness (1 -> 64)
    min_brush = 8.0;     // minimum stroke thickness (1 -> 64)
  }

  void preset03() // artist pen (a bit of random draw)
  {
    k = 0.10;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.92;      // friction (smorzamento) (0.01, 1.00)
    ductus = 2.5;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 1.0;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 12.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 3.0;     // minimum stroke thickness (1 -> 64)
  }

  void preset04() // paint brush
  {
    k = 0.18;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.32;      // friction (smorzamento) (0.01, 1.00)
    ductus = 0.6;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 0.5;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 20.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 10.0;    // minimum stroke thickness (1 -> 64)
  }

  void preset05() // blob ink brush
  {
    k = 0.55;            // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.70;      // friction (smorzamento) (0.01, 1.00)
    ductus = 2.8;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 1.5;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 16.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 6.0;     // minimum stroke thickness (1 -> 64)
  }

  void preset06() // write ink brush
  {
    k = 0.5;             // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 0.80;      // friction (smorzamento) (0.01, 1.00)
    ductus = 0.5;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 1.5;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 16.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 6.0;     // minimum stroke thickness (1 -> 64)
  }

  void preset07() // scribble brush (scarabocchio)
  {
    k = 0.6;             // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = 1.0;       // friction (smorzamento) (0.01, 1.00)
    ductus = 5.0;        // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = 3.0;          // mass of simulated pen (0.1 -> 5.0)
    max_brush = 32.0;    // maximum stroke thickness (1 -> 64)
    min_brush = 10.0;    // minimum stroke thickness (1 -> 64)
  }

  void preset08() // random brush
  {
    k = random(0,1);                   // bounciness, stiffness of spring (0.01 -> 1.0)
    damping = random(0,1);             // friction (smorzamento) (0.01, 1.00)
    ductus = random(0,5);              // this constant relates stroke width to speed (0.0 -> 5.0)
    mass = random(0.1,5);              // mass of simulated pen (0.1 -> 5.0)
    max_brush = random(8,32);          // maximum stroke thickness (1 -> 64)
    min_brush = random(1,max_brush);   // minimum stroke thickness (1 -> 64)
  }
}

// *************************************************
// *************************************************
// Button DynaDraw presets
class DynaButton
{
  // parameters
  float x, y;
  PImage iconON, iconOFF;
  boolean s;
  String m;

  // variables
  int ww; // icon width
  int hh; // icon height

  // constructor
  DynaButton(float ix, float iy, PImage _iconON, PImage _iconOFF, boolean is, String im)
  {
    x = ix; // start x (upper left)
    y = iy; // start y (upper left)
    iconOFF = _iconOFF; // icon tool OFF
    iconON = _iconON; // icon tool ON
    s = is; // status on-true/off-false
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
    if (s) { image(iconON,x,y); }
    else   { image(iconOFF,x,y); }
  }
}

// *************************************************
// DynaSlider
class DynaSlider
{
  float x1, y1, x2, y2;
  int p;
  int pr;
  String t;
  float v, v1, v2;
  color c0, c1, cl, ct;
  String m;

  boolean locked;

  // constructor
  DynaSlider(float ix1, float iy1, float ix2, float iy2, int ip, String it, float iv1, float iv2, float iv, int ipr, color ic0, color ic1, color icl, color ict, String im)
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
    pr = ipr;  // precision (0 --> 1,2,3...) (1 --> 1.0,1.1,1.2,1.3,...) ( 2 --> 1.00,1.01,1.02,1.03,...)
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
       v = constrain(map(mouseX,x1,x2,v1,v2),v1,v2);
       long factor = (long) Math.pow(10, pr);
       v = v * factor;
       long tmp = Math.round(v);
       v = (float) tmp / factor;
       method(m);
    }
  }

  void onDrag()
  {
    if (isOver() || locked)
    {
       v = constrain(map(mouseX,x1,x2,v1,v2),v1,v2);
       long factor = (long) Math.pow(10, pr);
       v = v * factor;
       long tmp = Math.round(v);
       v = (float) tmp / factor;
       method(m);
    }
  }

  void show()
  {
    pushStyle();
    textSize(11);
    stroke(cl);
    line(x1,y1,x2,y2);
    int pos = int(map(v,v1,v2,x1,x2));
    stroke(c0);
    fill(c1);
    rectMode(CENTER);
    rect(pos, y2, 6, 6);
    textAlign(CENTER);
    fill(ct);
    text(nf(v,0,0), pos, y1+14);
    textAlign(LEFT);
    //textAlign(RIGHT);
    //text(t, (x1+x2)/2, y1-6);
    text(t, x2+6, y1+3);
    popStyle();
  }
}