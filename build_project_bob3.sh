#!/bin/bash

set -e

BOARD_VARIANT=$1 # standard mega uno2018 sensebox_mcu esp32
MMCU=$2 # atmega328p atmega2560 atmega4809 atmega88
ARDUINO_VARIANT=$3 # ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA2560 ARDUINO_AVR_UNO_WIFI_REV2 ARDUINO_SAMD_MKR1000 ARDUINO_ESP32_DEV
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
ARDUINO_DIR_BOARD_NAME=$7 # robot name
ARDUINO_ARCH=$8 # unused
PRECOMPILE_DIR=$ORA_CC_RSC/arduino-resources
LIB_INCLUDE_DIR=$PRECOMPILE_DIR/includes
LIB_DIR=$PRECOMPILE_DIR/lib/$ARDUINO_DIR_BOARD_NAME

rm -f $BUILD_DIR/../target/*

avr-gcc -c -g -Os -Wall -Wextra -fno-exceptions -fdata-sections -fno-threadsafe-statics -ffunction-sections -finput-charset=UTF-8 \
        -Wpointer-arith -Wcast-qual -Wmissing-include-dirs -Wno-unused-parameter -Wuninitialized -MMD -mmcu=$MMCU \
        -DF_CPU=8000000 -D_BOB3_ -DAVR \
        -I$LIB_INCLUDE_DIR/bob3 \
        $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

avr-gcc -Os -L$LIB_DIR -mmcu=$MMCU -Wl,--gc-sections -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o  -lora
avr-objcopy -j .text -j .data -O ihex $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/../target/$PROGRAM_NAME.hex

rm $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
