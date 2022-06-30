// File integral_mouse.ino
// Makes a Circuit Playground or Circuit Playground Express into
// an accelerator mouse.
// (c) 2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

#ifndef ARDUINO_AVR_CIRCUITPLAY
  #ifndef ARDUINO_SAMD_CIRCUITPLAYGROUND_EXPRESS
    #error Please select Circuit Playground/Circuit Playground Express.
  #endif
#endif

#include <Adafruit_CircuitPlayground.h>
#include <Mouse.h>
#include <Wire.h>
#include <SPI.h>

#define SPEED .1
#define SAMPLE 10 //Number of samples in the average

boolean lb = 0;
boolean rb = 0;

float v[2] = {0, 0};
float cal[2] = {0, 0};

#define X 0
#define Y 1

unsigned long t = 0;

boolean lift() {
  return !CircuitPlayground.leftButton();
}

boolean leftmouse() {
  return CircuitPlayground.rightButton();
}

boolean rightmouse() {
  return 0;
}

void setup() {
  CircuitPlayground.begin();
  Mouse.begin();
  calibrate();
}

void loop() {
  t = millis();
  if(lb != leftmouse()) {
    lb = !lb;
    if(lb) Mouse.press(MOUSE_LEFT);
    else Mouse.release(MOUSE_LEFT);
  }
  if(rb != rightmouse()) {
    rb = !rb;
    if(rb) Mouse.press(MOUSE_RIGHT);
    else Mouse.release(MOUSE_RIGHT);
  }
  if(lift()) {
    v[X] = 0;
    v[Y] = 0;
    calibrate();
    return;
  }
  
  float dv[2] = {0, 0};
  
  // Average acceleration for SAMPLE samples. 
  
  for(int i = 0; i < SAMPLE; ++i) {
    dv[X] += CircuitPlayground.motionX();
    dv[Y] += CircuitPlayground.motionY();
  }
  dv[X] /= SAMPLE;
  dv[Y] /= SAMPLE;
  
  // Now integrate acceleration to get velocity.
  // Use the average acceleration we just computed. 
  
  unsigned long dt = millis() - t;
  
  v[X] += (dv[X] - cal[X]) * dt;
  v[Y] += (dv[Y] - cal[Y]) * dt;
  
  // Now export result consistent with screen coordinates
  // which have origin at top left.
  // Classic and Express boards have rotated coordinates 
  // from each other.
  
  #if defined(ARDUINO_AVR_CIRCUITPLAY)
    Mouse.move((int)-v[Y] * SPEED, (int)-v[X] * SPEED, 0);
  #elif defined(ARDUINO_SAMD_CIRCUITPLAYGROUND_EXPRESS)
    Mouse.move((int)v[X] * SPEED, (int)-v[Y] * SPEED, 0);
  #endif
}

void calibrate() {
  cal[X] = 0;
  cal[Y] = 0;
  for(int i = 0; i < SAMPLE; ++i) {
    cal[X] += CircuitPlayground.motionX() / SAMPLE;
    cal[Y] += CircuitPlayground.motionY() / SAMPLE;
  }
}
