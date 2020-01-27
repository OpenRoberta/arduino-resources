VARIANT=sensebox
CPU=

TMP_DIR=/tmp/arduino-resources
rm -rf $TMP_DIR
mkdir -p $TMP_DIR
  
$SRC_DIR/RobotArdu/arduino-builder/linux/arduino-builder \
    -hardware=$SRC_DIR/RobotArdu/hardware/builtin \
    -hardware=$SRC_DIR/RobotArdu/hardware/additional \
    -tools=$SRC_DIR/RobotArdu//arduino-builder/linux/tools-builder \
    -tools=$SRC_DIR/RobotArdu/hardware/additional \
    -libraries=$SRC_DIR/RobotArdu//libraries \
    -fqbn=sensebox:samd:sb:power=on \
    -prefs=compiler.path= \
    -vid-pid=0X04D8_0XEF66 \
    -ide-version=10805 \
    -prefs=build.warn_data_percentage=75 \
    -prefs=runtime.tools.arduinoOTA.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/arduinoOTA/1.2.0 \
    -prefs=runtime.tools.CMSIS.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/CMSIS/4.5.0 \
    -prefs=runtime.tools.CMSIS-Atmel.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/CMSIS-Atmel/1.1.0 \
    -prefs=runtime.tools.openocd.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/openocd/0.9.0-arduino6-static \
    -prefs=runtime.tools.arm-none-eabi-gcc.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/arm-none-eabi-gcc/4.8.3-2014q1 \
    -prefs=runtime.tools.bossac.path=$SRC_DIR/RobotArdu/hardware/additional/arduino/tools/bossac/1.7.0 \
    -build-path=$TMP_DIR sensebox/packing.ino

mkdir -p $TGT_DIR/core/$VARIANT
cp $TMP_DIR/core/core.a $TGT_DIR/core/$VARIANT
cp $TMP_DIR/core/WMath.cpp.o $TGT_DIR/core/$VARIANT
find $TMP_DIR/libraries -type f -name "*.o" | xargs avr-gcc-ar rcs libora.a
mkdir -p $TGT_DIR/lib/$VARIANT
mv libora.a $TGT_DIR/lib/$VARIANT

