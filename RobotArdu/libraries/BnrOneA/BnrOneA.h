/*
  BnrOneA.h - Library for interfacing with Bot'n Roll ONE Arduino Compatible from www.botnroll.com
  Created by José Cruz, November 28, 2013.
  Updated August 24, 2016.
  Released into the public domain.
*/

#ifndef BnrOneA_h
#define BnrOneA_h

#include "Arduino.h"

#define KEY1 0xAA // key used in critical commands
#define KEY2 0x55 // key used in critical commands
#define BRAKE_TORQUE 100
#define OFF 0
#define ON  1
#define AN0 0
#define AN1 1
#define AN2 2
#define AN3 3
#define AN4 4
#define AN5 5
#define AN6 6
#define AN7 7


/*User Commands*/
/*Read Firmware version*/
#define COMMAND_FIRMWARE        0xFE //Read firmware value (integer value)
/*Write Commands->Don't require response from Bot'n Roll ONE A */
#define COMMAND_LED             0xFD //Debug LED
#define COMMAND_SERVO1          0xFC //Move Servo1
#define COMMAND_SERVO2          0xFB //Move Servo2
#define COMMAND_LCD_L1          0xFA //Write LCD line1
#define COMMAND_LCD_L2          0xF9 //Write LCD line2
#define COMMAND_IR_EMITTERS     0xF8 //IR Emmiters ON/OFF
#define COMMAND_STOP            0xF7 //Stop motors freeley
#define COMMAND_MOVE            0xF6 //Move motors with no PID control
#define COMMAND_BRAKE           0xF5 //Stop motors with brake torque
#define COMMAND_BAT_MIN         0xF4 //Configure low battery level
#define COMMAND_MOVE_PID		0xF3 //Move motor with PID control
#define COMMAND_CALIBRATE		0xF2 //Calibrate motors
#define COMMAND_PID_CFG         0xF1 //Configure kp, ki and kd PID control values
#define COMMAND_ENCL_RESET		0xF0 //Preset the value of encoder1
#define COMMAND_ENCR_RESET      0xEF //Preset the value of encoder2
#define COMMAND_ENC_SAVE        0xEE //Save encoders position
#define COMMAND_RAMP_CFG        0xED //Configure acceleration ramp parameters
#define COMMAND_MOV_DIF_SI      0xEC //Move motors with SI units system
#define COMMAND_DIF_SI_CFG      0xEB //Configure SI movement parameters
#define COMMAND_MOVE_1M         0xEA //Move 1 motor with no PID control
#define COMMAND_STOP_1M         0xE9 //Stop 1 motor
#define COMMAND_BRAKE_1M        0xE8 //Brake 1 motor

/*Read Commands-> requests to Bot'n Roll ONE */
#define COMMAND_ADC0            0xDF //Read ADC0
#define COMMAND_ADC1            0xDE //Read ADC1
#define COMMAND_ADC2            0xDD //Read ADC2
#define COMMAND_ADC3            0xDC //Read ADC3
#define COMMAND_ADC4            0xDB //Read ADC4
#define COMMAND_ADC5            0xDA //Read ADC5
#define COMMAND_ADC6            0xD9 //Read ADC6
#define COMMAND_ADC7            0xD8 //Read ADC7
#define COMMAND_BAT_READ		0xD7 //Read ADC battery
#define COMMAND_BUT_READ		0xD6 //Read ADC button
#define COMMAND_OBSTACLES       0xD5 //Read IR obstacle sensors
#define COMMAND_IR_SENSORS      0xD4 //Read IR sensors instant value
#define COMMAND_ENCL            0xD3 //Read Encoder1 position
#define COMMAND_ENCR            0xD2 //Read Encoder2 position
#define COMMAND_ENCL_INC		0xD1 //Read Encoder1 Incremental value
#define COMMAND_ENCR_INC		0xD0 //Read Encoder2 Incremental value
//#define COMMAND_LINE_READ	0xCF //Read Line Value (0-8000)


/*Read Commands-> Computer to Bot'n Roll ONE A*/
#define COMMAND_ARDUINO_ANA0	0xBF //Read analog0 value
#define COMMAND_ARDUINO_ANA1	0xBE //Read analog1 value
#define COMMAND_ARDUINO_ANA2	0xBD //Read analog2 value
#define COMMAND_ARDUINO_ANA3	0xBC //Read analog3 value
#define COMMAND_ARDUINO_DIG0	0xBB //Read digital0 value
#define COMMAND_ARDUINO_DIG1	0xBA //Read digital1 value
//#define COMMAND_ARDUINO_DIG2	0xB9 //Read digital2 value
#define COMMAND_ARDUINO_DIG3	0xB8 //Read digital3 value
#define COMMAND_ARDUINO_DIG4	0xB7 //Read digital4 value
#define COMMAND_ARDUINO_DIG5	0xB6 //Read digital5 value
#define COMMAND_ARDUINO_DIG6	0xB5 //Read digital6 value
#define COMMAND_ARDUINO_DIG7	0xB4 //Read digital7 value
#define COMMAND_ARDUINO_DIG8	0xB3 //Read digital8 value
#define COMMAND_ARDUINO_DIG9	0xB2 //Read digital9 value
#define COMMAND_ARDUINO_DIG10	0xB1 //Read digital10 value
#define COMMAND_ARDUINO_DIG11	0xB0 //Read digital11 value
#define COMMAND_ARDUINO_DIG12	0xAF //Read digital12 value
#define COMMAND_ARDUINO_DIG13	0xAE //Read digital13 value
#define COMMAND_ARDUINO_BUZ     0xAD //Read Buzzer
#define COMMAND_ARDUINO_CMP     0xAC //Read Compass
#define COMMAND_ARDUINO_SNR     0xAB //Read Sonar
#define COMMAND_ARDUINO_GRP1    0xAA //Read gripper1
#define COMMAND_ARDUINO_GRP2    0x9F //Read gripper2


class BnrOneA
{
  public:
        //setup routines
        void spiConnect(byte sspin);
        void minBat(float batmin);
        void obstacleEmitters(boolean state);// ON/OFF
        void setPID(int kp,int ki,int kd);

        //reading routines
        byte obstacleSensors();
        byte readIRSensors();
        int readAdc(byte);
        int readAdc0();
        int readAdc1();
        int readAdc2();
        int readAdc3();
        int readAdc4();
        int readAdc5();
        int readAdc6();
        int readAdc7();
        byte readButton();
        float readBattery();
        int readEncL();
        int readEncR();
        int readEncLInc();
        int readEncRInc();
        int readDBG(byte);
        void readFirmware(byte*,byte*,byte*);


        //write routines
        void servo1(byte position);
        void servo2(byte position);
        void led(boolean state);// ON/OFF
        void move(int speedL,int speedR);
		void move1m(byte motor, int speed);
        void movePID(int speedL,int speedR);
        void stop();
		void stop1m(byte motor);
        void brake(byte torqueL,byte torqueR);
		void brake1m(byte motor, byte torque);
		void brake1m(byte motor);
        void resetEncL();
        void resetEncR();


        //LCD Line 1 write routines
        void lcd1(byte string[]);
        void lcd1(const char string[]);
        void lcd1(int number);
        void lcd1(unsigned int number);
        void lcd1(long int number);
        void lcd1(double number);
        void lcd1(const char string[],int number);
        void lcd1(const char string[],unsigned int number);
        void lcd1(const char string[],long int number);
        void lcd1(const char string[],double number);
        void lcd1(int num1, int num2);
        void lcd1(unsigned int num1, unsigned int num2);
        void lcd1(int num1, int num2, int num3);
        void lcd1(int num1, int num2, int num3, int num4);
        void lcd1(unsigned int num1, unsigned int num2, unsigned int num3);
        void lcd1(unsigned int num1, unsigned int num2, unsigned int num3, unsigned int num4);
        //LCD Line 2 write routines
        void lcd2(byte string[]);
        void lcd2(const char string[]);
        void lcd2(int number);
        void lcd2(unsigned int number);
        void lcd2(long int number);
        void lcd2(double number);
        void lcd2(const char string[],int number);
        void lcd2(const char string[],unsigned int number);
        void lcd2(const char string[],long int number);
        void lcd2(const char string[],double number);
        void lcd2(int num1, int num2);
        void lcd2(unsigned int num1, unsigned int num2);
        void lcd2(int num1, int num2, int num3);
        void lcd2(int num1, int num2, int num3, int num4);
        void lcd2(unsigned int num1, unsigned int num2, unsigned int num3);
        void lcd2(unsigned int num1, unsigned int num2, unsigned int num3, unsigned int num4);

  private:
        byte spiRequestByte(byte command);
        int  spiRequestWord(byte command);
        void spiSendData(byte command, byte buffer[], byte numBytes);
        byte _sspin;
};
#endif

