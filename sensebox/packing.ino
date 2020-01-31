#undef max
#undef min
#define _ARDUINO_STL_NOT_NEEDED
#include <NEPODefs.h>
#include "SenseBoxMCU.h"
#include <SPI.h>
#include <SD.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Plot.h>
#include <stdlib.h>
#include <list>

unsigned long _time = millis();

double ___numVar;
bool ___boolVar;
String ___stringVar;
unsigned int ___colourVar;
std::list<double> ___numList;
std::list<bool> ___boolList;
std::list<String> ___stringList;
std::list<unsigned int> ___colourList;
int _led_red_R2 = 1;
int _led_green_R2 = 2;
int _led_blue_R2 = 3;
int _input_S3 = 2;
char* _ID1 = "";
int _output_A = 4;
int _mic_S4 = 1;
int _led_G = 8;
HDC1080 _hdc1080_H;
GPS _gps_G2;
int _output_L = 1;
int _potentiometer_P = 3;
int _buzzer_B2 = 1;
int _output_A2 = 5;
int _button_B3 = 2;
int _led_R = 7;
File _dataFile;
BMP280 _bmp280_T;
Ultrasonic _hcsr04_U(1, 2);
VEML6070 _veml_V;
TSL45315 _tsl_V;
Bee* _bee_ = new Bee();
OpenSenseMap _osm("", _bee_);
#define OLED_RESET 4
Adafruit_SSD1306 _display_myDisplay(OLED_RESET);
int _input_S2 = 6;
Plot _plot_myDisplay(&_display_myDisplay);


void action() {
    Serial.println(___numVar);
    Serial.println(___boolVar);
    Serial.println(___stringVar);
    Serial.println(___colourVar);
    _display_myDisplay.setCursor(___numVar, ___numVar);
    _display_myDisplay.setTextSize(1);
    _display_myDisplay.setTextColor(WHITE, BLACK);
    _display_myDisplay.println(___numVar);
    _display_myDisplay.display();
    
    _display_myDisplay.setCursor(___numVar, ___numVar);
    _display_myDisplay.setTextSize(1);
    _display_myDisplay.setTextColor(WHITE, BLACK);
    _display_myDisplay.println(___boolVar);
    _display_myDisplay.display();
    
    _display_myDisplay.setCursor(___numVar, ___numVar);
    _display_myDisplay.setTextSize(1);
    _display_myDisplay.setTextColor(WHITE, BLACK);
    _display_myDisplay.println(___stringVar);
    _display_myDisplay.display();
    
    _display_myDisplay.setCursor(___numVar, ___numVar);
    _display_myDisplay.setTextSize(1);
    _display_myDisplay.setTextColor(WHITE, BLACK);
    _display_myDisplay.println(___colourVar);
    _display_myDisplay.display();
    
    
    
    
    
    _display_myDisplay.clearDisplay();
    tone(_buzzer_B2, ___numVar);
    delay(___numVar);
    noTone(_buzzer_B2);
    digitalWrite(_led_R, HIGH);
    digitalWrite(_led_R, LOW);
    digitalWrite(_led_R, HIGH);
    digitalWrite(_led_R, LOW);
    analogWrite(_led_red_R2, RCHANNEL(___colourVar));
    analogWrite(_led_green_R2, GCHANNEL(___colourVar));
    analogWrite(_led_blue_R2, BCHANNEL(___colourVar));
    
    analogWrite(_led_red_R2, 0);
    analogWrite(_led_green_R2, 0);
    analogWrite(_led_blue_R2, 0);
    
    _osm.uploadMeasurement(___numVar, _ID1);
    
    _dataFile = SD.open("FILE.TXT", FILE_WRITE);
    _dataFile.print(_ID1);
    _dataFile.print(" : ");
    _dataFile.println(___numVar);
    _dataFile.close();
    _plot_myDisplay.clear();
    _plot_myDisplay.drawPlot();
    
    _plot_myDisplay.addDataPoint(___numVar, ___numVar);
    
    digitalWrite(_output_A, ___numVar);
    analogWrite(_output_A2, 1);
}

void setup()
{
    Serial.begin(9600); 
    pinMode(_led_red_R2, OUTPUT);
    pinMode(_led_green_R2, OUTPUT);
    pinMode(_led_blue_R2, OUTPUT);
    pinMode(_input_S3, INPUT);
    pinMode(_output_A, OUTPUT);
    pinMode(_led_G, OUTPUT);
    _hdc1080_H.begin();
    _gps_G2.begin();
    pinMode(_output_A2, OUTPUT);
    pinMode(_button_B3, INPUT);
    pinMode(_led_R, OUTPUT);
    SD.begin(28);
    _dataFile = SD.open("FILE.TXT", FILE_WRITE);
    _dataFile.close();
    _bmp280_T.begin();
    _veml_V.begin();
    _tsl_V.begin();
    _bee_->connectToWifi("null","null");
    delay(1000);
    senseBoxIO.powerI2C(true);
    delay(2000);
    _display_myDisplay.begin(SSD1306_SWITCHCAPVCC, 0x3D);
    _display_myDisplay.display();
    delay(100);
    _display_myDisplay.clearDisplay();
    _plot_myDisplay.setTitle("P");
    _plot_myDisplay.setXLabel("X");
    _plot_myDisplay.setYLabel("Y");
    _plot_myDisplay.setXRange(0, 100);
    _plot_myDisplay.setYRange(0, 50);
    _plot_myDisplay.setXTick(10);
    _plot_myDisplay.setYTick(10);
    _plot_myDisplay.setXPrecision(0);
    _plot_myDisplay.setYPrecision(0);
    _plot_myDisplay.clear();
    pinMode(_input_S2, INPUT);
    ___numVar = 0;
    ___boolVar = true;
    ___stringVar = "";
    ___colourVar = RGB(0xFF, 0xFF, 0xFF);
    ___numList = {0, 0, 0};
    ___boolList = {true, true, true};
    ___stringList = {"", "", ""};
    ___colourList = {RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF)};
}

void loop()
{
    action();
}
