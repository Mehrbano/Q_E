//***Particle Managing Class***///
import ddf.minim.*;

Minim minim;
AudioInput in;

class PartiManager {
  MainCofig config;
  OpticalFlow flowfield;
  Particle particles[];
  int particleId = 0;

  //***CONSTRUCTOR***///
  PartiManager (MainCofig _config) {
    config = _config;
    minim = new Minim(this);
    in = minim.getLineIn();
    
    //count particle drawing
    int particleCount = config.MaxparticleCount;
    particles = new Particle[particleCount];
    for (int i=0; i < particleCount; i++) {
      particles[i] = new Particle(this, config);
    }
  }

  void updateRender() {
    pushStyle();
    // loop particles and quantity
    int particleCounts = config.particleMaxCount;
    for (int i = 0; i < particleCounts; i++) {
      Particle particle = particles[i];
      if (particle.isAlive()) {
        particle.update();
        particle.render();
      }
    }
    popStyle();
  }

  //***DISPLAY PARTICLE**//
  void addParticle(float x, float y, float dx, float dy) {
    AlphaParticles (x*width/sin (noise (x, y, 0)*TWO_PI), y * height*sin (noise (x/2.0, y/10.0, 0)*TWO_PI), 
    dx * config.particleForceMultiplier, 
    dy * config.particleForceMultiplier);//(width/2, height/2,dx, dy); //middle circle
    BetaParticles (width/sin (noise (x, y, 0)*TWO_PI), height*sin (noise (x/2.0, y/10.0, 0)*TWO_PI), 
    dx * config.particleForceMultiplier, 
    dy * config.particleForceMultiplier); //center circle
    CharlieParticles (x, y, 
    dx * config.particleForceMultiplier, 
    dy * config.particleForceMultiplier);
    //(x/PI, y/PI, dx * config.particleForceMultiplier, dy * config.particleForceMultiplier); //last circle
  }

  //***PARTICLES GENERATIONS**//
  void AlphaParticles(float starX, float starY, float forcX, float forcY) {
    float angle = random(TWO_PI);
    float r = 5.0*randomGaussian() + (width/2)*(1.0-pow(random(1.0), 7.0));
    float r2 = 5.0*randomGaussian() + (height/2)*(1.0-pow(random(1.0), 7.0));
    starX = width/2 + cos(angle)*r;
    starY = height/2 + sin(angle)*r2;
    for (int j = 0; j < config.particleGenerateRate; j++) {
      float originX = starX ;
      float originY = starY ;
      float noiseZ = particleId ;
      particles[particleId].preLoc(originX, originY, noiseZ, forcX/2, forcY/2);
      // increment counter -- go back to 0 if we're past the end
      particleId++;
      if (particleId >= config.particleMaxCount) particleId = 0;
    }
  }

  void BetaParticles(float staX, float staY, float forX, float forY) {
    float angle = random(-45, 45);
    float r2 = 15.0*randomGaussian() + (height/2)*(1.0-pow(random(1.0), 7.0));
    staX = width/2 + cos(angle)*r2;
    staY = height/2 + sin(angle)*r2;
    for (int k = 0; k < config.particleGenerateRate; k++) {
      float originX = staX ;
      float originY = staY ;
      float noiseZ = particleId ;
      particles[particleId].preLoc(originX, originY, noiseZ, forX/2, forY/2);
      // increment counter -- go back to 0 if we're past the end
      particleId++;
      if (particleId >= config.particleMaxCount) particleId = 0;
    }
  }

  void CharlieParticles(float statX, float statY, float foreX, float foreY) {
    float angle = random(-45, 45);
    int i = in.bufferSize();

    float r3 = 1.5*randomGaussian() + (width/2)*(1.0-pow(random(1.0), 7.0));
    statX = width/2 + cos(angle)*r3 +i*in.right.get(0);
    statY = height/2 + sin(angle)*r3+i*in.left.get(0);
    for (int m = 0; m < config.particleGenerateRate; m++) {
      float originX = statX ;
      float originY = statY ;
      float noiseZ = particleId ;
      particles[particleId].preLoc(originX, originY, noiseZ, foreX/2, foreY/2);
      // increment counter -- go back to 0 if we're past the end
      particleId++;
      if (particleId >= config.particleMaxCount) particleId = 0;
    }
  }
}

