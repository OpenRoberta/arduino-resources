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

arm-none-eabi-g++ -mcpu=cortex-m0plus -mthumb -c -g -Os -Wall -Wextra -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -DF_CPU=48000000L -DARDUINO=10809 -DARDUINO_SAMD_MKR1000 -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DUSB_VID=0x04D8 -DUSB_PID=0xEF67 -DUSBCON "-DUSB_MANUFACTURER=\"senseBox\"" "-DUSB_PRODUCT=\"senseBox MCU\"" \
-I$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/CMSIS/4.5.0/CMSIS/Include/ \
-I$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/CMSIS-Atmel/1.1.0/CMSIS/Device/ATMEL/ \
-I$ARDUINO_PACKAGES/arduino/hardware/samd/1.6.20/cores/arduino \
-I$ARDUINO_PACKAGES/sensebox/hardware/samd/1.2.1/variants/sensebox_mcu \
-I$ARDUINO_PACKAGES/sensebox/hardware/samd/1.2.1/libraries/SenseBox-MCU \
-I$ARDUINO_PACKAGES/arduino/hardware/samd/1.6.20/libraries/Wire \
-I$ARDUINO_PACKAGES/arduino/hardware/samd/1.6.20/libraries/SPI \
-I/home/Arduino/libraries/WiFi101/src \
-I$ARDUINO_PACKAGES/sensebox/hardware/samd/1.2.1/libraries/TinyGPSPlus/src \
-I$ARDUINO_PACKAGES/sensebox/hardware/samd/1.2.1/libraries/OneWire \
-I$ARDUINO_PACKAGES/sensebox/hardware/samd/1.2.1/libraries/Arduino-Temperature-Control-Library \
/tmp/arduino_build_992861/sketch/packing.ino.cpp -o /tmp/arduino_build_992861/sketch/packing.ino.cpp.o


arm-none-eabi-g++ -L/tmp/arduino_build_992861 -Os -Wl,--gc-sections -save-temps -T/home/.arduino15/packages/sensebox/hardware/samd/1.2.1/variants/sensebox_mcu/linker_scripts/gcc/flash_with_bootloader.ld -Wl,-Map,/tmp/arduino_build_992861/packing.ino.map --specs=nano.specs --specs=nosys.specs -mcpu=cortex-m0plus -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -o /tmp/arduino_build_992861/packing.ino.elf /tmp/arduino_build_992861/sketch/packing.ino.cpp.o \ 
$LIB_OBJECTS_DIR/SenseBox-MCU/SenseBoxMCU.cpp.o \ 
$LIB_OBJECTS_DIR/Wire/Wire.cpp.o \ 
$LIB_OBJECTS_DIR/SPI/SPI.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFi.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFiClient.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFiMDNSResponder.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFiSSLClient.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFiServer.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/WiFiUdp.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/bsp/source/nm_bsp_arduino.c.o  \
$LIB_OBJECTS_DIR/WiFi101/bsp/source/nm_bsp_arduino_avr.c.o  \
$LIB_OBJECTS_DIR/WiFi101/bus_wrapper/source/nm_bus_wrapper_samd21.cpp.o \ 
$LIB_OBJECTS_DIR/WiFi101/common/source/nm_common.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_ate_mode.c.o \ 
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_crypto.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_hif.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_ota.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_periph.c.o \ 
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_ssl.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/m2m_wifi.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmasic.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmbus.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmdrv.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmi2c.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmspi.c.o  \
$LIB_OBJECTS_DIR/WiFi101/driver/source/nmuart.c.o  \
$LIB_OBJECTS_DIR/WiFi101/socket/source/socket.c.o  \
$LIB_OBJECTS_DIR/WiFi101/socket/source/socket_buffer.c.o  \
$LIB_OBJECTS_DIR/WiFi101/spi_flash/source/spi_flash.c.o  \
$LIB_OBJECTS_DIR/WiFi101/utility/WiFiSocket.cpp.o  \
$LIB_OBJECTS_DIR/TinyGPSPlus/TinyGPS++.cpp.o  \
$LIB_OBJECTS_DIR/OneWire/OneWire.cpp.o  \
$LIB_OBJECTS_DIR/Arduino-Temperature-Control-Library/DallasTemperature.cpp.o  \
/tmp/arduino_build_992861/core/variant.cpp.o  \
-Wl,--start-group -L/home/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/  \
-larm_cortexM0l_math  \
-lm  \
$CORE_FILE  \
-Wl,--end-group

arm-none-eabi-objcopy -O binary $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.bin
arm-none-eabi-objcopy -O ihex -R .eeprom $BUILD_DIR/$PROGRAM_NAME.elf $BUILD_DIR/$PROGRAM_NAME.hex

cp $BUILD_DIR/$PROGRAM_NAME.hex $BUILD_DIR/../target/$PROGRAM_NAME.ino.hex

rm $BUILD_DIR/*.eep $BUILD_DIR/*.elf $BUILD_DIR/*.o $BUILD_DIR/*.d
