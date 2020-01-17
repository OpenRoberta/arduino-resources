#!/bin/bash

./compile_resources.sh uno
./compile_resources.sh nano :cpu=atmega328
./compile_resources.sh mega :cpu=atmega2560

BASE=$PWD

rm -rf ./RobotArdu/release

mv release RobotArdu
rm -rf target 

mkdir -p ./RobotArdu/release/includes
cd ./RobotArdu/libraries
find . -name '*.h' -exec cp --parents \{\} ../release/includes \;

cd ../../
cp ./RobotArdu/libraries/ArduinoSTL/src/* ./RobotArdu/release/includes/ArduinoSTL/src
rm -rf ./RobotArdu/release/includes/ArduinoSTL/src/*.cpp

cd ./RobotArdu/hardware/additional/arduino/hardware/avr/1.6.22/libraries
find . -name '*.h' -exec cp -- \{\} $BASE/RobotArdu/release/includes \;
