import codeanticode.gsvideo.*;
import processing.opengl.*;
import java.lang.reflect.Method;
import hypermedia.net.*;
import java.io.*;

int WIDTH = 25;
int HEIGHT = 160;
boolean VERTICAL = false;
int FRAMERATE = 30;
String hostname = "127.0.0.1"; //"192.168.1.130";
int TYPICAL_MODE_TIME = 30;

Routine[] enabledRoutines = new Routine[] {
  new Greetz(),
  new Bursts(),
  new Flash(),
  new Lines(),
  new OppositeLines(),
  new Waves(),
  new RadialStars(),
  new NightSky(),
  new TargetScanner(),
  new Waterfalls(),
 // new FFT(),
  new RGBRoutine(),
  new FlashColors(),
  new FollowMouse()
};

int w = 0;
int x = WIDTH;
PFont font;
int ZOOM = 1;

long modeFrameStart;
int mode = 0;

int direction = 1;
int position = 0;
Routine currentRoutine = null;

Dacwes dacwes;

PGraphics fadeLayer;
int fadeOutFrames = 0;
int fadeInFrames = 0;

void setup() {
  // Had to enable OPENGL for some reason new fonts don't work in JAVA2D.
  size(WIDTH,HEIGHT);

  frameRate(FRAMERATE);
  
  dacwes = new Dacwes(this, WIDTH, HEIGHT);
  dacwes.setAddress(hostname);
  dacwes.setAddressingMode(Dacwes.ADDRESSING_VERTICAL_NORMAL);  

  setMode(0);  
  
  for (Routine r : enabledRoutines) {
    r.setup(this);
  }
}

void setFadeLayer(int g) {
  fadeLayer = createGraphics(WIDTH, HEIGHT, P2D);
  fadeLayer.beginDraw();
  fadeLayer.stroke(g);
  fadeLayer.fill(g);
  fadeLayer.rect(0, 0, WIDTH, HEIGHT);
  fadeLayer.endDraw();
}

void setMode(int newMode) {
  //String methodName = enabledModes[newMode];
  currentRoutine = enabledRoutines[newMode];

  mode = newMode;
  modeFrameStart = frameCount;
  println("New mode " + currentRoutine.getClass().getName());
  
  currentRoutine.reset();
}

void newMode() {
  int newMode = mode;
  String methodName;

  fadeOutFrames = FRAMERATE;
  setFadeLayer(240);
  if (enabledRoutines.length > 1) {
    while (newMode == mode) {
      newMode = int(random(enabledRoutines.length));
    }
  }

  setMode(newMode);
//  dacwes.sendMode(enabledModes[newMode]);
}

void draw() {
  if (fadeOutFrames > 0) {
    fadeOutFrames--;
    blend(fadeLayer, 0, 0, WIDTH, HEIGHT, 0, 0, WIDTH, HEIGHT, MULTIPLY);

    if (fadeOutFrames == 0) {
      fadeInFrames = FRAMERATE;
    }
  }
  else if (currentRoutine != null) {
    currentRoutine.draw();
  }
  else {
    println("Current method is null");
  }

  if (fadeInFrames > 0) {
    setFadeLayer(240 - fadeInFrames*8);
    blend(fadeLayer, 0, 0, WIDTH, HEIGHT, 0, 0, WIDTH, HEIGHT, MULTIPLY);
    fadeInFrames--;
  }

  if (currentRoutine.isDone) {
    currentRoutine.isDone = false;
    newMode();
  }
//  println(frameRate);
  dacwes.sendData();  
}


