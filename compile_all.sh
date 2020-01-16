#!/bin/bash

./compile_resources.sh uno
./compile_resources.sh nano :cpu=atmega328
./compile_resources.sh mega :cpu=atmega2560
mv release RobotArdu
rm -rf target 
