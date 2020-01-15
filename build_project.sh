#!/bin/bash

#standard or mega
BOARD_VARIANT=$1
CORE_INCLUDES=/opt/ora-cc-rsc/RobotArdu/hardware/builtin/arduino/avr/cores/arduino
VARIANTS_INCLUDES=/opt/ora-cc-rsc/RobotArdu/hardware/builtin/arduino/avr/variants/$BOARD_VARIANT
#atmega328p atmega2560
MMCU=$2
#ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA
ARDUINO_VARIANT=$3
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
#uno, nano or mega
ARDUINO_DIR_BOARD_NAME=$7
LIB_INCLUDE_DIR=$ORA_CC_RSC/RobotArdu/release/include
LIB_DIR=$ORA_CC_RSC/RobotArdu/release/lib/$ARDUINO_DIR_BOARD_NAME
CORE_FILE=$ORA_CC_RSC/RobotArdu/release/cores/$ARDUINO_DIR_BOARD_NAME/core.a

avr-g++ -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=$MMCU -DF_CPU=16000000L -DARDUINO=10809 -D$ARDUINO_VARIANT -DARDUINO_ARCH_AVR -I$CORE_INCLUDES -I$VARIANTS_INCLUDES -I$LIB_INCLUDE_DIR $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

avr-gcc -Wall -Wextra -Os -g  -Wl,--gc-sections,--relax -mmcu=$MMCU -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o $CORE_FILE -L$LIB_DIR -lora -lm
avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.eep
avr-objcopy -O ihex -R .eeprom $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.hex

rm $BUILD_DIR/*.eep $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
