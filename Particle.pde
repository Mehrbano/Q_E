//***Particle class***///
class Particle {
  PartiManager manager;
  MainCofig config;

  // location, accel, velo
  PVector location;
  PVector prevLocation;
  PVector velo;
  PVector accel;
  float zNoise;
  int lifespan;
  float rad;
  float angle;
  color clr;
  float stepSize;
  // for flowfield
  PVector steer;
  PVector desired;
  PVector flowFieldLocation;

  //***CONSTRUCTOR***//
  public Particle(PartiManager _manager, MainCofig _config) {
    manager = _manager;
    config  = _config;
    // initialize data for location, accel, velo
    location       = new PVector(0, 0);
    prevLocation     = new PVector(0, 0);
    accel       = new PVector(0, 0);
    velo             = new PVector(0, 0);
    flowFieldLocation   = new PVector(0, 0);
    rad = 5.0+(width/2-100)*(1.0-pow(random(1.0), 7.0));
  }
  //***PARTICLE LOCATION***//
  void preLoc (float _x,float _y,float _zNoise, float _dx, float _dy) {
    location.x = prevLocation.x = _x;
    location.y = prevLocation.y = _y;
    zNoise = _zNoise;
    accel.x = _dx;
    accel.y = _dy;
    lifespan = config.particleLifetime;
    stepSize = random (config.particleMinStepSize, config.particleMaxStepSize);
    // color on x and y coordinate
    if (config.particleColorScheme == PARTICLE_COLOR_SCHEME_XY) {
      int r = (int) map (width, 255, height, _x, 150);
      int g = (int) map(height, _y, 0, 255, width);  
      int b = (int) map(_x + _y, 150 , width+ height, 0, 255);
      clr = color(r, g, b, config.particleAlpha);
    }
  }
  boolean isAlive() {
    return (lifespan > 0);
  }

  //***LOCATION UPDATE***///
  void update() {
    prevLocation = location.get();
    if (accel.mag() < config.particleAccelerationLimiter) {
      lifespan++;
      angle = noise (config.noiseScale*PI, config.noiseScale*PI, zNoise*rad);
      angle *= (float) config.noiseStrength;
    }
    else {
      //align kinect
      flowFieldLocation.x *= pow(width, gKinectWidth);
      flowFieldLocation.y *= pow(height, gKinectHeight);
      //spread and dircetion particles
      desired = manager.flowfield.lookup(flowFieldLocation);
      desired.x *= random(-3,5);
      //restrain flow
      steer = PVector.sub(desired, velo);
      steer.limit(stepSize);  // Limit to maximum steering force
      accel.add(steer);
    }
    accel.mult(config.particleAccelerationFriction);
    velo.add(accel);
    location.add(velo);
    zNoise += config.particleNoiseVelocity;
  }

  //render as draw
  void render() {
    pushStyle();
    pushMatrix();
    stroke(clr);
    line (prevLocation.x, prevLocation.y, location.x , location.y);
    popStyle();
    popMatrix();
    
    pushStyle();
    pushMatrix();
    fill(clr);
    point (location.x , location.y );
    popStyle();
    popMatrix();
  }
}
