#!/bin/env bash
# MUST BE INVOKED FROM THE USER PROJECT DIRECTORY A.T.M.

#/home/avinokurov/.arduino15/packages/arduino/tools/avr-gcc/5.4.0-atmel3.6.1-arduino2/bin
GCC_BIN_PATH=$1
#standard or mega
BOARD_VARIANT=$2
#/home/avinokurov/.arduino15/packages/arduino/hardware/avr/1.6.23/cores/arduino
CORE_INCLUDES=$3
#/home/avinokurov/.arduino15/packages/arduino/hardware/avr/1.6.23/variants
VARIANTS_INCLUDES=$4/$BOARD_VARIANT
#atmega328p atmega2560
MMCU=$5
#ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA
ARDUINO_VARIANT=$6
BUILD_DIR=$7
PROGRAM_NAME=$8
#/home/avinokurov/Development/Repositories/ora-cc-rsc
ORA_CC_RSC=$9
LIB_INCLUDE_DIR=$ORA_CC_RSC/gcc-compilation/include
LIB_DIR=$ORA_CC_RSC/gcc-compilation/lib/uno
CORE_FILE=$ORA_CC_RSC/gcc-compilation/cores/uno/core.a

$GCC_BIN_PATH/avr-g++ -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=$MMCU -DF_CPU=16000000L -DARDUINO=10809 -D$ARDUINO_VARIANT -DARDUINO_ARCH_AVR -I$CORE_INCLUDES -I$VARIANTS_INCLUDES -I$LIB_INCLUDE_DIR $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

$GCC_BIN_PATH/avr-gcc -Wall -Wextra -Os -g  -Wl,--gc-sections,--relax -mmcu=$MMCU -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o $CORE_FILE -L$LIB_DIR -lora -lm
$GCC_BIN_PATH/avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.eep
$GCC_BIN_PATH/avr-objcopy -O ihex -R .eeprom $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.hex

rm $BUILD_DIR/*.eep $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
