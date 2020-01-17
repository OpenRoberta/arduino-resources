VARIANT=$1
CPU=$2

TMP_DIR=/tmp/arduino-resources
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

$SRC_DIR/RobotArdu/arduino-builder/linux/arduino-builder \
  -hardware=$SRC_DIR/RobotArdu/hardware/builtin \
  -hardware=$SRC_DIR/RobotArdu/hardware/additional \
  -tools=$SRC_DIR/RobotArdu/arduino-builder/linux/tools-builder \
  -libraries=$SRC_DIR/RobotArdu/libraries \
  -fqbn=arduino:avr:$VARIANT$CPU -prefs=compiler.path= -build-path=$TMP_DIR packing.ino

mkdir -p $TGT_DIR/core/$VARIANT
cp $TMP_DIR/core/core.a $TGT_DIR/core/$VARIANT
cp $TMP_DIR/core/WMath.cpp.o $TGT_DIR/core/$VARIANT
find $TMP_DIR/libraries -type f -name "*.o" | xargs avr-gcc-ar rcs libora.a
mkdir -p $TGT_DIR/lib/$VARIANT
mv libora.a $TGT_DIR/lib/$VARIANT

