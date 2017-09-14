//***Optical Flow Class***///
//SAME, MODIFIED AND ADDITIONAL SYNTAX TO HIDETOSHI'S OPTICAL FLOW

class OpticalFlow {
  MainCofig config;
  PartiManager particles;
  //PVectors
  PVector[][] field;
  int cols, rows; // columns & rows
  int celSize; //resolution
  int avSize; //size
  int life;
  //same calculation as Hidetoshi Shimodaira
  int rvl = 3*9; //change in calculation does not work
  float distance; 
  // regression vectors same syntax as Hidetoshi Shimodaira
  float[] fx, fy, ft;
  //arrays
  float[] bar;             // averaged grid values (pixel average)
  float[] dtr, dxr, dyr;   // differentiation by t, x, y (red,gree,blue)
  float[] flowx, flowy;    // computed optical flow
  float[] sflowx, sflowy;  // changing version of the flow
  color clr2;

//***Constructor***//
  OpticalFlow(MainCofig _config, PartiManager _particles) {
    config = _config;
    particles = _particles;
    // set up flow field resolution & size
    celSize = config.setupFlowFieldResolution;
    avSize = celSize * 2;
    // Determine the number of columns and rows as width and height
    cols = gKinectWidth/celSize;
    rows = gKinectHeight/celSize;
    //call perlin noise
    field = makePerlinNoiseField(rows, cols);
    life = 1*gConfig.flowLineAlpha;
    // arrays
    bar = new float[cols*rows];
    dtr = new float[cols*rows];
    dxr = new float[cols*rows];
    dyr = new float[cols*rows];
    flowx = new float[cols*rows];
    flowy = new float[cols*rows];
    sflowx = new float[cols*rows];
    sflowy = new float[cols*rows];
    fx = new float[rvl];
    fy = new float[rvl];
    ft = new float[rvl];
    
    init();
    update();
  }

  void init() {
  }

  void update() {
    diffT();
    diffXY();
    solveFlow();
  }

    // same syntax as HIDETOSHI'S OPTICAL FLOW
    void getNeigborPixel(float x[], float y[], int i, int j) {
    y[j+0] = x[i+0];
    y[j+1] = x[i-1];
    y[j+2] = x[i+1];
    y[j+3] = x[i-cols];
    y[j+4] = x[i+cols];
    y[j+5] = x[i-cols-1];
    y[j+6] = x[i-cols+1];
    y[j+7] = x[i+cols-1];
    y[j+8] = x[i+cols+1];
  }

    // same syntax and modified HIDETOSHI'S OPTICAL FLOW
  void solveFlowIndex(int index) {
    float xx, xy, yy, xt, yt;
    float a, u, v, w;
    // prepare covariances
    xx = xy = yy = xt = yt = 0.0;
    for (int i = 0; i < rvl; i++) {
      xx += fx[i]*fx[i];
      xy += fx[i]*fy[i];
      yy += fy[i]*fy[i];
      xt += fx[i]*ft[i];
      yt += fy[i]*ft[i];
    }
    // least squares computation
    a = xx*yy - xy*xy + config.flowfieldRegularization;
    u = yy*xt - xy*yt; // x direction
    v = xx*yt - xy*xt; // y direction

    // write back
    flowx[index] = -2*celSize*u/a; // optical flow x (pixel per frame)
    flowy[index] = -2*celSize*v/a; // optical flow y (pixel per frame)
  }

  //this part initialize the input data from kinect per square inch or cm
   float dataAverage(int x1, int y1, int x2, int y2) {
    if (x1 < 0)          x1 = 10;
    if (y1 < 0)          y1 = 10;
    if (x2 >= gKinectWidth)   x2 = gKinectWidth - 10;
    if (y2 >= gKinectHeight)  y2 = gKinectHeight - 10;
  float sum = 0.0;
    for (int y = y1; y <= y2; y++) {
    for (int x = gKinectWidth * y + x1; x <= gKinectWidth * y+x2; x++) {
    sum += gNormalizedDepth[x];
      }
    }
    int dataCount = (x2-x1+1) * (y2-y1+1); //increment gives unrequired distance
    //float type has to return
    return sum / dataCount;
  }
  
  void diffT() {
    for (int col = 0; col < cols; col++) {
      int x0 = col * celSize + celSize/2;
      for (int row = 0; row < rows; row++) {
        int y0 = row * celSize + celSize/2;
        int index = row * cols + col;
        // compute data average
        float avg = dataAverage (x0-avSize, y0-avSize, x0+avSize, y0+avSize);
        // time difference
        dtr[index] = avg - bar[index]; // red
        // save pixel
        bar[index] = avg ;
      }
    }
  }

  // 2nd sweep : differentiations by x and y
  void diffXY() {
    for (int col = 1; col < cols-1; col++) {
      for (int row = 1; row<rows-1; row++) {
        int index = row * cols + col;
        // compute x difference
        dxr[index] = bar[index+1] - bar[index-1];
        // compute y difference
        dyr[index] = bar[index+cols] - bar[index-cols];
      }
    }
  }

  // 3rd sweep : solving optical flow
  void solveFlow() {
    //time distance between frames @ current time
    distance = config.flowfieldPredictionTime * config.setupFPS;

    // for kinect to window size mapping below
    float normalizedKinectWidth   = 1.0f / ((float) gKinectWidth);
    float normalizedKinectHeight  = 1.0f / ((float) gKinectHeight);
    float kinectToWindowWidth  = ((float) width) * normalizedKinectWidth;
    float kinectToWindowHeight = ((float) height) * normalizedKinectHeight;

    for (int col = 1; col < cols-1; col++) {
      int x0 = col * celSize + celSize/2;
      for (int row = 1; row < rows-1; row++) {
        int y0 = row * celSize + celSize/2;
        int index = row * cols + col;

        // index
        solveFlowIndex(index);
        // prepare vectors fx, fy, ft
        getNeigborPixel(dxr, fx, index, 0); // dx grey
        getNeigborPixel(dyr, fy, index, 0); // dy grey
        getNeigborPixel(dtr, ft, index, 0); // dt grey

        // smoothing
        sflowx[index] += (flowx[index] - sflowx[index]) * config.flowfieldSmoothing;
        sflowy[index] += (flowy[index] - sflowy[index]) * config.flowfieldSmoothing;

        float u = distance * sflowx[index];
        float v = distance * sflowy[index];

        // angular distance of the vector
        float acquire = sqrt(u * u + v * v);
        // register new vectors
        if (acquire >= gConfig.flowfieldMinVelocity) {
          field[col][row] = new PVector(u, v);

          // show optical flow as lines
          if (config.showFlowLines) {
            float startX = width - (((float) x0) * kinectToWindowWidth);
            float startY = ((float) y0) * kinectToWindowHeight;
            float endX   = width - (((float) (x0+u+life)) * kinectToWindowWidth);
            float endY   = ((float) (y0+v+life)) * kinectToWindowHeight;
            pushMatrix();
            //LINE
            stroke(#AD5C05, gConfig.flowLineAlpha);
            strokeWeight(1);
            beginShape();
            vertex(startX, startY);
            bezierVertex(startX, startY,startX+1, startY+1, endX-1, endY-1);
            endShape();
            //line(startX, startY, endX, endY);
            //DOT
            fill (#6AFA05, gConfig.flowLineAlpha); //#E57A07
            noStroke();
            rect (startX-1, startY-1, 4, 4);
            popMatrix();
          }
          //call particle generation to kinect
          float normalizedX = (x0+u) * normalizedKinectWidth;
          float normalizedY = (y0+v) * normalizedKinectHeight;
          float velocityX  = ((x0+u) - x0) * normalizedKinectWidth;
          float velocityY  = ((y0+v) - y0) * normalizedKinectHeight;
          particles.addParticle(1-normalizedX, normalizedY, -velocityX, velocityY);
        }
      }
    }
  }

  // same syntax as JugglingMolecules
  PVector lookup(PVector worldLocation) {
    int i = (int) constrain(worldLocation.x / celSize, 0, cols-1);
    int j = (int) constrain(worldLocation.y / celSize, 0, rows-1);
    return field[i][j].get();
  }
}

//***PERLIN***//
PVector[][] makePerlinNoiseField (int rows, int cols) {  
  PVector[][] field = new PVector[cols][rows];

  float xOffset = 0;
  for (int col = 0; col < cols; col++) {

    float yOffset = 0;
    for (int row = 0; row < rows; row++) {

      // Use perlin noise to get an angle between 0 and 2 PI
      float theta = map (noise (xOffset, yOffset), 0, 500, 0, TWO_PI);

      // Polar to cartesian coordinate transformation to get x and y components of the vector
      field[col][row] = new PVector(cos(theta+theta), sin(random(-theta, theta)));

      yOffset += 0.1;
    }
    xOffset += 0.1;
  }
  return field;
}

