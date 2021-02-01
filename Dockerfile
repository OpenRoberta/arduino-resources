FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget && \
    apt-get install -y python && \
    apt-get install -y python-pip && \
    pip install pyserial && \
    apt-get clean

#    apt-get install -y locales && \
#    apt-get install -y tzdata && \
    
#RUN locale-gen de_DE.UTF-8
#ENV LANG de_DE.UTF-8 
#ENV LANGUAGE de_DE:de 
#ENV LC_ALL de_DE.UTF-8

#RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime; \
#    export DEBIAN_FRONTEND=noninteractive; \
#    apt-get install -y tzdata; \
#    dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /tmp

ENV ARDUINO_CLI_VERSION 0.11.0

RUN wget https://github.com/arduino/arduino-cli/releases/download/${ARDUINO_CLI_VERSION}/arduino-cli_${ARDUINO_CLI_VERSION}_Linux_64bit.tar.gz

WORKDIR /opt/compiler
RUN tar -xf /tmp/arduino-cli_${ARDUINO_CLI_VERSION}_Linux_64bit.tar.gz && \
    rm -rf /tmp/*
ENV PATH = "${PATH}:/opt/compiler/"

ENV ARDUINO_AVR_VERSION 1.8.3
ENV ARDUINO_MEGAAVR_VERSION 1.8.6
ENV ARDUINO_SAMD_VERSION 1.8.8
ENV SENSEBOX_SAMD_VERSION 1.3.1
ENV ESP32_ESP32_VERSION 1.0.4
ENV STM32_STM32_VERSION 1.9.0
ENV ARDUINO_MBED_VERSION 1.1.6

RUN arduino-cli core update-index --additional-urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json,https://raw.githubusercontent.com/sensebox/senseBoxMCU-core/master/package_sensebox_index.json,https://github.com/stm32duino/BoardManagerFiles/raw/master/STM32/package_stm_index.json && \
    arduino-cli core install arduino:avr@$ARDUINO_AVR_VERSION && \
    arduino-cli core install arduino:megaavr@$ARDUINO_MEGAAVR_VERSION && \
    arduino-cli core install arduino:samd@$ARDUINO_SAMD_VERSION && \
    arduino-cli core install sensebox:samd@$SENSEBOX_SAMD_VERSION --additional-urls https://raw.githubusercontent.com/sensebox/senseBoxMCU-core/master/package_sensebox_index.json && \
    arduino-cli core install esp32:esp32@$ESP32_ESP32_VERSION --additional-urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json && \
    arduino-cli core install STM32:stm32@$STM32_STM32_VERSION --additional-urls https://github.com/stm32duino/BoardManagerFiles/raw/master/STM32/package_stm_index.json && \
    arduino-cli core install arduino:mbed@$ARDUINO_MBED_VERSION
ENV PATH "${PATH}:/root/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino5/bin:/root/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin:/root/.arduino15/packages/esp32/tools/xtensa-esp32-elf-gcc/1.22.0-80-g6c4433a-5.2.0/bin"

# Install Arduino dependencies
RUN arduino-cli lib update-index && \
    arduino-cli lib install "DHT sensor library"@1.3.10 && \
    arduino-cli lib install "ESP32Servo"@0.9.0 && \
    arduino-cli lib install "IRremote"@2.6.1 && \
    arduino-cli lib install "MFRC522"@1.4.7 && \
    arduino-cli lib install "SD"@1.2.4 && \
    arduino-cli lib install "Servo"@1.1.6 && \
    arduino-cli lib install "SparkFun LSM6DS3 Breakout"@1.0.0 && \
    arduino-cli lib install "Stepper"@1.1.3 && \
    arduino-cli lib install "BSEC Software Library"@1.5.1474 && \
    arduino-cli lib install "Adafruit NeoPixel"@1.6.0 && \
    arduino-cli lib install "WiFiNINA"@1.7.1
    arduino-cli lib install "Adafruit SSD1306"@2.4.3 && \
    arduino-cli lib install "Adafruit GFX"@1.10.4 && \

# re-add when not using outdated LiquidCrystal_I2C
#    arduino-cli lib install "LiquidCrystal I2C"@1.1.2 && \

WORKDIR /opt/ora-cc-rsc/

COPY ./ ./

# Currently released ArduinoSTL (1.1.0) does not have assignment change by VinArt
# Additionally, it conflicts with AVR core version 1.8.3, this was fixed in the yet unmerged PR by nholthaus
# In order to fix it for MegaAVR core 1.8.6, an explicit arduino namespace usage is required, found in the OpenRoberta fork
# download directly from GitHub
RUN wget https://github.com/OpenRoberta/ArduinoSTL/archive/a9c82de598ba3dec75cd6092c8927c7201b4146c.tar.gz && \
    tar -xf a9c82de598ba3dec75cd6092c8927c7201b4146c.tar.gz && \
    mkdir -p /root/Arduino/libraries/ArduinoSTL && \
    cp -r ArduinoSTL-a9c82de598ba3dec75cd6092c8927c7201b4146c/. /root/Arduino/libraries/ArduinoSTL && \
    rm -rf ArduinoSTL-a9c82de598ba3dec75cd6092c8927c7201b4146c && rm a9c82de598ba3dec75cd6092c8927c7201b4146c.tar.gz

# Currently releases LiquidCrystal (1.0.7) does not support MegaAVR core > 1.8.5
# this was fixed in the yet unmerged PR by n-gineer
# download directly from GitHub
RUN wget https://github.com/n-gineer/LiquidCrystal/archive/439ae314b3d8b3c8c2f22d11dac357754539e161.tar.gz && \
    tar -xf 439ae314b3d8b3c8c2f22d11dac357754539e161.tar.gz && \
    mkdir -p /root/Arduino/libraries/LiquidCrystal && \
    cp -r LiquidCrystal-439ae314b3d8b3c8c2f22d11dac357754539e161/. /root/Arduino/libraries/LiquidCrystal && \
    rm -rf LiquidCrystal-439ae314b3d8b3c8c2f22d11dac357754539e161 && rm 439ae314b3d8b3c8c2f22d11dac357754539e161.tar.gz

# Add Makeblock dependencies, these are not available through arduino-cli, corresponds to v3.27
# https://github.com/Makeblock-official/Makeblock-Libraries/tree/3a0e66bac4596d90749c2d35d8b60ec79f12e5e0
RUN wget https://github.com/Makeblock-official/Makeblock-Libraries/archive/3a0e66bac4596d90749c2d35d8b60ec79f12e5e0.tar.gz && \
    tar -xf 3a0e66bac4596d90749c2d35d8b60ec79f12e5e0.tar.gz && \
    cp -r Makeblock-Libraries-3a0e66bac4596d90749c2d35d8b60ec79f12e5e0/src/. RobotArdu/libraries/Makeblock && \
    rm -rf Makeblock-Libraries-3a0e66bac4596d90749c2d35d8b60ec79f12e5e0 && rm 3a0e66bac4596d90749c2d35d8b60ec79f12e5e0.tar.gz

# Currently releases LiquidCrystal-I2C does not support MegaAVR core > 1.8.5, fix found in the OpenRoberta fork
# download directly from GitHub
RUN wget https://github.com/OpenRoberta/Arduino-LiquidCrystal-I2C-library/archive/ee79038133895846dc1df0cbd715674743479fc8.tar.gz && \
    tar -xf ee79038133895846dc1df0cbd715674743479fc8.tar.gz && \
    cp -r Arduino-LiquidCrystal-I2C-library-ee79038133895846dc1df0cbd715674743479fc8/. RobotArdu/libraries/LiquidCrystal_I2C && \
    rm -rf Arduino-LiquidCrystal-I2C-library-ee79038133895846dc1df0cbd715674743479fc8 && rm ee79038133895846dc1df0cbd715674743479fc8.tar.gz

# Bot'n Roll libs were changed when including them into the Lab, using the committed files instead
## Add Bot'n Roll dependencies, these are not available through arduino-cli, corresponds to v1.2.0
## https://github.com/botnroll/BnrOneA_Arduino/tree/2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc
#RUN wget https://github.com/botnroll/BnrOneA_Arduino/archive/2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc.tar.gz && \
#    tar -xf 2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc.tar.gz && \
#    cp -r BnrOneA_Arduino-2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc/. RobotArdu/libraries/Botnroll && \
#    rm -rf BnrOneA_Arduino-2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc && rm 2d5e7d9b3a6b8d45cf3ebdf4380671f6df8a6fbc.tar.gz

RUN /opt/ora-cc-rsc/compile_all.sh
