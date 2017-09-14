//***Call Events***///
//Handle keypress to adjust parameters
void keyPressed() {

  // toggle showParticles on/off
  if (key == 'q') {
    gConfig.showParticles = !gConfig.showParticles;
  }
  // toggle showFlowLines on/off
  else if (key == 'w') {
    gConfig.showFlowLines = !gConfig.showFlowLines;
  }

  // blend modes
  else if (key == '1') {
    gConfig.blendMode = BLEND;
    println("Blend mode: BLEND");
  } else if (key == '2') { 
    gConfig.blendMode = ADD;
    println("Blend mode: ADD");
  } else if (key == '3') {
    gConfig.blendMode = SUBTRACT;
    println("Blend mode: SUBTRACT");
  } else if (key == '4') { 
    gConfig.blendMode = DARKEST;
    println("Blend mode: DARKEST");
  } else if (key == '5') {
    gConfig.blendMode = LIGHTEST;
    println("Blend mode: LIGHTEST");
  } else if (key == '6') {
    gConfig.blendMode = DIFFERENCE;
    println("Blend mode: DIFFERENCE");
  } else if (key == '7') {
    gConfig.blendMode = EXCLUSION;
    println("Blend mode: EXCLUSION");
  } else if (key == '8') { 
    gConfig.blendMode = MULTIPLY;
    println("Blend mode: MULTIPLY");
  } else if (key == '9') { 
    gConfig.blendMode = SCREEN;
    println("Blend mode: SCREEN");
  }
}

