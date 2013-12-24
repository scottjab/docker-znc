# Docker file for znc-1.2
# Builds ZNC from scratch (for now inside an LXC)
# Will push the config directory from ./znc 

FROM ubuntu

MAINTAINER scottjab

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential curl sudo libssl-dev libperl-dev pkg-config

# BUILD AND INSTALL
# Will build pacakges soon
RUN curl -LO http://znc.in/releases/znc-1.2.tar.gz
RUN tar zvxf znc-1.2.tar.gz
RUN cd znc-1.2 && ./configure && make && make install


RUN useradd znc -d /home/znc -m
RUN sudo -u znc mkdir -p /home/znc/.znc

#push znc config
ADD ./znc /home/znc/.znc

RUN curl -Lo /home/znc/colloquy.cpp http://github.com/wired/colloquypush/raw/master/znc/colloquy.cpp
RUN /usr/local/bin/znc-buildmod /home/znc/colloquy.cpp
RUN cp /home/znc/colloquy.so /home/znc/.znc/modules/
RUN chown znc:znc /home/znc/.znc/modules/colloquy.so


CMD /usr/bin/sudo -u znc /usr/local/bin/znc -fd /home/znc/.znc
EXPOSE 5556
