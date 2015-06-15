class Greetz extends Routine {
  int w;
  int x;
  int FONT_SIZE = 16;
  PFont font;
  PImage imgCopy;
  String messages[] = new String[] {
    "N Y C R"//, 
    //  "KOSTUME  KULT",
    //  "BLACK  LIGHT  BALL"
  //  "COUNTRY  CLUB"
  };  
  String message = "N Y C R";

  void setup(PApplet parent) {
    super.setup(parent);
    font = loadFont("Disorient-" + FONT_SIZE + ".vlw");
    draw.textFont(font, FONT_SIZE);
    draw.textMode(MODEL);
    w=0;
    x=0;
  }
 
  void draw() {
    draw.background(0);
    draw.fill(255);
  
    if (w == 0) {
      w = -int((message.length()-1) * (FONT_SIZE*1.35) + Config.WIDTH);
    }
    
    draw.fill(255,128,64);
    draw.text(message, x, FONT_SIZE);
  
    if (Config.HEIGHT/2 > FONT_SIZE) {
      
      draw.image(draw.get(0,0,Config.WIDTH,FONT_SIZE),0,20,Config.WIDTH,Config.HEIGHT/2);
      draw.fill(0);
      draw.rect(0,0,Config.WIDTH,FONT_SIZE);
      //copy(0,0,Config.WIDTH,FONT_SIZE,0,FONT_SIZE,Config.WIDTH,FONT_SIZE/2);
      //imgCopy = copy(0,0,Config.WIDTH,FONT_SIZE);
      //image(imgCopy,0,0,Config.WIDTH,Config.HEIGHT);
    }
    
    if (frameCount % 2 == 0) {
      x = x - 1;
    }
  
    if (x<w) {
      x = Config.HEIGHT;  
      message = messages[int(random(messages.length))];
      w = 0;
      newMode();
    }
  }
}
