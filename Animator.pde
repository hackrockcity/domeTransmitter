 /**
 * Display an animation based on a set of PNG images
 */
class Animator extends Routine {
  boolean loaded = false;
  
  Animation anim;
  String m_name;
  int m_frameDivider;
  float m_xVelocity;
  float m_yVelocity;
  float m_xOffset;
  float m_yOffset;
  
  // Create an animation routine using the specificed name
  Animator(String name, int frameDivider, float xVelocity, float yVelocity, float xOffset, float yOffset) {
    m_name = name;
    m_frameDivider = frameDivider;
    m_xVelocity = xVelocity;
    m_yVelocity = yVelocity;
    m_xOffset = xOffset;
    m_yOffset = yOffset;
  }
  
  void reset() {
    if(!loaded){
      anim = new Animation(m_name, m_frameDivider);
      loaded=true;
    }
  }
  
  void draw() {
    draw.background(0);
  
    float frame_mult = 3;  // speed adjustment
  
    long frame = frameCount;
    
    // Draw four images, in case we are wrapping
    float xNominal = (frame*m_xVelocity + m_xOffset)%Config.WIDTH;
    float yNominal = (frame*m_yVelocity + m_yOffset)%Config.HEIGHT;

    draw.image(anim.update(),xNominal, yNominal);
    draw.image(anim.update(),xNominal - Config.WIDTH, yNominal);    
    draw.image(anim.update(),xNominal - Config.WIDTH, yNominal - Config.HEIGHT);
    draw.image(anim.update(),xNominal, yNominal - Config.HEIGHT);

    if (frame > Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }

}

class Animation {
  PImage[] frames;
  int frameNumber;
  int frameDivider;
  PGraphics canvas;
  
  Animation(String _name, int _frameDivider) {
    canvas = createGraphics(Config.WIDTH,Config.HEIGHT,P2D);
    frameNumber = 0;
    frameDivider = _frameDivider;
    load(_name);
  }

  /*
  void load(String name) {
    File dir = new File(savePath("data/" + name));
    String[] numFiles = dir.list();
    println(numFiles.length);
    frames = new PImage[numFiles.length];
    for (int i=0; i<frames.length; i++) {
      println("Loading " + name + "/frame" + (i+1) + ".png");
      frames[i] = loadImage(name + "/frame" + (i+1) + ".png");
      //frames[i].filter(INVERT);
    }
  }
  */
  
  void load(String name){
  int filesCounter=0;
  File dataFolder = new File(sketchPath, "data/"+name); 
  String[] allFiles = dataFolder.list();
  try{
    for(int j=0;j<allFiles.length;j++){
      if (allFiles[j].toLowerCase().endsWith("png")) {
        filesCounter++;
      }
  }
  }catch(Exception e){ }
     frames = new PImage[filesCounter];
    for (int i=0; i<frames.length; i++) {
      println("Loading " + name + "/frame" + (i+1) + ".png");
      frames[i] = loadImage(name + "/frame" + (i+1) + ".png");
      //frames[i].filter(INVERT);
    }
  }

  PImage update() {
    if (frameCount % frameDivider == 0) {
      frameNumber++;
      if (frameNumber >= frames.length) {
        frameNumber = 0;
      }
    }
      canvas.beginDraw();
      if(frames[frameNumber].width==Config.WIDTH&&frames[frameNumber].height==Config.HEIGHT){
        canvas.image(frames[frameNumber],0,0);
      }else if(frames[frameNumber].width<Config.WIDTH&&frames[frameNumber].height<Config.HEIGHT){
        canvas.image(frames[frameNumber],0,0,Config.WIDTH,Config.HEIGHT);
      }else{
      canvas.loadPixels();
      for(int x = 0; x < Config.WIDTH; x++) {
        for (int y = 0; y < Config.HEIGHT; y++) {
            int loc1 = x + (y * Config.WIDTH);
            int loc2 = (x*(round(float(frames[frameNumber].width)/float(Config.WIDTH)))) + ((y*(round(float(frames[frameNumber].height)/float(Config.HEIGHT)))) * frames[frameNumber].width);
            try{
              canvas.pixels[loc1] = frames[frameNumber].pixels[loc2];
            }catch(Exception e){ }
        }
      }
      }  
      canvas.updatePixels();
      canvas.endDraw(); 
      return canvas;
  }
}
