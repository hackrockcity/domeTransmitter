import oscP5.*;
import netP5.*;

/** darwiinremoteOSC address space
/wii/connected , i
/wii/mousemode , i
/wii/button/a , i
/wii/button/b , i
/wii/button/up , i
/wii/button/down , i
/wii/button/left , i
/wii/button/right , i
/wii/button/minus , i
/wii/button/plus , i
/wii/button/home , i
/wii/button/one , i
/wii/button/two , i
/wii/acc , fff
/wii/orientation , ff
/wii/irdata , ffffffffffff
/wii/batterylevel , f
/nunchuk/joystick , ff
/nunchuk/button/z , i
/nunchuk/button/c , i
/nunchuk/acc , fff
/nunchuk/orientation , ff
*/


class WiiController {
  WiiController singleton = null;
  
  OscP5 osc;  
  boolean buttonA, buttonB, buttonUp, buttonDown, buttonLeft, buttonRight;
  boolean buttonOne, buttonTwo, buttonMinus, buttonPlus, buttonHome,buttonC,buttonZ;
  boolean isConnected;
  float roll, pitch;
  float nRoll, nPitch;
  Acceleration acc;
  float x,y;
  float nX, nY;
  float pNx, pNy;
  Acceleration nAcc;
  boolean isNunchuck = false;

  float batterylevel;
  boolean DEBUG = false;

  IRdata[] ir;

  String remoteAddress;
  int remotePort;


  WiiController() {
    // by default darwiinremoteOSC sends OSC messages to port 5600
    osc = new OscP5(this,5600);
    
    // the address and the port of darwiinremoteOSC
    remoteAddress = "127.0.0.1";
    remotePort = 5601;


    acc = new Acceleration();
    nAcc = new Acceleration();
    ir = new IRdata[4];
    
    // Darwiin messages
    osc.plug(this,"connected","/wii/connected");// i
    osc.plug(this,"mousemode","/wii/mousemode");// i
    osc.plug(this,"buttonA","/wii/button/a");// i
    osc.plug(this,"buttonB","/wii/button/b");// i
    osc.plug(this,"buttonUp","/wii/button/up");// i
    osc.plug(this,"buttonDown","/wii/button/down");// i
    osc.plug(this,"buttonLeft","/wii/button/left");// i
    osc.plug(this,"buttonRight","/wii/button/right");// i
    osc.plug(this,"buttonMinus","/wii/button/minus");// i
    osc.plug(this,"buttonPlus","/wii/button/plus");// i
    osc.plug(this,"buttonHome","/wii/button/home");// i
    osc.plug(this,"buttonOne","/wii/button/one");// i
    osc.plug(this,"buttonTwo","/wii/button/two");// i
    osc.plug(this,"acceleration","/wii/acc");
    osc.plug(this,"orientation","/wii/orientation");
    osc.plug(this,"irdata","/wii/irdata");
    osc.plug(this,"batterylevel","/wii/batterylevel");
    osc.plug(this,"joystick","/nunchuk/joystick");
    osc.plug(this,"buttonZ","/nunchuk/button/z");
    osc.plug(this,"buttonC","/nunchuk/button/c");
    osc.plug(this,"nunchukAcceleration","/nunchuk/acc");
    osc.plug(this,"nunchukOrientation","/nunchuk/orientation");

    // Wiiosc messages
    osc.plug(this,"wiiosc_buttonA",     "/wii/keys/a");
    osc.plug(this,"wiiosc_buttonB",     "/wii/keys/b");
    osc.plug(this,"wiiosc_buttonUp",    "/wii/keys/up");// i
    osc.plug(this,"wiiosc_buttonDown",  "/wii/keys/down");// i
    osc.plug(this,"wiiosc_buttonLeft",  "/wii/keys/left");// i
    osc.plug(this,"wiiosc_buttonRight", "/wii/keys/right");// i
    osc.plug(this,"wiiosc_buttonMinus", "/wii/keys/minus");// i
    osc.plug(this,"wiiosc_buttonPlus",  "/wii/keys/plus");// i
    osc.plug(this,"wiiosc_buttonHome",  "/wii/keys/home");// i
    osc.plug(this,"wiiosc_buttonOne",   "/wii/keys/one");// i
    osc.plug(this,"wiiosc_buttonTwo",   "/wii/keys/two");// i
    osc.plug(this,"wiiosc_accX",        "/wii/acc/x");// i
    osc.plug(this,"wiiosc_accY",        "/wii/acc/y");// i
    osc.plug(this,"wiiosc_accZ",        "/wii/acc/z");// i
  }
  
  void wiiosc_accX(int id, float value) {
    // value goes from .4 (-90) to .6 (90)
    acc.x = (value-.5)*10;
  }
  
  void wiiosc_accY(int id, float value) {
    acc.y = (value-.5)*10;
  }
  
  void wiiosc_accZ(int id, float value) {
    acc.z = (value-.5)*10;
    
    pitch = (float) Math.atan2(acc.y, acc.z)*(180/3.14);
    roll = (float) Math.atan2(acc.x, acc.z)*(180/3.14);
  }

  void connected(int theValue) {
    isConnected = (theValue==0) ? false:true;
  }
  
  
  void oscEvent(OscMessage theOscMessage) {
    if(theOscMessage.checkAddrPattern("/framerate")==true) {
      if(theOscMessage.checkTypetag("i")) {
//        println("Update framerate to " + theOscMessage.get(0).intValue());
        frameRate(theOscMessage.get(0).intValue());
      }
    }
    if(theOscMessage.checkAddrPattern("/brightness")==true) {
      if(theOscMessage.checkTypetag("f")) {
//        println("Update brigthness to " + theOscMessage.get(0).floatValue());
        Config.BRIGHTNESS = theOscMessage.get(0).floatValue();
      }
    }
  }
  
  
  void acceleration(float theX, float theY, float theZ) {
    acc.x = theX;
    acc.y = theY;
    acc.z = theZ;
    if(DEBUG) {
      println("acceleration  x:"+acc.x+" y:"+acc.y+"  z:"+acc.z);  
    }
  }

  void orientation(float theRoll, float thePitch) {
    roll += (theRoll - roll)*0.04;
    pitch += (thePitch - pitch)*0.04;
    if(DEBUG) {
      println("orientation roll:"+roll+"   pitch:"+pitch);
    }
  }


  // darwiinremoteOSC sends 12 floats containing the x,y and size values for 
  // 4 IR spots the wiimote can sense. values are between 0 and 1 for x and y
  // values for size are 0 and bigger. if the size is 15 or 0, the IR point is not 
  // recognized by the wiimote.
  void ir(
  float f10, float f11,float f12, 
  float f20,float f21, float f22,
  float f30, float f31, float f32,
  float f40, float f41, float f42
    ) {
    ir[0].x = f10;
    ir[0].y = f11;
    ir[0].s = f12;
    ir[1].x = f20;
    ir[1].y = f21;
    ir[1].s = f22;
    ir[2].x = f30;
    ir[2].y = f31;
    ir[2].s = f32;
    ir[3].x = f40;
    ir[3].y = f41;
    ir[3].s = f42;
  }


  void joystick(float theX, float theY) {
    // the origin xy coordinates for the joystick are theX = 125, and theY=129
    nX = theX;
    nY = theY;
    isNunchuck = true;
  }

  void nunchukAcceleration(float theX, float theY, float theZ) {
    nAcc.x = theX;
    nAcc.y = theY;
    nAcc.z = theZ;
  }


  void nunchukOrientation(float theRoll, float thePitch) {
    nRoll += (theRoll - nRoll)*0.04;
    nPitch += (thePitch - nPitch)*0.04;
    if(DEBUG) {
      println("NUNCHUCK orientation roll:"+roll+"   pitch:"+pitch);
    }
  }
  
  void wiiosc_buttonA    (int id, int theValue) {buttonA    (theValue);}
  void wiiosc_buttonB    (int id, int theValue) {buttonB    (theValue);}
  void wiiosc_buttonOne  (int id, int theValue) {buttonOne  (theValue);}
  void wiiosc_buttonTwo  (int id, int theValue) {buttonTwo  (theValue);}
  void wiiosc_buttonMinus(int id, int theValue) {buttonMinus(theValue);}
  void wiiosc_buttonPlus (int id, int theValue) {buttonPlus (theValue);}
  void wiiosc_buttonUp   (int id, int theValue) {buttonUp   (theValue);}
  void wiiosc_buttonDown (int id, int theValue) {buttonDown (theValue);}
  void wiiosc_buttonLeft (int id, int theValue) {buttonLeft (theValue);}
  void wiiosc_buttonRight(int id, int theValue) {buttonRight(theValue);}
  void wiiosc_buttonHome (int id, int theValue) {buttonHome (theValue);}

//  void wiiosc_accX (int id, int theValue) {acc.x = theX;}
//  void wiiosc_accY (int id, int theValue) {}
//  void wiiosc_accZ (int id, int theValue) {buttonHome (theValue);}  
  
  void buttonA(int theValue) {
    buttonA = (theValue==1) ? true:false;
  }

  void buttonB(int theValue) {
    buttonB = (theValue==1) ? true:false;
  }

  void buttonOne(int theValue) {
    buttonOne = (theValue==1) ? true:false;
  }

  void buttonTwo(int theValue) {
    buttonTwo = (theValue==1) ? true:false;
  }

  void buttonMinus(int theValue) {
    buttonMinus = (theValue==1) ? true:false;
  }

  void buttonPlus(int theValue) {
    buttonPlus = (theValue==1) ? true:false;
  }

  void buttonUp(int theValue) {
    buttonUp = (theValue==1)  ? true:false;
    
    if(buttonUp) {
      Config.BRIGHTNESS = min(1,Config.BRIGHTNESS + .1);
    }
  }

  void buttonDown(int theValue) {
    buttonDown = (theValue==1) ? true:false;

    if(buttonDown) {
      Config.BRIGHTNESS = max(.1,Config.BRIGHTNESS - .1);
    }
  }
  
  void buttonLeft(int theValue) {
    buttonLeft = (theValue==1)  ? true:false;
    
    if (buttonLeft) {
      frameRate(max(15,frameRate - 5));
    }
  }

  void buttonRight(int theValue) {
    buttonRight = (theValue==1) ? true:false;
    
    // make faster
    if (buttonRight) {
      frameRate(min(150,frameRate + 5));
    }
  }

  void buttonHome(int theValue) {
    buttonHome = (theValue==1) ? true:false;
  }

  void batterylevel(float theValue) {
    println("BatteryLevel: "+theValue);
    batterylevel = theValue;
  }

  class Acceleration {
    float x,y,z;
    float speedX=0, speedY=0, speedZ=0;
  }

  class IRdata {
    float x,y,s;
  }

  void requestBatterylevel() {
    osc.send("/wii/batterylevel",new Object[] {},remoteAddress,remotePort);
  }
  
  void forcefeedback(boolean theFlag) {
    int n = 0;
    if(theFlag) {
      n = 1;
    }
    osc.send("/wii/forcefeedback",new Object[] {new Integer(n)  },remoteAddress,remotePort);
  }
  
  void led(int[] n) {
      osc.send("/wii/led",new Object[] { new Integer(n[0]), new Integer(n[1]),new Integer(n[2]),new Integer(n[3])},remoteAddress,remotePort);
  }
}
