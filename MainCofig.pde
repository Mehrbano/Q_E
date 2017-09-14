//***Main Configeration Class**//
//COLOR SCHEME OF PARTICLES
int PARTICLE_COLOR_SCHEME_XY= 0;

class MainCofig {
  // Initialize construction
  MainCofig() {
 }

  //***GLOBAL SETUP***//
  //Window size
   int setupWindowWidth = 640;
   int setupWindowHeight = 480;

  //FRAMERATE
  int setupFPS = 60;

  //RANDOM NOISESEED
  int setupNoiseSeed = 26103;

  //KINECT SETUP
  int kinectMinDepth = 100;
  int MIN_kinectMinDepth = 0;
  int MAX_kinectMinDepth = 3000;

  int kinectMaxDepth = 950;
  int MIN_kinectMaxDepth = 0;
  int MAX_kinectMaxDepth = 2047;
  
  // Show particles
  boolean showParticles = true;
  // Show force lines.
  boolean showFlowLines = false;
  // Show the depth image.
  boolean showDepthImage = false;
  // Show perlin noise field
  boolean showNoise = true;
  // Show "fade" overlay
  boolean showFade = true;
  // sound effect on /off
  boolean flagsound=false; 

  //***PARAMETERS FOR OPTICAL FLOW***//
  //MAPPING TO
  boolean fadeGreyscale = true;

  //BACKGROUND FADE IN 
  int fadeAlpha = 15;
  int MIN_fadeAlpha = 0;
  int MAX_fadeAlpha = 255;

  //FADE CONFIG
  color fadeColor = color(0, 155); 
  
////////////////////////////////////////////////////////////////////////////////
  
  //***PARAMETERS OF OPTICAL FLOW***//
  //RESOLUTION OF FIELD FLOW
  int setupFlowFieldResolution = 5;
 
  //USED IN void solveFlow AVERAGE TIME OF COMPUTED FLOW
  float flowfieldPredictionTime = 1.5;
  float MIN_flowfieldPredictionTime = .1;
  float MAX_flowfieldPredictionTime = 2.5;

  //VELOCITY OPTIC FLOW FIELD WHEN NEW VECTORS ARE REGISTERED
  int flowfieldMinVelocity = 10; //by increasing this the flow of optic is made far apart 
  int MIN_flowfieldMinVelocity = 1;
  int MAX_flowfieldMinVelocity = 100;

  //pow() function is an efficient way of multiplying numbers by themselves 
  //https://processing.org/reference/pow_.html
  //REGULARIZATION OF REGRESSION USED IN // least squares computation
  float flowfieldRegularization = pow (-10, 8); 
  float MIN_flowfieldRegularization = 0;
  float MAX_flowfieldRegularization = pow(10, 10);

  //ADD SMOOTHNESS TO FLOW FIELD
  float flowfieldSmoothing = 0.05; //smaller value resulted in longer smoothing
  float MIN_flowfieldSmoothing = 0.02; 
  float MAX_flowfieldSmoothing = 1;

////////////////////////////////////////////////////////////////////////////////
  //http://flafla2.github.io/2014/08/09/perlinnoise.html
  //http://www.lumicon.de/wp/?p=3257

  //*** PERLIN NOISE ***//
  //used in particle void update()
  //Cloud variation Low values = long stretchs long distances
  //High values= do not move outside smaller radius
  int noiseStrength = 10;
  int MIN_noiseStrength = 1;
  int MAX_noiseStrength = 100;

  // Cloud scale
  // Low strength values makes clouds more detailed but move the same long distances. ???
  int noiseScale = 10; //1-400
  int MIN_noiseScale = 1;
  int MAX_noiseScale = 100;

////////////////////////////////////////////////////////////////////////////////
  //*** INTERACTION PARTICLE AND FLOW FIELD***//
  // How much particle slows down in fluid environment.
  float particleViscocity = .995;  //0-1  ???
  float MIN_particleViscocity = 0;
  float MAX_particleViscocity = 1;

  // Force to apply to input
  float particleForceMultiplier = 50;   //1-300
  float MIN_particleForceMultiplier = 1;
  float MAX_particleForceMultiplier = 300;

  // How fast to return to the noise after force velocities.
  float particleAccelerationFriction = .75;  //.001-.999  // WAS: .075
  float MIN_particleAccelerationFriction = .001;
  float MAX_particleAccelerationFriction = .999;

  // How fast to return to the noise after force velocities.
  float particleAccelerationLimiter = .35;  // - .999
  float MIN_particleAccelerationLimiter = .001;
  float MAX_particleAccelerationLimiter = .999;

  // Turbulance, or how often to change the 'clouds' - third parameter of perlin noise: time.
  float particleNoiseVelocity = .008; // .005 - .3
  float MIN_particleNoiseVelocity = .005;
  float MAX_particleNoiseVelocity = .3;

  //***Particle drawing***//
  int particleColorScheme = PARTICLE_COLOR_SCHEME_XY;
  
  // Opacity for all particle lines, used for all color schemes.
  int particleAlpha  = 50;  //0-255
  int MIN_particleAlpha   = 10;
  int MAX_particleAlpha   = 255;

  // Color for particles iff `PARTICLE_COLOR_SCHEME_SAME_COLOR` color scheme in use.
  color particleColor    = color(255, 0, 255);

  //number of particles
  int particleMaxCount = 20000;
  int MinparticleCount = 10000;
  int MaxparticleCount = 30000;

  // how many particles to emit when mouse/tuio blob move
  int particleGenerateRate = 5; //2-200
  int MIN_particleGenerateRate = 1;
  int MAX_particleGenerateRate = 10;// 2000;

  // random offset for particles emitted, so they don't all appear in the same place
  int particleGenerateSpread = 20; //1-50
  int MIN_particleGenerateSpread = 1;
  int MAX_particleGenerateSpread = 50;

  // Upper and lower bound of particle movement each frame.
  int particleMinStepSize = 4;
  int MIN_particleMinStepSize = 2;
  int MAX_particleMinStepSize = 10;

  int particleMaxStepSize = 8;
  int MIN_particleMaxStepSize = 2;
  int MAX_particleMaxStepSize = 10;

  // Particle life time span
  int particleLifetime = 400;
  int MIN_particleLifetime = 50;
  int MAX_particleLifetime = 1000;

  //***Drawing flow field lines in optic class***//
  int flowLineAlpha = 20;
  int MIN_flowLineAlpha   = 10;
  int MAX_flowLineAlpha   = 255;

  // color for optical flow lines
  color flowLineColor = color(255, 0, 0, 30);  // RED

  //***Depth image drawing***//
  // show depth image as black/white or greyscale
  boolean depthImageAsGreyscale = false;

  int blendMode = BLEND;
}

