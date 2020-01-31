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


HDC1080 _hdc1080_H;
GPS _gps_G2;
File _dataFile;
BMP280 _bmp280_T;
Ultrasonic _hcsr04_U(1, 2);
VEML6070 _veml_V;
TSL45315 _tsl_V;
Bee* _bee_ = new Bee();
OpenSenseMap _osm("", _bee_);
#define OLED_RESET 4
Adafruit_SSD1306 _display_myDisplay(OLED_RESET);
Plot _plot_myDisplay(&_display_myDisplay);


void setup()
{
}

void loop()
{
}
