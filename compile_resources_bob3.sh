#!/bin/bash
avr-gcc -D_BOB3_ -I./bob3/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/analog.c -o ./bob3/analog.o
avr-gcc -D_BOB3_ -I./bob3/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/bob3.cpp -o ./bob3/bob3.o
avr-gcc -D_BOB3_ -I./bob3/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/ircom.c -o ./bob3/ircom.o
avr-gcc -D_BOB3_ -I./bob3/include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/leds.c -o ./bob3/leds.o
avr-gcc -D_BOB3_ -I./bob3/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/main.cpp -o ./bob3/main.o
avr-gcc -D_BOB3_ -I./bob3/include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ./bob3/bob3smd.cpp -o ./bob3/bob3smd.o
avr-ar -q ./bob3/libbob3-smd.a ./bob3/analog.o ./bob3/bob3.o ./bob3/ircom.o ./bob3/leds.o ./bob3/main.o ./bob3/bob3smd.o 
rm ./bob3/analog.o ./bob3/bob3.o ./bob3/ircom.o ./bob3/leds.o ./bob3/main.o ./bob3/bob3smd.o
mkdir -p $TGT_DIR/lib/bob3
mv ./bob3/libbob3-smd.a $TGT_DIR/lib/bob3

mkdir $TGT_DIR/includes/bob3
cp ./bob3/include* $TGT_DIR/includes/bob3
