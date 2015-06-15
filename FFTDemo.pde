import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

class FFTDemo extends Routine {
  FFT fft;
  Minim minim;
  AudioInput audioin;

  void setup(PApplet parent) {
    super.setup(parent);
    minim = new Minim(parent);
    audioin = minim.getLineIn(Minim.STEREO, 2048);
    fft = new FFT(audioin.bufferSize(), audioin.sampleRate());
  }

  void draw() {
    long frame = frameCount - modeFrameStart;

    draw.background(0);
    draw.stroke(255);

    fft.forward(audioin.mix);

    for (int i = 0; i < fft.specSize(); i++)
    {
      // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
      //    stroke(0,0,255);
      //    line(i, Config.HEIGHT, i, Config.HEIGHT - fft.getBand(i)*4);
      //    //line(i, Config.HEIGHT, i, Config.HEIGHT - fft.getBand(i));
      float barHeight = fft.getBand(i)*4;
      for (float c = 0; c < barHeight; c++) {
        draw.stroke(c/barHeight*255, 0, 255);
        draw.point(i, Config.HEIGHT - c);
      }
    }

    if (frame >Config.FRAMERATE*Config.MODE_TIMEOUT) {
      newMode();
    }
  }
}

