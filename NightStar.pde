class NightStar {
  float x;
  float y;
  int brightness;
 public NightStar() {
   this.reset();
 }
 
 public void draw() {
   
   noStroke();
   this.twinkle();
   fill(brightness);
   rect(x, y, 1, 1);
   
 }
 
 public void twinkle() {
   brightness = brightness + round(random(-20, 20));
   if(brightness > 255){
     brightness = 255;
   }
 }
 
 public void reset() {
   x = random(WIDTH*ZOOM);
   y = random(HEIGHT*ZOOM) * 0.7;
   println("New star " + x + "/" + y + " "); 
 }

}


