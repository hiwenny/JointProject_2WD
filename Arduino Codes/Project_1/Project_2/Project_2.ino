//#include <Stepper.h>
#include <AccelStepper.h>

// Project 1 MTRN3100
// Tristan Manewell z3292606
// Jordan Stewart z3291315
// Allan Salmon z3419647
// Wenny Hidayat z3351846


// Required to: Periodically read 3 Analog Inputs and send this data,
// recieve commands from external sources and implement them.
// Message Format:  [HEADER, SID, DID, L, DATA[], CS]
// HEADER: 0xFA
// Main Comp - 0xAA
// Robot - 0xBB
// CS - 0xFF Arbitrary constant, will use formulae at later period

//Global Constants
//static int DelayValue=25;             //this variable is used to define (approximately) the sampling time of the periodic task.
int samNum = 1;                //Counts the samples taken by the Sensors ???Need to check that this is not forced to stay at 0. I want declared at zero only once, then to increment in the loop???
int DelayValue=25;
       
//Analog Output Pins - NOTE: GENERAL CASE, RENAME AND CONFIRM PIN LOCATIONS LATER - Also these are useless.
int sensor3 = 6;  //Pin 6
int sensor4 = 9;  //Pin 9
int sensor5 = 10; //Pin 10
int sensor6 = 11; //Pin 11

//Analog Input Pins

int in1 = 0;
int in2 = 1;
int in3 = 2;
int in4 = 3;
int in5 = 4;
int in6 = 5;

//Digital Pins
int output1 = 2;  //Pin 2
int output2 = 4;  //Pin 4
int output3 = 13; //Pin 13

//Structures
struct MsgInfo  {  //buffer for incoming message ID info
  unsigned SID,DID,L; 
  int error ; 
}; 

struct MyData1 {     //Stores Sensor Readings for transmission
   int command;
   int valAI0;       //Reading from Sensor 1
   int valAI1;       //Reading from Sensor 2
   int valAI2;       //Reading from Sensor 3
   int sampleNumber; //Counts the sensor readings
   unsigned time;    //At what time the sample was taken
};   


//Function Prototypes
int AskPendingSerialMessages(void);                                 //Is there a complete message to recieve? 
int GetPendingSerialMessage(struct MsgInfo *pm,void *p0,int nmax);  //Then retrieve the message
void SetAOvalue(unsigned channel, unsigned value);                  //Sets the Analog Output value for a specified Pin
void dOutSet(int dOut);
void ProcessRxMessage(struct MsgInfo *pm,unsigned char *p,int n);   //Dispatcher - Interprets recieved message ???What is the purpose of n here???
void ProcessMyTask1(void);                                          //Processes Task1
void ProcessMyTask2(void);                                          //Processes Task2
void SendBinaryData(void *data,struct MsgInfo *pm);                 //Sends Sensor Readings
void motorControl(int leftMotorSpeed, int rightMotorSpeed, int leftMotorDistance, int rightMotorDistance); //Controls Motor Speed

//Stepper Setup
//Stepper leftMotor(400, 2, 3);
//Stepper rightMotor(400, 4, 5);

AccelStepper rightMotor(2, 2, 3);
AccelStepper leftMotor(2, 4, 5);

void setup()  {
  leftMotor.setMaxSpeed(10000.0);
  leftMotor.setAcceleration(10000.0);
  rightMotor.setMaxSpeed(10000.0);
  rightMotor.setAcceleration(10000.0);
//  leftMotor.setSpeed(500.0);
//  rightMotor.setSpeed(500.0);
  
  Serial.begin(57600);
  pinMode(output1, OUTPUT); //Activates these pins as digital outputs
  pinMode(output2, OUTPUT);    
  pinMode(output3, OUTPUT);
}

void loop() {
   int x;                        //Flag indicates presence of recieved message
   int n;                        //Flag indicates recieved message relevant (i.e. for this arduino)
   int sampleCounter=0;
   unsigned char RxMessage[100]; //Buffer for incoming message data
   struct MsgInfo msginfo;       //Structure that stores message ID info
   struct MyData1 mydata1;       //Structure that stores Sensor reading data
   char batteryError[] = "WARNING: BATTERY LOW. CHARGE BATTERY"; //don't think this is working
   
   while (1) {
   driveSquare();
   }
//   //Testing
//   
//     leftMotor.move(-1000);
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
//  //end testing
   
   
   sampleCounter++;
   
   msginfo.SID = 0xBB;
   msginfo.DID = 0xAA;
   msginfo.L = sizeof(mydata1);
   mydata1.command = 100;
  
  if (DelayValue < 255 ){// && sampleCounter > DelayValue) {
     mydata1.valAI0 = analogRead(in1);
     mydata1.valAI1 = analogRead(in2);
     mydata1.valAI2 = analogRead(in3);
     mydata1.sampleNumber = samNum; //check these
     mydata1.time = millis();
     samNum++;
     
     SendBinaryData(&mydata1, &msginfo); //works to here
     
     sampleCounter=0;
  }
 
  x = AskPendingSerialMessages();
  
  if (x == 1){
    //Stores message ID info in msginfo and checks relevant. Stores Message Data in RxMessage
    n = GetPendingSerialMessage(&msginfo,RxMessage,100);
    if(n>0) {
        //Dispatcher - Interprets and Implements recieved Data    
        ProcessRxMessage(&msginfo,RxMessage,n);
    }
  } 
  
  //Voltage check - FINISH THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Don't Forget!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  if (analogRead(in1) < 850) {
    
    //Send message to Matlab
    SendBinaryData(&batteryError, &msginfo);
    
    //Write out to speaker or LED, need to install one
    
  }
  
 // delay(DelayValue); old school way
}

//------------------------------------------------
//Function Definitions

// Method 1
int AskPendingSerialMessages(void) {
  char garbage;     //Trash can for unwanted bytes
  int msgReady = 0; //Flag indicates whether message is ready for reception
  
  if (Serial.available() > 0) {
    if (Serial.peek() != '0xFA') {
      garbage = Serial.read();
    } else {
      msgReady = 1;
      garbage = Serial.read();
    }
  }
  
  if(msgReady = 1) {
    return 1;
  } 
  else {
    return 0;
  }
}
                                                
                                                     
int GetPendingSerialMessage(struct MsgInfo *pm, void *p0, int nmax) {
   pm->L = 0;
   pm->error = 1;
   unsigned char *p = (unsigned char *)p0;
   int i = 0; // counter 1
   
   pm->SID = Serial.read();
   pm->DID = Serial.read();
   pm->L = Serial.read();
 
   if (pm->L > nmax) { //Checks to see that the data is not bigger than the buffer array
    	return -1;
   }
   else {
	 
 	while (i < pm->L) {
   	  p[i] = Serial.read();  
   	  i++;
 	}
   }
 
  return pm->L;
}   

//-----------------------------------------------

void ProcessMyTask1(void) //look at later
{
  unsigned long timeL ;
  static int sampleNumber=0;
  struct MyData1 data1;
  static struct MsgInfo msginfo = { 0,0,0,0 };
 
  timeL =  millis();  //Arduino clock, in ms.    
  data1.time = (unsigned)(0xFFFF & timeL) ;    //copy only the lower 18 bits,

  data1.valAI0 = analogRead(0);    // read the analog input pin #3
  data1.valAI1 = analogRead(1);    // read the analog input pin #3

  data1.sampleNumber = sampleNumber++;

  msginfo.L = sizeof(data1) ;
  SendBinaryData(&data1,&msginfo); //send the bytes that compose the instance of the structure.
}

//-----------------------------------------------

void SetAOvalue(unsigned channel, unsigned value) {
  
  //Writes a value between 0 - 255 to the specified AO Pin (3,5,6,9,10,11)
  analogWrite(channel, value);
}

//Turns a DO Pin to HIGH or LOW. First No. indicates which pin, second indicates HIGH (1) or LOW (0)
void dOutSet(int dOut) {
  
  int pin = 0;
  int onOff = 0;
  pin = dOut & 0x0F;
  onOff = dOut & 0xF0;
  onOff = onOff >> 4;
  
  if (onOff == 1 ) {
    digitalWrite(pin, HIGH);
  } 
  else if (onOff == 0) {
    digitalWrite(pin, LOW);
  }
}

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
//                                                                                              MAIN SWITCH
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
void ProcessRxMessage(struct MsgInfo *pm,unsigned char *p,int n) {
  
   switch(p[0]) {
     
      //set "sample time"   data = [0,dt] , L=2bytes, data[1] = dt (in milliseconds)
     case 0: {            
       
       DelayValue = (int)p[1]; 
       
       if (DelayValue < 5) {
         DelayValue = 5; 
       }
       break;
     }
     
     //Drives Motors. data = [3, leftSpeed, rightSpeed, leftDist, rightDist]
     case 3: {
       
//       int left = int(p[1]);
//       int right = int(p[2]);
//       int leftDistance = int(p[3]);
//       int rightDistance = int(p[4]);

         leftMotor.move(p[1]);
         rightMotor.move(p[2]);
          while(leftMotor.distanceToGo()!=0){
         motorControl(/*left, right, leftDistance, rightDistance*/);
          }
          dOutSet(29);

leftMotor.runSpeed();
rightMotor.runSpeed();
         break;
     }
      
     // Set Analog Output Value. data = [4,AOchannel,value8bits]
     case 4: {
        int channel = (int)p[1];
        int value = (int)p[2];    
        
        SetAOvalue(channel,value);
        break;  
     } 
      
     //Set mulitple AO's. data = [5,n,channel,value,channel,value]
     case 5: {
       
        int n = (int)p[1];
        int i,u;
        unsigned channel,value;
        u=2;
        
        if (n>8) {  //just a protection
          break; 
        }
        
        for (i=0;i<n;i++,u+=2) {
          channel = p[u];
          value =   p[u+1];      
          SetAOvalue(channel,value);
        }         
        break;
      }        
      
      //DO Set Command. data = [6, byte]. First 4bits indicate on/off state, last 4 indicate which pin.
      case 6: {
        
        int dOut = p[1];
     
        dOutSet(p[1]);
        
        break;
      }

      //Echo Command, returns [17, RECIEVE DATA]
      case 7: {            
  
          struct MsgInfo msginfo;
          msginfo.SID = pm->SID;           
          msginfo.DID = pm->DID;        
          msginfo.L = pm->L;
          p[0]=23;

          SendBinaryData(p,&msginfo);   
          break;    
        }   
        
      default: { 
          break; 
     }
  }
}
// ---------------------------------%

void SendBinaryData(void *data,struct MsgInfo *pm) {
    int i,n;
    unsigned cs;
    unsigned char *p = (unsigned char *)data;
    static unsigned char BufTx[100] = {0};
    n=pm->L;
    
    if (n>40) {
      return; 
    }

    BufTx[0]=0xFA;        //header; fixed value
    BufTx[1]=pm->SID;
    BufTx[2]=pm->DID;
    BufTx[3]=(unsigned char)n;
    
    for (i=0;i<n;i++) {    
      BufTx[4+i]=p[i]; 
    }

    //cs =  MkCheckSum(BufTx+1,n+3) ;
    cs=0xFF;          //you should use a proper Checksum calculation in final version
    
    BufTx[4+n]=0xFF;
    BufTx[4+n]=(unsigned char)(cs&0xFF);
    
          Serial.write(BufTx, 4+1+n);
}

//Motor Control Function
void motorControl(/*int leftMotorSpeed, int rightMotorSpeed, int leftMotorDistance, int rightMotorDistance*/) {
// 
//  //Set Speed in RPMs
//  leftMotor.setSpeed(leftMotorSpeed);
//  rightMotor.setSpeed(rightMotorSpeed);
//  
//  //Drive motors
//  
//  leftMotor.step(leftMotorDistance);
//  rightMotor.step(rightMotorDistance);
  
 // leftMotor.moveTo(leftDistance);
  //rightMotor.moveTo(rightDistance);
  
  leftMotor.run();
  rightMotor.run();
  
}

void driveSquare() {
 
  //first side
  leftMotor.move(-716.85);
  rightMotor.move(716.85);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //first turn
  leftMotor.move(-35.45);
  rightMotor.move(0);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Second Side
  leftMotor.move(-716.85);
  rightMotor.move(716.85);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Second turn
  leftMotor.move(-35.45);
  rightMotor.move(0);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Third Side
  leftMotor.move(-716.85);
  rightMotor.move(716.85);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Third turn
  leftMotor.move(-35.45);
  rightMotor.move(0);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Fourth Side
  leftMotor.move(-716.85);
  rightMotor.move(716.85);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }
  //Fourth turn
  leftMotor.move(-35.45);
  rightMotor.move(0);
  while (leftMotor.distanceToGo() != 0) {
  leftMotor.run();
  rightMotor.run();
  }

}


