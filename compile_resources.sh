#!/usr/bin/env bash

NAME=$1
FOLDER=$2
PACKAGE=$3
CPU_ARCH=$4
BOARD=$5
ADDITIONAL=$6
BUILD_PROPERTIES=$7

echo Compiling resources for $NAME, packing file $FOLDER.ino in $FOLDER will be used
ARCHIVER=
if [ $CPU_ARCH == "avr" ] || [ $CPU_ARCH == "megaavr" ]; then
  ARCHIVER=avr-gcc-ar
elif [ $CPU_ARCH == "samd" ] || [ $CPU_ARCH == "stm32" ]; then
  ARCHIVER=arm-none-eabi-ar
elif [ $CPU_ARCH == "esp32" ]; then
  ARCHIVER=xtensa-esp32-elf-ar
else
  echo Could not determine archiver
  exit 1
fi
echo Using package $PACKAGE and cpu architecture $CPU_ARCH with board $BOARD and archiver $ARCHIVER

TMP_DIR=/tmp/arduino-resources
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

echo Starting compilation
arduino-cli compile \
  --fqbn $PACKAGE:$CPU_ARCH:$BOARD$ADDITIONAL \
  --libraries $SRC_DIR/RobotArdu/libraries \
  --build-cache-path $TMP_DIR/core \
  --build-path $TMP_DIR \
  $BUILD_PROPERTIES \
  $FOLDER
echo Finished compilation
echo Copying results
mkdir -p $TGT_DIR/core/$NAME
cp $TMP_DIR/core/core.a $TGT_DIR/core/$NAME
if [ $NAME == "sensebox" ]; then
  echo Additionally copying variant.cpp.o
  cp $TMP_DIR/core/variant.cpp.o $TGT_DIR/core/$NAME
fi
if [ $NAME == "unowifirev2" ]; then
  echo Additionally copying variant.c.o
  cp $TMP_DIR/core/variant.c.o $TGT_DIR/core/$NAME
fi
if [ $NAME == "stm32" ]; then
  echo Additionally copying variant.cpp.o, PeripheralPins.c.o and syscalls.c.o
  cp $TMP_DIR/core/variant.cpp.o $TGT_DIR/core/$NAME
  cp $TMP_DIR/core/PeripheralPins.c.o $TGT_DIR/core/$NAME
  # syscalls.c.o is already archived in the library created below, but it needs to be linked explicitly for some reason
  cp $TMP_DIR/libraries/SrcWrapper/syscalls.c.o $TGT_DIR/core/$NAME
fi
echo Creating and moving libraries archive
find $TMP_DIR/libraries -type f -name "*.o" | xargs $ARCHIVER rcs libora.a
mkdir -p $TGT_DIR/lib/$NAME
mv libora.a $TGT_DIR/lib/$NAME
