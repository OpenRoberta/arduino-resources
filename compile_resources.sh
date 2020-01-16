VARIANT=$1
CPU=$2

mkdir -p target

./RobotArdu/arduino-builder/linux/arduino-builder -hardware=./RobotArdu/hardware/builtin -hardware=./RobotArdu/hardware/additional -tools=./RobotArdu/arduino-builder/linux/tools-builder -libraries=./RobotArdu/libraries -fqbn=arduino:avr:$VARIANT$CPU -prefs=compiler.path= -build-path=./target packing.ino

mkdir -p release/core/$VARIANT
cp target/core/core.a release/core/$VARIANT
find target/libraries -type f -name "*.o" > lib.objects
xargs avr-gcc-ar rcs libora.a < lib.objects
mkdir -p release/lib/$VARIANT
mv libora.a release/lib/$VARIANT

rm lib.objects
