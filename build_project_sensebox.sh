#!/bin/bash

set -e

BOARD_VARIANT=$1 # standard mega uno2018 sensebox_mcu esp32
MMCU=$2 # unused
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
VARIANTS_INCLUDES=$PRECOMPILE_DIR/hardware/sensebox/$ARDUINO_ARCH/variants/$BOARD_VARIANT

rm -f $BUILD_DIR/../target/*

arm-none-eabi-g++ -c -g -Os -Wall -Wextra -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics -fno-rtti -fno-exceptions \
                  -mcpu=cortex-m0plus -mthumb -nostdlib --param max-inline-insns-single=500 -MMD \
                  -DF_CPU=48000000L -DARDUINO=10810 -D$ARDUINO_VARIANT -DARDUINO_ARCH_${ARDUINO_ARCH^^} -D__SAMD21G18A__ \
                  -DUSB_VID=0x04D8 -DUSB_PID=0xEF67 -DUSBCON "-DUSB_MANUFACTURER=\"senseBox\"" "-DUSB_PRODUCT=\"senseBox MCU\"" \
                  -I$LIB_INCLUDE_DIR \
                  -I$LIB_INCLUDE_DIR/RobertaFunctions \
                  -I$LIB_INCLUDE_DIR/SD/src \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Adafruit-GFX-Library \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Adafruit_SSD1306 \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Arduino-Temperature-Control-Library \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/OneWire \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/SenseBox-MCU \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/senseBoxIO/src \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/SPI \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/SSD1306-Plot-Library \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/TinyGPSPlus/src \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/WiFi101/src \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Wire \
                  -I$LIB_INCLUDE_DIR/BSEC_Software_Library/src \
                  -I$CORE_INCLUDES \
                  -I$VARIANTS_INCLUDES \
                  -I$PRECOMPILE_DIR/hardware/arduino/tools/CMSIS/4.5.0/CMSIS/Include/ \
                  -I$PRECOMPILE_DIR/hardware/arduino/tools/CMSIS-Atmel/1.2.0/CMSIS/Device/ATMEL/ \
                  $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

arm-none-eabi-g++ -L$LIB_DIR -Os -Wl,--gc-sections -save-temps \
                  -T$PRECOMPILE_DIR/hardware/sensebox/$ARDUINO_ARCH/variants/$BOARD_VARIANT/linker_scripts/gcc/flash_with_bootloader.ld \
                  -Wl,-Map,$BUILD_DIR/$PROGRAM_NAME.map --specs=nano.specs --specs=nosys.specs -mcpu=cortex-m0plus -mthumb \
                  -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align \
                  -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o \
                  $PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/variant.cpp.o \
                  -Wl,--start-group -L$PRECOMPILE_DIR/hardware/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/  \
                  -larm_cortexM0l_math  \
                  -lora \
                  -lm  \
                  -L$LIB_INCLUDE_DIR/BSEC_Software_Library/src/cortex-m0plus -lalgobsec \
                  $CORE_FILE  \
                  -Wl,--end-group

arm-none-eabi-objcopy -O binary $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/../target/$PROGRAM_NAME.bin

rm $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
