#!/bin/bash

./compile_resources.sh uno
./compile_resources.sh nano :cpu=atmega328
./compile_resources.sh mega :cpu=atmega2560
mkdir -p /tmp/ora-res
cp -r release /opt/ora-res
mv release RobotArdu
rm -rf target 

mkdir -p ./RobotArdu/release/includes
cd ./RobotArdu/libraries
find . -name '*.h' -exec cp --parents \{\} ../release/includes \;
