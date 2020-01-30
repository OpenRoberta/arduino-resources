This GIT repository is needed to generate all resources, that are used to compile arduino programs in the OpenRoberta lab for

- MEGA
- NANO
- UNO
- UNO WIFI REV2
- bob3

The resources generated are

- libraries (.a archive),
- header files and a
- script, that runs the Arduino compiler and linker in the lab

Sketches that are located in respective folders contain header includes and are processed by arduino builder to
find all dependencies and compile the libraries. Once this lengthy process is done, the results can be reused.

In order to add new libraries simply put the include directive with the needed header in the respective sketch.
Do not forget to provide the library itself in RobotArdu/libraries.

The main reason for creating this repository is to to speed up the compilation in the lab. To achieve this,
unnecessary (re-)compilations are avoided by compiling everything that could be referenced in the lab once and
storing the object files in libraries.

For a stable build the resources are generated inside a docker container. The C++ compiler (the same as the one used
in the lab) is installed in the image together with all Arduino sources.

When the container is started, a shell script generates the libraries and stores them together with the header files
in the directory /tmp/arduino-release. This directory is made available outside of the compiler as ./arduino-release
by a volume mount.

To generate the docker image:

docker build --no-cache -t rbudde/arduinolibs:1 -f Dockerfile .

To run the image:

rm -rf ./arduino-resources && mkdir ./arduino-resources

docker run -v /data/openroberta-lab/git/arduino-resources/arduino-resources:/tmp/arduino-release rbudde/arduinolibs:1

rm -rf ../ora-cc-rsc/RobotArdu/arduino-resources && mkdir ../ora-cc-rsc/RobotArdu/arduino-resources

cp -r ./arduino-resources ../ora-cc-rsc/RobotArdu/


Following warnings can be disregarded:

`cp: -r not specified; omitting directory './RobotArdu/libraries/ArduinoSTL/src/abi'`

abi folder is not needed at all.

The following:

```
In file included from /opt/ora-cc-rsc/RobotArdu/libraries/SparkFun_LSM6DS3_Breakout/src/SparkFunLSM6DS3.cpp:32:0:
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h: In member function 'status_t LSM6DS3Core::readRegisterRegion(uint8_t*, uint8_t, uint8_t)':
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h:62:13: note: candidate 1: uint8_t TwoWire::requestFrom(int, int)
     uint8_t requestFrom(int, int);
             ^~~~~~~~~~~
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h:60:13: note: candidate 2: virtual uint8_t TwoWire::requestFrom(uint8_t, size_t)
     uint8_t requestFrom(uint8_t, size_t);
             ^~~~~~~~~~~
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h: In member function 'status_t LSM6DS3Core::readRegister(uint8_t*, uint8_t)':
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h:62:13: note: candidate 1: uint8_t TwoWire::requestFrom(int, int)
     uint8_t requestFrom(int, int);
             ^~~~~~~~~~~
/opt/ora-cc-rsc/RobotArdu/hardware/additional/arduino/hardware/megaavr/1.8.5/libraries/Wire/src/Wire.h:60:13: note: candidate 2: virtual uint8_t TwoWire::requestFrom(uint8_t, size_t)
     uint8_t requestFrom(uint8_t, size_t);
```

Comes from a third party library, may be fixed with an update

