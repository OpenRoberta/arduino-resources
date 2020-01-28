#!/bin/bash
avr-gcc -D_BOB3_ -I./include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c analog.c -o analog.o
avr-gcc -D_BOB3_ -I./include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c bob3.cpp -o bob3.o
avr-gcc -D_BOB3_ -I./include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c ircom.c -o ircom.o
avr-gcc -D_BOB3_ -I./include -std=c99 -g -Os -fno-exceptions -ffunction-sections -fdata-sections -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c leds.c -o leds.o
avr-gcc -D_BOB3_ -I./include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c main.cpp -o main.o
avr-gcc -D_BOB3_ -I./include -g -Os -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -DAVR -Wall -I.. -mmcu=atmega88 -DF_CPU=8000000 -c bob3smd.cpp -o bob3smd.o
avr-ar -q libbob3-smd.a analog.o bob3.o ircom.o leds.o main.o bob3smd.o 
rm analog.o bob3.o ircom.o leds.o main.o bob3smd.o
mv libbob3-smd.a lib
