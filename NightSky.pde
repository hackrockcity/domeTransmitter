class NightSky extends Routine {
  int NUMBER_OF_STARS = 30;
  NightStar[] nightStars;
  PImage grad;
  
  void setup(PApplet parent) {
    super.setup(parent);
    
    color c1 = color(0, 0, 20);
    color c2 = color(0, 20, 60);
    grad = generateGradient(c1, c2, WIDTH*ZOOM, HEIGHT*ZOOM);
    
    nightStars = new NightStar[NUMBER_OF_STARS];
    for (int i=0; i<NUMBER_OF_STARS; i++) {
      nightStars[i] = new NightStar(); 
    }
  }
  
  void draw() {
    background(0);
    image(grad, 0, 0);
    noStroke();
    fill(0, 20, 0);
    rect(0, HEIGHT*ZOOM * 0.7, WIDTH*ZOOM, HEIGHT*ZOOM * 0.3);
    for (int i=0; i<NUMBER_OF_STARS; i++) {
      nightStars[i].draw();
    }
   
   if (frameCount - modeFrameStart > FRAMERATE*TYPICAL_MODE_TIME) {
      newMode();
    }
  }
  
  // Generate a vertical gradient image
  PImage generateGradient(color top, color bottom, int w, int h) {
    int tR = (top >> 16) & 0xFF;
    int tG = (top >> 8) & 0xFF;
    int tB = top & 0xFF;
    int bR = (bottom >> 16) & 0xFF;
    int bG = (bottom >> 8) & 0xFF;
    int bB = bottom & 0xFF;
   
    PImage bg = createImage(w,h,RGB);
    bg.loadPixels();
    for(int i=0; i < bg.pixels.length; i++) {
      int y = i/bg.width;
      float n = y/(float)bg.height;
      // for a horizontal gradient:
      // float n = x/(float)bg.width;
      bg.pixels[i] = color(
      lerp(tR,bR,n), 
      lerp(tG,bG,n), 
      lerp(tB,bB,n), 
      255); 
    }
    bg.updatePixels();
    return bg;
  }
}

