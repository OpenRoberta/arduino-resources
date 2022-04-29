#ifndef _NEPO_COMPAT_H_
#define _NEPO_COMPAT_H_

#ifndef _NEPO_
#error "this include file is only for NEPO compatibility!"
#endif

#include "utils.h"
#include "clock.h"
#include "iodefs.h"
#include "analog.h"
#include "leds.h"
#include "robot.hpp"
#include "utils.h"
#include "ircom.h"

#ifndef M_GOLDEN_RATIO
#define M_GOLDEN_RATIO 1.61803398875
#endif

#ifndef M_INFINITY
#define M_INFINITY 0x7f800000
#endif

#ifndef _CLAMP
#define _CLAMP(x, lower, upper) constrain(x, lower, upper)
#endif

extern "C++" {


inline static
unsigned RGB(unsigned r, unsigned g, unsigned b) { return rgb(r,g,b); }

// dummy, TIMER0 and TIMER1 are already in use by library, clock functions are automatically called in bottom half of timer0 IRQ....
inline static
void timer_init() {}

inline static
unsigned long millis(void) { return clock_get_sys_ms(); }


} // extern "C++"

#endif
