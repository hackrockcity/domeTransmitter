class Seizure extends Routine {
  int count = 0;
  
  void draw() {  
    if (count < 1) {
      draw.background(0,0,0);
    }
    else {
      draw.background(255,255,255);
    }
    
    count = (count + 1) % 2;
  }
}
