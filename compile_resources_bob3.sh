#!/usr/bin/env bash

NAME=$1
FOLDER=$2

CPPFLAGS="-D_BOB3_ -D_NEPO_ -DF_CPU=8000000 -DAVR -I./$FOLDER/include"
CFLAGS="-std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -Wall -mmcu=atmega88"
CXXFLAGS="-g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wall -mmcu=atmega88"

avr-gcc $CPPFLAGS $CFLAGS -c ./$FOLDER/analog.c -o ./$FOLDER/analog.o
avr-gcc $CPPFLAGS $CXXFLAGS -c ./$FOLDER/robot.cpp -o ./$FOLDER/robot.o
avr-gcc $CPPFLAGS $CFLAGS -c ./$FOLDER/clock.c -o ./$FOLDER/clock.o
avr-gcc $CPPFLAGS $CFLAGS -c ./$FOLDER/ircom.c -o ./$FOLDER/ircom.o
avr-gcc $CPPFLAGS $CFLAGS -c ./$FOLDER/leds.c -o ./$FOLDER/leds.o
avr-gcc $CPPFLAGS $CFLAGS -c ./$FOLDER/color-white.c -o ./$FOLDER/color-white.o
avr-gcc $CPPFLAGS $CXXFLAGS -c ./$FOLDER/main.cpp -o ./$FOLDER/main.o
avr-gcc $CPPFLAGS $CXXFLAGS -c ./$FOLDER/bob3smd.cpp -o ./$FOLDER/bob3smd.o
avr-ar -q ./$FOLDER/libora.a ./$FOLDER/analog.o ./$FOLDER/robot.o ./$FOLDER/clock.o ./$FOLDER/ircom.o ./$FOLDER/leds.o ./$FOLDER/color-white.o ./$FOLDER/main.o ./$FOLDER/bob3smd.o 
rm ./$FOLDER/analog.o ./$FOLDER/robot.o ./$FOLDER/clock.o ./$FOLDER/ircom.o ./$FOLDER/leds.o ./$FOLDER/color-white.o ./$FOLDER/main.o ./$FOLDER/bob3smd.o
mkdir -p $TGT_DIR/lib/$NAME
mv ./$FOLDER/libora.a $TGT_DIR/lib/$NAME

mkdir -p $TGT_DIR/includes/$NAME
find ./$FOLDER/include/ -name '*.h' -exec cp \{\} $TGT_DIR/includes/$NAME \;
find ./$FOLDER/include/ -name '*.hpp' -exec cp \{\} $TGT_DIR/includes/$NAME \;
