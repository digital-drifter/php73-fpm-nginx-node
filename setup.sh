#!/usr/bin/env bash

if [ -f `pwd`/.env ]; then
  NODE_VER=$(grep NODE_VER .env | cut -d '=' -f2)
  YARN_VER=$(grep YARN_VER .env | cut -d '=' -f2)
  PHP_VER=$(grep PHP_VER .env | cut -d '=' -f2)
else
  NODE_VER=11.4.0
  YARN_VER=$1.12.3
  PHP_VER=7.3.0
fi

echo -n "Building Docker image. This will take a while..."

docker-compose -f docker-compose.test.yml build \
  --pull \
  --force-rm \
  --no-cache \
  --build-arg USERNAME=`whoami` \
  --build-arg UID=`id -u` \
  --build-arg GID=`id -g` \
  --build-arg NODE_VER=${NODE_VER} \
  --build-arg YARN_VER=${YARN_VER} \
  --build-arg PHP_VER=${PHP_VER}

echo -n "Complete!"
