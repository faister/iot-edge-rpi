FROM aziotbld/raspberrypi-c:latest

LABEL maintainer "hoongfai@microsoft.com"

RUN apt-get update

#### Install .NET Core dependencies
RUN apt-get install -y \
	libunwind8 \
	libunwind8-dev \
	gettext \
	libicu-dev \
	liblttng-ust-dev \
	libcurl4-openssl-dev \
	libssl-dev \
	uuid-dev \
	apt-transport-https \
	wget

#### Install .NET Core 2.0.0
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'

RUN apt-get update

RUN apt-get install -y dotnet-sdk-2.0.0

#### Git clone IoT Edge repo
RUN git clone https://github.com/Azure/iot-edge.git /iot-edge

#### Update csproj files to target .NET Core 2.0.0
RUN cd / \
    && wget "https://scrapyard.blob.core.windows.net/share/iot-edge.tar.gz"  \
    && tar -xzf iot-edge.tar.gz \
    && rm -f iot-edge.tar.gz \
    && chmod +x /iot-edge/tools/build_dotnet_core.sh

#### Get RPi toolchain
RUN chmod +x /iot-edge/jenkins/raspberrypi_c.sh

#### Create a symbolic link to the RPiTools in /home/jenkins because the script expects these tools in the root directory
RUN ln -sd /home/jenkins/RPiTools/ /root/RPiTools

RUN /iot-edge/jenkins/raspberrypi_c.sh

RUN  cd /iot-edge \
     && ./tools/build.sh \
     --enable-dotnet-core-binding \
     --disable-native-remote-modules \
     --toolchain-file ./toolchain-rpi.cmake

#### Create IoT Edge for RPi tarball so that it is easy to copy the file from the Docker container to the host
RUN tar -czf /iot-edge-rpi.tar.gz /iot-edge 

CMD ["/bin/bash"]
