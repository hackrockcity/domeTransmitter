class Bursts extends Routine {
  int NUMBER_OF_BURSTS = 16;
  Burst[] bursts;

  void setup(PApplet parent) {
    super.setup(parent);
    bursts = new Burst[NUMBER_OF_BURSTS];
    for (int i = 0; i<NUMBER_OF_BURSTS; i++) {
      bursts[i] = new Burst();
    }
  }

  void reset() {
  }
  
  void draw()
  {
    draw.background(0,0,20);
  
    for (int i=0; i<NUMBER_OF_BURSTS; i++) {
      bursts[i].draw();
    }
  
    if (frameCount - modeFrameStart > Config.FRAMERATE * Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}


class Burst {
  float x;
  float y;
  float xv;
  float yv;
  float d;
  float maxd;
  float speed;
  int intensity;
  
  float r;
  float g;
  float b;

  public Burst()
  {
    init();
  }

  public void reset()
  {
    resetColor();
    
    x = random(Config.WIDTH);
    y = random(Config.HEIGHT);

    float max_speed = 0.25;
    xv = random(max_speed) - max_speed/2;
    yv = random(max_speed) - max_speed/2;
    
    maxd = random(6);
    speed = random(5)/10 + 0.4;
    d = 0;
    intensity = 255;
  }
  
  public void resetColor()
  {
    color col;
    float i = random(3);
    
    if (i<1) col = primaryColor;
    else if (i<2) col = secondaryColor;
    else col = tertiaryColor;
     
    r = red(col);
    g = green(col);
    b = blue(col);
  }  

  public void init()
  {
    reset();
  }
  
  public void draw_ellipse(float x, float y, float widt, float heigh, color c) {
    while(widt > 1 && heigh > 1) {
      float target_brightness = random(.8,1.5);
      c = color(red(c)*target_brightness, green(c)*target_brightness, blue(c)*target_brightness);
      draw.fill(c);
      draw.stroke(c);
      draw.ellipse(x, y, widt, heigh);
      widt -= 1;
      heigh -= 1;
    }
  }
  
  public void draw()
  {
    // Draw multiple elipses, to handle wrapping in the y direction.
    draw_ellipse(x, y,       d*(.5-.3*y/Config.HEIGHT), d*3, color(r,g,b));
    draw_ellipse(x-Config.WIDTH, y, d*(.5-.3*y/Config.HEIGHT), d*3, color(r,g,b));
    draw_ellipse(x+Config.WIDTH, y, d*(.5-.3*y/Config.HEIGHT), d*3, color(r,g,b));
    
    d+= speed;
    if (d > maxd) {
      // day
      r -= 2;
      g -= 2;
      b -= 2;
      intensity -= 15;
      //night
//      r -= 1;
//      g -= 1;
//      b -= 1;
//      intensity -= 3;
    }
    
    // add speed, try to scale slower at the bottom...
    x +=xv*(Config.HEIGHT - y/3)/Config.HEIGHT;
    y +=yv*(Config.HEIGHT - y/3)/Config.HEIGHT;

    if (intensity <= 0) {
      reset();
    }
   
    long frame = frameCount - modeFrameStart;
    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}

