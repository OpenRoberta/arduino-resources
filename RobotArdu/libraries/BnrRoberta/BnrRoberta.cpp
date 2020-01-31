/*
  BnrRoberta.cpp - additional library for interfacing with Bot'n Roll ONE Arduino Compatible
  from www.botnroll.com that allows using some extra functions from https://www.open-roberta.org/
  Created by Evgeniya Ovchinnikova, August 30, 2016.
  Released into the public domain.
*/
#include <stdio.h>
#include <stdlib.h>
#include "SPI.h"
#include "BnrOneA.h"
#include "BnrRescue.h"
#include "BnrRoberta.h"
#include "Wire.h"
#include "math.h"
#define SSPIN  2
#define ADDRESS 0x60
#define MODULE_ADDRESS 0x2C

BnrRoberta::BnrRoberta(BnrOneA oneInn, BnrRescue brmInn)
: one(oneInn), brm(brmInn)
{
}


void BnrRoberta::setOne(BnrOneA oneInn){
	this->one = oneInn;
}

void BnrRoberta::setBrm(BnrRescue brmInn){
	this->brm = brmInn;
}

void BnrRoberta::moveTime(int speedL,int speedR, double time)
{   one.move(speedL, speedR);
    delay(time);
    one.stop();
}

void BnrRoberta::moveTimePID(int speedL,int speedR, double time)
{   one.movePID(speedL, speedR);
    delay(time);
    one.stop();
}

void BnrRoberta::move1mTime(int port, int speed, double time)
{  one.move1m(port, speed);
   delay(time);
   one.stop();
}

void BnrRoberta::lcdClear()
{    	one.lcd1("                   ");
	one.lcd2("                   ");
}

int BnrRoberta::ultrasonicDistance(int port)
{
	byte distances[3]={0,0,0};
	brm.readSonars(&distances[0],&distances[1],&distances[2]);
	return distances[port];
}

int BnrRoberta::sonar()
{

    int echoPin = 7;
    int trigPin = 8;
    int maximumRange = 200;
    int minimumRange = 0; 
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
    unsigned long duration;
    int distance;
    unsigned long tempo=micros();
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH, 11640);
    delayMicroseconds(16000 - (micros()-tempo));
    distance = (int)(duration/58.2);
    if (distance >= maximumRange || distance <= minimumRange)
      distance=-1;
    return distance;
}

bool BnrRoberta::buttonIsPressed(int button)
{   
	if (one.readButton() == 0){
		return false;
	}
	else{
		return (one.readButton() == button || button == 123);
	}
}

byte *BnrRoberta::colorSensorRGB(byte colors[], int port)
{
	
	if (port == 1){
		brm.readRgbL(&colors[0],&colors[1],&colors[2]);
	}
	else{
		brm.readRgbR(&colors[0],&colors[1],&colors[2]);
	}
	return colors;
}


int BnrRoberta::colorSensorLight(byte colors[], int port)
{
	
	int light;
	if (port == 1){
		brm.readRgbL(&colors[0],&colors[1],&colors[2]);
	}
	else{
		brm.readRgbR(&colors[0],&colors[1],&colors[2]);
	}
	light = (colors[0] + colors[1] + colors[2]) / 3 / 2.55;
	return light;
}



unsigned int BnrRoberta::colorSensorColor(byte colors[], int port)
{   
    if (port == 1){
		brm.readRgbL(&colors[0],&colors[1],&colors[2]);
	}
	else{
		brm.readRgbR(&colors[0],&colors[1],&colors[2]);
	}
	return RGB(colors[0], colors[1], colors[2]);
}

bool BnrRoberta::infraredSensorObstacle(int port)
{	if (one.obstacleSensors() == 3){
		return true;
	}
	return port == one.obstacleSensors();
}

bool BnrRoberta::infraredSensorPresence(int port)
{	
	if (one.readIRSensors() == 3){
		return true;
	}
	return port == one.readIRSensors();
}

float BnrRoberta::readBearing()
{
	Wire.begin();
    byte highByte, lowByte;
    Wire.beginTransmission(ADDRESS);           //start communication with CMPS10
    Wire.write(2);                             //Send the register we wish to start reading from
    Wire.endTransmission();

    Wire.requestFrom(ADDRESS, 2);              // Request 4 bytes from CMPS10
    while(Wire.available() < 2);               // Wait for bytes to become available
    highByte = Wire.read();
    lowByte = Wire.read();

return (float)((highByte<<8)+lowByte)/10;
}

char BnrRoberta::readRoll()
{   Wire.begin();
    char roll;                 // Store  roll values of CMPS10, chars are used because they support signed value
    Wire.beginTransmission(ADDRESS);           //start communication with CMPS10
    Wire.write(5);                             //Send the register we wish to start reading from
    Wire.endTransmission();

    Wire.requestFrom(ADDRESS, 1);              // Request 4 bytes from CMPS10
    while(Wire.available() < 1);               // Wait for bytes to become available
    roll = Wire.read();
	return roll;
}

char BnrRoberta::readPitch()
{
	Wire.begin();
	char pitch;                // Store pitch values of CMPS10, chars are used because they support signed value
    Wire.beginTransmission(ADDRESS);           //start communication with CMPS10
    Wire.write(4);                             //Send the register we wish to start reading from
    Wire.endTransmission();

    Wire.requestFrom(ADDRESS, 1);              // Request 4 bytes from CMPS10
    while(Wire.available() < 1);               // Wait for bytes to become available
    pitch = Wire.read();

	return pitch;
}


//following 3 functions are taken from http://www.geeksforgeeks.org/convert-floating-point-number-string/

void BnrRoberta::reverse(char *str, int len)
{
    int i=0, j=len-1, temp;
    while (i<j)
    {
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
        i++; j--;
    }
}
 

int BnrRoberta::intToStr(int x, char str[], int d)
{
    int i = 0;
    while (x)
    {
        str[i++] = (x%10) + '0';
        x = x/10;
    }
 
    while (i < d)
        str[i++] = '0';
 
    reverse(str, i);
    str[i] = '\0';
    return i;
}

void BnrRoberta::dtoa(double n, char *res, int afterpoint)
{
    int ipart = (int)n;
 
    float fpart = n - (double)ipart;
 
    int i = intToStr(ipart, res, 0);
 
    if (afterpoint != 0)
    {
        res[i] = '.';
 
        fpart = fpart * pow(10, afterpoint);
 
        intToStr((int)fpart, res + i + 1, afterpoint);
    }
}

char *BnrRoberta::numToString(double num)
{
	char *res;
	res = (char*)malloc(20);
	dtoa(num, res, 1);
	return res; 
}

char *BnrRoberta::boolToString(bool boolean)
{
	char *res;
	res = (char*)malloc(20);
	if (boolean){
		res = "true";
	}
	else{
		res = "false";
	}
	return res; 
}
