VARIANT=uno
CPU=

TMP_DIR=/tmp/arduino-resources
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

$SRC_DIR/RobotArdu/arduino-builder/linux/arduino-builder \
  -hardware=$SRC_DIR/RobotArdu/hardware/builtin \
  -hardware=$SRC_DIR/RobotArdu/hardware/additional \
  -tools=$SRC_DIR/RobotArdu/arduino-builder/linux/tools-builder \
  -libraries=$SRC_DIR/RobotArdu/libraries \
  -fqbn=arduino:avr:$VARIANT$CPU -prefs=compiler.path= -build-path=$TMP_DIR mbot/packing_mbot.ino

mkdir -p $TGT_DIR/core/mbot
cp $TMP_DIR/core/core.a $TGT_DIR/core/mbot
cp $TMP_DIR/core/WMath.cpp.o $TGT_DIR/core/mbot
find $TMP_DIR/libraries -type f -name "*.o" | xargs avr-gcc-ar rcs libora.a
mkdir -p $TGT_DIR/lib/mbot
mv libora.a $TGT_DIR/lib/mbot

