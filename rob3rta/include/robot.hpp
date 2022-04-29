#ifndef _ROB3RTA_ROBOT_H_
#define _ROB3RTA_ROBOT_H_


#include <avr/io.h>
#include <avr/eeprom.h>
#include <util/delay.h>
#include "utils.h"
#include "clock.h"
#include <stdlib.h>

extern "C++" {

void setup();
void loop();

enum {
    ARM_NONE,
    ARM_TOP,
    ARM_MID_TOP,
    ARM_MID_BOT,
    ARM_BOT
};


enum {
    ARMS_OFF        = 0,
    ARMS_TOUCH      = 1,
    ARMS_DETECTOR   = 2,
    ARMS_MULTITOUCH = 3,
};


enum {
    OFF            = 0x000,
    WHITE          = 0xfff,
    ON             = 0xfff,
    RED            = 0xf00,
    GREEN          = 0x0f0,
    BLUE           = 0x00f,
    YELLOW         = 0xff0,
    CYAN           = 0x0ff,
    FUCHSIA        = 0xf0f,
    
    ORANGE         = 0xf80,
    KABARED        = 0xd42,
    PURPLE         = 0xf08,
    VIOLET         = 0x63a,
    AQUAMARINE     = 0x7fd,
    BROWN          = 0xa33,
    CORAL          = 0xf75,
    CORNFLOWERBLUE = 0x69e,
    STEELBLUE      = 0x48a,
    ROYALBLUE      = 0x46e,
    FORESTGREEN    = 0x282,
    SEAGREEN       = 0x5f9,
    COLERED        = 0x100,
    UNICORN        = 0x609
};


enum {
    ARM_1    = 1,
    ARM_2    = 2,
    EYE_1    = 1,
    EYE_2    = 2,
    EAR_1    = 1, // Rob3rta
    EAR_2    = 2, // Rob3rta
    WHEEL_A  = 3, // Rob3rta
    WHEEL_B  = 4, // Rob3rta
    WHEEL_C  = 5, // Rob3rta
    WHEEL_D  = 6, // Rob3rta
    LED_1    = 1,
    LED_2    = 2,
    LED_3    = 3,
    LED_4    = 4
};



// linker optional:
int16_t _Bob3_receiveMessage(uint8_t carrier, uint16_t timeout);
void _Bob3_transmitMessage(uint8_t carrier, uint8_t code);
extern int16_t _Bob3_lastMessage;


class Robot {
  public:
    static void init();
    static void setLed(uint8_t id, uint16_t color);
    static uint16_t getLed(uint8_t id);
    static inline void setEyes(uint16_t eye1, uint16_t eye2) {setLed(1, eye1); setLed(2, eye2);} // BOB3 compatibility
    static inline void setHeadLeds(uint16_t eye1, uint16_t eye2) {setLed(1, eye1); setLed(2, eye2);} // Rob3rta
    static inline void setWhiteLeds(uint16_t wled1, uint16_t wled2) {setLed(3, wled1); setLed(4, wled2);}
    static inline void setLeds(uint16_t eye1, uint16_t eye2, uint16_t wled1, uint16_t wled2) {setLed(1, eye1); setLed(2, eye2); setLed(3, wled1); setLed(4, wled2);}
    static uint16_t getIRSensor();
    static uint16_t getIRLight();
    static void enableIRSensor(bool enable);
    static uint8_t getArm(uint8_t id); // BOB3 compatibility
    static uint8_t getTouch(uint8_t id); // Rob3rta
    static void enableTouch(uint8_t enable);
    static uint16_t getTemperature();
    static uint16_t getMillivolt();
    static uint8_t getID();
    static inline int16_t receiveMessage(uint8_t carrier, uint16_t timeout) {return _Bob3_receiveMessage(carrier, timeout);}
    static inline void transmitMessage(uint8_t carrier, uint8_t message) {_Bob3_transmitMessage(carrier, message);}
    static inline int16_t receiveMessage(uint16_t timeout) {return _Bob3_receiveMessage(0, timeout);}
    static inline void transmitMessage(uint8_t message) {_Bob3_transmitMessage(0, message);}
    static inline int16_t lastMessage() {return _Bob3_lastMessage;}

    // compatibility:
    static inline int16_t receiveIRCode(uint8_t carrier, uint16_t timeout) {return _Bob3_receiveMessage(carrier, timeout);} // OBSOLETE
    static inline void transmitIRCode(uint8_t carrier, uint8_t message) {_Bob3_transmitMessage(carrier, message);} // OBSOLETE
    static inline int16_t receiveIRCode(uint16_t timeout) {return _Bob3_receiveMessage(0, timeout);} // OBSOLETE
    static inline void transmitIRCode(uint8_t message) {_Bob3_transmitMessage(0, message);} // OBSOLETE
    static inline void enableArms(uint8_t enable) {enableTouch(enable);} // OBSOLETE
    
};



extern Robot bob3;
extern Robot rob3rta; // full static class -> same as bob3

//#ifndef ARDUINO
//inline static 
//void delay(uint16_t ms) {while (ms--) _delay_ms(1);}
//#endif

//inline static 
//void delay32(uint32_t ms) {while (ms--) _delay_ms(1);}

inline static 
void delay(uint32_t ms) {clock_sleep_ms(ms);}


inline static uint16_t rgb(uint8_t r, uint8_t g, uint8_t b) __attribute__((const));

inline static 
uint16_t rgb(uint8_t r, uint8_t g, uint8_t b) {return ((uint16_t)(r&0x0f)<<8)|((g&0x0f)<<4)|(b&0x0f);}

uint16_t mixColor(uint16_t color1, uint16_t color2, uint8_t w1, uint8_t w2) __attribute__((const));

static inline uint16_t mixColor100(uint16_t color1, uint16_t color2, uint16_t w) {w*=41; w/=256; return mixColor(color1, color2, w, 16-(uint8_t)w);}

uint16_t hsv(int16_t h, uint8_t s, uint8_t v) __attribute__((const));

uint16_t hsvx(uint8_t h, uint8_t s, uint8_t v) __attribute__((const));

uint16_t randomNumber(uint16_t lo, uint16_t hi);

uint16_t randomBits(uint8_t zeros, uint8_t ones);

uint32_t random32();


static inline
uint8_t random8() {
    return random32() & 0xff;
}


static inline
uint16_t random16() {
    return random32() & 0xffff;
}

static inline 
void remember(int16_t value) {eeprom_update_word ((uint16_t *)(E2END-1), ~value);}

static inline 
int16_t recall() {return ~eeprom_read_word ((const uint16_t *)(E2END-1));}

static inline 
uint8_t colorcomp_red(uint16_t color) {return (color>>8)&0x0f;}

static inline 
uint8_t colorcomp_green(uint16_t color) {return (color>>4)&0x0f;}

static inline 
uint8_t colorcomp_blue(uint16_t color) {return (color>>0)&0x0f;}


uint16_t colorcomp_hue(uint16_t color) __attribute__((const));

uint8_t colorcomp_sat(uint16_t color) __attribute__((const));

uint8_t colorcomp_val(uint16_t color) __attribute__((const));

} // extern "C++"


// include additional NEPO functions
#if defined(_NEPO_)
#include "nepo-compat.hpp"
#endif


#endif
