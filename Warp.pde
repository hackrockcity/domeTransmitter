class Warp extends Routine {
  float r;
  float rofs;
  float warpSpeed;
  Routine subroutine;
  boolean warpHorizontal;
  boolean warpVertical;
  float warpFactor;

  public Warp() {
    this.subroutine = null;
    warpHorizontal = false;
    warpVertical = true;
    warpSpeed = 2;
    warpFactor = 1;
  }

  public Warp(Routine subroutine, boolean warpHorizontal, boolean warpVertical, float warpSpeed, float warpFactor) {
    this.subroutine = subroutine;
    this.warpHorizontal = warpHorizontal;
    this.warpVertical = warpVertical;
    this.warpSpeed = warpSpeed;
    this.warpFactor = warpFactor;
  }

  void setup(PApplet parent) {
    super.setup(parent);

    if (this.subroutine != null) {
      this.subroutine.setup(parent);
    }
  }

  void hshift(int y, int xofs) {
    if (xofs < 0) 
      xofs = Config.WIDTH + xofs;

    PImage tmp = draw.get(Config.WIDTH-xofs, y, xofs, 1);
    draw.copy(0, y, Config.WIDTH-xofs, 1, xofs, y, Config.WIDTH-xofs, 1);    
    draw.image(tmp, 0, y);
  }

  void vshift(int x, int yofs) {
    if (yofs < 0) 
      yofs = Config.HEIGHT + yofs;

    PImage tmp = draw.get(x, Config.HEIGHT-yofs, 1, yofs);
    draw.copy(x, 0, 1, Config.HEIGHT-yofs, x, yofs, 1, Config.HEIGHT-yofs);    
    draw.image(tmp, x, 0);
  }

  void drawBackground() {
    if (subroutine != null) {
      subroutine.draw();

      if (subroutine.isDone) {
        newMode();
      }
    }
    else {
      draw.background(0);
      draw.noFill();
      draw.ellipseMode(RADIUS);
      for (int i=0; i<10; i++) {
        draw.stroke(i%2==0 ? primaryColor : secondaryColor);
        draw.ellipse(Config.WIDTH/2,Config.HEIGHT/2,i*(Config.WIDTH/10),i*(Config.HEIGHT/10));  
      }
    }
  }

  void draw() {
    drawBackground();

    if (warpVertical) {
      for (int x=0; x<Config.WIDTH; x++) {
        r = x*1.0/Config.HEIGHT*PI + rofs;
        vshift(x, int(sin(r)*(Config.HEIGHT*warpFactor)));
      }

      rofs += 0.0314 * warpSpeed;
    }

    if (warpHorizontal) {
      for (int y=0; y<Config.HEIGHT; y++) {
        r = y*1.0/Config.WIDTH*PI + rofs;
        hshift(y, int(sin(r)*(Config.WIDTH*warpFactor)));
      }

      rofs += 0.0314 * warpSpeed;
    }
  }
}

