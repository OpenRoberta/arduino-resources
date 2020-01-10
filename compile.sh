VARIANT=uno

mkdir -p target

$HOME/Development/Repositories/ora-cc-rsc/RobotArdu/arduino-builder/linux/arduino-builder -hardware=$HOME/Development/Repositories/ora-cc-rsc/RobotArdu/hardware/builtin -hardware=$HOME/Development/Repositories/ora-cc-rsc/RobotArdu/hardware/additional -tools=$HOME/Development/Repositories/ora-cc-rsc/RobotArdu//arduino-builder/linux/tools-builder -libraries=$HOME/Development/Repositories/ora-cc-rsc/RobotArdu//libraries -fqbn=arduino:avr:$VARIANT -prefs=compiler.path= -build-path=./target packing.ino

mkdir -p release/core/$VARIANT
cp target/core/core.a release/core/$VARIANT
find target/libraries -type f -name "*.o" > lib.objects
xargs avr-gcc-ar rcs libora.a < lib.objects
mkdir -p release/lib/$VARIANT
mv libora.a release/lib/$VARIANT

rm lib.objects
