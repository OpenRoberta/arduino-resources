
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <util/atomic.h>
#include <avr/sleep.h>
//#include <avr/cpufunc.h>

#include "iodefs.h"
#include "leds.h"
#include "clock.h"
 
#ifdef _BOB3_NEW_COLOR_
uint8_t _bob3_calib_red = 4;
uint8_t _bob3_calib_green = 10;
uint8_t _bob3_calib_blue = 8;
#endif
