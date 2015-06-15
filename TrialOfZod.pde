class TrialOfZod extends Routine {
  float arcHeight = Config.HEIGHT/4;
  float n = 0;
  float s = 0.5;
  float top;
  
  void draw() {
    draw.background(0);
    draw.stroke(primaryColor);
    draw.fill(0);
    draw.strokeWeight(3);
    //arc(Config.WIDTH/2,Config.HEIGHT-50,(float)Config.WIDTH+20,50,-PI,0);
    //line(0,Config.HEIGHT-25,Config.WIDTH,Config.HEIGHT-25);
    top = 85 + controller.pitch/2;
    
    n = n + s;
    if (abs(n)>Config.WIDTH) {
      n = 0;
    }

    draw.line(-Config.WIDTH+n,   top-45,      -Config.WIDTH/2+n,       top+45);
    draw.line(-Config.WIDTH/2+n, top+45,      n,                top-45);
    draw.line(n,          top-45,      Config.WIDTH/2+n,        top+45);
    draw.line(Config.WIDTH/2+n,  top+45,      Config.WIDTH+n,          top-45);
    draw.line(Config.WIDTH+n,    top-45,      Config.WIDTH+Config.WIDTH/2+n,  top+45);


    draw.line(-Config.WIDTH+n,   top+45,      -Config.WIDTH/2+n,       top-45);
    draw.line(-Config.WIDTH/2+n, top-45,      n,                top+45);
    draw.line(n,          top+45,      Config.WIDTH/2+n,        top-45);
    draw.line(Config.WIDTH/2+n,  top-45,      Config.WIDTH+n,          top+45);
    draw.line(Config.WIDTH+n,    top+45,      Config.WIDTH+Config.WIDTH/2+n,  top-45);

    long frame = frameCount - modeFrameStart;
    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}

