class WarpSpeedMrSulu extends Routine {
  int NUM_STARS = 200;
  WarpStar[] warpstars;

  void setup(PApplet parent) {
    super.setup(parent);
    warpstars = new WarpStar[NUM_STARS];
    for (int i = 0; i<NUM_STARS; i++) {
      warpstars[i] = new WarpStar();
    }
  }
  
  void draw() {
    draw.background(0);
    draw.stroke(255);
    
    for (int i=0; i<NUM_STARS; i++) {
      warpstars[i].draw();
    }
   
    if (frameCount - modeFrameStart >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    } 
  }


}


class WarpStar {
  float x;
  float y;
  float len;
  float vy;
  float vx;
  
  float r;
  float g;
  float b;

  public WarpStar() {
    this.reset();
  }

  public void reset() {
    x = int(random(0, Config.WIDTH));
    y = int(random(0, -100));

//    if (random(0,1) > .5) {
//      vx = random(0, 1);
//      vy = 0;
//      len = vx * 5;
//    }
//    else {
      vx = 0;
      vy = random(0, 1);
      len = vy * 5;
//    }
  }

  public void draw() {
    x = x + vx;
    y = y + vy;
    //RGB 252/23/218 
    //r = int(map(y, 0, Config.HEIGHT, 0, 255));
    //g = 0;
    //b = 0;
    //r = 252;
    //g = 23;
    //b = 218;
//    r = random(232,255);
//    g = random(230,255);
//    b = random(230,255);

    r = red(primaryColor);
    g = green(primaryColor);
    b = blue(primaryColor);

    // scale brightness.
    float bright = random(.5,2);
    r = r*bright;
    g = g*bright;
    b = b*bright;

    draw.stroke(r, g, b);
    draw.point(x, y);

    for (int i=0; i<len; i++) {
      float intensity = 255 >> i / 2;
      
      draw.fill(color(r*random(.8,1.3),g*random(.8,1.3),b*random(.8,1.3)));
      draw.stroke(color(r,g,b));
      //stroke(intensity);
      draw.point(x, y - i);
    }

    if (y > Config.HEIGHT) this.reset();
    if (x > Config.WIDTH) this.reset();
  }
}

