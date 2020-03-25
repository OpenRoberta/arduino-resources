#!/bin/bash

set -e

BOARD_VARIANT=$1 # standard mega uno2018 sensebox_mcu esp32
MMCU=$2 # atmega328p atmega2560 atmega4809 atmega88
ARDUINO_VARIANT=$3 # ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA2560 ARDUINO_AVR_UNO_WIFI_REV2 ARDUINO_SAMD_MKR1000 ARDUINO_ESP32_DEV
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
ARDUINO_DIR_BOARD_NAME=$7 # robot name
ARDUINO_ARCH=$8 # avr megaavr samd esp32
PRECOMPILE_DIR=$ORA_CC_RSC/arduino-resources
LIB_INCLUDE_DIR=$PRECOMPILE_DIR/includes
LIB_DIR=$PRECOMPILE_DIR/lib/$ARDUINO_DIR_BOARD_NAME
CORE_FILE=$PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/core.a

CORE_INCLUDES=$PRECOMPILE_DIR/hardware/arduino/$ARDUINO_ARCH/cores/arduino
VARIANTS_INCLUDES=$PRECOMPILE_DIR/hardware/arduino/$ARDUINO_ARCH/variants/$BOARD_VARIANT

rm -f $BUILD_DIR/../target/*

avr-g++ -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics \
        -Wno-error=narrowing -MMD -mmcu=$MMCU \
        -DF_CPU=16000000L -DARDUINO=10810 -D$ARDUINO_VARIANT -DARDUINO_ARCH_${ARDUINO_ARCH^^} \
        -I$LIB_INCLUDE_DIR \
        -I$LIB_INCLUDE_DIR/RobertaFunctions \
        -I$LIB_INCLUDE_DIR/Makeblock \
        -I$LIB_INCLUDE_DIR/ArduinoSTL/src/ \
        -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/EEPROM/src \
        -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/HID/src \
        -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/SoftwareSerial/src \
        -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/SPI/src \
        -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Wire/src \
        -I$CORE_INCLUDES \
        -I$VARIANTS_INCLUDES \
        $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

# core needs to be last (after libora) to avoid undefined references when used in conjuction with mbot library
avr-gcc -Wall -Wextra -Os -g -Wl,--gc-sections,--relax -mmcu=$MMCU -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o -L$LIB_DIR -lora -lm $CORE_FILE
avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.eep
avr-objcopy -O ihex -R .eeprom $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/../target/$PROGRAM_NAME.hex

rm $BUILD_DIR/*.eep $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
