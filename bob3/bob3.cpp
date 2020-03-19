
#include "iodefs.h"
#include "analog.h"
#include "leds.h"
#include "bob3.h"
#include "utils.h"
#include "ircom.h"
#include <stdlib.h>
#include <avr/io.h>
#include <avr/boot.h>

#ifndef SIGRD
#define SIGRD 5
#endif

Bob3 bob3;

uint8_t _bob3_revision;
extern uint8_t _bob3_edition;
#define BOB3_EDITION_THT 0
#define BOB3_EDITION_SMD 1

uint8_t _arm_mode;

void Bob3::init() {
  if (_bob3_edition==BOB3_EDITION_THT)  {
    uint8_t sig2 = boot_signature_byte_get(4);
    if (sig2==0x0a) _bob3_revision = 102;  // V1.02
    if (sig2==0x0f) _bob3_revision = 103;  // V1.03
  } else {
    _bob3_revision = 103; // like THT V1.03
  }
  leds_init();
  timer_init();
  analog_init();
  leds_set_RGBx(1, OFF);
  leds_set_RGBx(2, OFF);
  _arm_mode = 1;
}

void Bob3::setLed(uint8_t id, uint16_t color) {
  switch (id) {
    case 1:
    case 2:
      leds_set_RGBx(id, color);
      break;
    case 3:
      set_output_bitval(IO_LED_1, color);
      break;
    case 4:
      set_output_bitval(IO_LED_2, color);
      break;
  }
}


uint16_t Bob3::getLed(uint8_t id) {
  if (id<=2) {
    return leds_get_RGBx(id);
  } else if (id==3) {
    return get_output_bit(IO_LED_1)?ON:OFF;
  } else if (id==4) {
    return get_output_bit(IO_LED_2)?ON:OFF;
  }
  return 0;
}



uint16_t Bob3::getIRSensor() {
  return analog_getValueExt(ANALOG_IR, 2);
}


uint16_t Bob3::getIRLight() {
  return analog_getValueExt(ANALOG_IR, 0);
}


void Bob3::enableIRSensor(bool enable) {
  
}


uint8_t Bob3::getArm(uint8_t id) {
  if (_arm_mode==ARMS_DETECTOR) {
    uint16_t v0;
    if (id==1) {
      v0 = analog_getValueExt(ANALOG_L0, 0);
    } else if (id==2) {
      v0 = analog_getValueExt(ANALOG_R0, 0);
    } else {
      return 0;
    }
    // 4095 = maxval
    // ca. 1100 = untouched
    // 0 = touched
    v0 /= 4; // better range...

    // 0: untouched
    // 255: touched max
    if (v0>255) return 0;
    return 255-v0;
    
  } else {
    uint8_t v0, v1, v2, v3;
    if (id==1) {
      v0 = analog_getValueExt(ANALOG_L0, 0);
      v1 = analog_getValueExt(ANALOG_L1, 0);
      v2 = analog_getValueExt(ANALOG_L2, 0);
      v3 = analog_getValueExt(ANALOG_L3, 0);
    } else if (id==2) {
      v0 = analog_getValueExt(ANALOG_R0, 0);
      v1 = analog_getValueExt(ANALOG_R1, 0);
      v2 = analog_getValueExt(ANALOG_R2, 0);
      v3 = analog_getValueExt(ANALOG_R3, 0);
    } else {
      return 0;
    }
  
    if (v0&0x01) return 1;
    if (v1&0x01) return 2;
    if (v2&0x01) return 2;
    if (v3&0x01) return 3;
    return 0;
  }
}


void Bob3::enableArms(uint8_t enable) {
  _arm_mode = enable;
}


uint16_t Bob3::getTemperature() {
  return analog_getValueExt(ANALOG_TEMP, 0)/4;
}


uint16_t Bob3::getMillivolt() {
  // ADC_BANDGAP_CHANNEL_VOLTAGE must be below 1.28 V!!!
  uint16_t voltage = analog_getValueExt(ANALOG_VOLT, 0);
  voltage = ((uint16_t)(50*ADC_BANDGAP_CHANNEL_VOLTAGE*1024))/voltage;
  voltage *= 20;
  return voltage;
}


uint8_t Bob3::getID() {
  uint8_t id=0;
  deactivate_output_bit(IO_ID_0);
  deactivate_output_bit(IO_ID_1);
  deactivate_output_bit(IO_ID_2);
  deactivate_output_bit(IO_ID_3);
  deactivate_output_bit(IO_ID_4);
  set_output_bit(IO_ID_0);
  set_output_bit(IO_ID_1);
  set_output_bit(IO_ID_2);
  set_output_bit(IO_ID_3);
  set_output_bit(IO_ID_4);
  id += get_input_bit(IO_ID_0)?0:1;
  id += get_input_bit(IO_ID_1)?0:2;
  id += get_input_bit(IO_ID_2)?0:4;
  id += get_input_bit(IO_ID_3)?0:8;
  id += get_input_bit(IO_ID_4)?0:16;
  clear_output_bit(IO_ID_0);
  clear_output_bit(IO_ID_1);
  clear_output_bit(IO_ID_2);
  clear_output_bit(IO_ID_3);
  clear_output_bit(IO_ID_4);  
  return id;
}


int16_t _Bob3_receiveMessage(uint8_t carrier, uint16_t timeout) {
  int16_t code;
  uint8_t an_bak = analog_enable(false);
  code = ircom_receive(carrier, timeout);  
  analog_enable(an_bak);
  return code;
}


void _Bob3_transmitMessage(uint8_t carrier, uint8_t code) {
  uint8_t an_bak = analog_enable(false);
  ircom_transmit(carrier, code);
  analog_enable(an_bak);
}


static uint16_t mixColor16(uint16_t color1, uint16_t color2, uint8_t w1, uint8_t w2) {
  uint8_t r = (((uint8_t(color1>>8))&0x0f)*w1 + ((uint8_t(color2>>8))&0x0f)*w2)/16;
  uint8_t g = (((uint8_t(color1>>4))&0x0f)*w1 + ((uint8_t(color2>>4))&0x0f)*w2)/16;
  uint8_t b = (((uint8_t(color1>>0))&0x0f)*w1 + ((uint8_t(color2>>0))&0x0f)*w2)/16;
  return rgb(r, g, b);
}


uint16_t mixColor(uint16_t color1, uint16_t color2, uint8_t w1, uint8_t w2) {
  if (w1==0) return color2;
  if (w2==0) return color1;
  uint8_t sum=w1+w2;
  if (sum==16) return mixColor16(color1, color2, w1, w2);
  uint8_t r = (((color1>>8)&0x0f)*w1 + ((color2>>8)&0x0f)*w2)/sum;
  uint8_t g = (((color1>>4)&0x0f)*w1 + ((color2>>4)&0x0f)*w2)/sum;
  uint8_t b = (((color1>>0)&0x0f)*w1 + ((color2>>0)&0x0f)*w2)/sum;
  return rgb(r, g, b);  
}



uint16_t hsvx(uint8_t h, uint8_t _s, uint8_t _v) { 
  if (_s == 0) {
    _v >>= 4;
    return rgb(_v,_v,_v);
  }  
  
  uint16_t v = _v;
  uint16_t s = _s;
  uint8_t seg, delta;

  if      (h>=213) { seg=5; delta = 6*(h-213); }
  else if (h>=170) { seg=4; delta = 6*(h-170); } 
  else if (h>=128) { seg=3; delta = 6*(h-128); }
  else if (h>=85)  { seg=2; delta = 6*(h-85); }
  else if (h>=42)  { seg=1; delta = 6*(h-42); }
  else             { seg=0; delta = 6*(h-0); }

  uint8_t p = (v * (255 - s)) >> 12;
  uint8_t q = (v * (255 - ((s * delta) >> 8))) >> 12;
  uint8_t t = (v * (255 - ((s * (255 - delta)) >> 8))) >> 12;
 
  v >>= 4;
  
  switch (seg) {
    case 0: return rgb(v, t, p);
    case 1: return rgb(q, v, p);
    case 2: return rgb(p, v, t);
    case 3: return rgb(p, q, v);
    case 4: return rgb(t, p, v);
    case 5: return rgb(v, p, q);
  }
  return 0;
}


uint16_t hsv(int16_t _h, uint8_t _s, uint8_t _v) { 
  // _h: [0..359] degree (tolarant)
  // _s: [0..100] percent
  // _v: [0..100] percent
  
  if (_s == 0) {
    _v = 2*_v + _v/2; // Range: [0...250]
    _v >>= 4;
    return rgb(_v,_v,_v);
  }  
  
  uint16_t v = 2*_v + _v/2; // Range: [0...250]
  uint16_t s = 2*_s + _s/2; // Range: [0...250]
  uint8_t seg, delta;

  while (_h<0) _h += 360;
  while (_h>=360) _h -= 360;
  
  if      (_h>=300) { seg=5; delta = _h-300; }
  else if (_h>=240) { seg=4; delta = _h-240; } 
  else if (_h>=180) { seg=3; delta = _h-180; }
  else if (_h>=120) { seg=2; delta = _h-120; }
  else if (_h>=60)  { seg=1; delta = _h-60; }
  else              { seg=0; delta = _h-0; }
  
  delta = 4*delta + delta/4; // Range: [0...250]

  uint8_t p = (v * (255 - s)) >> 12;
  uint8_t q = (v * (255 - ((s * delta) >> 8))) >> 12;
  uint8_t t = (v * (255 - ((s * (255 - delta)) >> 8))) >> 12;
 
  v >>= 4;
  
  switch (seg) {
    case 0: return rgb(v, t, p);
    case 1: return rgb(q, v, p);
    case 2: return rgb(p, v, t);
    case 3: return rgb(p, q, v);
    case 4: return rgb(t, p, v);
    case 5: return rgb(v, p, q);
  }
  return 0;
}



uint32_t random32() {
  static unsigned long ctx = 1;
  ctx += analog_getRandomSeed();
  return random_r(&ctx);
}


uint16_t randomNumber(uint16_t lo, uint16_t hi) {
  uint16_t x = random16();
  if ((lo==0x0000) && (hi==0xffff)) return x;
  if (hi<lo) return 0;
  uint16_t range = hi-lo+1;
  x = x%range;
  return x+lo;
}


uint16_t randomBits(uint8_t zeros, uint8_t ones) {
  uint16_t val = 0;
  uint8_t rounds = zeros+ones;
  while (rounds--) {
    val<<=1;
    if (randomNumber(0, rounds) < ones) {
      ones--;
      val |= 0x01;
    }
  }
  return val;
}

// for the millis() implementation, taken from leds.c and the Arduino Core
// as BOB3 uses TIMER0 for LEDs TIMER1 is used instead

void timer_init() {
  TCCR0A = _BV(COM1A1) // Clear OC0A on Compare Match, set OC0A at BOTTOM
         | _BV(COM1B1) // Clear OC0B on Compare Match, set OC0B at BOTTOM
         | _BV(WGM11) | _BV(WGM10); // Fast PWM
  TCCR1B = _BV(CS11); // CLK/8
  TIMSK1 = _BV(TOIE1); // enable timer overflow IRQ
}

#define clockCyclesPerMicrosecond() ( F_CPU / 1000000L )
#define clockCyclesToMicroseconds(a) ( (a) / clockCyclesPerMicrosecond() )

// the prescaler is set so that timer1 ticks every 8 clock cycles, and the
// the overflow handler is called every 65536 ticks.
#define MICROSECONDS_PER_TIMER1_OVERFLOW (clockCyclesToMicroseconds(8 * 65536))

// the whole number of milliseconds per timer1 overflow
#define MILLIS_INC (MICROSECONDS_PER_TIMER1_OVERFLOW / 1000)

// the fractional number of milliseconds per timer1 overflow. we shift right
// by three to fit these numbers into a byte. (for the clock speeds we care
// about - 8 and 16 MHz - this doesn't lose precision.)
#define FRACT_INC ((MICROSECONDS_PER_TIMER1_OVERFLOW % 1000) >> 3)
#define FRACT_MAX (1000 >> 3)

volatile unsigned long timer1_millis = 0;
static unsigned char timer1_fract = 0;

ISR(TIMER1_OVF_vect) {
  // copy these to local variables so they can be stored in registers
  // (volatile variables must be read from memory on every access)
  unsigned long m = timer1_millis;
  unsigned char f = timer1_fract;

  m += MILLIS_INC;
  f += FRACT_INC;
  if (f >= FRACT_MAX) {
    f -= FRACT_MAX;
    m += 1;
  }

  timer1_fract = f;
  timer1_millis = m;
}

unsigned long millis() {
  unsigned long m;
  uint8_t oldSREG = SREG;

  // disable interrupts while we read timer1_millis or we might get an
  // inconsistent value (e.g. in the middle of a write to timer1_millis)
  cli();
  m = timer1_millis;
  SREG = oldSREG;

  return m;
}
