#include <Servo.h>

Servo myservoA;
Servo myservoB;
Servo myservoC;
Servo myservoD;
Servo myservoE;
Servo myservoF;
int i, pos, myspeed;
int sea, seb, sec, sed, see, sef;
static int v=0;
static int mycomflag=0;
String mycommand="";


void setup() 
{ 
    // Unsure what these do and if they are required
    pinMode(13, INPUT);
    pinMode(12, INPUT);
    
    Serial.begin(9600);     // Set the boud rate to 9600
 
    mycomflag=1;    // Default state of operation
 
    // Attach each servo to a specific pin
    myservoA.attach(11);    // Waist servo at port 11
    myservoB.attach(12);    // Shoulder servo at port 12
    myservoC.attach(13);    // Elbow servo at port 13
    myservoD.attach(8);     // Wrist elevation servo at port 8
    myservoE.attach(9);     // Wrist rotation servo at port 9
    myservoF.attach(10);    // Gripper servo at port 10
    
    // Position the waist in the center
    myservoA.write(90);
    // Position shoulder to a lower angle for better arm balance
    myservoB.write(70);
    // Position elbow to a higher angle for better arm balance
    myservoC.write(140);
    // Position the wrist elevation in the center
    myservoD.write(90);
    // Correct for a slight offset for the wrist rotation
    myservoE.write(100);
    // Default to a wide open gripper
    myservoF.write(30);
}


void loop() 
{ 
    // Set mycommand if a message is being entered into the serial port
    while (Serial.available() > 0)
    {
        mycommand += char(Serial.read());
        delay(2);
    }

    // If a command is provided, identify what it is before resetting it
    if (mycommand.length() > 0)
    {
        if(mycommand=="#auto")
        {
            mycomflag=2;
            Serial.println("auto station");
            mycommand="";
        }
        if(mycommand=="#com")
        {
            mycomflag=1;
            Serial.println("computer control station");
            mycommand="";
        }
        if(mycommand=="#stop")
        {
            mycomflag=0;
            Serial.println("stop station");
            mycommand="";
        }
    }
  
    // If performing computer control use this
    if(mycomflag==1)
    {      
        /* Calculate the new angle for the specific servo then move it there

        Expect format of <int><alpha>
            where <int> represents the servo angle between 0 and 180
            and <alpha> represents the specific servo between a and f
            
        For example, 90a moves servo a to 90 degrees, etc. */
        for(int m=0; m<mycommand.length(); m++)
        {
            char ch = mycommand[m];
            switch(ch)
            {
                /* When ch is between 0 and 9, calculate the servo angle
                
                If there is an existing value for v, multiply it by 10 to put
                it in the tens place, then put the second command value in the
                ones place */
                case '0'...'9':
                v = v*10 + ch - '0';
                break;
                
                // Move waist
                case 'a':
                myservoA.write(v);
                Serial.print("moving waist to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;

                // Move shoulder
                case 'b':
                myservoB.write(v);
                Serial.print("moving shoulder to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;

                // Move elbow only if it's greater than 35 degrees
                case 'c':
                if(v >= 35) myservoC.write(v);
                Serial.print("moving elbow to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;

                // Move wrist elevation
                case 'd':
                myservoD.write(v);
                Serial.print("elevating wrist to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;

                // Move wrist rotation
                case 'e':
                myservoE.write(v);
                Serial.print("rotating waist to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;

                // Move gripper only between 30 and 90 degrees
                case 'f':
                if(v >= 30 || v <= 90) myservoF.write(v);
                Serial.print("moving gripper to ");
                Serial.print(v);
                Serial.println(" degrees");
                v = 0;
                break;
            }
        }
        mycommand="";
    }
    
    // If performing auto control, use this to cycle through these joint angles
    if(mycomflag==2)
    {    
        delay(3000); 
        Serial.println("starting auto mode");

        // Cycle through the joint angle from specified start to end

        myspeed=500;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoA.write(int(map(pos, 1, myspeed, 90, 60)));
            myservoB.write(int(map(pos, 1, myspeed, 70, 90)));
            delay(1);                       
        }
        delay(1000);

        myspeed=500;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoA.write(int(map(pos, 1, myspeed, 60, 90)));
            myservoC.write(int(map(pos, 1, myspeed, 140, 90)));
            myservoD.write(int(map(pos, 1, myspeed, 90, 30)));
            myservoE.write(int(map(pos, 1, myspeed, 100, 10))); 
            delay(1);                       
        }
        delay(1000);

        myspeed=1000;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoB.write(int(map(pos, 1, myspeed, 90, 50)));
            myservoC.write(int(map(pos, 1, myspeed, 90, 150)));
            delay(1);                       
        }
        delay(1000);

        myspeed=500;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoC.write(int(map(pos, 1, myspeed, 150, 120)));
            myservoD.write(int(map(pos, 1, myspeed, 30, 140)));
            myservoE.write(int(map(pos, 1, myspeed, 10, 100)));
            myservoF.write(int(map(pos, 1, myspeed, 30, 85)));
            delay(1);                       
        }
        delay(1000);

        myspeed=1000;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoA.write(int(map(pos, 1, myspeed, 90, 140)));
            myservoF.write(int(map(pos, 1, myspeed, 85, 30)));    
            delay(1);                       
        }  
        delay(1000);

        myspeed=500;
        for(pos=0; pos<=myspeed; pos+=1)  
        {                                
            myservoA.write(int(map(pos, 1, myspeed, 140, 90)));
            myservoB.write(int(map(pos, 1, myspeed, 50, 70)));
            myservoC.write(int(map(pos, 1, myspeed, 120, 140)));
            delay(1);                       
        } 
        delay(1000);
    }
    
    // No command was specified
    if(mycomflag==0)
    {
        Serial.println("no mode specified; use either #com or #auto");
    }
}
