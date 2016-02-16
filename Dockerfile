# Dockerfile for the guide at https://gameservermanagers.com/lgsm/pzserver/   (Debian-based install)

# INSTRUCTIONS:
# First download the pzserver script from wget http://gameservermanagers.com/dl/pzserver
# Then update the steamuser and steampass values in that script (see the Basic Usage section at https://gameservermanagers.com/lgsm/pzserver/)
# Then build the image (docker build -t zomboid .)
# After you have created a zomboid image, open a new 'screen' session, and start an interactive container:
#    $ (host)# screen
#    $ (host)# docker run -it -p 16261:16261 -p 16261:16261/udp -p 8766:8766 -p 8767:8767 -p 16262-16272:16262-16272 zomboid bash
#    $ (container)# ./pzserver start
#    $ (container)# ./pzserver console
# (see https://github.com/TuRz4m/Project-Zomboid_Docker for more info, need to 
#  run the 16262-16272 port range to allow 10 client connections, increase the range for more connections)
#
# To restart the container:
# $ (host)# docker ps -a   # find container id
# $ (host)# docker start <container id>
# $ (host)# docker attach <container id>  # press enter afterwards
# $ (container)# ./pzserver start
# $ (container)# ./pzserver console

FROM debian:latest
RUN dpkg --add-architecture i386 && apt-get -y update
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y install mailutils
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y install postfix
RUN apt-get -y install \
        tmux \
        ca-certificates curl \
        lib32gcc1 \
        libstdc++6 \
        libstdc++6:i386 \
        openjdk-7-jre

RUN useradd -ms /bin/bash pzserver

COPY ./pzserver /home/pzserver/pzserver

RUN chmod +x /home/pzserver/pzserver
RUN chown pzserver:pzserver /home/pzserver/pzserver

USER pzserver
WORKDIR /home/pzserver

RUN cd /home/pzserver && yes | ./pzserver install

# steamports
expose 8766
expose 8767

# gameport
expose 16261
expose 16261/udp

expose 27015
