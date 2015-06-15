class RGBRoutine extends Routine {
  int color_angle = 0;
  
  void draw() {
    draw.background(0);
  
    for (int row = 0; row < Config.HEIGHT; row++) {
      for (int col = 0; col < Config.WIDTH; col++) {
        float r = (((row)*2          + 100.0*col/Config.WIDTH   + color_angle  +   0)%100)*(255.0/100);
        float g = (((row)*2          + 100.0*col/Config.WIDTH   + color_angle  +  33)%100)*(255.0/100);
        float b = (((row)*2          + 100.0*col/Config.WIDTH   + color_angle  +  66)%100)*(255.0/100);
        
        draw.stroke(r,g,b);
        draw.point(col,row);
      }
    }
    
    color_angle = (color_angle+1);//%255;


    long frame = frameCount - modeFrameStart;
    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}
