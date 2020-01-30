#!/bin/bash

#standard or mega
BOARD_VARIANT=$1
#atmega328p atmega2560
MMCU=$2
#ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA
ARDUINO_VARIANT=$3
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
#uno, nano or mega
ARDUINO_DIR_BOARD_NAME=$7
ARDUINO_ARCH=$8
PRECOMPILE_DIR=$ORA_CC_RSC/arduino-resources
LIB_INCLUDE_DIR=$PRECOMPILE_DIR/includes
LIB_DIR=$PRECOMPILE_DIR/lib/$ARDUINO_DIR_BOARD_NAME
CORE_FILE=$PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/core.a

CORE_INCLUDES=$ORA_CC_RSC/hardware/builtin/arduino/avr/cores/arduino
VARIANTS_INCLUDES=$ORA_CC_RSC/hardware/builtin/arduino/avr/variants/$BOARD_VARIANT

cp $BUILD_DIR/$PROGRAM_NAME.ino $BUILD_DIR/$PROGRAM_NAME.cpp

arm-none-eabi-g++ -mcpu=cortex-m0plus -mthumb -c -g -Os -Wall -Wextra -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -DF_CPU=48000000L -DARDUINO=10809 -DARDUINO_SAMD_MKR1000 -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DUSB_VID=0x04D8 -DUSB_PID=0xEF67 -DUSBCON "-DUSB_MANUFACTURER=\"senseBox\"" "-DUSB_PRODUCT=\"senseBox MCU\"" \
-I$ORA_CC_RSC/hardware/additional/arduino/tools/CMSIS/4.5.0/CMSIS/Include/ \
-I$ORA_CC_RSC/hardware/additional/arduino/tools/CMSIS-Atmel/1.1.0/CMSIS/Device/ATMEL/ \
-I$ORA_CC_RSC/hardware/additional/arduino/hardware/samd/1.6.20/cores/arduino \
-I$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/variants/sensebox_mcu \
-I$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/libraries/SenseBox-MCU \
-I$ORA_CC_RSC/hardware/additional/arduino/hardware/samd/1.6.20/libraries/Wire \
-I$ORA_CC_RSC/hardware/additional/arduino/hardware/samd/1.6.20/libraries/SPI \
-I$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/libraries/TinyGPSPlus/src \
-I$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/libraries/OneWire \
-I$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/libraries/Arduino-Temperature-Control-Library \
-I$ORA_CC_RSC/arduino-resources/includes/WiFi101/src \
-I$ORA_CC_RSC/arduino-resources/includes/senseBoxIO/src \
-I$ORA_CC_RSC/arduino-resources/includes/SenseBoxOTA/src \
-I$ORA_CC_RSC/arduino-resources/includes/SenseBox-MCU \
-I$ORA_CC_RSC/arduino-resources/includes/SD/src \
-I$ORA_CC_RSC/arduino-resources/includes/SPI \
-I$ORA_CC_RSC/arduino-resources/includes/Wire \
-I$ORA_CC_RSC/arduino-resources/includes/RobertaFunctions \
$BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

arm-none-eabi-g++ -L$LIB_DIR -Os -Wl,--gc-sections -save-temps \
-T$ORA_CC_RSC/hardware/additional/sensebox/hardware/samd/1.2.1/variants/sensebox_mcu/linker_scripts/gcc/flash_with_bootloader.ld \
-Wl,-Map,$BUILD_DIR/$PROGRAM_NAME.map --specs=nano.specs --specs=nosys.specs -mcpu=cortex-m0plus -mthumb \
-Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align \
-o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o \
$PRECOMPILE_DIR/core/sensebox/variant.cpp.o \
-Wl,--start-group -L$ORA_CC_RSC/hardware/additional/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/  \
-larm_cortexM0l_math  \
-lora \
-lm  \
$CORE_FILE  \
-Wl,--end-group

arm-none-eabi-objcopy -O binary $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.bin

cp $BUILD_DIR/$PROGRAM_NAME.bin $BUILD_DIR/../target/$PROGRAM_NAME.ino.bin

rm $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
