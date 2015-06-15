// This outputs a data structure that can be used in Config to rearrange the order
// of the strips.  Use this instead of swaping strips and boxes for an hour.  Use
// the arrows to move the green strip around the dome until you hit the next strip, 
// then press space.  Configured strips will turn light blue.  Use up and down to swap 
// RGB to RBG.  Press 's' to output the data structure.  You can copy/paste that into
// Config.
public class Configulate extends Routine {
  boolean pressed = false;
  int currentStrip = 0;
  color currentColor = color(0,0,255);
  int[] savedStrips;
  boolean[] savedSwaps;
  boolean[] hasSaved;
  int saveIndex = 0;
  
  void setup(PApplet parent) {
    super.setup(parent);
    savedStrips = new int[Config.WIDTH];
    savedSwaps = new boolean[Config.WIDTH];
    hasSaved = new boolean[Config.WIDTH];
    
    for (int i=0; i<Config.WIDTH; i++) {
      savedStrips[i] = -1;
      hasSaved[i] = false;
    }
  }

  void draw() {
    draw.background(0);

    handleKeys();
    drawSavedStrips();
    drawCurrentStrip();
  }  
    
  void handleKeys() {
    if (keyPressed) {
      pressed = true;
    }
    else if (!keyPressed && pressed) {
      pressed = false;
 
      if (keyCode == LEFT || keyCode == RIGHT) {     
        currentStrip += (keyCode == RIGHT) ? 1 : -1;
      
        if (currentStrip >= Config.WIDTH) currentStrip = 0;
        else if (currentStrip < 0) currentStrip = Config.WIDTH-1;
      }
      else if (keyCode == UP) {
        currentColor = color(0,0,255);
      }
      else if (keyCode == DOWN) {
        currentColor = color(0,255,0);
      }
      else if (key == ' ') {
        println("saveIndex="+saveIndex+" currentStrip="+currentStrip);
        savedStrips[saveIndex] = currentStrip;
        savedSwaps[saveIndex] = (currentColor == color(0,255,0));
        hasSaved[currentStrip] = true;
        saveIndex++;
        currentStrip++;
        if (saveIndex >= Config.WIDTH) { saveIndex = 0; }
        if (currentStrip >= Config.WIDTH) { currentStrip = 0; }
      }
      else if (key == 's') {
        printStrips();
        printSwaps();
      }
    }
  }
  
  void drawCurrentStrip() {
    draw.stroke(hasSaved[currentStrip] ? color(255,0,0) : currentColor);
    draw.line(currentStrip,0,currentStrip,Config.HEIGHT);
  }
  
  void drawSavedStrips() {
    for (int i=0; i<saveIndex; i++) {
      draw.stroke(savedSwaps[i] ? color(100,255,100) : color(100,100,255));
      draw.line(savedStrips[i],0,savedStrips[i],Config.HEIGHT);
    }
  }

  void printStrips() {
    print("\tpublic static int[] STRIP_LOOKUP = new int[] {");
    for (int i=0; i<savedStrips.length; i++) {
      if (i % 8 == 0) print("\n\t\t");
      print(savedStrips[i]);
      if (i<savedStrips.length-1) print(", ");
    }
    println("\n\t};");
  }
  
  void printSwaps() {
    print("\tpublic static boolean[] SWAP_LOOKUP = new boolean[] {");
    for (int i=0; i<savedSwaps.length; i++) {
      if (i % 8 == 0) print("\n\t\t");
      print(savedSwaps[i]);
      if (i<savedSwaps.length-1) print(", ");
      
    }
    println("\n\t};");
  }  
}

