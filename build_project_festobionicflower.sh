#!/bin/bash

# don't show outputs
set -e

#show all outpus
#set -x

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

CORE_INCLUDES=$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/cores/esp32
VARIANTS_INCLUDES=$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/variants/$BOARD_VARIANT

#parameters of shellscript
#echo  1: $1
#echo  2: $2
#echo  3: $3
#echo  4: $4
#echo  5: $5
#echo  6: $6
#echo  7: $7
#echo  8: $8

#replace backslashes for remove command
RMBUILD_DIR=$(echo -e $BUILD_DIR | sed 's/\\/\//g')
rm -f $RMBUILD_DIR../target/*.*

xtensa-esp32-elf-g++ -c -g3 -Os -Wall -Wextra -std=gnu++11 -fexceptions -ffunction-sections -fdata-sections -fstack-protector -fstrict-volatile-bitfields -fno-rtti \
                     -Wno-error=maybe-uninitialized -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable \
                     -Wno-error=deprecated-declarations -Wno-unused-parameter -Wno-unused-but-set-parameter -Wno-missing-field-initializers -Wno-sign-compare \
                     -MMD -mlongcalls -nostdlib \
                     -DF_CPU=240000000L -DARDUINO=10810 -D$ARDUINO_VARIANT -DARDUINO_ARCH_${ARDUINO_ARCH^^} \
                     -DESP_PLATFORM "-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"" -DHAVE_CONFIG_H -DGCC_NOT_5_2_0=0 -DWITH_POSIX \
                     "-DARDUINO_BOARD=\"ESP32_DEV\"" "-DARDUINO_VARIANT=\"esp32\"" -DESP32 -DCORE_DEBUG_LEVEL=0 \
                     -I$LIB_INCLUDE_DIR \
                     -I$LIB_INCLUDE_DIR/RobertaFunctions \
                     -I$LIB_INCLUDE_DIR/Adafruit_BusIO \
                     -I$LIB_INCLUDE_DIR/Adafruit_SSD1306 \
                     -I$LIB_INCLUDE_DIR/Adafruit_GFX_Library \
                     -I$LIB_INCLUDE_DIR/Adafruit_NeoPixel \
                     -I$LIB_INCLUDE_DIR/StepperDriver/src \
                     -I$LIB_INCLUDE_DIR/RPR-0521RS \
                     -I$LIB_INCLUDE_DIR/SparkFun_CAP1203_Arduino_Library/src \
                     -I$LIB_INCLUDE_DIR/esp32/Wire/src \
                     -I$LIB_INCLUDE_DIR/$ARDUINO_ARCH \
                     -I$CORE_INCLUDES \
                     -I$VARIANTS_INCLUDES \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/freertos \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/config \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/esp32 \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/soc \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/heap \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/driver \
                     -I$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/include/log \
                     $BUILD_DIR/$PROGRAM_NAME.cpp -o $BUILD_DIR/$PROGRAM_NAME.o

xtensa-esp32-elf-g++ -nostdlib -L$LIB_DIR -L$PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/sdk/ld \
                     -T esp32_out.ld -T esp32.common.ld -T esp32.rom.ld -T esp32.peripherals.ld -T esp32.rom.libgcc.ld -T esp32.rom.spiram_incompatible_fns.ld \
                     -u ld_include_panic_highint_hdl -u call_user_start_cpu0 \
                     -Wl,--gc-sections -Wl,-static -Wl,--undefined=uxTopUsedPriority -u __cxa_guard_dummy -u __cxx_fatal_exception \
                     -Wl,--start-group $BUILD_DIR/$PROGRAM_NAME.o $CORE_FILE \
                     -lora \
                     -lgcc -lesp32 -lphy -lesp_http_client -lmbedtls -lrtc -lesp_http_server -lbtdm_app -lspiffs -lbootloader_support -lmdns \
                     -lnvs_flash -lfatfs -lpp -lnet80211 -ljsmn -lface_detection -llibsodium -lvfs -ldl_lib -llog -lfreertos -lcxx -lsmartconfig_ack \
                     -lxtensa-debug-module -lheap -ltcpip_adapter -lmqtt -lulp -lfd -lfb_gfx -lnghttp -lprotocomm -lsmartconfig -lm -lethernet \
                     -limage_util -lc_nano -lsoc -ltcp_transport -lc -lmicro-ecc -lface_recognition -ljson -lwpa_supplicant -lmesh -lesp_https_ota \
                     -lwpa2 -lexpat -llwip -lwear_levelling -lapp_update -ldriver -lbt -lespnow -lcoap -lasio -lnewlib -lconsole -lapp_trace \
                     -lesp32-camera -lhal -lprotobuf-c -lsdmmc -lcore -lpthread -lcoexist -lfreemodbus -lspi_flash -lesp-tls -lwpa -lwifi_provisioning \
                     -lwps -lesp_adc_cal -lesp_event -lopenssl -lesp_ringbuf -lfr -lstdc++ \
                     -Wl,--end-group \
                     -Wl,-EL \
                     -o $BUILD_DIR/$PROGRAM_NAME.elf

python $PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/gen_esp32part.py -q $PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/partitions/default.csv $BUILD_DIR../target/$PROGRAM_NAME.partitions.bin
python $PRECOMPILE_DIR/hardware/esp32/$ARDUINO_ARCH/tools/esptool.py --chip esp32 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB -o $BUILD_DIR../target/$PROGRAM_NAME.bin $BUILD_DIR$PROGRAM_NAME.elf


rm $RMBUILD_DIR*.elf $RMBUILD_DIR*.o $RMBUILD_DIR*.d

#stop shellscript at the end
#read -t 60 -p "I am going to wait for 60 seconds only ..."
#read -p "Press any key to resume ..."