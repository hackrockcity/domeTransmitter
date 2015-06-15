class TestPattern extends Routine {
  int o=-1;
  boolean vertical = false;
  
  public TestPattern(boolean vertical) {
    this.vertical = vertical;
  }
  
  void draw() {
    draw.background(0);
    draw.stroke(primaryColor);
    //draw.stroke(color(0,0,255));
        
    if (!vertical) {
      draw.line(o,0,o,Config.HEIGHT);
      o++;
      if (o>Config.WIDTH) o=0;
    }
    else {
      o++;
      o = o % 16;
      
      for (int i=o; i<Config.HEIGHT; i+=16)
        draw.line(0,i,Config.WIDTH,i);
    }
  }
}

