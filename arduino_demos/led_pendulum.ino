// File led_pendulum.ino
// Makes a Circuit Playground or Circuit Playground Express
// light up with one of two colors, depending on the acceleration
// seen on a chosen axis
// (c) 2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

#include <Adafruit_CircuitPlayground.h>

#define Y //capital X, Y or Z, this is the direction you will be swinging (see the markings by your board's accelerometer).
#define THRESHOLD 0.3

void setup() {
  CircuitPlayground.begin();
  CircuitPlayground.setBrightness(255);
  CircuitPlayground.clearPixels();
}

void loop() {
  float motion =
    #if defined(X)
      CircuitPlayground.motionX();
    #elif defined(Y)
      -CircuitPlayground.motionY();
    #elif defined(Z)
      CircuitPlayground.motionZ();
    #else
      #error No valid axis specified.
    #endif
  
  CircuitPlayground.clearPixels();
  if(motion > THRESHOLD) for(int i = 0; i < 3; i++)
    CircuitPlayground.setPixelColor(i, 255, 0, 0);
  else if(motion < -THRESHOLD) for(int i = 7; i < 10; i++)
    CircuitPlayground.setPixelColor(i, 0, 0, 255);
  else for(int i = 4; i < 6; i++)
  CircuitPlayground.setPixelColor(i, 0, 255, 0);
}
