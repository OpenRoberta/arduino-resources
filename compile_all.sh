#!/bin/bash

export SRC_DIR=/opt/ora-cc-rsc
export TGT_DIR=/opt/arduino-resources

./compile_resources.sh uno
./compile_resources.sh nano :cpu=atmega328
./compile_resources.sh mega :cpu=atmega2560
./compile_resources_mbot.sh

mkdir $TGT_DIR/includes
cd $SRC_DIR/RobotArdu/libraries
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes \;

cd $SRC_DIR
cp ./RobotArdu/libraries/ArduinoSTL/src/* $TGT_DIR/includes/ArduinoSTL/src
rm -f $TGT_DIR/includes/ArduinoSTL/src/*.cpp

cd $SRC_DIR/RobotArdu/hardware/additional/arduino/hardware/avr/1.6.22/libraries
find . -name '*.h' -exec cp -- \{\} $TGT_DIR/includes \;

cp $SRC_DIR/build_project.sh $TGT_DIR
