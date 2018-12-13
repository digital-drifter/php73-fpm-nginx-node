#!/usr/bin/env bash

cat << EOF > ./.env
USERNAME=`whoami`
UID=`id -u`
GID=`id -g`
NODE_VERSION=11.4.0
YARN_VERSION=1.12.3
PHP_VERSION=7.3.0
EOF

echo -n "MYSQL ROOT PASSWORD:"
read MYSQL_ROOT_PASSWORD

echo -n "MYSQL DEFAULT DATABASE:"
read MYSQL_DATABASE

echo -n "MYSQL DEFAULT USER:"
read MYSQL_USER

echo -n "MYSQL DEFAULT PASSWORD:"
read MYSQL_PASSWORD

cat << EOF > ./.env.db
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
EOF

mkdir data

echo -n "Building image. This will take a while..."

docker-compose -f docker-compose.yml -f docker-compose.local.yml --no-cache --rm build

echo -n "Complete!"
