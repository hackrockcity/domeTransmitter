class Chase extends Routine {
  void draw() {
    draw.background(0);

    long frame = frameCount - modeFrameStart;
    
    draw.stroke(red(primaryColor)*0.5,green(primaryColor)*0.5,blue(primaryColor)*0.5);
    draw.line(frame/3.0%Config.WIDTH, 0, frame/3.0%Config.WIDTH, Config.HEIGHT);
    draw.stroke(red(primaryColor)*0.6,green(primaryColor)*0.6,blue(primaryColor)*0.6);
    draw.line((frame/3.0+1)%Config.WIDTH, 0, ((frame/3.0+1))%Config.WIDTH, Config.HEIGHT);
    draw.stroke(red(primaryColor)*0.7,green(primaryColor)*0.7,blue(primaryColor)*0.7);
    draw.line((frame/3.0+2)%Config.WIDTH, 0, ((frame/3.0+2))%Config.WIDTH, Config.HEIGHT);
    draw.stroke(red(primaryColor)*0.8,green(primaryColor)*0.8,blue(primaryColor)*0.8);
    draw.line((frame/3.0+3)%Config.WIDTH, 0, ((frame/3.0+3))%Config.WIDTH, Config.HEIGHT);
    draw.stroke(primaryColor);
    draw.line((frame/3.0+4)%Config.WIDTH, 0, ((frame/3.0+4))%Config.WIDTH, Config.HEIGHT);

    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}

