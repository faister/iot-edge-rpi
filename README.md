# iot-edge-rpi
Contains recipe for building a Docker image with cross-compiled native libraries for RPi and .NET Core 2.0.0 DLLs for Linux-ARM

# How to get started? 

1. Run this on your dev machine, not your target Raspberry Pi. This is because the Docker image is based upon Debian 8 (jessie) x86-64 GNU/Linux. This is the environment needed to run the RPiToolchain as well as the .NET Core 2.0.0 SDK. 

2. Git clone my repo from here. 

3. Build the Docker image by the following command:
docker build -t iot-edge-rpi .

4. As a result of the cross-compilation and .NET Core 2.0.0 compilation, you get a tar ball which you can copy onto your target Raspberry Pi. The cleanest way to do so is by mounting a host directory onto your container before running it. Then copy the iot-edge-rpi.tar.gz to /mnt.
docker run -v /home/username:/mnt --name iot-edge-rpi -it iot-edge-rpi

5. Copy iot-edge-rpi.tar.gz to your target Raspberry Pi. Easiest way is to use SCP.
docker build -t iot-edge-rpi .
