#!/usr/bin/env bash

NAME=$1
FOLDER=$2

avr-gcc -D_BOB3_ -I./$FOLDER/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/analog.c -o ./$FOLDER/analog.o
avr-gcc -D_BOB3_ -I./$FOLDER/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/bob3.cpp -o ./$FOLDER/bob3.o
avr-gcc -D_BOB3_ -I./$FOLDER/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/ircom.c -o ./$FOLDER/ircom.o
avr-gcc -D_BOB3_ -I./$FOLDER/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/leds.c -o ./$FOLDER/leds.o
avr-gcc -D_BOB3_ -I./$FOLDER/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/main.cpp -o ./$FOLDER/main.o
avr-gcc -D_BOB3_ -I./$FOLDER/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./$FOLDER/bob3smd.cpp -o ./$FOLDER/bob3smd.o
avr-ar -q ./$FOLDER/libora.a ./$FOLDER/analog.o ./$FOLDER/bob3.o ./$FOLDER/ircom.o ./$FOLDER/leds.o ./$FOLDER/main.o ./$FOLDER/bob3smd.o 
rm ./$FOLDER/analog.o ./$FOLDER/bob3.o ./$FOLDER/ircom.o ./$FOLDER/leds.o ./$FOLDER/main.o ./$FOLDER/bob3smd.o
mkdir -p $TGT_DIR/lib/$NAME
mv ./$FOLDER/libora.a $TGT_DIR/lib/$NAME

mkdir -p $TGT_DIR/includes/$NAME
find ./$FOLDER/include/ -name '*.h' -exec cp \{\} $TGT_DIR/includes/$NAME \;
