#!/bin/bash

set -e

BOARD_VARIANT=$1 # nano_33_iot
MMCU=$2 # unused
ARDUINO_VARIANT=$3 # ARDUINO_ARDUINO_NANO33BLE
BUILD_DIR=$4
PROGRAM_NAME=$5
ORA_CC_RSC=$6
ARDUINO_DIR_BOARD_NAME=$7 # robot name
ARDUINO_ARCH=$8 # mbed
PRECOMPILE_DIR=$ORA_CC_RSC/arduino-resources
LIB_INCLUDE_DIR=$PRECOMPILE_DIR/includes
LIB_DIR=$PRECOMPILE_DIR/lib/$ARDUINO_DIR_BOARD_NAME
CORE_FILE=$PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/core.a

CORE_INCLUDES=$PRECOMPILE_DIR/hardware/arduino/$ARDUINO_ARCH/cores/arduino
VARIANTS_INCLUDES=$PRECOMPILE_DIR/hardware/arduino/$ARDUINO_ARCH/variants/ARDUINO_NANO33BLE

rm -f $BUILD_DIR/../target/*

arm-none-eabi-g++ -nostdlib -MMD -DARDUINO=10810 -D$ARDUINO_VARIANT -DARDUINO_ARCH_${ARDUINO_ARCH^^} -DARDUINO_ARCH_NRF52840 \
                  -I$LIB_INCLUDE_DIR \
                  -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH/Wire \
                  -I$LIB_INCLUDE_DIR/RobertaFunctions \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Arduino_APDS9960 \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Arduino_HTS221 \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Arduino_LPS22HB \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Arduino_LSM9DS1 \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Adafruit_BusIO \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Adafruit_GFX_Library \
                  -I$LIB_INCLUDE_DIR/Nano33blesense__Adafruit_SSD1306 \
                  -I$CORE_INCLUDES \
                  -I$VARIANTS_INCLUDES \
                  -iprefix$CORE_INCLUDES \
                  @$VARIANTS_INCLUDES/defines.txt \
                  @$VARIANTS_INCLUDES/cxxflags.txt \
                  @$VARIANTS_INCLUDES/includes.txt \
                  $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

# the libcc_310_* files might not need to be linked, basic programs seem to work without them, but they are linked anyway to not differ from Arduino IDE

arm-none-eabi-g++ -L$LIB_DIR -Wl,--gc-sections -w \
                  -Wl,--as-needed @$VARIANTS_INCLUDES/ldflags.txt \
                  -T$VARIANTS_INCLUDES/linker_script.ld \
                  -Wl,-Map,$BUILD_DIR/$PROGRAM_NAME.map --specs=nano.specs --specs=nosys.specs \
                  -o $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.o \
                  $PRECOMPILE_DIR/core/$ARDUINO_DIR_BOARD_NAME/variant.cpp.o \
                  -Wl,--whole-archive $CORE_FILE \
                  -lora \
                  $VARIANTS_INCLUDES/libs/libmbed.a \
                  $VARIANTS_INCLUDES/libs/libcc_310_core.a \
                  $VARIANTS_INCLUDES/libs/libcc_310_ext.a \
                  $VARIANTS_INCLUDES/libs/libcc_310_trng.a \
                  -Wl,--no-whole-archive \
                  -Wl,--start-group -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys -Wl,--end-group

arm-none-eabi-objcopy -O binary $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/../target/$PROGRAM_NAME.bin

rm $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d

