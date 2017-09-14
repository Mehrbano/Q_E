//***Main Sketch***///
//fullScreen Displayfor full screen sketch>present

import processing.opengl.*;
import java.util.Iterator;
import processing.video.*;

//*** GLOBAL OBJECTS ***//
//MAIN CONFIGURATION all data stored
MainCofig gConfig;
Kinecter gKinecter;
OpticalFlow gFlowfield;
PartiManager gPartiManager;
int[] gRawDepth;
int[] gNormalizedDepth;
PImage gDepthImg;
//Timer
float lasttimecheck;
float timeinterval;

//RUNNING CONFIGURATION
void start() {
  gConfig = new MainCofig();
}

void setup() {
  size (displayWidth, displayHeight, OPENGL);
  background(55, 100, 50);
  lasttimecheck = millis();
  timeinterval = 5000; //5 sec?
  // set up noise seed
  noiseSeed(gConfig.setupNoiseSeed);
  frameRate(gConfig.setupFPS);
  // helper class for kinect
  gKinecter = new Kinecter (this);
  //used in kinect and opticalflow classes
  gNormalizedDepth = new int[gKinectWidth*gKinectHeight];
  gDepthImg = new PImage(gKinectWidth, gKinectHeight);
  // Create the particle manager.
  gPartiManager = new PartiManager(gConfig);
  // Create the flowfield
  gFlowfield = new OpticalFlow(gConfig, gPartiManager);
  // Tell the particleManager about the flowfield
  gPartiManager.flowfield = gFlowfield;
}

// DRAW LOOP
void draw() {
pushStyle();
pushMatrix();
if (gConfig.showParticles) gPartiManager.updateRender();
gKinecter.updateKinDepth();
gFlowfield.update();
if (gConfig.showFade) blendScreen(gConfig.fadeColor, gConfig.fadeAlpha);
popStyle();
popMatrix();
}

//CREATE AMBIENCE OF THE PROGRAM 
void blendScreen (color bgColor, int opacity) 
{
  pushStyle();
  blendMode(gConfig.blendMode); 
  noStroke();
  fill(150,190,130, opacity);
  rect(0, 0, width, height); 
  blendMode(ADD);
  popStyle(); 
}
