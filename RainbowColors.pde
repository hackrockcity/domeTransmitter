class RainbowColors extends Routine {
  void draw() {
    long frame = frameCount - modeFrameStart;
  //  print(mouseY*255.0/Config.HEIGHT);
  //  print(" ");
    
    draw.colorMode(HSB, 100);
    
    for(int x = 0; x < Config.WIDTH; x++) {
      for(int y = 0; y < Config.HEIGHT; y++) {
        if (x < Config.WIDTH/2) {
          draw.stroke((pow(x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        else {
          draw.stroke((pow(Config.WIDTH-x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        draw.point((x+frame)%Config.WIDTH,y);
      }
    }
    
    draw.colorMode(RGB, 255);
       
    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}
