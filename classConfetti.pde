// Confetti class
// by Dave Bollinger
// modified and adapted for layers by cameyo

// parameters: velocity and velocity variation

class ConfettiBase 
{
  float x, y;
  float ox, oy;
  float vel, dvel, ddvel;
  float ang, dang, ddang;
  float t;
  float wid,hei;
  color c;
  ConfettiBase(float _x, float _y) 
  {
    x = _x;
    y = _y;
    t = 0.0;
    //wid = random(1.0,20.0);
    //hei = random(1.0,20.0); // original
    wid = random(1.0,brushSize);
    hei = random(1.0,brushSize);    
    //c = (randomConfettiColor) ? pal.get() : color(0);
    //c = (randomConfettiColor) ? pal.get() : brushCol;
    c = (cbCONFRND.s) ? randomColor() : brushCol;
    //vel = random(1.0,4.0); // original
    //vel = random(1.0,50.0);
    vel = random(1.0,slCONFVEL.v);
    dvel = random(0.001,0.01);
    ddvel = random(0.0001,0.001);
    ang = random(-PI,PI);
    dang = random(-0.01,0.01);
    ddang = random(-0.001,0.001);
  }
  
  boolean alive() { return (t < 1.0); }
  
  void move() 
  {
    ox = x;
    oy = y;
    dang += ddang;
    ang += dang;
    dvel += ddvel;
    vel += dvel;
    vel *= slCONFDVEL.v/100.0;
    x += vel * cos(ang);
    y += vel * sin(ang);
    t += 0.01;
  }
  
  void paint() 
  {
    //livelli[activeLyr].pg.stroke((c >> 16) & 0xFF, (c >> 8)  & 0xFF, c & 0xFF, 255f-t*255f);  
    livelli[activeLyr].pg.stroke((c >> 16) & 0xFF, (c >> 8)  & 0xFF, c & 0xFF, alfa-t*alfa);  
    //livelli[activeLyr].pg.fill(255, 255-t*255f);
    livelli[activeLyr].pg.fill(255, alfa-t*alfa);
    livelli[activeLyr].pg.pushMatrix();
    livelli[activeLyr].pg.translate(x,y);
    float theta = atan2(y-oy,x-ox);
    livelli[activeLyr].pg.rotate(theta);
    if (cbCONFSCALE.s) { livelli[activeLyr].pg.scale(1.0-t*0.9); }
    shape();
    livelli[activeLyr].pg.popMatrix();
  }

  void shape() { }
}


class ConfettiRectangle extends ConfettiBase 
{
  ConfettiRectangle(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.vertex(wid,-hei);
    livelli[activeLyr].pg.vertex(wid,hei);
    livelli[activeLyr].pg.vertex(-wid,hei);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiTriangle extends ConfettiBase 
{
  ConfettiTriangle(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid/2,-hei);
    livelli[activeLyr].pg.vertex(wid,0);
    livelli[activeLyr].pg.vertex(-wid/2,hei);
    livelli[activeLyr].pg.vertex(-wid/2,-hei);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiParallelogram extends ConfettiBase {
  ConfettiParallelogram(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.vertex(-wid/2,hei);
    livelli[activeLyr].pg.vertex(wid,hei);
    livelli[activeLyr].pg.vertex(wid/2,-hei);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiPentagon extends ConfettiBase 
{
  ConfettiPentagon(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid/2,-hei/2);
    livelli[activeLyr].pg.vertex(wid/2,-hei);
    livelli[activeLyr].pg.vertex(wid,0);
    livelli[activeLyr].pg.vertex(wid/2,hei);
    livelli[activeLyr].pg.vertex(-wid/2,hei/2);
    livelli[activeLyr].pg.vertex(-wid/2,-hei/2);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiHexagon extends ConfettiBase 
{
  ConfettiHexagon(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid,0);
    livelli[activeLyr].pg.vertex(-wid/2,hei);
    livelli[activeLyr].pg.vertex(wid/2,hei);
    livelli[activeLyr].pg.vertex(wid,0);
    livelli[activeLyr].pg.vertex(wid/2,-hei);
    livelli[activeLyr].pg.vertex(-wid/2,-hei);
    livelli[activeLyr].pg.vertex(-wid,0);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiStar extends ConfettiBase 
{
  ConfettiStar(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid/2,0);
    livelli[activeLyr].pg.vertex(-wid,hei);
    livelli[activeLyr].pg.vertex(0,hei/2);
    livelli[activeLyr].pg.vertex(wid/2,hei*3/2);
    livelli[activeLyr].pg.vertex(wid/2,hei/2);
    livelli[activeLyr].pg.vertex(wid*3/2,0);
    livelli[activeLyr].pg.vertex(wid/2,-hei/2);
    livelli[activeLyr].pg.vertex(wid/2,-hei*3/2);
    livelli[activeLyr].pg.vertex(0,-hei/2);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.vertex(-wid/2,0);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiBoomerang extends ConfettiBase 
{
  ConfettiBoomerang(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(0,hei/2);
    livelli[activeLyr].pg.vertex(-wid,hei);
    livelli[activeLyr].pg.vertex(wid,hei/2);
    livelli[activeLyr].pg.vertex(wid,-hei/2);
    livelli[activeLyr].pg.vertex(-wid,-hei);
    livelli[activeLyr].pg.vertex(0,-hei/2);
    livelli[activeLyr].pg.vertex(0,hei/2);
    livelli[activeLyr].pg.endShape();
  }
}

class ConfettiShuriken extends ConfettiBase 
{
  ConfettiShuriken(float _x, float _y) { super(_x,_y); } 
  void shape() 
  {
    livelli[activeLyr].pg.beginShape(POLYGON);
    livelli[activeLyr].pg.vertex(-wid*3/2,0);
    livelli[activeLyr].pg.vertex(0,hei/2);
    livelli[activeLyr].pg.vertex(0,hei*3/2);
    livelli[activeLyr].pg.vertex(wid/2,0);
    livelli[activeLyr].pg.vertex(wid*3/2,0);
    livelli[activeLyr].pg.vertex(0,-hei/2);
    livelli[activeLyr].pg.vertex(0,-hei*3/2);
    livelli[activeLyr].pg.vertex(-wid/2,0);
    livelli[activeLyr].pg.vertex(-wid*3/2,0);
    livelli[activeLyr].pg.endShape();
  }
}

void spawn() 
{
  int which = (int)(random(8));
  //which = 0;
  switch(which) 
  {
    case 0 : confettiThings.add( new ConfettiRectangle(mouseX,mouseY) ); break;
    case 1 : confettiThings.add( new ConfettiTriangle(mouseX,mouseY) );  break;
    case 2 : confettiThings.add( new ConfettiParallelogram(mouseX,mouseY) ); break;
    case 3 : confettiThings.add( new ConfettiHexagon(mouseX,mouseY) ); break;
    case 4 : confettiThings.add( new ConfettiPentagon(mouseX,mouseY) ); break;
    case 5 : confettiThings.add( new ConfettiStar(mouseX,mouseY) ); break;
    case 6 : confettiThings.add( new ConfettiBoomerang(mouseX,mouseY) ); break;
    case 7 : confettiThings.add( new ConfettiShuriken(mouseX,mouseY) ); break;
  } 
}

color randomColor()
{
  return ((color) random(#000000));
}