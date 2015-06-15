class ColorDrop extends Routine {
  void draw() {
    draw.background(0);
  
    float frame_mult = 3;  // speed adjustment
  
    // lets add some jitter
    modeFrameStart = modeFrameStart - min(0,int(random(-5,12)));
    
    long frame = frameCount - modeFrameStart;
    
    
    for(int row = 0; row < Config.HEIGHT; row++) {
      float phase = sin((float)((row+frame*frame_mult)%Config.HEIGHT)/Config.HEIGHT*3.146 + random(0,.6));
      
      float r = 0;
      float g = 0;
      float b = 0;
      
      
      if((row+frame*frame_mult)%(3*Config.HEIGHT) < Config.HEIGHT) {
        r = red(primaryColor)* phase;
        g = green(primaryColor) * phase;
        b = blue(primaryColor) * phase;
//        r = 255*phase;
//        g = 0;
//        b = 0;
      }
      else if((row+frame*frame_mult)%(3*Config.HEIGHT) < Config.HEIGHT*2) {
        r = red(secondaryColor)* phase;
        g = green(secondaryColor) * phase;
        b = blue(secondaryColor) * phase;


//        r = 0;
//        g = 255*phase;
//        b = 0;
      }
      else {
        r = red(tertiaryColor)* phase;
        g = green(tertiaryColor) * phase;
        b = blue(tertiaryColor) * phase;


//        r = 0;
//        g = 0;
//        b = 255*phase;
      }
      
      draw.stroke(r,g,b);
      draw.line(0, row, Config.WIDTH, row);
    }
    
    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }

}
