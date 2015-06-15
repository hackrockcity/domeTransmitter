class DropTheBomb extends Routine {
  float bombX;
  float bombY;
  float bombSpeed;
  float flashSpeed;
  float flashBrightness;
  float blastRadius;
  float blastSpeed;
  
  void setup(PApplet parent) {
    super.setup(parent);
    bombSpeed = Config.HEIGHT / (frameRate*3);
    flashSpeed = 255 / (frameRate*1);   
    blastSpeed = max(Config.WIDTH,Config.HEIGHT) / (frameRate*5);
  }    
    
  void reset() {
    bombX = random(Config.WIDTH);
    bombY = 0;
    flashBrightness = 255;    
    blastRadius = 0;
  }
  
  void draw() {
    if (bombY < Config.HEIGHT) {
      drawBomb();
      bombY += bombSpeed;
    }
    else if (flashBrightness > 0) {
      drawFlash();
      flashBrightness -= flashSpeed;
    }
    else if (blastRadius/2 < Config.WIDTH || blastRadius/2 < Config.HEIGHT) {
      drawBlast();
      blastRadius += blastSpeed;
    }
    else {
      newMode();
    }
  }
  
  void drawBomb() {
    int c = 255;
    draw.background(0);
    
    for (int i=0; i<5; i++) {
      draw.stroke(c);
      draw.point(bombX,bombY-i);
      c = c - 32;
    }
  }
  
  void drawFlash() {
    draw.colorMode(HSB);
    draw.background(0, 255 - flashBrightness, flashBrightness);
    draw.colorMode(RGB);
  }
  
  void drawBlast() {
    draw.noStroke();
    draw.rectMode(CENTER);
    draw.background(0);
    for (int i=0; i<5; i++) {    
      draw.fill(255-(i*16),64-(i*4),32-(i*2));
      draw.ellipseMode(CENTER);
      draw.rect(0,Config.HEIGHT,Config.WIDTH*2,blastRadius/(i+1));
    }
  }
}
