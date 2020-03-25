#!/usr/bin/env bash

export SRC_DIR=/opt/ora-cc-rsc
export TGT_DIR=/tmp/arduino-release

echo Compiling all resources
# Compile cores & libs
./compile_resources.sh uno arduino arduino avr uno "" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh nano arduino arduino avr nano ":cpu=atmega328" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh mega arduino arduino avr mega ":cpu=atmega2560" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh mbot mbot arduino avr uno "" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh botnroll botnroll arduino avr uno "" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh unowifirev2 unowifirev2 arduino megaavr uno2018 :mode=off "" "--build-properties build.extra_flags=-fno-lto"
./compile_resources.sh sensebox sensebox sensebox samd sb :power=on "" ""
./compile_resources_bob3.sh bob3 bob3
./compile_resources.sh festobionic festobionic esp32 esp32 esp32 :PSRAM=disabled,PartitionScheme=default,CPUFreq=240,FlashMode=qio,FlashFreq=80,FlashSize=4M,UploadSpeed=921600,DebugLevel=none "" ""
echo Finished compilation

echo Creating include and hardware folders
# Prepare includes
mkdir -p $TGT_DIR/includes/avr
mkdir -p $TGT_DIR/includes/megaavr
mkdir -p $TGT_DIR/includes/samd
mkdir -p $TGT_DIR/includes/esp32
mkdir -p $TGT_DIR/hardware/arduino/avr/cores
mkdir -p $TGT_DIR/hardware/arduino/avr/variants
mkdir -p $TGT_DIR/hardware/arduino/megaavr/cores
mkdir -p $TGT_DIR/hardware/arduino/megaavr/variants
mkdir -p $TGT_DIR/hardware/arduino/samd/cores
mkdir -p $TGT_DIR/hardware/arduino/samd/variants
mkdir -p $TGT_DIR/hardware/arduino/tools/CMSIS-Atmel/1.2.0/CMSIS/Device/ATMEL
mkdir -p $TGT_DIR/hardware/arduino/tools/CMSIS/4.5.0/CMSIS/Include
mkdir -p $TGT_DIR/hardware/sensebox/samd/variants
mkdir -p $TGT_DIR/hardware/esp32/esp32/cores
mkdir -p $TGT_DIR/hardware/esp32/esp32/variants
mkdir -p $TGT_DIR/hardware/esp32/esp32/tools

echo Copying header files and tools
# OpenRoberta libraries
cd $SRC_DIR/RobotArdu/libraries
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes \;

# Downloaded libraries
cd /root/Arduino/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes \;
# ArduinoSTL files are not suffixed with .h, instead copy everything and delete .cpp files
cp ./ArduinoSTL/src/* $TGT_DIR/includes/ArduinoSTL/src
rm -f $TGT_DIR/includes/ArduinoSTL/src/*.cpp

# Core libraries
cd /root/.arduino15/packages/arduino/hardware/avr/$ARDUINO_AVR_VERSION/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes/avr \;
cd ..
find ./cores/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/avr \;
find ./variants/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/avr \;

cd /root/.arduino15/packages/arduino/hardware/megaavr/$ARDUINO_MEGAAVR_VERSION/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes/megaavr \;
cd ..
find ./cores/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/megaavr \;
find ./variants/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/megaavr \;

# Sensebox Arduino libs
cd /root/.arduino15/packages/arduino/hardware/samd/$ARDUINO_SAMD_VERSION/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes/samd \;
cd ..
find ./cores/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/samd \;
find ./variants/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/samd \;
cd /root/.arduino15/packages/arduino/tools/
find ./CMSIS-Atmel/1.2.0/CMSIS/Device/ATMEL -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/tools \;
find ./CMSIS/4.5.0/CMSIS/Include -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/tools \;
find ./CMSIS/4.5.0/CMSIS/Lib/GCC -name 'libarm_cortexM0l_math.a' -exec cp --parents \{\} $TGT_DIR/hardware/arduino/tools \;

# Sensebox Sensebox libs
cd /root/.arduino15/packages/sensebox/hardware/samd/$SENSEBOX_SAMD_VERSION/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes/samd \;
cd ..
find ./variants/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/sensebox/samd \;
find ./variants/ -name '*.ld' -exec cp --parents \{\} $TGT_DIR/hardware/sensebox/samd \;

# ESP32 libs and tools
cd /root/.arduino15/packages/esp32/hardware/esp32/$ESP32_ESP32_VERSION/libraries/
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes/esp32 \;
cd ..
find ./cores/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/esp32/esp32 \;
find ./variants/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/esp32/esp32 \;
find ./tools/ -name '*.h' -exec cp --parents \{\} $TGT_DIR/hardware/esp32/esp32 \;
find ./tools/ -name '*.ld' -exec cp --parents \{\} $TGT_DIR/hardware/esp32/esp32 \;
find ./tools/ -name '*.csv' -exec cp --parents \{\} $TGT_DIR/hardware/esp32/esp32 \;
cp ./tools/gen_esp32part.py $TGT_DIR/hardware/esp32/esp32/tools/gen_esp32part.py
cp ./tools/esptool.py $TGT_DIR/hardware/esp32/esp32/tools/esptool.py
cd ./tools/sdk/lib/
find . -name '*.a' -exec cp --parents \{\} $TGT_DIR/lib/festobionic \;

echo Copying build scripts
cp $SRC_DIR/build_project.sh $TGT_DIR
cp $SRC_DIR/build_project_bob3.sh $TGT_DIR
cp $SRC_DIR/build_project_botnroll.sh $TGT_DIR
cp $SRC_DIR/build_project_festobionic.sh $TGT_DIR
cp $SRC_DIR/build_project_mbot.sh $TGT_DIR
cp $SRC_DIR/build_project_sensebox.sh $TGT_DIR
cp $SRC_DIR/build_project_unowifirev2.sh $TGT_DIR

echo Everything finished
