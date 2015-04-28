#!/bin/bash

# Set this to match the valid interface
ETH="enp0s8"

# Setup machine
yum update -y
service docker restart
chkconfig docker on

# Pull
docker pull hunty1/bsdpydocker

# Clean up
docker stop bsdpy
docker rm bsdpy
    
# Run
chmod -R 777 /usr/local/docker/nbi
IP=`ifconfig enp0s8 | awk '/inet / {print $2}' | sed 's/ //'`
echo $IP

docker run -d \
  -p 0.0.0.0:69:69/udp \
  -p 0.0.0.0:67:67/udp \
  -p 0.0.0.0:80:80 \
  -v /usr/local/docker/nbi:/nbi \
  -e DOCKER_BSDPY_IFACE=$ETH \
  -e DOCKER_BSDPY_IP=$IP \
  -e BSDPY_NBI_URL=http://$IP \
  --name bsdpy \
  --restart=always \
  hunty1/bsdpydocker

