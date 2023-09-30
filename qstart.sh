#!/bin/bash

RED='\033[0;31m';
YELLOW='\e[0;33;40m'
GREEN='\033[0;32m';
NC='\033[0m';
bold=$(tput bold)
normal=$(tput sgr0)

# Get server name
echo -ne "\n${YELLOW}${bold}Enter server name:  ${NC}${normal}"
read   SERVER_NAME

# Get server user name
echo -ne "\n${YELLOW}${bold}Enter your github name: ${NC}${normal}"
read  SERVER_USER_NAME

# Build docker image
docker build \
  --build-arg USER_NAME=${SERVER_USER_NAME} \
  --build-arg SERVER_NAME=${SERVER_NAME} \
  --build-arg UBUNTU_VERSION="22.04" \
  -t ubuntu-server .

# Run docker container
docker run \
  --name $SERVER_NAME \
  -d \
  -p 2222:22 \
  -p 8088:80 \
  -h ${SERVER_NAME} \
  ubuntu-server
