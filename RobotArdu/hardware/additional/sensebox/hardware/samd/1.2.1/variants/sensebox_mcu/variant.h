/*
  Copyright (c) 2014-2015 Arduino LLC.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#pragma once

// The definitions here needs a SAMD core >=1.6.10
#define ARDUINO_SAMD_VARIANT_COMPLIANCE 10610

#include <WVariant.h>

// General definitions
// -------------------

// Frequency of the board main oscillator
#define VARIANT_MAINOSC (32768ul)

// Master clock frequency
#define VARIANT_MCK     (48000000ul)

// Pins
// ----

// Number of pins defined in PinDescription array
#define PINS_COUNT           (34u) // 34
#define NUM_DIGITAL_PINS     (32u) // 32
#define NUM_ANALOG_INPUTS    (7u)  // 7
#define NUM_ANALOG_OUTPUTS   (1u)  // 1
#define analogInputToDigitalPin(p)  ((p < 7u) ? (p) : -1)

// Low-level pin register query macros
// -----------------------------------
#define digitalPinToPort(P)      (&(PORT->Group[g_APinDescription[P].ulPort]))
#define digitalPinToBitMask(P)   (1 << g_APinDescription[P].ulPin)
//#define analogInPinToBit(P)    ()
#define portOutputRegister(port) (&(port->OUT.reg))
#define portInputRegister(port)  (&(port->IN.reg))
#define portModeRegister(port)   (&(port->DIR.reg))
#define digitalPinHasPWM(P)      (g_APinDescription[P].ulPWMChannel != NOT_ON_PWM || g_APinDescription[P].ulTCChannel != NOT_ON_TIMER)

/*
 * digitalPinToTimer(..) is AVR-specific and is not defined for SAMD
 * architecture. If you need to check if a pin supports PWM you must
 * use digitalPinHasPWM(..).
 *
 * https://github.com/arduino/Arduino/issues/1833
 */
// #define digitalPinToTimer(P)

// senseBox MCU pins
// -----------------
#define PIN_UART_PWR  (9u)
#define PIN_UART_TX1  (10u)
#define PIN_UART_RX1  (11u)
#define PIN_UART_TX2  (12u)
#define PIN_UART_RX2  (13u)
#define PIN_I2C_PWR   (14u)
#define PIN_XB1_PWR   (22u)
#define PIN_XB1_CS    (23u)
#define PIN_XB1_INT   (24u)
#define PIN_XB1_TX    (25u)
#define PIN_XB1_RX    (26u)
#define PIN_XB2_PWR   (27u)
#define PIN_XB2_CS    (28u)
#define PIN_XB2_INT   (29u)
#define PIN_XB2_TX    (30u)
#define PIN_XB2_RX    (31u)
#define PIN_RED_LED   (7u)
#define PIN_GREEN_LED (8u)
#define PIN_SWITCH    (0u)
#define PIN_IO1       (1u)
#define PIN_IO2       (2u)
#define PIN_IO3       (3u)
#define PIN_IO4       (4u)
#define PIN_IO5       (5u)
#define PIN_IO6       (6u)

// LEDs
// ----
#define PIN_LED     (7u) // D7/PA27 (red)
#define PIN_LED2    (8u) // D8/PA28 (green)
#define LED_BUILTIN PIN_LED
#define LED_BUILTIN2 PIN_LED2

// Analog pins
// -----------
#define PIN_A0   (1u)
#define PIN_A1   (1u)
#define PIN_A2   (2u)
#define PIN_A3   (3u)
#define PIN_A4   (4u)
#define PIN_A5   (5u)
#define PIN_A6   (6u)
#define PIN_DAC0 (6u)

static const uint8_t A0   = PIN_A0;
static const uint8_t A1   = PIN_A1;
static const uint8_t A2   = PIN_A2;
static const uint8_t A3   = PIN_A3;
static const uint8_t A4   = PIN_A4;
static const uint8_t A5   = PIN_A5;
static const uint8_t A6   = PIN_A6;
static const uint8_t DAC0 = PIN_DAC0;
#define ADC_RESOLUTION 12

// SPI Interfaces
// --------------
#define SPI_INTERFACES_COUNT 1

// SPI
#define PIN_SPI_MISO  (21u)
#define PIN_SPI_MOSI  (19u)
#define PIN_SPI_SCK   (20u)
#define PIN_SPI_SS    (23u) // CS XB1
#define PERIPH_SPI    sercom1 // sercom1 or sercom3
#define PAD_SPI_TX    SPI_PAD_0_SCK_1
#define PAD_SPI_RX    SERCOM_RX_PAD_3
static const uint8_t SS   = PIN_SPI_SS;   // SPI Slave SS not used. Set here only for reference.
static const uint8_t MOSI = PIN_SPI_MOSI;
static const uint8_t MISO = PIN_SPI_MISO;
static const uint8_t SCK  = PIN_SPI_SCK;

// Wire Interfaces
// ---------------
#define WIRE_INTERFACES_COUNT 2

// Wire
#define PIN_WIRE_SDA        (15u)
#define PIN_WIRE_SCL        (16u)
#define PERIPH_WIRE         sercom0 // sercom0 or sercom2
#define WIRE_IT_HANDLER     SERCOM0_Handler
static const uint8_t SDA = PIN_WIRE_SDA;
static const uint8_t SCL = PIN_WIRE_SCL;

#define PIN_WIRE1_SDA       (17u) // IMU
#define PIN_WIRE1_SCL       (18u) // IMU
#define PERIPH_WIRE1        sercom2 // sercom2 or sercom4
#define WIRE1_IT_HANDLER    SERCOM2_Handler
static const uint8_t SDA1 = PIN_WIRE1_SDA;
static const uint8_t SCL1 = PIN_WIRE1_SCL;

// USB
// ---
#define PIN_USB_DM          (32u)
#define PIN_USB_DP          (33u)
#define PIN_USB_HOST_ENABLE (-1u)

// Needed for WINC1501B (WiFi101) library
// --------------------------------------
#define WINC1501_RESET_PIN   (-1u) // no reset pin
#define WINC1501_CHIP_EN_PIN (-1u) // no enable pin
#define WINC1501_INTN_PIN    (24u) // 24 = INT XB1, 29 = INT XB2
#define WINC1501_SPI         SPI
#define WINC1501_SPI_CS_PIN  (23u) // 23 = CS XB1, 28 = CS XB2
//#define NO_HW_CHIP_EN        (1) // No Chip Enable Pin

// Needed for SD library
// ---------------------
#define SDCARD_SS_PIN       (28u) // CS XB2

// Serial ports
// ------------
#ifdef __cplusplus
#include "SERCOM.h"
#include "Uart.h"

// Instances of SERCOM
extern SERCOM sercom0;
extern SERCOM sercom1;
extern SERCOM sercom2;
extern SERCOM sercom3;
extern SERCOM sercom4;
extern SERCOM sercom5;

// SERCOM3 oder SERCOM5 Serial1 UART RXTX1
extern Uart Serial1;
#define PIN_SERIAL1_RX (11u)
#define PIN_SERIAL1_TX (10u)
#define PAD_SERIAL1_TX (UART_TX_PAD_0)
#define PAD_SERIAL1_RX (SERCOM_RX_PAD_1)

// SERCOM4 Serial2 UART RXTX2
extern Uart Serial2;
#define PIN_SERIAL2_RX (13u)
#define PIN_SERIAL2_TX (12u)
#define PAD_SERIAL2_TX (UART_TX_PAD_0)
#define PAD_SERIAL2_RX (SERCOM_RX_PAD_1)

// SERCOM5 Serial3 XBEE1
extern Uart Serial3;
#define PIN_SERIAL3_RX (26u)
#define PIN_SERIAL3_TX (25u)
#define PAD_SERIAL3_TX (UART_TX_PAD_2)
#define PAD_SERIAL3_RX (SERCOM_RX_PAD_3)

// SERCOM0 oder SERCOM2 Serial4 XBEE2
/*
extern Uart Serial4;
#define PIN_SERIAL4_RX (31u)
#define PIN_SERIAL4_TX (30u)
#define PAD_SERIAL4_TX (UART_TX_PAD_2)
#define PAD_SERIAL4_RX (SERCOM_RX_PAD_3)
*/



#endif // __cplusplus

// These serial port names are intended to allow libraries and architecture-neutral
// sketches to automatically default to the correct port name for a particular type
// of use.  For example, a GPS module would normally connect to SERIAL_PORT_HARDWARE_OPEN,
// the first hardware serial port whose RX/TX pins are not dedicated to another use.
//
// SERIAL_PORT_MONITOR        Port which normally prints to the Arduino Serial Monitor
//
// SERIAL_PORT_USBVIRTUAL     Port which is USB virtual serial
//
// SERIAL_PORT_LINUXBRIDGE    Port which connects to a Linux system via Bridge library
//
// SERIAL_PORT_HARDWARE       Hardware serial port, physical RX & TX pins.
//
// SERIAL_PORT_HARDWARE_OPEN  Hardware serial ports which are open for use.  Their RX & TX
//                            pins are NOT connected to anything by default.
#define SERIAL_PORT_USBVIRTUAL      SerialUSB
#define SERIAL_PORT_MONITOR         SerialUSB
#define SERIAL_PORT_HARDWARE        Serial1
#define SERIAL_PORT_HARDWARE_OPEN   Serial1

// Alias Serial to SerialUSB
#define Serial                      SerialUSB
