import processing.opengl.*;
import java.lang.reflect.Method;
import hypermedia.net.*;
import java.io.*;

// Most standard configuration stuff moved to Config class.

// TODO Move Routine configuraiton to Config class. Not straightfoward because static restrictions.
public Routine[] enabledRoutines = new Routine[] {
    //new Configulate(),
    //new TestPattern(false),
    new Waves(),
    new WarpSpeedMrSulu(),
    new Warp(),
    new TrialOfZod(),
    new Seizure(),
    new RainbowColors(),
    new RGBRoutine(),
    new Pong(),
    //new Greetz(),
    //new FFTDemo(),
    //new DropTheBomb(),
    new ColorDrop(),
    new Chase(),
    new Bursts(),
    new Animator("anim-nyancat",1,.5,0,0,0),
    new TestPattern(true)
};
 
PGraphics draw;
Routine drop = new Seizure();
Routine backupRoutine = null;
int currentColor = 0;
color primaryColor = Config.PALETTE[0];
color secondaryColor = Config.PALETTE[1];
color tertiaryColor = Config.PALETTE[2];
PFont font;
int ZOOM = 1;
long modeFrameStart;
int mode = 0;
//int direction = 1;
//int position = 0;
Routine currentRoutine = null;
LEDDisplay sign;
PGraphics fadeLayer;
int fadeOutFrames = 0;
int fadeInFrames = 0;
WiiController controller;
boolean wasButtonUp = false;
PImage displayBuffer;
boolean switching_mode = false; // if true, we already switched modes, so don't do it again this frame (don't freeze the display if someone holds the b button)
int seizure_count = 0;  // Only let seizure mode work for a short time.


void setup() {
  println("Display dimensions = " + Config.WIDTH + "x" + Config.HEIGHT);
  size(int(Config.WIDTH*Config.ZOOM),int(Config.HEIGHT*Config.ZOOM),P2D);
  draw = createGraphics(Config.WIDTH, Config.HEIGHT);
  frameRate(Config.FRAMERATE);

  // TODO FIX LEDDisplay to work in old send 1 then packets mode..
  sign = new LEDDisplay(this, Config.WIDTH, Config.HEIGHT, true, Config.HOST, Config.PORT);
  sign.setAddressingMode(Config.ADDRESSING_MODE);  
  sign.setEnableGammaCorrection(Config.ENABLE_GAMMA);
  
  setMode(0);  
  controller = new WiiController();

  for (Routine r : enabledRoutines) {
    r.setup(this);
  }  

  drop.setup(this);
}

void setFadeLayer(int g) {
  fadeLayer = createGraphics(Config.WIDTH, Config.HEIGHT);
  fadeLayer.beginDraw();
  fadeLayer.stroke(g);
  fadeLayer.fill(g);
  fadeLayer.rect(0, 0, Config.WIDTH, Config.HEIGHT);
  fadeLayer.endDraw();
}

void setMode(int newMode) {
  currentRoutine = enabledRoutines[newMode];

  mode = newMode;
  modeFrameStart = frameCount;
  println("New mode " + currentRoutine.getClass().getName());

  currentRoutine.reset();
}

void newMode() {
  int newMode = mode;
  String methodName;

  fadeOutFrames = int(Config.FRAMERATE);
  setFadeLayer(240);
  if (enabledRoutines.length > 1) {
    while (newMode == mode) {
      newMode = int(random(enabledRoutines.length));
    }
  }

  setMode(newMode);
}

void draw() {
  draw.beginDraw();
  if (!controller.buttonB) {
    switching_mode = false;
  }

  if (controller.buttonA) {
    seizure_count += 1;
  }
  else {
    seizure_count = 0;
  }

  // Jump into seizure mode
  if ((controller.buttonA || (keyPressed && key == 'a')) && currentRoutine != drop && seizure_count == 1) {
    //drop.draw();
    backupRoutine = currentRoutine;
    currentRoutine = drop;
    drop.reset();
  }
  // Drop out of seizure mode
  else if (!controller.buttonA && currentRoutine == drop) {
    currentRoutine = backupRoutine;
  }
  else if (seizure_count > 10 && currentRoutine == drop) {
    currentRoutine = backupRoutine;
  }
  else if ((controller.buttonB || (keyPressed && key == 'c')) && !switching_mode) {
    newMode();
    switching_mode = true;
  }
  else {
    if (fadeOutFrames > 0) {
      fadeOutFrames--;
      draw.blend(fadeLayer, 0, 0, Config.WIDTH, Config.HEIGHT, 0, 0, Config.WIDTH, Config.HEIGHT, MULTIPLY);

      if (fadeOutFrames == 0) {
        fadeInFrames = int(Config.FRAMERATE);
      }
    }
    else if (currentRoutine != null) {
      currentRoutine.draw();
    }
    else {
      println("Current method is null");
    }

    if (controller.buttonUp && !wasButtonUp) {
      wasButtonUp = true;
      println("New color");
      cycleColors();
    }
    else if (!controller.buttonUp && wasButtonUp) {
      wasButtonUp = false;
    }

    if (fadeInFrames > 0) {
      setFadeLayer(240 - fadeInFrames * (240 / int(Config.FRAMERATE)));
      draw.blend(fadeLayer, 0, 0, Config.WIDTH, Config.HEIGHT, 0, 0, Config.WIDTH, Config.HEIGHT, MULTIPLY);
      fadeInFrames--;
    }

    if (currentRoutine.isDone) {
      currentRoutine.isDone = false;
      newMode();
    }
  }
    
  displayBuffer = draw.get(0,0,Config.WIDTH,Config.HEIGHT);
  displayBuffer.loadPixels();
  
  sign.sendData(displayBuffer.pixels);
  draw.endDraw();
  image(draw,0,0,width,height);
}

color randomColor() {
  return Config.PALETTE[int(random(Config.PALETTE.length))];
}

void cycleColors() {
  currentColor++;
  
  if (currentColor >= Config.PALETTE.length)
    currentColor = 0;
    
  primaryColor = Config.PALETTE[currentColor];
  secondaryColor = Config.PALETTE[currentColor+1 < Config.PALETTE.length ? currentColor+1 : currentColor-Config.PALETTE.length+1];
  tertiaryColor = Config.PALETTE[currentColor+2 < Config.PALETTE.length ? currentColor+2 : currentColor-Config.PALETTE.length+2];  
}

