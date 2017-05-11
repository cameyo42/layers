void showMenu()
{
  // GUI
  // draw menu background (rectangle)
  stroke(0);
  fill(backMenuCol);
  //rect(0,0,menuX,menuY);
  rect(0,0,menuX,height-1);
  // draw swatch brush
  stroke(0);
  fill(backCol);
  rect(4, 14, brushSizeMax+10, brushSizeMax+10);
  if (tool == "Pencil" || tool == "Liner" || tool == "Quad" || tool == "Circle" || tool == "Ink" || tool == "Vernice" || tool == "Mixer" || tool == "Web")
  {
    noStroke();
    fill(brushCol);
    ellipse(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,brushSize,brushSize);
  }
  else if (tool=="Eraser")
  {
    stroke(0);
    noFill();
    ellipse(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,brushSize,brushSize);
  }
  else if (tool=="Filler")
  {
    stroke(0);
    fill(brushCol);
    rect(4,14, brushSizeMax+10, brushSizeMax+10);
  }
  else if (tool=="Dyna")
  {
    stroke(0);
    fill(brushCol);
    ellipse(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,myDD.max_brush,myDD.max_brush);
    noFill();
    ellipse(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,myDD.min_brush,myDD.min_brush);
  }
  else if (tool=="Stamp")
  {
    stroke(0);
    noFill();
    rectMode(CENTER);
    rect(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,brushSize,brushSize);
    rectMode(CORNER);
    if (userStamp) { image(stampPG,4+(brushSizeMax+10)/2-brushSize/2,14+(brushSizeMax+10)/2-brushSize/2); }
  }
  else if (tool=="Web")
  {
    stroke(0);
    noFill();
    rectMode(CENTER);
    rect(4+(brushSizeMax+10)/2,14+(brushSizeMax+10)/2,brushSize,brushSize);
    rectMode(CORNER);
  }
  // rgb and hsb control
  rgbhsb.show();
  // palette colors
  tavolozza.show();

  // layers control
  if (showLayerGUI)
  {
    for(int i = 0; i < livelli.length; i++)
    {
      livelli[i].showIcon();
    }
    controlloLivelli.show();
  }
  // button, checkbox, slider tools
  btnPENCIL.show();
  btnLINER.show();
  btnQUAD.show();
  btnLOCK.show();
  btnCIRCLE.show();
  btnERASER.show();
  btnSELECT.show();
  btnVERNICE.show();
  btnINK.show();
  btnSTAMP.show();
  btnMIXER.show();
  btnDYNA.show();
  btnFILLER.show();
  btnCLONE.show();
  btnWEB.show();
  btGRID.show();
  // open & save
  btOPENLYR.show();
  btOPEN.show();
  btSAVE.show();
  // undo/redo
  btnUNDO.show();
  btnREDO.show();
  // size brush slider
  slSIZE.show();
  // alfa slider
  slALFA.show();
  // X,Y symmetry
  cbSYMX.show();
  cbSYMY.show();
  // no glitch
  cbGLITCH.show();
  // Grid
  sbGRIDX.show();
  sbGRIDY.show();
  cbGRID.show();
  cbSNAP.show();
  // background colors
  btcBACKCOL.show();

  if (tool == "Filler")   // show Filler Options
  {
    slFILLER.show();
  }
  // show Dyna Options
  else if (tool == "Dyna")
  {
    dslHOOKE.show();
    dslDAMPING.show();
    dslDUCTUS.show();
    dslMASS.show();
    dslMINB.show();
    dslMAXB.show();
    btnPRE01.show();
    btnPRE02.show();
    btnPRE03.show();
    btnPRE04.show();
    btnPRE05.show();
    btnPRE06.show();
    btnPRE07.show();
    btnPRE08.show();
  }
  // Show Stamp Options
  else if (tool == "Stamp")
  {
    mySB.show();
    slSTAMP.show();
    slSTAMP2.show();
  }
  // Show Mixer Options
  else if (tool == "Mixer")
  {
    slMIXERA.show();
    slMIXERD.show();
  }
  // Show Web Options
  else if (tool == "Web")
  {
    slWEBA.show();
    slWEBD.show();
    btWEB.show();
    sbWEBT.show();
    sbWEBJ.show();
    cbWEBE.show();
    cbWEBP.show();
  }
  // Show Clone Options
  else if (tool == "Clone")
  {
    cbCLONE.show();
  }
}