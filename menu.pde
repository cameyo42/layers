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
  if (tool == "Pencil" || tool == "Liner" || tool == "Quad" || tool == "Circle" || tool == "Ink" ||
      tool == "Vernice" || tool == "Mixer" || tool == "Web" || tool == "Stencil" || tool == "Clone" ||
      tool == "Confetti" || tool == "Shape" || tool == "Alpha" || tool == "RGB" || tool == "HSB" || tool == "RND" || tool == "Tool01")
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
  btnSTENCIL.show();
  btnVERNICE.show();
  btnINK.show();
  btnSTAMP.show();
  btnMIXER.show();
  btnDYNA.show();
  btnFILLER.show();
  btnCLONE.show();
  btnWEB.show();
  btnCONFETTI.show();
  btnSHAPE.show();
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

  // new tools
  btnALPHA.show();
  btnRGB.show();
  btnHSB.show();
  btnRND.show();
  btnBACK.show();

  // show Alpha Options
  if (tool == "Alpha")
  {
    slALPHAT.show();
    cbALPHAT.show();
    cbALPHATT.show();
  }
  // show RGB Options
  if (tool == "RGB")
  {
    slRGBr.show();
    slRGBg.show();
    slRGBb.show();
    cbRGBT.show();
    cbRGBTT.show();
  }
  // show HSB Options
  if (tool == "HSB")
  {
    slHSBh.show();
    slHSBs.show();
    slHSBb.show();
    cbHSBT.show();
    cbHSBTT.show();
  }
  // show RND Options
  if (tool == "RND")
  {
    slRNDr.show();
    slRNDg.show();
    slRNDb.show();
    slRNDa.show();
  }  
  // show BACK Options
  if (tool == "BACK")
  {
    sbBACK1.show();
    sbBACK2.show();
    sbBACK3.show();
    sbBACKa.show();
    cbBACKadd.show();
    cbBACKv.show();
    cbBACKh.show();
    cbBACKrgb.show();
    cbBACKhsb.show();
  }
  // show Filler Options
  else if (tool == "Filler")
  {
    slFILLER.show();
    cbFILLERASE.show();
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
  // Show Select Options
  else if (tool == "Select")
  {
    cbSELECT.show();
    cbSELOUT.show();
    btSELCOPY.show();
    btSELPASTE.show();
    btSELDRAW.show();
    btSELSAVE.show();
  }
  // Show Stencil Options
  else if (tool == "Stencil")
  {
    cbSTENCIL.show();
    btSTENLOAD.show();
    btSTENCENTER.show();
    btSTENCREA.show();
    btSTENINVERT.show();
  }
  // Show Confetti Options
  else if (tool == "Confetti")
  {
    cbCONFSCALE.show();
    cbCONFRND.show();
    slCONFVEL.show();
    slCONFDVEL.show();
  }
  // Show Shape Options
  else if (tool == "Shape") //SHAPE
  {
    slSHitems.show();
    slSHsizeD.show();
    slSHalfaD.show();
    slSHposD.show();
    cbSHcolorRND.show();
    cbSHstyle.show();
    sbSHtype.show();
    btSHSVG.show();
  }
}