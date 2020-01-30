#!/bin/bash

export SRC_DIR=/opt/ora-cc-rsc
export TGT_DIR=/tmp/arduino-release

./compile_resources.sh uno
./compile_resources.sh nano :cpu=atmega328
./compile_resources.sh mega :cpu=atmega2560
./compile_resources_mbot.sh
./compile_resources_wifirev2.sh
./compile_resources_bob3.sh
./compile_resources_sensebox.sh

mkdir $TGT_DIR/includes
cd $SRC_DIR/RobotArdu/libraries
find . -name '*.h' -exec cp --parents \{\} $TGT_DIR/includes \;

cd $SRC_DIR
cp ./RobotArdu/libraries/ArduinoSTL/src/* $TGT_DIR/includes/ArduinoSTL/src
rm -f $TGT_DIR/includes/ArduinoSTL/src/*.cpp

cd $SRC_DIR/RobotArdu/hardware/additional/arduino/hardware/avr/1.6.22/libraries
find . -name '*.h' -exec cp -- \{\} $TGT_DIR/includes \;

cp $SRC_DIR/build_project.sh $TGT_DIR
cp $SRC_DIR/build_project_bob3.sh $TGT_DIR
cp $SRC_DIR/build_project_sensebox.sh $TGT_DIR
cp $SRC_DIR/build_project_unowifirev2.sh $TGT_DIR
