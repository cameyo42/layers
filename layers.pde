// Layers: a sketch for painting
// version 0.7
// written with processing 3.x
// by cameyo 2017
// WTFPL license (see the WTFPL.txt file)
// Thanks to:
// Anonymous, Bird, Bollinger Chrisir, GoToLoop,
// jas0501, jeremydouglass, kfrajer, koogs, Lord_of_the_Galaxy,
// neilcsmith_net, PhilLo, prince_polka,
// quark, Shiffman, TfGuy44, ...

// Import libraries
// PDF output
import processing.pdf.*;
// Input dialog
import javax.swing.JOptionPane;
// Used by floodfill() function
import java.util.ArrayDeque;
// Used by Ink pen
import java.awt.Polygon;
// OS info
String OS;
// windows on top flag
boolean onTop;
// array used by floodfill() function
ArrayDeque<Point> q = new ArrayDeque<Point>();
// Ink brush
InkBrush myIB;
// DynaDraw brush
DynaDraw myDD;
// DynaDraw Sliders and Buttons
DynaSlider dslHOOKE, dslDAMPING, dslDUCTUS, dslMASS, dslMINB, dslMAXB;
DynaButton btnPRE01, btnPRE02, btnPRE03, btnPRE04, btnPRE05, btnPRE06, btnPRE07, btnPRE08;
// Stamp Brush
StampBrushes mySB;

// Test Brush
import java.util.HashSet;
import java.util.Set;
Set<String> pts = new HashSet<String>();

// tools icon images
PImage gui_IMG;
PImage pencilON_IMG, pencilOFF_IMG, eraserON_IMG, eraserOFF_IMG, fillerON_IMG, fillerOFF_IMG,
       linerON_IMG, linerOFF_IMG, quadON_IMG, quadOFF_IMG, circleON_IMG, circleOFF_IMG;
PImage undoON_IMG, undoOFF_IMG, redoON_IMG, redoOFF_IMG, lockON_IMG, lockOFF_IMG;
PImage verniceON_IMG, verniceOFF_IMG, inkON_IMG, inkOFF_IMG, stampON_IMG, stampOFF_IMG, dynaON_IMG, dynaOFF_IMG;
PImage mixerON_IMG, mixerOFF_IMG, cloneON_IMG, cloneOFF_IMG, webON_IMG, webOFF_IMG, selectOFF_IMG, selectON_IMG;
PImage stencilON_IMG, stencilOFF_IMG, confettiON_IMG, confettiOFF_IMG, shapeON_IMG, shapeOFF_IMG;
PImage copyPixel_IMG, pastePixel_IMG, drawSelPixel_IMG, saveSel_IMG, shapeSVG_IMG;
PImage grid_IMG, freeze_IMG, open_IMG, save_IMG, openLyr_IMG, creaStencil_IMG, loadStencil_IMG, centerStencil_IMG, invertStencil_IMG;
PImage pre01ON_IMG, pre02ON_IMG, pre03ON_IMG, pre04ON_IMG, pre05ON_IMG, pre06ON_IMG, pre07ON_IMG, pre08ON_IMG;
PImage pre01OFF_IMG, pre02OFF_IMG, pre03OFF_IMG, pre04OFF_IMG, pre05OFF_IMG, pre06OFF_IMG, pre07OFF_IMG, pre08OFF_IMG;
PImage stampBRUSHES_IMG;
PGraphics stampPG;
PImage lyrCTRL_IMG;
// fill tolerance
float fillTolMin;
float fillTolMax;
float fillTolerance;

// remove antialiasing glitch when drawing on transparent layer or with alpha < 255 (slow down a bit the paint)
boolean noGlitch;
boolean startGlitch, stopGlitch;

// font
PFont font;

// start action who modifies layer
boolean startAction;

// Palette colors
color white, black;
// total number of palette pages
int numPalettes = 13;
PImage palettes[] = new PImage[numPalettes];
int activePalettePage;
Palette tavolozza;

// RGB and HSB controls
RGB_HSB rgbhsb;
HSBcontrol myHSB;

// Open and Save file
// name of file
String folder; // folder path
String filename; // fullpath + fname
String fname; // name + ext
String fpath; // fullpath
String name; // name (without ext)
String folderSep; // folder separator: "\" for windows and "/" for unix
boolean loadingLayer;
boolean loadingDraw;
File dummyFile = new File("draw");
File dummyFolder = new File("");

// dummy file for layers
PGraphics dummy;

// background color
color backCol;
// pointer color (black or white)
color pointerCol;

// brush size
color brushSize;
int brushSizeMax, brushSizeMin;
// brush color
color brushCol;
// alpha value
int alfa;

// line draw coords
int x1, y1;
int x2, y2;
int x1L, y1L;
int x2L, y2L;

//stamp tool
int xs0,ys0;
int xs1,ys1;
boolean userStamp;

// center of canvas
float centerX, centerY;
// symmetry
int s1x, s1y, s2x, s2y;
boolean symX, symY;
// grid
int gridX, gridY;
boolean grid;
boolean snap2Grid;

// Cursor and Zoom properties
boolean zoom;
PImage canvasIMG;
float magnify;
boolean highlightCursor;

// menu and colors
boolean menu;
int menuX, menuY;
color highLight;
color backMenuCol;
color textMenuCol;
color darkGray, gray, lightGray;
boolean toolHSB;

// tools: Pencil, Eraser, Filler, Liner, Quad, Circle
String tool;
boolean picker;
boolean lineDown, quadDown, circleDown;
boolean quadLock, circleLock;

// Layers control
int numLayers = 6;
Layer[] livelli = new Layer[numLayers];
LayerControl controlloLivelli;
// show Layer GUI
boolean showLayerGUI;
// active layer
int activeLyr;

// Undo changes
// array of PGraphics and Layer index for undo (all transparent)
boolean grab;
PGraphics grabPG;
int grabLyr;
int numUndo;
PGraphics[] undoPG;
int[] undoLyr;
int numRedo;
PGraphics[] redoPG;
int[] redoLyr;

// GUI elements (buttons, slider, spinners, ...)
ButtonIMG btnPENCIL, btnLINER, btnQUAD, btnCIRCLE, btnERASER, btnLOCK;
ButtonIMG btnFILLER, btnVERNICE, btnINK, btnSTAMP, btnDYNA, btnMIXER, btnCLONE, btnWEB, btnSELECT, btnSTENCIL, btnCONFETTI, btnSHAPE;
ButtonIMG btnUNDO, btnREDO;
Button btGRID, btWEB, btOPENLYR, btOPEN, btSAVE;
Button btSTENLOAD, btSTENCREA, btSTENCENTER, btSTENINVERT;
Button btSELCOPY, btSELPASTE, btSELDRAW, btSELSAVE, btSHSVG;
ButtonColor btcBACKCOL;
Slider slSIZE, slALFA, slSTAMP, slSTAMP2, slFILLER, slMIXERA, slMIXERD, slWEBA, slWEBD;
Slider slSHitems, slSHalfaD, slSHsizeD, slSHposD;
Checkbox cbSHcolorRND, cbSHstyle;
SpinBound sbSHtype;
Checkbox cbSYMX, cbSYMY, cbGLITCH, cbGRID, cbSNAP, cbCLONE, cbWEBE, cbWEBP;
Checkbox cbSELECT, cbSTENCIL, cbFILLERASE;
Checkbox cbSELOUT;
Checkbox cbCONFSCALE, cbCONFRND;
Slider slCONFVEL, slCONFDVEL;
SpinBound sbGRIDX, sbGRIDY, sbWEBT, sbWEBJ;

// mixer brush
PImage mixer;  // mixer brush image
int mixer_alpha;   // mixer brush alpha (start alpha: 0 -> 255)
int mixer_decay;   // mixer brush decay (step alpha: 0 -> 25)

// clone brush
boolean cloneGap;
int cloneX, cloneY, gapX, gapY;

// web brush
// array of pont history
ArrayList<PVector> cobweb = new ArrayList<PVector>();
// distance of attraction
float attractionW;
// density of line drawing
float densityW;
// drawing type
int typeW;
// jitter
int jitterW;
// show web points
boolean pointsW;
// erase point when draw
boolean eraseW;
// web points layer (PGraphics)
PGraphics web;
// update web PG only when change
boolean updateWeb;
// web point color
color webPointCol = color (255,0,0);

// selection
boolean aSelection;
boolean selectDown;
int x1sel, y1sel, x2sel, y2sel;
color fillSelect;
boolean eraseOutside;
// copy & paste
boolean pixelCopy, pixelPaste;
boolean layerPaste;
PImage pixelCopyIMG;

// stencil
PImage stencilIMG;
boolean stencil;
boolean loadingStencil;
int xsten, ysten;

// confetti
ArrayList confettiThings;
//MultiPalette pal;
boolean scaleConfetti;
boolean randomConfettiColor;

// shape
int shItems, shPosD;
int shSizeD, shAlfaD;
PShape aShape;
boolean loadingShape;

//*********************************
//*********************************
void setup()
{
  //size(1800, 1000);
  // macBook Pro 13" 1280x800
  // macBook Air 12" 1300x750
  size(1300,750);
  //size(1900,900);
  //size(1280,800);
  smooth();
  noCursor();
  frameRate(100);
  OS = platformNames[platform];
  if (OS == "windows")
  {
    PImage icon = loadImage("icon.png"); // set icon
    surface.setIcon(icon);
    folderSep = "\\";
  }
  else { folderSep = "/"; }

  // set monitor (high dpi)
  println(displayDensity());
  //pixelDensity(displayDensity()); // wrong with iMac

  onTop = false;
  startAction = false;
  noGlitch = false;
  startGlitch= false;
  stopGlitch = true;
  // background color
  backCol = color(245);
  font = createFont("Calibri Bold", 13);
  //font = createFont("Arial Bold", 12);
  textFont(font);
  // menu colors
  white = color(255);
  black = color(0);
  highLight = color(83,114,142);
  darkGray = color(66,66,66);
  gray = color(72,72,72);
  lightGray = color(128,128,128);
  backMenuCol = color(56,56,56);
  textMenuCol = color(202, 202, 202);
  // pointer colors
  pointerCol = black;
  // set brush parameters
  alfa = 255;
  brushCol = color(3,7,8, alfa); //
  brushSize= 10;
  brushSizeMax = 64;
  brushSizeMin = 1;
  // set cursor/zoom parameters
  highlightCursor = false;
  zoom = false;
  magnify = 3.0;
  // set active layer
  activeLyr = 0;
  // set active palette page
  activePalettePage = 0;
  // calculate center of canvas (x and y axis)
  centerX = width/2.0;
  centerY = height/2.0;
  // grid
  grid = false;
  gridX = 25;
  gridY = 25;
  snap2Grid = false;
  // symmetry
  symX = false;
  symY = false;
  // set tool
  tool = "Ink";
  picker = false;
  lineDown = false;
  quadDown = false;
  quadLock = false;
  circleDown = false;
  circleLock = false;
  userStamp = false;
  // web tool
  // show web points
  pointsW = false;
  // erase point when draw
  eraseW = false;
  // web points layer (PGraphics)
  web = createGraphics(width,height);
  web.beginDraw();
  web.clear();
  web.endDraw();
  updateWeb = false;
  // selection
  aSelection = false;
  selectDown = false;
  fillSelect = color(83,114,142,50);
  eraseOutside = false;
  x1sel = 0;
  y1sel = 0;
  x2sel = 0;
  y2sel = 0;
  // copy & paste
  pixelCopy = false;
  pixelPaste = false;
  layerPaste = false;
  // stencil
  stencil = false;
  stencilIMG = loadImage("stencil.png");
  loadingStencil = false;
  ysten = height/2 - stencilIMG.height/2;
  xsten = width/2 - stencilIMG.width/2;
  // confetti
  confettiThings = new ArrayList();
  scaleConfetti = true;
  randomConfettiColor = false;
  // shape
  aShape = loadShape("shape.svg");
  shItems = 1;
  shPosD = 10;
  shSizeD = 10;
  shAlfaD = 50;
  aShape.enableStyle();
  loadingShape = false;
  // undo/redo variables
  grab = true;
  numUndo = 10;
  numRedo = numUndo;
  undoPG = new PGraphics[numUndo];
  undoLyr = new int[numUndo];
  redoPG = new PGraphics[numUndo];
  redoLyr = new int[numUndo];
  // open/save
  filename  = "";
  fname  = "";
  fpath = "";
  name  = "";
  loadingLayer = false;
  loadingDraw = false;
  // load tools icon images
  gui_IMG = loadImage("gui_IMAGES.png");
  pencilOFF_IMG = gui_IMG.get(0, 0, 34, 34);
  pencilON_IMG = gui_IMG.get(34, 0, 34, 34);
  linerOFF_IMG = gui_IMG.get(34*2, 0, 34, 34);
  linerON_IMG = gui_IMG.get(34*3, 0, 34, 34);
  quadOFF_IMG = gui_IMG.get(34*4, 0, 34, 34);
  quadON_IMG = gui_IMG.get(34*5, 0, 34, 34);
  circleOFF_IMG = gui_IMG.get(34*6, 0, 34, 34);
  circleON_IMG = gui_IMG.get(34*7, 0, 34, 34);
  verniceOFF_IMG = gui_IMG.get(34*8, 0, 34, 34);
  verniceON_IMG = gui_IMG.get(34*9, 0, 34, 34);
  inkOFF_IMG = gui_IMG.get(34*10, 0, 34, 34);
  inkON_IMG = gui_IMG.get(34*11, 0, 34, 34);
  stampOFF_IMG = gui_IMG.get(34*12, 0, 34, 34);
  stampON_IMG = gui_IMG.get(34*13, 0, 34, 34);
  dynaOFF_IMG = gui_IMG.get(34*14, 0, 34, 34);
  dynaON_IMG = gui_IMG.get(34*15, 0, 34, 34);
  eraserOFF_IMG = gui_IMG.get(34*16, 0, 34, 34);
  eraserON_IMG = gui_IMG.get(34*17, 0, 34, 34);
  fillerOFF_IMG = gui_IMG.get(34*18, 0, 34, 34);
  fillerON_IMG = gui_IMG.get(34*19, 0, 34, 34);
  webOFF_IMG = gui_IMG.get(1274, 102, 34, 34);
  webON_IMG = gui_IMG.get(1240, 102, 34, 34);
  freeze_IMG = gui_IMG.get(1080, 0, 20, 20);
  undoOFF_IMG = gui_IMG.get(34*20, 0, 34, 34);
  undoON_IMG = gui_IMG.get(34*21, 0, 34, 34);
  redoOFF_IMG = gui_IMG.get(34*22, 0, 34, 34);
  redoON_IMG = gui_IMG.get(34*23, 0, 34, 34);
  grid_IMG = gui_IMG.get(34*24, 0, 34, 34);
  openLyr_IMG = gui_IMG.get(34*25, 0, 34, 34);
  open_IMG = gui_IMG.get(34*26, 0, 34, 34);
  save_IMG = gui_IMG.get(34*27, 0, 34, 34);
  lockON_IMG = gui_IMG.get(34*28, 0, 64, 8);
  lockOFF_IMG = gui_IMG.get(34*28, 8, 64, 8);
  pre01OFF_IMG = gui_IMG.get(1264, 0, 16, 16);
  pre01ON_IMG = gui_IMG.get(1264+16, 0, 16, 16);
  pre02OFF_IMG = gui_IMG.get(1264+16*2, 0, 16, 16);
  pre02ON_IMG = gui_IMG.get(1264+16*3, 0, 16, 16);
  pre03OFF_IMG = gui_IMG.get(1264, 16, 16, 16);
  pre03ON_IMG = gui_IMG.get(1264+16, 16, 16, 16);
  pre04OFF_IMG = gui_IMG.get(1264+16*2, 16, 16, 16);
  pre04ON_IMG = gui_IMG.get(1264+16*3, 16, 16, 16);
  pre05OFF_IMG = gui_IMG.get(1016, 0, 16, 16);
  pre05ON_IMG = gui_IMG.get(1032, 0, 16, 16);
  pre06OFF_IMG = gui_IMG.get(1048, 0, 16, 16);
  pre06ON_IMG = gui_IMG.get(1064, 0, 16, 16);
  pre07OFF_IMG = gui_IMG.get(1016, 16, 16, 16);
  pre07ON_IMG = gui_IMG.get(1032, 16, 16, 16);
  pre08OFF_IMG = gui_IMG.get(1048, 16, 16, 16);
  pre08ON_IMG = gui_IMG.get(1064, 16, 16, 16);
  mixerON_IMG = gui_IMG.get(1240, 34, 34, 34);
  mixerOFF_IMG = gui_IMG.get(1274, 34, 34, 34);
  cloneON_IMG = gui_IMG.get(1240, 68, 34, 34);
  cloneOFF_IMG = gui_IMG.get(1274, 68, 34, 34);
  stampBRUSHES_IMG = gui_IMG.get(775, 213, 177, 17);
  selectON_IMG = gui_IMG.get(1240, 136, 34, 34);
  selectOFF_IMG = gui_IMG.get(1274, 136, 34, 34);
  copyPixel_IMG = gui_IMG.get(1308, 110, 20, 20);
  pastePixel_IMG = gui_IMG.get(1308, 130, 20, 20);
  drawSelPixel_IMG = gui_IMG.get(1308, 90, 20, 20);
  saveSel_IMG = gui_IMG.get(1308, 70, 20, 20);
  creaStencil_IMG = gui_IMG.get(1308, 150, 20, 20);
  loadStencil_IMG = gui_IMG.get(1308, 170, 20, 20);
  centerStencil_IMG = gui_IMG.get(1308, 190, 20, 20);
  invertStencil_IMG = gui_IMG.get(1308, 210, 20, 20);
  stencilON_IMG = gui_IMG.get(1240, 170, 34, 34);
  stencilOFF_IMG = gui_IMG.get(1274, 170, 34, 34);
  confettiOFF_IMG = gui_IMG.get(1274, 204, 34, 34);
  confettiON_IMG = gui_IMG.get(1240, 204, 34, 34);
  shapeOFF_IMG = gui_IMG.get(1274, 238, 34, 34);
  shapeON_IMG = gui_IMG.get(1240, 238, 34, 34);
  shapeSVG_IMG = gui_IMG.get(1308, 230, 20, 20);
  lyrCTRL_IMG = gui_IMG.get(1113, 0, 151, 26);

  // grab PGraphic for undo
  grabPG = createGraphics(width,height);
  grabPG.beginDraw();
  grabPG.clear();
  grabPG.endDraw();
  menu = true;
  menuX = 310;
  menuY = 750;
  toolHSB = true; // show HSB control

  // Stamp brush stroke
  mySB = new StampBrushes(10, 448, stampBRUSHES_IMG);

  // Ink brush stroke
  myIB = new InkBrush(width, height);

  // DynaDraw brush stroke
  myDD = new DynaDraw();

  // create GUI elements
  btnPENCIL = new ButtonIMG(5, 184, pencilON_IMG, pencilOFF_IMG, false, "", textMenuCol, "btn_PENCIL");
  btnLINER = new ButtonIMG(41, 184, linerON_IMG, linerOFF_IMG, false, "", textMenuCol, "btn_LINER");
  btnQUAD = new ButtonIMG(77, 184, quadON_IMG, quadOFF_IMG, false, "", textMenuCol, "btn_QUAD");
  btnCIRCLE = new ButtonIMG(113, 184, circleON_IMG, circleOFF_IMG, false, "", textMenuCol, "btn_CIRCLE");
  btnLOCK = new ButtonIMG(80, 174, lockON_IMG, lockOFF_IMG, false, "", textMenuCol, "btn_LOCK");
  btnVERNICE = new ButtonIMG(5, 256, verniceON_IMG, verniceOFF_IMG, false, "", textMenuCol, "btn_VERNICE");
  btnINK = new ButtonIMG(41, 256, inkON_IMG, inkOFF_IMG, true, "", textMenuCol, "btn_INK");
  btnSTAMP = new ButtonIMG(77, 256, stampON_IMG, stampOFF_IMG, false, "", textMenuCol, "btn_STAMP");
  slSTAMP = new Slider(10, 388, 210, 388, 5, "gap", 1, 100, 10, black, highLight, black, textMenuCol, "sl_STAMP");
  slSTAMP2 = new Slider(10, 422, 210, 422, 5, "density", 1, 100, 50, black, highLight, black, textMenuCol, "sl_STAMP2");
  btnMIXER = new ButtonIMG(113, 256, mixerON_IMG, mixerOFF_IMG, false, "", textMenuCol, "btn_MIXER");
  slMIXERA = new Slider(10, 388, 265, 388, 5, "strenght", 0, 255, 200, black, highLight, black, textMenuCol, "sl_MIXERA");
  slMIXERD = new Slider(10, 422, 210, 422, 5, "decay", 0, 50, 10, black, highLight, black, textMenuCol, "sl_MIXERD");
  btnDYNA = new ButtonIMG(5, 292, dynaON_IMG, dynaOFF_IMG, false, "", textMenuCol, "btn_DYNA");
  btnFILLER = new ButtonIMG(41, 292, fillerON_IMG, fillerOFF_IMG, false, "", textMenuCol, "btn_FILLER");
  slFILLER = new Slider(10, 388, 280, 388, 5, "threshold", 0, 100, 0, black, highLight, black, textMenuCol, "sl_FILLER");
  cbFILLERASE = new Checkbox(6, 420, 14, 14, "erase", false, black, darkGray, highLight, gray, textMenuCol, "cb_FILLERASE");
  btnCLONE = new ButtonIMG(77, 292, cloneON_IMG, cloneOFF_IMG, false, "", textMenuCol, "btn_CLONE");
  cbCLONE = new Checkbox(6, 380, 14, 14, "aligned", false, black, darkGray, highLight, gray, textMenuCol, "cb_CLONE");
  btnWEB = new ButtonIMG(113, 292, webON_IMG, webOFF_IMG, false, "", textMenuCol, "btn_WEB");
  slWEBA = new Slider(10, 422, 265, 422, 5, "attraction", 0, 200, 60, black, highLight, black, textMenuCol, "sl_WEBA");
  slWEBD = new Slider(10, 388, 210, 388, 5, "density", 0, 100, 40, black, highLight, black, textMenuCol, "sl_WEBD");
  btWEB = new Button(278, 374, freeze_IMG, "clear", textMenuCol, "bt_WEB");
  sbWEBJ = new SpinBound(35, 444, 50, 14, "jitter", 0, 1, 0, 50, black, gray, textMenuCol, "sb_WEBJ");
  sbWEBT = new SpinBound(126, 444, 50, 14, "type", 1, 1, 0, 4, black, gray, textMenuCol, "sb_WEBT");
  cbWEBE = new Checkbox(254, 444, 14, 14, "erase", false, black, darkGray, highLight, gray, textMenuCol, "cb_WEBE");
  cbWEBP = new Checkbox(192, 444, 14, 14, "points", false, black, darkGray, highLight, gray, textMenuCol, "cb_WEBP");
  btnERASER = new ButtonIMG(270, 108, eraserON_IMG, eraserOFF_IMG, false, "", textMenuCol, "btn_ERASER");
  btnSELECT = new ButtonIMG(5, 328, selectON_IMG, selectOFF_IMG, false, "", textMenuCol, "btn_SELECT");
  cbSELECT = new Checkbox(6, 380, 14, 14, "active (F3)", false, black, darkGray, highLight, gray, textMenuCol, "cb_SELECT");
  cbSELOUT = new Checkbox(150, 380, 14, 14, "erase outside (F9)", false, black, darkGray, highLight, gray, textMenuCol, "cb_SELOUT");
  btSELCOPY = new Button(20, 420, copyPixel_IMG, "copy (F5)", textMenuCol, "bt_SELCOPY");
  btSELPASTE = new Button(90, 420, pastePixel_IMG, "paste (F6)", textMenuCol, "bt_SELPASTE");
  btSELDRAW = new Button(160, 420, drawSelPixel_IMG, "draw (F7)", textMenuCol, "bt_SELDRAW");
  btSELSAVE = new Button(230, 420, saveSel_IMG, "save (F8)", textMenuCol, "bt_SELSAVE");
  btnSTENCIL = new ButtonIMG(41, 328, stencilON_IMG, stencilOFF_IMG, false, "", textMenuCol, "btn_STENCIL");
  cbSTENCIL = new Checkbox(6, 380, 14, 14, "active (F4)", false, black, darkGray, highLight, gray, textMenuCol, "cb_STENCIL");
  btSTENLOAD = new Button(95, 380, loadStencil_IMG, "load", textMenuCol, "bt_STENLOAD");
  btSTENCREA = new Button(135, 380, creaStencil_IMG, "create", textMenuCol, "bt_STENCREA");
  btSTENCENTER = new Button(175, 380, centerStencil_IMG, "center", textMenuCol, "bt_STENCENTER");
  btSTENINVERT = new Button(215, 380, invertStencil_IMG, "invert", textMenuCol, "bt_STENINVERT");
  btnCONFETTI = new ButtonIMG(77, 328, confettiON_IMG, confettiOFF_IMG, false, "", textMenuCol, "btn_CONFETTI");
  cbCONFSCALE = new Checkbox(6, 380, 14, 14, "scale", scaleConfetti, black, darkGray, highLight, gray, textMenuCol, "cb_CONFSCALE");
  cbCONFRND = new Checkbox(76, 380, 14, 14, "random color", randomConfettiColor, black, darkGray, highLight, gray, textMenuCol, "cb_CONFRND");
  slCONFVEL = new Slider(10, 416, 210, 416, 5, "base speed", 1, 50, 4, black, highLight, black, textMenuCol, "sl_CONFVEL");
  slCONFDVEL = new Slider(10, 450, 210, 450, 5, "delta speed", 1, 99, 88, black, highLight, black, textMenuCol, "sl_CONFDVEL");
  btnUNDO = new ButtonIMG(236, 698, undoON_IMG, undoOFF_IMG, false, "Undo", textMenuCol, "btn_UNDO");
  btnREDO = new ButtonIMG(271, 698, redoON_IMG, redoOFF_IMG, false, "Redo", textMenuCol, "btn_REDO");
  cbSYMX = new Checkbox(6, 92, 14, 14, "X mirror", false, black, darkGray, highLight, gray, textMenuCol, "cb_SYMX");
  cbSYMY = new Checkbox(6, 110, 14, 14, "Y mirror", false, black, darkGray, highLight, gray, textMenuCol, "cb_SYMY");
  cbGLITCH = new Checkbox(6, 136, 14, 14, "Antialias", false, black, darkGray, highLight, gray, textMenuCol, "cb_GLITCH");
  btGRID = new Button(90, 108, grid_IMG, "", textMenuCol, "bt_GRID");
  cbGRID = new Checkbox(182, 109, 14, 14, "show", false, black, darkGray, highLight, gray, textMenuCol, "cb_GRID");
  cbSNAP = new Checkbox(182, 126, 14, 14, "snap", false, black, darkGray, highLight, gray, textMenuCol, "cb_SNAP");
  sbGRIDX = new SpinBound(128, 109, 50, 14, "", 25, 1, 2, 500, black, gray, textMenuCol, "sb_GRIDX");
  sbGRIDY = new SpinBound(128, 126, 50, 14, "", 25, 1, 2, 500, black, gray, textMenuCol, "sb_GRIDY");
  slALFA = new Slider(6, 156, 261, 156, 5, "alpha", 1, 255, 255, black, highLight, black, textMenuCol, "sl_ALFA");
  slSIZE = new Slider(10, 236, 138, 236, 5, "size", 1, 64, 10, black, highLight, black, textMenuCol, "sl_SIZE");
  btOPENLYR = new Button(268, 478, openLyr_IMG, "Import", textMenuCol, "bt_OPENLYR");
  btOPEN = new Button(268, 536, open_IMG, "Open", textMenuCol, "bt_OPEN");
  btSAVE = new Button(268, 594, save_IMG, "Save", textMenuCol, "bt_SAVE");
  btcBACKCOL = new ButtonColor(150, 355, 154, 12, black, backCol, "", textMenuCol, "btc_BACKCOL");
  // Dyna Sliders
  dslHOOKE = new DynaSlider(10, 394, 130, 394, 4, "k", 0.01, 1.00, myDD.k, 2, black, highLight, black, textMenuCol, "dsl_HOOKE");
  dslMASS = new DynaSlider(170, 394, 290, 394, 4, "m", 0.1, 5.0, myDD.mass, 1, black, highLight, black, textMenuCol, "dsl_MASS");
  dslDAMPING = new DynaSlider(10, 425, 130, 425, 4, "f", 0.01, 1.00, myDD.damping, 2, black, highLight, black, textMenuCol, "dsl_DAMPING");
  dslDUCTUS = new DynaSlider(170, 425, 290, 425 , 4, "d", 0.0, 5.0, myDD.ductus, 1, black, highLight, black, textMenuCol, "dsl_DUCTUS");
  dslMINB = new DynaSlider(10, 456, 130, 456, 4, "b", 1.0, 64.0, myDD.min_brush, 0, black, highLight, black, textMenuCol, "dsl_MINB");
  dslMAXB = new DynaSlider(170, 456, 290, 456, 4, "B", 1.0, 64.0, myDD.max_brush, 0, black, highLight, black, textMenuCol, "dsl_MAXB");
  //Dyna Buttons
  btnPRE01 = new DynaButton(10, 368, pre01ON_IMG, pre01OFF_IMG, true,  "btn_PRE01");
  btnPRE02 = new DynaButton(26, 368, pre02ON_IMG, pre02OFF_IMG, false, "btn_PRE02");
  btnPRE03 = new DynaButton(42, 368, pre03ON_IMG, pre03OFF_IMG, false, "btn_PRE03");
  btnPRE04 = new DynaButton(56, 368, pre04ON_IMG, pre04OFF_IMG, false, "btn_PRE04");
  btnPRE05 = new DynaButton(70, 368, pre05ON_IMG, pre05OFF_IMG, false, "btn_PRE05");
  btnPRE06 = new DynaButton(84, 368, pre06ON_IMG, pre06OFF_IMG, false, "btn_PRE06");
  btnPRE07 = new DynaButton(100, 368, pre07ON_IMG, pre07OFF_IMG, false, "btn_PRE07");
  btnPRE08 = new DynaButton(116, 368, pre08ON_IMG, pre08OFF_IMG, false, "btn_PRE08");
  // Shape button and Sliders
  btnSHAPE = new ButtonIMG(113, 328, shapeON_IMG, shapeOFF_IMG, false, "", textMenuCol, "btn_SHAPE");
  slSHitems = new Slider(10, 394, 130, 394, 4, "items", 1, 10, shItems, black, highLight, black, textMenuCol, "sl_SHitems");
  slSHsizeD = new Slider(10, 425, 130, 425, 4, "delta size", 0, 64, shSizeD, black, highLight, black, textMenuCol, "sl_SHsizeD");
  slSHalfaD = new Slider(170, 425, 290, 425, 4, "delta alpha", 0, 128, shAlfaD, black, highLight, black, textMenuCol, "sl_SHalfaD");
  slSHposD = new Slider(10, 456, 210, 456, 4, "jitter", 0, 200, shPosD, black, highLight, black, textMenuCol, "sl_SHposD");
  cbSHcolorRND = new Checkbox(6, 368, 14, 14, "RND color", false, black, darkGray, highLight, gray, textMenuCol, "cb_SHcolorRND");
  btSHSVG = new Button(170, 376, shapeSVG_IMG, "load SVG", textMenuCol, "bt_SHSVG");
  cbSHstyle = new Checkbox(230, 380, 14, 14, "style SVG", true, black, darkGray, highLight, gray, textMenuCol, "cb_SHstyle");
  sbSHtype = new SpinBound(254, 445, 50, 14, "type", 1, 1, 1, 5, black, gray, textMenuCol, "sb_SHtype");

  // RGB and HSB control
  rgbhsb = new RGB_HSB(82, 15, 12*18, 4*18, brushCol, black, gray, textMenuCol, "rgbhsb_M");
  myHSB = new HSBcontrol(width-230, 50, brushCol, "HSB_M");

  // PALETTE control
  // load palette images
  palettes[0] = gui_IMG.get(0, 34, 155, 179);
  palettes[1] = gui_IMG.get(155, 34, 155, 179);
  palettes[2]  = gui_IMG.get(155*2, 34, 155, 179);
  palettes[3]  = gui_IMG.get(155*3, 34, 155, 179);
  palettes[4]  = gui_IMG.get(155*4, 34, 155, 179);
  palettes[5]  = gui_IMG.get(155*5, 34, 155, 179);
  palettes[6]  = gui_IMG.get(155*6, 34, 155, 179);
  palettes[7]  = gui_IMG.get(155*7, 34, 155, 179);
  palettes[8]  = gui_IMG.get(0, 213, 155, 179);
  palettes[9]  = gui_IMG.get(155,  213, 155, 179);
  palettes[10] = gui_IMG.get(155*2, 213, 155, 179);
  palettes[11] = gui_IMG.get(155*3, 213, 155, 179);
  palettes[12] = gui_IMG.get(155*4, 213, 155, 179);
  activePalettePage = 0;
  tavolozza = new Palette(palettes, 150, 174, numPalettes, color(232), black, color(128), "palette_M", activePalettePage);

  // LAYERS controls
  int baseX = 5;
  int baseY = 478;
  int step = 40;
  int lwidth = 150;
  int lheight = lwidth/6;
  livelli[0] = new Layer(dummy, width, height, 0, 0, true, true, false,  "layer 1", 255, "normal",
                         baseX, baseY+step*0, lwidth, lheight, textMenuCol, black, darkGray,
                         "liv1", 0, 0);
  livelli[1] = new Layer(dummy, width, height, 0, 0, false, false, false, "layer 2", 255, "normal",
                         baseX, baseY+step*1, lwidth, lheight, textMenuCol, black, darkGray,
                         "liv2", 1, 1);
  livelli[2] = new Layer(dummy, width, height, 0, 0, false, false, false, "layer 3", 255, "normal",
                         baseX, baseY+step*2, lwidth,lheight, textMenuCol, black, darkGray,
                         "liv3", 2, 2);
  livelli[3] = new Layer(dummy, width, height, 0, 0, false, false, false, "layer 4", 255, "normal",
                         baseX, baseY+step*3, lwidth, lheight, textMenuCol, black, darkGray,
                         "liv4", 3, 3);
  livelli[4] = new Layer(dummy, width, height, 0, 0, false, false, false, "layer 5", 255, "normal",
                         baseX, baseY+step*4, lwidth, lheight, textMenuCol, black, darkGray,
                         "liv5", 4, 4);
  livelli[5] = new Layer(dummy, width, height, 0, 0, false, false, false, "layer 6", 255, "normal",
                         baseX, baseY+step*5, lwidth, lheight, textMenuCol, black, darkGray,
                         "liv6", 5, 5);
//  livelli[6] = new Layer(dummy, width, height, 0, 0, true, false, false, "layer 7", 255, "normal",
//                         baseX, baseY+step*6, lwidth, lheight, textMenuCol, black, darkGray,
//                         "liv7", 6, 6);
//  livelli[7] = new Layer(dummy, width, height, 0, 0, true, false, false, "layer 8", 255, "normal",
//                         baseX, baseY+step*7, lwidth, lheight, textMenuCol, black, darkGray,
//                         "liv8", 7, 7);
//  livelli[8] = new Layer(dummy, width, height, 0, 0, true, false, false, "layer 9", 255, "normal",
//                         baseX, baseY+step*8, lwidth, lheight, textMenuCol, black, darkGray,
//                         "liv9", 8, 8);
  // layerControl
  controlloLivelli = new LayerControl(5, 718, lyrCTRL_IMG);
  // show Layer GUI
  showLayerGUI = true;

  // set UNDO/REDO
  resetUNDO_REDO();
} // end setup()

// GUI elements methods
// palette method
void palette_M()
{
  //brushCol = color(red(tavolozza.currentCol), green(tavolozza.currentCol), blue(tavolozza.currentCol), alfa);
  brushCol = color((tavolozza.currentCol >> 16) & 0xFF, (tavolozza.currentCol >> 8)  & 0xFF, tavolozza.currentCol & 0xFF, alfa);
  rgbhsb.setRGBHSB(brushCol);
  myHSB.updateHSB("HSB");
}
// rgbhsb method
void rgbhsb_M()
{
  //brushCol = color(red(rgbhsb.cc), green(rgbhsb.cc), blue(rgbhsb.cc), alfa);
  brushCol = color((rgbhsb.cc >> 16) & 0xFF, (rgbhsb.cc >> 8)  & 0xFF, rgbhsb.cc & 0xFF, alfa);
  // update HSBcontrol (myHSB)
  myHSB.updateHSB("HSB");
}
// HSB method
void HSB_M()
{
  brushCol = color((myHSB.c >> 16) & 0xFF, (myHSB.c >> 8)  & 0xFF, myHSB.c & 0xFF, alfa);
  rgbhsb.setRGBHSB(brushCol);
}

// SIZE slider method
void sl_SIZE() { brushSize = (int)slSIZE.v; }
// ALFA slider method
void sl_ALFA()
{
  alfa = (int)slALFA.v;
  //brushCol = color(red(brushCol),green(brushCol),blue(brushCol),alfa);
  brushCol = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, alfa);
}
void btn_PENCIL()   { selectTool("Pencil"); }
void btn_LINER()    { selectTool("Liner"); }
void btn_QUAD()     { selectTool("Quad"); }
void btn_LOCK()     { quadLock = !quadLock; circleLock = !circleLock; btnLOCK.s = !btnLOCK.s;}
void btn_ERASER()   { selectTool("Eraser"); }
void btn_CIRCLE()   { selectTool("Circle"); }
void btn_VERNICE()  { selectTool("Vernice"); }
void btn_INK()      { selectTool("Ink"); }
void btn_STAMP()    { selectTool("Stamp"); }
void btn_DYNA()     { selectTool("Dyna"); }
void btn_FILLER()   { selectTool("Filler"); }
void btn_MIXER()    { selectTool("Mixer"); }
void btn_CLONE()    { selectTool("Clone"); }
void btn_WEB()      { selectTool("Web"); }
void btn_SELECT()   { selectTool("Select"); }
void btn_STENCIL()  { selectTool("Stencil"); }
void btn_CONFETTI() { selectTool("Confetti"); }
void btn_SHAPE()    { selectTool("Shape"); }
void btn_UNDO()     { undo(); }
void btn_REDO()     { redo(); }
// SELECT checkbox
void cb_SELECT()
{
  //aSelection = !aSelection;
  //cbSELECT.s = aSelection;
  if ((x1sel == x2sel) || (y1sel == y2sel)) { aSelection = false; }
  else { aSelection = !aSelection; }
  cbSELECT.s = aSelection;
}
void cb_SELOUT()
{
}
// SELECT button
void bt_SELCOPY()
{
  copyPixels();
}
void bt_SELPASTE()
{
  pastePixels();
}
void bt_SELDRAW()
{
  selectionContour();
}
void bt_SELSAVE()
{
  selectionSaveDialog();
}
// STENCIL options method
void cb_STENCIL()
{
  stencil = !stencil;
  cbSTENCIL.s = stencil;
}
void bt_STENCREA()   { createStencilFromSelection(); }
void bt_STENLOAD()   { openStencilDialog(); }
void bt_STENINVERT() { invertStencil(); }
void bt_STENCENTER()
{
  ysten = height/2 - stencilIMG.height/2;
  xsten = width/2 - stencilIMG.width/2;
}
// CONFETTI options method
void cb_CONFSCALE() { };
void cb_CONFRND() { };
void sl_CONFVEL() { };
void sl_CONFDVEL() { };
// SHAPE options method
void sl_SHitems() { };
void sl_SHsizeD() { };
void sl_SHalfaD() { };
void sl_SHposD() { };
void cb_SHcolorRND() { };
void cb_SHstyle()
{
  if (cbSHstyle.s) { aShape.enableStyle(); } // SVG style
  else { aShape.disableStyle(); } // processing style
};
void bt_SHSVG() { openShapeDialog(); }
void sb_SHtype() { };
// CLONE slider method
void cb_CLONE() { }
// STAMP slider method
void sl_STAMP() { }
void sl_STAMP2() { }
// MIXER slider method
void sl_MIXERA() { }
void sl_MIXERD() { }
// FILLER method
void sl_FILLER() { }
void cb_FILLERASE() { }
// WEB method
void sl_WEBA() { }
void sl_WEBD() { }
void bt_WEB() { freezeWebPoint(); }
void sb_WEBT() { }
void sb_WEBJ() { }
void cb_WEBE()
{
  eraseW = !eraseW;
  pointsW = true;
  cbWEBP.s = true;
  if (eraseW) { brushSize = 10; slSIZE.v = 10; }
  else { brushSize = 1; slSIZE.v = 1; }
}
void cb_WEBP() { pointsW = !pointsW; }
void freezeWebPoint()
{
  // remove all points
  cobweb.clear();
}
// X,Y mirror checkbox method
void cb_SYMX() { symX = !symX; }
void cb_SYMY() { symY = !symY; }
// grid method
void bt_GRID() { drawGrid(); }
void cb_GRID() { grid = !grid; }
void cb_SNAP() { snap2Grid = !snap2Grid; }
void sb_GRIDX() { gridX = int(sbGRIDX.v); }
void sb_GRIDY() { gridY = int(sbGRIDY.v); }
// antialias
void cb_GLITCH() { noGlitch = !noGlitch; }
// open & save
void bt_OPENLYR() { openLayerDialog(); }
void bt_OPEN() { selectFolderOpenDialog(); }
void bt_SAVE() { selectFolderSaveDialog(); }
// dyna sliders method
void dsl_HOOKE()   { myDD.k = dslHOOKE.v; }
void dsl_DAMPING() { myDD.damping = dslDAMPING.v; }
void dsl_DUCTUS()  { myDD.ductus = dslDUCTUS.v; }
void dsl_MASS()    { myDD.mass = dslMASS.v; }
void dsl_MINB()    { myDD.min_brush = dslMINB.v; }
void dsl_MAXB()    { myDD.max_brush = dslMAXB.v; }
// dyna buttons method
void btn_PRE01() { myDD.preset01(); setDynaSlider(1); }
void btn_PRE02() { myDD.preset02(); setDynaSlider(2); }
void btn_PRE03() { myDD.preset03(); setDynaSlider(3); }
void btn_PRE04() { myDD.preset04(); setDynaSlider(4); }
void btn_PRE05() { myDD.preset05(); setDynaSlider(5); }
void btn_PRE06() { myDD.preset06(); setDynaSlider(6); }
void btn_PRE07() { myDD.preset07(); setDynaSlider(7); }
void btn_PRE08() { myDD.preset08(); setDynaSlider(8); }

void setDynaSlider(int b)
{
  btnPRE01.s = false;
  btnPRE02.s = false;
  btnPRE03.s = false;
  btnPRE04.s = false;
  btnPRE05.s = false;
  btnPRE06.s = false;
  btnPRE07.s = false;
  btnPRE08.s = false;
  dslHOOKE.v = myDD.k;
  dslDAMPING.v = myDD.damping;
  dslDUCTUS.v = myDD.ductus;
  dslMASS.v = myDD.mass;
  dslMINB.v = myDD.min_brush;
  dslMAXB.v = myDD.max_brush;
  if (b == 1) { btnPRE01.s = true; }
  else if (b == 2) { btnPRE02.s = true; }
  else if (b == 3) { btnPRE03.s = true; }
  else if (b == 4) { btnPRE04.s = true; }
  else if (b == 5) { btnPRE05.s = true; }
  else if (b == 6) { btnPRE06.s = true; }
  else if (b == 7) { btnPRE07.s = true; }
  else if (b == 8) { btnPRE08.s = true; }
}

// background color
void btc_BACKCOL()
{
  backCol = color(red(brushCol),green(brushCol),blue(brushCol));
  btcBACKCOL.c1 = backCol;
}

//*********************************
//*********************************
void draw()
{
  background(backCol);

  if (mousePressed && (tool == "Dyna") && (mouseButton == LEFT))
  {
    // draw with DynaDraw tool
    if ((!keyPressed) && (!livelli[activeLyr].ll) && ((!menu) || (mouseX > menuX)))
    {
      livelli[activeLyr].pg.beginDraw();
      if (aSelection) { livelli[activeLyr].pg.clip(x1sel+1, y1sel+1, x2sel-x1sel-1, y2sel-y1sel-1); } // check selection
      myDD.updateDyna();
      myDD.drawDyna();
      livelli[activeLyr].pg.endDraw();
    }
  }

  // load an SVG vector file
  if (loadingShape)
  {
    openShape();
  }

  // load a stencil image
  if (loadingStencil)
  {
    openStencil();
  }

  // load an image on current layer
  if (loadingLayer)
  {
    openLayer();
  }

  // load a complete draw
  if (loadingDraw)
  {
    openDrawFromFolder();
  }

  // show layers
  for(int i = livelli.length-1; i >= 0; i--)
  {
    livelli[i].show();
  }

  // show layers (method II) - (slow)
  //PGraphics outLYR = createGraphics(width, height);
  //outLYR.beginDraw();
  //outLYR.clear();
  //for(int i=numLayers-1; i>=0; i--)
  //{
  //  if (livelli[i].lv)
  //  {
  //    if (livelli[i].lt != 255) { outLYR.tint(255,livelli[i].lt); } // transparency
  //    else { outLYR.noTint(); }
  //    outLYR.image(livelli[i].pg,0,0);
  //  }
  //}
  //outLYR.endDraw();
  //image(outLYR,0,0);

  // show cobweb points
  if (tool == "Web" && pointsW)  { drawWebPoint(); }

  // show grid
  if (grid)  { showGrid(gridX, gridY, black); }


  // LINER: show straight line
  if (lineDown) { ghostLine(); }
  // QUAD: show rect
  else if (quadDown) { ghostQuad(); }
  // CIRCLE: show circonference
  else if (circleDown) { ghostCircle(); }
  // SELECT: show rect selection
  else if (selectDown) { ghostSelect(); }

  //show stencil
  if (stencil)
  {
    image(stencilIMG, xsten, ysten);
  }

  // show selection
  if (aSelection)
  {
    fill(fillSelect); //highLight
    stroke(highLight);
    rect(x1sel,y1sel,x2sel-x1sel,y2sel-y1sel);
  }

  // show HSB color selector
  if (toolHSB)  { myHSB.show(); }

  // show menu
  if (menu) { showMenu(); }

  // show cursor/zoom
  showCursor(mouseX,mouseY, zoom, magnify);

  // show information on window title bar
  showInfo();
}  // end draw()

//*********************************
void selectTool(String t)
{
  tool = t;
  btnPENCIL.s = false;
  btnLINER.s = false;
  btnQUAD.s = false;
  btnCIRCLE.s = false;
  btnERASER.s = false;
  btnSELECT.s = false;
  btnVERNICE.s = false;
  btnINK.s = false;
  btnSTAMP.s = false;
  btnFILLER.s = false;
  btnDYNA.s = false;
  btnMIXER.s = false;
  btnCLONE.s = false;
  btnWEB.s = false;
  btnSELECT.s = false;
  btnSTENCIL.s = false;
  btnCONFETTI.s = false;
  btnSHAPE.s = false;
  //aSelection = false;
  if (t == "Pencil")        { btnPENCIL.s = true; }
  else if (t == "Liner")    { btnLINER.s = true; }
  else if (t == "Quad")     { btnQUAD.s = true; }
  else if (t == "Circle")   { btnCIRCLE.s = true; }
  else if (t == "Eraser")   { btnERASER.s = true; }
  else if (t == "Vernice")  { btnVERNICE.s = true; }
  else if (t == "Ink")      { btnINK.s = true; }
  else if (t == "Stamp")    { btnSTAMP.s = true; }
  else if (t == "Filler")   { btnFILLER.s = true; }
  else if (t == "Dyna")     { btnDYNA.s = true; }
  else if (t == "Mixer")    { btnMIXER.s = true; }
  else if (t == "Clone")    { btnCLONE.s = true; }
  else if (t == "Web")      { btnWEB.s = true; setWebBrush(); }
  else if (t == "Select")   { btnSELECT.s = true; checkSelection();}
  else if (t == "Stencil")  { btnSTENCIL.s = true; stencil = true; cbSTENCIL.s = stencil;}
  else if (t == "Confetti") { btnCONFETTI.s = true;}
  else if (t == "Shape")    { btnSHAPE.s = true;}
  else if (t == "TEST")     { }
}

void checkSelection()
{
  if ((x1sel == x2sel) || (y1sel == y2sel))
  { aSelection = false; }
  else { aSelection = true; }
  cbSELECT.s = aSelection;
}

void setWebBrush()
{
  brushSize = 1; slSIZE.v = 1;
  alfa = 10; slALFA.v = 10;
  noGlitch = true; cbGLITCH.s = true;
  brushCol = color((brushCol >> 16) & 0xFF, (brushCol >> 8)  & 0xFF, brushCol & 0xFF, alfa);
}

//*********************************
void showInfo()
{
  String info;
  info = nfs(mouseX,4) + "," + nfs(mouseY,4) + " | " + tool + " | size: " + str(brushSize) + " | layer: " + str(activeLyr+1);
  info = info + " | sel: " + aSelection;
  info = info + " | " + width + "x" + height;
  info = info + " (" + nf(int(frameRate),0) + ")";
// set window title
  surface.setTitle(info);
}

//*********************************
void checkOS()
{
  String OS = platformNames[platform];
}
