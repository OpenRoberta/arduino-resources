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
in the directory /opt/arduino-resources. This directory is made available outside of the compiler as ./arduino-resources
by a volume mount.

To generate the docker image:

docker build --no-cache -t rbudde/arduinolibs:1 -f Dockerfile .

To run the image:

mkdir ./arduino-resources
docker run -v /data/openroberta-lab/git/arduino-resources/arduino-resources:/opt/arduino-resources rbudde/arduinolibs:1

Copy generated resources (core, includes, lib) to ora-cc-rsc/RobotArdu/gcc-compilation/
