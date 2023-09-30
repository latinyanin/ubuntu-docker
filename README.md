# Ubuntu Docker demo

## Requirements

- docker

## How to use

### Build docker image

```bash
docker build \
  --build-arg USER_NAME=[YOUR_GITHUB_NAME] \
  --build-arg SERVER_NAME=[SERVER_NAME] \
  --build-arg UBUNTU_VERSION="22.04" \
  -t [IMAGE_NAME] .
  ```

### Run docker container

  ```bash
docker run \
  --name [CONTAINER_NAME] -d \
  -p 2222:22 -p 8088:80 \
  -h [HOSTNAME] ubuntu-server
  ```

### Or run `qstart.sh` script

## How to connect to container

### Execute `ssh` command below in your terminal

```bash
ssh -p 2222 [USER_NAME]@localhost
```
