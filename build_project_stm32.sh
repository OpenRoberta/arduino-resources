#!/bin/bash

set -e

BOARD_VARIANT=$1 # standard mega uno2018 sensebox_mcu esp32 NUCLEO_F4x1RE
MMCU=$2 # unused
ARDUINO_VARIANT=$3 # ARDUINO_AVR_UNO ARDUINO_AVR_NANO ARDUINO_AVR_MEGA2560 ARDUINO_AVR_UNO_WIFI_REV2 ARDUINO_SAMD_MKR1000 ARDUINO_ESP32_DEV ARDUINO_NUCLEO_F401RE
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
ARDUINO_DIR_BOARD_NAME=$7 # robot name
ARDUINO_ARCH=$8 # avr megaavr samd esp32 stm32
PRECOMPILE_DIR=$ORA_CC_RSC/arduino-resources
LIB_INCLUDE_DIR=$PRECOMPILE_DIR/includes
LIB_DIR=$PRECOMPILE_DIR/lib/$ARDUINO_DIR_BOARD_NAME
CORE_FILE=$PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/core.a

CORE_INCLUDES=$PRECOMPILE_DIR/hardware/$ARDUINO_ARCH/$ARDUINO_ARCH/cores/arduino
VARIANTS_INCLUDES=$PRECOMPILE_DIR/hardware/$ARDUINO_ARCH/$ARDUINO_ARCH/variants/$BOARD_VARIANT
SYSTEM_INCLUDE_DIR=$PRECOMPILE_DIR/hardware/$ARDUINO_ARCH/$ARDUINO_ARCH/system/

rm -f $BUILD_DIR/../target/*

arm-none-eabi-g++ -c -g -Os -Wall -Wextra -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics -fno-rtti -fno-exceptions -fno-use-cxa-atexit \
                  -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -nostdlib --param max-inline-insns-single=500 -MMD \
                  -DARDUINO=10810 \
                  -D$ARDUINO_VARIANT -DARDUINO_ARCH_${ARDUINO_ARCH^^} -DSTM32F4xx -DBOARD_NAME=NUCLEO_F401RE -DSTM32F401xE -DHAL_UART_MODULE_ENABLED \
                  -I$LIB_INCLUDE_DIR \
                  -I$LIB_INCLUDE_DIR/RobertaFunctions \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Wire/src \
                  -I$CORE_INCLUDES \
                  -I$CORE_INCLUDES/stm32 \
                  -I$CORE_INCLUDES/stm32/LL \
                  -I$VARIANTS_INCLUDES \
                  -I$SYSTEM_INCLUDE_DIR/Drivers/CMSIS/Device/ST/STM32F4xx/Include \
                  -I$SYSTEM_INCLUDE_DIR/Drivers/STM32F4xx_HAL_Driver/Inc \
                  -I$SYSTEM_INCLUDE_DIR/STM32F4xx \
                  -I$PRECOMPILE_DIR/hardware/arduino/tools/CMSIS/4.5.0/CMSIS/Include \
                  $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

arm-none-eabi-g++ -L$LIB_DIR -Os -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb --specs=nano.specs \
                  -Wl,--defsym=LD_FLASH_OFFSET=0 -Wl,--defsym=LD_MAX_SIZE=524288 -Wl,--defsym=LD_MAX_DATA_SIZE=98304 \
                  -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common \
                  -Wl,--default-script=$VARIANTS_INCLUDES/ldscript.ld \
                  -Wl,--script=$SYSTEM_INCLUDE_DIR/ldscript.ld \
                  -Wl,-Map,$BUILD_DIR/$PROGRAM_NAME.map \
                  -L$PRECOMPILE_DIR/hardware/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/ \
                  -larm_cortexM4lf_math \
                  -o $BUILD_DIR/$PROGRAM_NAME.elf \
                  -Wl,--start-group $BUILD_DIR/$PROGRAM_NAME.o \
                  -lora \
                  $PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/variant.cpp.o \
                  $PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/PeripheralPins.c.o \
                  $PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/syscalls.c.o \
                  $CORE_FILE \
                  -lc \
                  -Wl,--end-group\
                  -lm -lgcc -lstdc++

arm-none-eabi-objcopy -O binary $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/../target/$PROGRAM_NAME.bin

rm $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
