
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <util/atomic.h>
#include <avr/sleep.h>
//#include <avr/cpufunc.h>

#include "iodefs.h"
#include "leds.h"
#include "clock.h"

#define HALFTIME_VALUE 128

#ifndef _BOB3_CALIB_RED_INIT
# define _BOB3_CALIB_RED_INIT 5
# define _BOB3_CALIB_GREEN_INIT 10
# define _BOB3_CALIB_BLUE_INIT 10
#endif

static uint8_t led_r1;
static uint8_t led_g1;
static uint8_t led_b1;
static uint8_t led_r2;
static uint8_t led_g2;
static uint8_t led_b2;

static uint16_t eye1col;
static uint16_t eye2col;
static uint8_t eye;

void leds_init() {
    
    // setup output bits
    PORTD |= 0x68;
    DDRD  |= 0x68;
    DDRB  |= 0xc6;
    
    // setup timer 0
    TCCR0A = _BV(COM0A1) // Clear OC0A on Compare Match, set OC0A at BOTTOM
            | _BV(COM0B1) // Clear OC0B on Compare Match, set OC0B at BOTTOM
            | _BV(WGM01) | _BV(WGM00); // Fast PWM
    TCCR0B =  _BV(CS01); // CLK/8
    TIMSK0 |= _BV(TOIE0); // enable timer overflow IRQ

    // setup timer 2
    TCCR2A = _BV(COM2B1) // Clear OC2B on Compare Match, set OC2B at BOTTOM
            | _BV(WGM21) | _BV(WGM20); // Fast PWM
    TCCR2B =  _BV(CS21); // CLK/8
    OCR2A = HALFTIME_VALUE; // halftime
    TIMSK2 |= _BV(OCIE2A);
}


ISR(TIMER0_OVF_vect) {
    if (eye) {
        PORTB &= ~_BV(2);
        if ((led_r1&led_g1&led_b1)!=0xff) PORTB |= _BV(1);
        eye = 0;
    } else {
        PORTB &= ~_BV(1);
        if ((led_r2&led_g2&led_b2)!=0xff) PORTB |= _BV(2);
        eye = 1;
    }
    _clock_handle_interrupt_isr();
}


// halftime IRQ:
ISR(TIMER2_COMPA_vect) {
    if (eye) {
        OCR0A = led_r1;
        OCR0B = led_g1;
        OCR2B = led_b1;
    } else {
        OCR0A = led_r2;
        OCR0B = led_g2;
        OCR2B = led_b2;
    }
}

#ifdef _BOB3_NEW_COLOR_
static uint8_t calc200(uint8_t v) {
    switch (v) {
        case 0:  return 0; //2
        case 1:  return 2; //2
        case 2:  return 4; //4
        case 3:  return 8; //4
        case 4:  return 12; //6
        case 5:  return 18; //8
        case 6:  return 26; //9
        case 7:  return 35; //13
        case 8:  return 48; //15
        case 9:  return 63; //17
        case 10: return 80; //18
        case 11: return 98; //20
        case 12: return 118; //24
        case 13: return 142; //28
        case 14: return 170; //30
        case 15: return 200; //
    }
    return 255;
}

// ASSERT: calib<=10, v<=15
static uint8_t calcColor(uint8_t v, uint8_t calib) {
    uint8_t v200 = calc200(v);
    uint8_t v100 = v200>>1;
    uint8_t v50 = v100>>1;
    uint8_t v25 = v50>>1;
    switch(calib) {
        case 1:  return (uint8_t)255-(v25);
        case 2:  return (uint8_t)255-(v50);
        case 3:  return (uint8_t)255-(v100-v25);
        case 4:  return (uint8_t)255-(v100);
        case 5:  return (uint8_t)255-(v100+v25);
        case 6:  return (uint8_t)255-(v100+v50);
        case 7:  return (uint8_t)255-(v200-v25);
        case 8:  return (uint8_t)255-(v200);
        case 9:  return (uint8_t)255-(v200+v25);
        case 10: return (uint8_t)255-(v200+v50);
    }
    return 0;
}

#else

// range: 130
static uint8_t calcR(uint8_t v) {
    switch (v) {
        case 0:  return 255; //1
        case 1:  return 254; //2
        case 2:  return 252; //2
        case 3:  return 250; //3
        case 4:  return 247; //4
        case 5:  return 243; //5
        case 6:  return 238; //6
        case 7:  return 232; //8
        case 8:  return 224; //10
        case 9:  return 214; //11
        case 10: return 203; //12
        case 11: return 191; //13
        case 12: return 178; //15
        case 13: return 163; //18
        case 14: return 145; //20
        case 15: return 125; //
    }
    return 255;
}

// range: 250
static uint8_t calcGB(uint8_t v) {
    switch (v) {
        case 0:  return 255; //2
        case 1:  return 253; //3
        case 2:  return 250; //5
        case 3:  return 245; //5
        case 4:  return 240; //8
        case 5:  return 232; //10
        case 6:  return 222; //11
        case 7:  return 211; //16
        case 8:  return 195; //19
        case 9:  return 176; //21
        case 10: return 155; //23
        case 11: return 132; //25
        case 12: return 107; //29
        case 13: return 78;  //35
        case 14: return 43;  //38
        case 15: return 5;
    }
    return 255;
}


void leds_set_RGB(uint8_t id, uint8_t r, uint8_t g, uint8_t b) {
    if (id==1) {
        eye1col=r;
        eye1col=(eye1col<<8)|(g<<4)|b;
        led_r1=calcR(r);
        led_g1=calcGB(g);
        led_b1=calcGB(b);
    } else if (id==2) {
        eye2col=r;
        eye2col=(eye2col<<8)|(g<<4)|b;
        led_r2=calcR(r);
        led_g2=calcGB(g);
        led_b2=calcGB(b);
    }
}

#endif

void leds_set_RGBx(uint8_t id, uint16_t color) {
#ifdef _BOB3_NEW_COLOR_
    uint8_t r = calcColor((color&0xf00)>>8, _bob3_calib_red);
    uint8_t g = calcColor((color&0x0f0)>>4, _bob3_calib_green);
    uint8_t b = calcColor((color&0x00f)>>0, _bob3_calib_blue);
#else
    uint8_t r = calcR((color&0xf00)>>8);
    uint8_t g = calcGB((color&0x0f0)>>4);
    uint8_t b = calcGB((color&0x00f)>>0);
#endif
    if (id==1) {
        eye1col = color;
        led_r1 = r;
        led_g1 = g;
        led_b1 = b;
    } else if (id==2) {
        eye2col = color;
        led_r2 = r;
        led_g2 = g;
        led_b2 = b;
    }
}

uint16_t leds_get_RGBx(uint8_t id) {
    if (id==1) {
        return eye1col;
    } else if (id==2) {
        return eye2col;
    }
    return 0;
}

