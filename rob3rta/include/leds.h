#ifndef _ROB3RTA_LEDS_H_

#define _ROB3RTA_LEDS_H_
#ifdef __cplusplus
extern "C" {
#endif

#define _BOB3_NEW_COLOR_ 1
    
#ifdef _BOB3_NEW_COLOR_
extern uint8_t _bob3_calib_red;
extern uint8_t _bob3_calib_green;
extern uint8_t _bob3_calib_blue;
#endif

void leds_init();

void leds_set_RGB(uint8_t id, uint8_t r, uint8_t g, uint8_t b);

void leds_set_RGBx(uint8_t id, uint16_t color);

uint16_t leds_get_RGBx(uint8_t id);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
