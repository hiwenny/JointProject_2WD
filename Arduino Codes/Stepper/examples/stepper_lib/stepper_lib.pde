
/* 
 Stepper Motor Controller
 language: Wiring/Arduino
 
 This program drives a unipolar or bipolar stepper motor. 
 The motor is attached to digital pins 8 - 11 of the Arduino.
 A switch is attached to digital pin 3, and a potentiometer
 is attached to analog pin 0.
 
 When the switch is pressed, the motor changes direction.
 The potentimeter controls the motor's speed, by changing the 
 delay between motor steps.
 
 The stepMotor() and moveMotor() methods can be used in other ways as well.
 
 Created 11 Mar. 2007
 by Tom Igoe
 
 */

// define the pins that the motor is attached to. You can use
// any digital I/O pins.

#include <Stepper.h>

// define the pin the switch is attached to.
#define switchPin 3

// define a sensitivity threshold for the analog input:
#define threshold 10

int sensorReading = 0;        // reading from the sensor
Stepper myStepper;            // instance of the Stepper library

void setup() {
  // attach the motor pins to the Stepper instance:
 myStepper.attach(8,9,10,11);
}

void loop() {
// read the analog sensor, convert to 0 a byte (0 - 255):
  int sensorReading = analogRead(0) /4;
  // if the sensor's changed more than the threshold since 
  // the last speed setting, change the speed:
  if (abs(myStepper.speed - sensorReading) > threshold) {
    myStepper.speed = sensorReading;
  }
  // read the switch, use it to set the direction:
  myStepper.direction = digitalRead(switchPin);
  // move the motor one step:
  myStepper.moveMotor(1);
 
}

