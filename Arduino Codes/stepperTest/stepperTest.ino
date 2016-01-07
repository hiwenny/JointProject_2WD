//Stepper Motor only for testing purposes

#include <AccelStepper.h>



AccelStepper rightMotor(2, 2, 3);
AccelStepper leftMotor(2, 4, 5);

void setup()  {
  leftMotor.setMaxSpeed(100000.0);
  leftMotor.setAcceleration(100000.0);
  rightMotor.setMaxSpeed(100000.0);
  rightMotor.setAcceleration(100000.0);
 //leftMotor.setSpeed(-10000);
//rightMotor.setSpeed(10000);
pinMode(13, OUTPUT);
  
  Serial.begin(57600);
}

void loop() {
//  leftMotor.move(-1000);
//  rightMotor.move(1000);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//}
//
//  //leftMotor.move(-5000);
//  //rightMotor.move(-5000);
//  //while (leftMotor.distanceToGo() != 0) {
//  //leftMotor.run();
//  //rightMotor.run();
//  
//  //delay(50);
//  //}
//
//  leftMotor.move(5000);
//  rightMotor.move(-5000);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//  }
//

 //first side
 delay(500);
//  leftMotor.move(-21930);
//  rightMotor.move(21930);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
// 
//  }
  
   
  //first turn
  leftMotor.move(-3070*4);
  rightMotor.move(-3070*4);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();

//  }
// 
//  //Second Side
//  leftMotor.move(-716.85);
//  rightMotor.move(716.85);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//
//  }
//
//  //Second turn
//  leftMotor.move(-35.45);
//  rightMotor.move(0);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//  
//  }
//
//  //Third Side
//  leftMotor.move(-716.85);
//  rightMotor.move(716.85);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
// 
//  }
//
//  //Third turn
//  leftMotor.move(-35.45);
//  rightMotor.move(0);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//
//  }
//
//  //Fourth Side
//  leftMotor.move(-716.85);
//  rightMotor.move(716.85);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//
//  }
// 
//  //Fourth turn
//  leftMotor.move(-35.45);
//  rightMotor.move(0);
//  while (leftMotor.distanceToGo() != 0) {
//  leftMotor.run();
//  rightMotor.run();
//
//  }


//delay(5000);
}
}
